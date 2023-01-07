import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/suggestion.dart';
import '../../../domain/interactors/suggestion_interactor.dart';
import '../../di/injector.dart' as injector;
import 'suggestions_state.dart';

class SuggestionsCubit extends Cubit<SuggestionsState> {
  final SuggestionInteractor _suggestionInteractor;
  StreamSubscription<List<Suggestion>>? _suggestionSubscription;

  SuggestionsCubit(this._suggestionInteractor)
      : super(
          const SuggestionsState(
            requests: <Suggestion>[],
            inProgress: <Suggestion>[],
            completed: <Suggestion>[],
            isCreateBottomSheetOpened: false,
          ),
        );

  void init() {
    _suggestionSubscription?.cancel();
    _suggestionSubscription = _suggestionInteractor.suggestionsStream.listen(_onNewSuggestions);
    _suggestionInteractor.initSuggestions();
  }

  void dispose() {
    _suggestionSubscription?.cancel();
    _suggestionSubscription = null;
  }

  Future<void> _onNewSuggestions(List<Suggestion> suggestions) async {
    emit(
      state.newState(
        requests: suggestions
            .where((Suggestion element) => element.status == SuggestionStatus.requests)
            .toList(growable: false)
          ..sort((Suggestion a, Suggestion b) => b.upvotesCount.compareTo(a.upvotesCount)),
        inProgress: suggestions
            .where((Suggestion element) => element.status == SuggestionStatus.inProgress)
            .toList(growable: false)
          ..sort((Suggestion a, Suggestion b) => b.upvotesCount.compareTo(a.upvotesCount)),
        completed: suggestions
            .where((Suggestion element) => element.status == SuggestionStatus.completed)
            .toList(growable: false)
          ..sort((Suggestion a, Suggestion b) => b.upvotesCount.compareTo(a.upvotesCount)),
      ),
    );
  }

  void vote(SuggestionStatus status, int i) {
    switch (status) {
      case SuggestionStatus.requests:
          final List<Suggestion> newList = _changeListElement(state.requests, i);
          emit(state.newState(requests: newList));
          break;
      case SuggestionStatus.inProgress:
          final List<Suggestion> newList = _changeListElement(state.inProgress, i);
          emit(state.newState(inProgress: newList));
          break;
      case SuggestionStatus.completed:
          final List<Suggestion> newList = _changeListElement(state.completed, i);
          emit(state.newState(completed: newList));
          break;
    }
  }

  List<Suggestion> _changeListElement(List<Suggestion> suggestionsList, int i) {
    final List<Suggestion> newList = <Suggestion>[...suggestionsList];
    final bool isVoted = newList[i].votedUserIds.contains(injector.i.userId);
    final Set<String> newVotedUserIds = <String>{...newList[i].votedUserIds};

    !isVoted
        ? _suggestionInteractor.upvote(newList[i].id)
        : _suggestionInteractor.downvote(newList[i].id);

    newList[i] = newList[i].copyWith(
      votedUserIds: !isVoted
          ? <String>{...newVotedUserIds..add(injector.i.userId)}
          : <String>{...newVotedUserIds..remove(injector.i.userId)},
    );
    return newList;
  }

  void openCreateBottomSheet() => emit(state.newState(isCreateBottomSheetOpened: true));

  void closeCreateBottomSheet() => emit(state.newState(isCreateBottomSheetOpened: false));

  void changeActiveTab(SuggestionStatus activeTab) => emit(state.newState(activeTab: activeTab));
}
