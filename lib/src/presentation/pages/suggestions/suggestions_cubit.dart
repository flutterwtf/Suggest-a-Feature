import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suggest_a_feature/src/domain/data_interfaces/suggestion_repository.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart'
    as injector;
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_state.dart';

class SuggestionsCubit extends Cubit<SuggestionsState> {
  final SuggestionRepository _suggestionRepository;
  StreamSubscription<List<Suggestion>>? _suggestionSubscription;

  SuggestionsCubit(this._suggestionRepository)
      : super(
          const SuggestionsState(
            requests: [],
            inProgress: [],
            completed: [],
            declined: [],
            duplicated: [],
            sortType: SortType.likes,
            loading: true,
          ),
        ) {
    _init();
  }

  Future<void> _init() async {
    _suggestionSubscription?.cancel();
    _suggestionSubscription = _suggestionRepository.suggestionsStream.listen(
      _onNewSuggestions,
    );
    await _suggestionRepository.initSuggestions();
    emit(state.newState(loading: false));
  }

  @override
  Future<void> close() async {
    _suggestionSubscription?.cancel();
    _suggestionSubscription = null;
    await super.close();
  }

  Future<void> _onNewSuggestions(List<Suggestion> suggestions) async {
    suggestions.sort(state.sortType.sortFunction);

    emit(
      state.newState(
        requests: suggestions
            .where((s) => s.status == SuggestionStatus.requests)
            .toList(growable: false),
        inProgress: suggestions
            .where((s) => s.status == SuggestionStatus.inProgress)
            .toList(growable: false),
        completed: suggestions
            .where((s) => s.status == SuggestionStatus.completed)
            .toList(growable: false),
        declined: suggestions
            .where((s) => s.status == SuggestionStatus.declined)
            .toList(growable: false),
        duplicated: suggestions
            .where((s) => s.status == SuggestionStatus.duplicated)
            .toList(growable: false),
      ),
    );
  }

  void vote(SuggestionStatus status, int i) {
    switch (status) {
      case SuggestionStatus.requests:
        _voteForSuggestion(state.requests[i]);
      case SuggestionStatus.inProgress:
        _voteForSuggestion(state.inProgress[i]);
      case SuggestionStatus.completed:
        _voteForSuggestion(state.completed[i]);
      case SuggestionStatus.declined:
        _voteForSuggestion(state.declined[i]);
      case SuggestionStatus.duplicated:
        _voteForSuggestion(state.duplicated[i]);
      case SuggestionStatus.unknown:
    }
  }

  void _voteForSuggestion(Suggestion suggestion) {
    final isVoted = suggestion.votedUserIds.contains(injector.i.userId);

    isVoted
        ? _suggestionRepository.downvote(suggestion.id)
        : _suggestionRepository.upvote(suggestion.id);
  }

  void openCreateBottomSheet() => emit(
        CreateState(
          requests: state.requests,
          inProgress: state.inProgress,
          completed: state.completed,
          declined: state.declined,
          duplicated: state.duplicated,
          sortType: state.sortType,
          activeTab: state.activeTab,
          loading: state.loading,
        ),
      );

  void closeBottomSheet() => emit(
        SuggestionsState(
          requests: state.requests,
          inProgress: state.inProgress,
          completed: state.completed,
          declined: state.declined,
          duplicated: state.duplicated,
          sortType: state.sortType,
          loading: state.loading,
        ),
      );

  void changeActiveTab(SuggestionStatus activeTab) =>
      emit(state.newState(activeTab: activeTab));

  void openSortingBottomSheet() => emit(
        SortingState(
          requests: state.requests,
          inProgress: state.inProgress,
          completed: state.completed,
          declined: state.declined,
          duplicated: state.duplicated,
          sortType: state.sortType,
          loading: state.loading,
        ),
      );

  void onSortTypeChanged(SortType sortType) {
    if (sortType != state.sortType) {
      emit(state.newState(sortType: sortType));
      _onNewSuggestions(_suggestionRepository.suggestions);
    }
  }
}
