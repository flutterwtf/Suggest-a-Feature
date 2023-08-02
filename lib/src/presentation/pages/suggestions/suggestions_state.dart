import 'package:equatable/equatable.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';

class SuggestionsState extends Equatable {
  final List<Suggestion> requests;
  final List<Suggestion> inProgress;
  final List<Suggestion> completed;
  final List<Suggestion> declined;
  final List<Suggestion> duplicated;
  final SuggestionStatus activeTab;
  final SortType sortType;
  final bool loading;

  const SuggestionsState({
    required this.requests,
    required this.inProgress,
    required this.completed,
    required this.declined,
    required this.duplicated,
    required this.sortType,
    required this.loading,
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
    bool? loading,
  }) {
    return SuggestionsState(
      requests: requests ?? this.requests,
      inProgress: inProgress ?? this.inProgress,
      completed: completed ?? this.completed,
      declined: declined ?? this.declined,
      duplicated: duplicated ?? this.duplicated,
      activeTab: activeTab ?? this.activeTab,
      sortType: sortType ?? this.sortType,
      loading: loading ?? this.loading,
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
        loading,
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
    required super.loading,
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
    bool? loading,
  }) {
    return CreateState(
      requests: requests ?? this.requests,
      inProgress: inProgress ?? this.inProgress,
      completed: completed ?? this.completed,
      declined: declined ?? this.declined,
      duplicated: duplicated ?? this.duplicated,
      activeTab: activeTab ?? this.activeTab,
      sortType: sortType ?? this.sortType,
      loading: loading ?? this.loading,
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
    required super.loading,
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
    bool? loading,
  }) {
    return SortingState(
      requests: requests ?? this.requests,
      inProgress: inProgress ?? this.inProgress,
      completed: completed ?? this.completed,
      declined: declined ?? this.declined,
      duplicated: duplicated ?? this.duplicated,
      activeTab: activeTab ?? this.activeTab,
      sortType: sortType ?? this.sortType,
      loading: loading ?? this.loading,
    );
  }
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

extension SuggestionsStateType on SuggestionsState {
  Type get type {
    if (this is SortingState) return SortingState;
    if (this is CreateState) return CreateState;
    return SuggestionsState;
  }
}
