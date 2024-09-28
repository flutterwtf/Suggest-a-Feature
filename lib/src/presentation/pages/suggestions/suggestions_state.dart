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
  final bool loading;
  final Suggestion? suggestion;
  final bool isRedirect;

  const SuggestionsState({
    required this.requests,
    required this.inProgress,
    required this.completed,
    required this.declined,
    required this.duplicated,
    required this.sortType,
    required this.loading,
    this.activeTab = SuggestionStatus.requests,
    this.suggestion,
    this.isRedirect = false,
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
    Suggestion? suggestion,
    bool? isRedirect,
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
      suggestion: suggestion ?? this.suggestion,
      isRedirect: isRedirect ?? this.isRedirect,
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
        suggestion,
        isRedirect,
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
    super.suggestion,
    super.activeTab,
    super.isRedirect,
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
    Suggestion? suggestion,
    bool? isRedirect,
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
      suggestion: suggestion ?? this.suggestion,
      isRedirect: isRedirect ?? this.isRedirect,
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
    super.suggestion,
    super.isRedirect,
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
    Suggestion? suggestion,
    bool? isRedirect,
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
      suggestion: suggestion ?? this.suggestion,
      isRedirect: isRedirect ?? this.isRedirect,
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
