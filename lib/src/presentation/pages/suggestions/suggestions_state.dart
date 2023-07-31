import 'package:equatable/equatable.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';

class SuggestionsState extends Equatable {
  final List<Suggestion> requests;
  final List<Suggestion> inProgress;
  final List<Suggestion> completed;
  final List<Suggestion> declined;
  final List<Suggestion> duplicated;
  final SuggestionStatus activeTab;
  final bool isCreateBottomSheetOpened;
  final bool isSortingBottomSheetOpened;
  final SortType sortType;

  const SuggestionsState({
    required this.requests,
    required this.inProgress,
    required this.completed,
    required this.declined,
    required this.duplicated,
    required this.isCreateBottomSheetOpened,
    required this.isSortingBottomSheetOpened,
    required this.sortType,
    this.activeTab = SuggestionStatus.requests,
  });

  SuggestionsState newState({
    List<Suggestion>? requests,
    List<Suggestion>? inProgress,
    List<Suggestion>? completed,
    List<Suggestion>? declined,
    List<Suggestion>? duplicated,
    SuggestionStatus? activeTab,
    bool? isCreateBottomSheetOpened,
    bool? isSortingBottomSheetOpened,
    SortType? sortType,
  }) {
    return SuggestionsState(
      requests: requests ?? this.requests,
      inProgress: inProgress ?? this.inProgress,
      completed: completed ?? this.completed,
      declined: declined ?? this.declined,
      duplicated: duplicated ?? this.duplicated,
      activeTab: activeTab ?? this.activeTab,
      isCreateBottomSheetOpened:
          isCreateBottomSheetOpened ?? this.isCreateBottomSheetOpened,
      isSortingBottomSheetOpened:
          isSortingBottomSheetOpened ?? this.isSortingBottomSheetOpened,
      sortType: sortType ?? this.sortType,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        requests,
        inProgress,
        completed,
        declined,
        duplicated,
        activeTab,
        isCreateBottomSheetOpened,
        isSortingBottomSheetOpened,
      ];
}

enum SortType { likes, date }

extension SortTypeExtension on SortType {
  Comparator<Suggestion> get sortFunction {
    return switch (this) {
      SortType.likes => (a, b) => b.upvotesCount.compareTo(a.upvotesCount),
      SortType.date => (a, b) => b.creationTime.compareTo(a.creationTime),
    };
  }
}
