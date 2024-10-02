import 'dart:async';

import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/domain/data_interfaces/suggestion_repository.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_state.dart';
import 'package:suggest_a_feature/src/presentation/utils/typedefs.dart';

class SuggestionsManager extends StatefulWidget {
  final SortType sortType;
  final Widget child;
  final String? initialSuggestionId;

  const SuggestionsManager({
    required this.sortType,
    required this.child,
    this.initialSuggestionId,
    super.key,
  });

  static SuggestionsStateManager of(BuildContext context) {
    return (context
            .dependOnInheritedWidgetOfExactType<_InheritedSuggestions>()!)
        .suggestionManager;
  }

  @override
  SuggestionsStateManager createState() => SuggestionsStateManager();
}

class SuggestionsStateManager extends State<SuggestionsManager> {
  late SuggestionsState state;
  late final SuggestionRepository _suggestionRepository;
  StreamSubscription<List<Suggestion>>? _suggestionSubscription;

  @override
  void initState() {
    super.initState();
    _suggestionRepository = i.suggestionRepository;
    state = SuggestionsState(
      requests: const [],
      inProgress: const [],
      completed: const [],
      declined: const [],
      duplicated: const [],
      sortType: widget.sortType,
      loading: true,
    );
    _init();
  }

  Future<void> _init() async {
    _suggestionSubscription?.cancel();
    _suggestionSubscription = _suggestionRepository.suggestionsStream.listen(
      _onNewSuggestions,
    );
    await _suggestionRepository.initSuggestions();

    final suggestionId = widget.initialSuggestionId;
    if (suggestionId != null) {
      try {
        final suggestion =
            await _suggestionRepository.getSuggestionById(suggestionId);
        state = SuggestionsRedirectState(
          requests: state.requests,
          inProgress: state.inProgress,
          completed: state.completed,
          declined: state.declined,
          duplicated: state.duplicated,
          sortType: state.sortType,
          loading: state.loading,
          suggestion: suggestion,
        );
      } catch (_) {}
    }

    _update(state.newState(loading: false));
  }

  @override
  void dispose() {
    _suggestionSubscription?.cancel();
    _suggestionSubscription = null;
    super.dispose();
  }

  void _update(SuggestionsState newState) {
    if (newState != state) {
      setState(() {
        state = newState;
      });
    }
  }

  Future<void> _onNewSuggestions(List<Suggestion> suggestions) async {
    suggestions.sort(state.sortType.sortFunction);

    _update(
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
    final isVoted = suggestion.votedUserIds.contains(i.userId);

    isVoted
        ? _suggestionRepository.downvote(suggestion.id)
        : _suggestionRepository.upvote(suggestion.id);
  }

  void openCreateBottomSheet() => _update(
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

  void closeBottomSheet() => _update(
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
      _update(state.newState(activeTab: activeTab));

  void openSortingBottomSheet() => _update(
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
      _update(state.newState(sortType: sortType));
      _onNewSuggestions(_suggestionRepository.suggestions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedSuggestions(
      suggestionManager: this,
      child: widget.child,
    );
  }
}

class _InheritedSuggestions extends InheritedWidget {
  final SuggestionsStateManager suggestionManager;

  const _InheritedSuggestions({
    required this.suggestionManager,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedSuggestions old) => true;
}
