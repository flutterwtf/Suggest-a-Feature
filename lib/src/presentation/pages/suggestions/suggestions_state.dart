import '../../../domain/entities/suggestion.dart';

class SuggestionsState {
  final List<Suggestion> requests;
  final List<Suggestion> inProgress;
  final List<Suggestion> completed;
  final SuggestionStatus activeTab;
  final bool isCreateBottomSheetOpened;

  SuggestionsState({
    required this.requests,
    required this.inProgress,
    required this.completed,
    required this.isCreateBottomSheetOpened,
    this.activeTab = SuggestionStatus.requests,
  });

  SuggestionsState newState({
    List<Suggestion>? requests,
    List<Suggestion>? inProgress,
    List<Suggestion>? completed,
    SuggestionStatus? activeTab,
    bool? isCreateBottomSheetOpened,
  }) {
    return SuggestionsState(
      requests: requests ?? this.requests,
      inProgress: inProgress ?? this.inProgress,
      completed: completed ?? this.completed,
      activeTab: activeTab ?? this.activeTab,
      isCreateBottomSheetOpened: isCreateBottomSheetOpened ?? this.isCreateBottomSheetOpened,
    );
  }
}
