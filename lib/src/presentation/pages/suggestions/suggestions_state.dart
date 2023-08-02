import 'package:equatable/equatable.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/presentation/utils/typedefs.dart';

class SuggestionsState extends Equatable {
  final List<Suggestion> requests;
  final List<Suggestion> inProgress;
  final List<Suggestion> completed;
  final List<Suggestion> declined;
  final List<Suggestion> duplicated;
  final SuggestionStatus activeTab;
  final SortType sortType;

  const SuggestionsState({
    required this.requests,
    required this.inProgress,
    required this.completed,
    required this.declined,
    required this.duplicated,
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
    SortType? sortType,
  }) {
    return SuggestionsState(
      requests: requests ?? this.requests,
      inProgress: inProgress ?? this.inProgress,
      completed: completed ?? this.completed,
      declined: declined ?? this.declined,
      duplicated: duplicated ?? this.duplicated,
      activeTab: activeTab ?? this.activeTab,
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
        sortType,
      ];
}

class CreateState extends SuggestionsState {
  const CreateState({
    required super.requests,
    required super.inProgress,
    required super.completed,
    required super.declined,
    required super.duplicated,
    required super.sortType,
    super.activeTab,
  });

  @override
  CreateState newState({
    List<Suggestion>? requests,
    List<Suggestion>? inProgress,
    List<Suggestion>? completed,
    List<Suggestion>? declined,
    List<Suggestion>? duplicated,
    SuggestionStatus? activeTab,
    SortType? sortType,
  }) {
    return CreateState(
      requests: requests ?? this.requests,
      inProgress: inProgress ?? this.inProgress,
      completed: completed ?? this.completed,
      declined: declined ?? this.declined,
      duplicated: duplicated ?? this.duplicated,
      activeTab: activeTab ?? this.activeTab,
      sortType: sortType ?? this.sortType,
    );
  }
}

class SortingState extends SuggestionsState {
  const SortingState({
    required super.requests,
    required super.inProgress,
    required super.completed,
    required super.declined,
    required super.duplicated,
    required super.sortType,
    super.activeTab,
  });

  @override
  SortingState newState({
    List<Suggestion>? requests,
    List<Suggestion>? inProgress,
    List<Suggestion>? completed,
    List<Suggestion>? declined,
    List<Suggestion>? duplicated,
    SuggestionStatus? activeTab,
    SortType? sortType,
  }) {
    return SortingState(
      requests: requests ?? this.requests,
      inProgress: inProgress ?? this.inProgress,
      completed: completed ?? this.completed,
      declined: declined ?? this.declined,
      duplicated: duplicated ?? this.duplicated,
      activeTab: activeTab ?? this.activeTab,
      sortType: sortType ?? this.sortType,
    );
  }
}

extension SortTypeExtension on SortType {
  Comparator<Suggestion> get sortFunction {
    return switch (this) {
      SortType.upvotes => (a, b) => b.upvotesCount.compareTo(a.upvotesCount),
      SortType.creationDate => (a, b) =>
          b.creationTime.compareTo(a.creationTime),
    };
  }
}

extension SuggestionsStateType on SuggestionsState {
  Type get type {
    if (this is SortingState) return SortingState;
    if (this is CreateState) return CreateState;
    return SuggestionsState;
  }
}
