import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_cubit.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_state.dart';

import '../../utils/mocked_entities.dart';
import '../../utils/shared_mocks.mocks.dart';

void main() {
  group(
    'suggestions cubit',
    () {
      final mockSuggestionsTheme = MockSuggestionsTheme();
      final mockSuggestionsDataSource = MockSuggestionsDataSource();
      final mockSuggestionRepository = MockSuggestionRepositoryImpl();
      final emptySuggestionsState = SuggestionsState(
        requests: [mockedRequestSuggestion, mockedRequestSuggestion2],
        inProgress: [mockedInProgressSuggestion, mockedInProgressSuggestion2],
        completed: [mockedCompletedSuggestion, mockedCompletedSuggestion2],
        declined: const [],
        duplicated: const [],
        isCreateBottomSheetOpened: false,
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
        );
      });

      blocTest<SuggestionsCubit, SuggestionsState>(
        'open CreateBottomSheet',
        build: () {
          when(mockSuggestionRepository.suggestionsStream).thenAnswer(
            (_) => Stream.value(mockedSuggestions),
          );
          return SuggestionsCubit(
            mockSuggestionRepository,
          );
        },
        seed: () => emptySuggestionsState,
        act: (cubit) => cubit.openCreateBottomSheet(),
        expect: () => [
          emptySuggestionsState.newState(
            isCreateBottomSheetOpened: true,
          ),
        ],
      );

      blocTest<SuggestionsCubit, SuggestionsState>(
        'close CreateBottomSheet',
        build: () {
          when(mockSuggestionRepository.suggestionsStream).thenAnswer(
            (_) => Stream.value(mockedSuggestions),
          );
          return SuggestionsCubit(
            mockSuggestionRepository,
          );
        },
        seed: () => emptySuggestionsState.newState(
          isCreateBottomSheetOpened: true,
        ),
        act: (cubit) => cubit.closeCreateBottomSheet(),
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
          return SuggestionsCubit(
            mockSuggestionRepository,
          );
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
          final dataStream = BehaviorSubject.seeded([
            mockedRequestSuggestion,
            mockedRequestSuggestion2,
          ]);

          when(mockSuggestionRepository.suggestionsStream).thenAnswer(
            (_) => dataStream,
          );

          when(mockSuggestionRepository.upvote(any)).thenAnswer(
            (_) async => dataStream.add(
              [mockedRequestSuggestion, upvotedSuggestion],
            ),
          );

          return SuggestionsCubit(
            mockSuggestionRepository,
          );
        },
        seed: () => SuggestionsState(
          requests: [mockedRequestSuggestion, mockedRequestSuggestion2],
          inProgress: const [],
          completed: const [],
          declined: const [],
          duplicated: const [],
          isCreateBottomSheetOpened: false,
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
            isCreateBottomSheetOpened: false,
          ),
        ],
      );
    },
  );
}
