import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/domain/utils/simple_behavior_subject.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_cubit.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_state.dart';
import 'package:suggest_a_feature/src/presentation/utils/typedefs.dart';

import '../../utils/mocked_entities.dart';
import '../../utils/shared_mocks.mocks.dart';

void main() {
  group(
    'suggestions cubit',
    () {
      final mockSuggestionsTheme = MockSuggestionsTheme();
      final mockSuggestionsDataSource = MockSuggestionsDataSource();
      final mockSuggestionRepository = MockSuggestionRepositoryImpl();
      const mockSortType = SortType.upvotes;
      final emptySuggestionsState = SuggestionsState(
        requests: [mockedRequestSuggestion, mockedRequestSuggestion2],
        inProgress: [mockedInProgressSuggestion, mockedInProgressSuggestion2],
        completed: [mockedCompletedSuggestion, mockedCompletedSuggestion2],
        declined: const [],
        duplicated: const [],
        sortType: SortType.upvotes,
        loading: false,
      );
      final mockedSuggestions = [
        mockedRequestSuggestion,
        mockedInProgressSuggestion,
        mockedCompletedSuggestion,
        mockedRequestSuggestion2,
        mockedInProgressSuggestion2,
        mockedCompletedSuggestion2,
      ];
      final upvotedSuggestion = mockedRequestSuggestion2.copyWith(
        votedUserIds: {mockedSuggestionAuthor.id},
      );

      setUp(() {
        i.init(
          theme: mockSuggestionsTheme,
          userId: mockedSuggestionAuthor.id,
          suggestionsDataSource: mockSuggestionsDataSource,
          locale: 'en',
          navigatorKey: GlobalKey<NavigatorState>(),
        );
      });

      blocTest<SuggestionsCubit, SuggestionsState>(
        'open CreateBottomSheet',
        build: () {
          when(mockSuggestionRepository.suggestionsStream).thenAnswer(
            (_) => Stream.value(mockedSuggestions),
          );
          return SuggestionsCubit(mockSuggestionRepository, mockSortType);
        },
        seed: () => emptySuggestionsState,
        act: (cubit) => cubit.openCreateBottomSheet(),
        expect: () => [
          CreateState(
            requests: emptySuggestionsState.requests,
            inProgress: emptySuggestionsState.inProgress,
            completed: emptySuggestionsState.completed,
            declined: emptySuggestionsState.declined,
            duplicated: emptySuggestionsState.duplicated,
            sortType: emptySuggestionsState.sortType,
            activeTab: emptySuggestionsState.activeTab,
            loading: emptySuggestionsState.loading,
          ),
        ],
      );

      blocTest<SuggestionsCubit, SuggestionsState>(
        'close CreateBottomSheet',
        build: () {
          when(mockSuggestionRepository.suggestionsStream).thenAnswer(
            (_) => Stream.value(mockedSuggestions),
          );
          return SuggestionsCubit(mockSuggestionRepository, mockSortType);
        },
        seed: () => CreateState(
          requests: emptySuggestionsState.requests,
          inProgress: emptySuggestionsState.inProgress,
          completed: emptySuggestionsState.completed,
          declined: emptySuggestionsState.declined,
          duplicated: emptySuggestionsState.duplicated,
          sortType: emptySuggestionsState.sortType,
          activeTab: emptySuggestionsState.activeTab,
          loading: emptySuggestionsState.loading,
        ),
        act: (cubit) => cubit.closeBottomSheet(),
        expect: () => [
          emptySuggestionsState,
        ],
      );

      blocTest<SuggestionsCubit, SuggestionsState>(
        'change active tab',
        build: () {
          when(mockSuggestionRepository.suggestionsStream).thenAnswer(
            (_) => Stream.value(mockedSuggestions),
          );
          return SuggestionsCubit(mockSuggestionRepository, mockSortType);
        },
        seed: () => emptySuggestionsState.newState(
          activeTab: SuggestionStatus.inProgress,
        ),
        act: (cubit) => cubit.changeActiveTab(SuggestionStatus.completed),
        expect: () => [
          emptySuggestionsState.newState(
            activeTab: SuggestionStatus.completed,
          ),
        ],
      );

      blocTest<SuggestionsCubit, SuggestionsState>(
        'vote requested suggestion',
        build: () {
          final dataStream = SimpleBehaviorSubject([
            mockedRequestSuggestion,
            mockedRequestSuggestion2,
          ]);

          when(mockSuggestionRepository.suggestionsStream).thenAnswer(
            (_) => dataStream.stream(),
          );

          when(mockSuggestionRepository.upvote(any)).thenAnswer(
            (_) async =>
                dataStream.value = [mockedRequestSuggestion, upvotedSuggestion],
          );

          return SuggestionsCubit(mockSuggestionRepository, mockSortType);
        },
        seed: () => SuggestionsState(
          requests: [mockedRequestSuggestion, mockedRequestSuggestion2],
          inProgress: const [],
          completed: const [],
          declined: const [],
          duplicated: const [],
          sortType: SortType.upvotes,
          loading: false,
        ),
        act: (cubit) {
          cubit.vote(SuggestionStatus.requests, 1);
        },
        expect: () => <SuggestionsState>[
          SuggestionsState(
            requests: [upvotedSuggestion, mockedRequestSuggestion],
            inProgress: const [],
            completed: const [],
            declined: const [],
            duplicated: const [],
            sortType: SortType.upvotes,
            loading: false,
          ),
        ],
      );
    },
  );
}
