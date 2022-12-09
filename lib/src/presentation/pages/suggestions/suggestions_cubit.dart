import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/suggestion.dart';
import '../../../domain/interactors/suggestion_interactor.dart';
import 'suggestions_state.dart';
import '../../di/injector.dart' as injector;

class SuggestionsCubit extends Cubit<SuggestionsState> {
  final SuggestionInteractor _suggestionInteractor;
  StreamSubscription<List<Suggestion>>? _suggestionSubscription;

  SuggestionsCubit(this._suggestionInteractor)
      : super(
          SuggestionsState(
            requests: [],
            inProgress: [],
            completed: [],
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

  void _onNewSuggestions(List<Suggestion> suggestions) async {
    emit(
      state.newState(
        requests: suggestions
            .where((element) => element.status == SuggestionStatus.requests)
            .toList(growable: false)
          ..sort((a, b) => b.upvotesCount.compareTo(a.upvotesCount)),
        inProgress: suggestions
            .where((element) => element.status == SuggestionStatus.inProgress)
            .toList(growable: false)
          ..sort((a, b) => b.upvotesCount.compareTo(a.upvotesCount)),
        completed: suggestions
            .where((element) => element.status == SuggestionStatus.completed)
            .toList(growable: false)
          ..sort((a, b) => b.upvotesCount.compareTo(a.upvotesCount)),
      ),
    );
  }

  void vote(SuggestionStatus status, int i) {
    if (status == SuggestionStatus.requests) {
      final newList = _changeListElement(state.requests, i);
      emit(state.newState(requests: newList));
    } else if (status == SuggestionStatus.inProgress) {
      final newList = _changeListElement(state.inProgress, i);
      emit(state.newState(inProgress: newList));
    } else {
      final newList = _changeListElement(state.completed, i);
      emit(state.newState(completed: newList));
    }
  }

  List<Suggestion> _changeListElement(List<Suggestion> suggestionsList, int i) {
    var newList = [...suggestionsList];
    final isVoted = newList[i].votedUserIds.contains(injector.i.userId);
    final newVotedUserIds = {...newList[i].votedUserIds};

    !isVoted
        ? _suggestionInteractor.upvote(newList[i].id)
        : _suggestionInteractor.downvote(newList[i].id);

    newList[i] = newList[i].copyWith(
      votedUserIds: !isVoted
          ? {...newVotedUserIds..add(injector.i.userId)}
          : {...newVotedUserIds..remove(injector.i.userId)},
    );
    return newList;
  }

  void openCreateBottomSheet() => emit(state.newState(isCreateBottomSheetOpened: true));

  void closeCreateBottomSheet() => emit(state.newState(isCreateBottomSheetOpened: false));

  void changeActiveTab(SuggestionStatus activeTab) => emit(state.newState(activeTab: activeTab));
}
