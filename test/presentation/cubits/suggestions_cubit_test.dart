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
      final mockSuggestionInteractor = MockSuggestionInteractor();
      final emptySuggestionsState = SuggestionsState(
        requests: <Suggestion>[mockedSuggestion, mockedSuggestion2],
        inProgress: <Suggestion>[mockedSuggestion, mockedSuggestion2],
        completed: <Suggestion>[mockedSuggestion, mockedSuggestion2],
        isCreateBottomSheetOpened: false,
      );
      final upvotedSuggestion = mockedSuggestion2.copyWith(
        votedUserIds: <String>{mockedSuggestionAuthor.id},
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
          return SuggestionsCubit(
            mockSuggestionInteractor,
          );
        },
        seed: () => emptySuggestionsState,
        act: (SuggestionsCubit cubit) => cubit.openCreateBottomSheet(),
        expect: () => <SuggestionsState>[
          SuggestionsState(
            requests: <Suggestion>[mockedSuggestion, mockedSuggestion2],
            inProgress: <Suggestion>[mockedSuggestion, mockedSuggestion2],
            completed: <Suggestion>[mockedSuggestion, mockedSuggestion2],
            isCreateBottomSheetOpened: true,
          ),
        ],
      );

      blocTest<SuggestionsCubit, SuggestionsState>(
        'close CreateBottomSheet',
        build: () {
          return SuggestionsCubit(
            mockSuggestionInteractor,
          );
        },
        seed: () => SuggestionsState(
          requests: <Suggestion>[mockedSuggestion, mockedSuggestion2],
          inProgress: <Suggestion>[mockedSuggestion, mockedSuggestion2],
          completed: <Suggestion>[mockedSuggestion, mockedSuggestion2],
          isCreateBottomSheetOpened: true,
        ),
        act: (SuggestionsCubit cubit) => cubit.closeCreateBottomSheet(),
        expect: () => <SuggestionsState>[emptySuggestionsState],
      );

      blocTest<SuggestionsCubit, SuggestionsState>(
        'change active tab',
        build: () {
          return SuggestionsCubit(
            mockSuggestionInteractor,
          );
        },
        seed: () => emptySuggestionsState,
        act: (SuggestionsCubit cubit) =>
            cubit.changeActiveTab(SuggestionStatus.completed),
        expect: () => <SuggestionsState>[
          SuggestionsState(
            requests: <Suggestion>[mockedSuggestion, mockedSuggestion2],
            inProgress: <Suggestion>[mockedSuggestion, mockedSuggestion2],
            completed: <Suggestion>[mockedSuggestion, mockedSuggestion2],
            isCreateBottomSheetOpened: false,
            activeTab: SuggestionStatus.completed,
          ),
        ],
      );

      blocTest<SuggestionsCubit, SuggestionsState>(
        'vote requested suggestion',
        build: () {
          final dataStream = BehaviorSubject.seeded([
            mockedSuggestion,
            mockedSuggestion2,
          ]);

          when(mockSuggestionInteractor.suggestionsStream).thenAnswer(
            (_) => dataStream,
          );

          when(mockSuggestionInteractor.upvote(any)).thenAnswer(
            (_) => dataStream.add([mockedSuggestion, upvotedSuggestion]),
          );

          return SuggestionsCubit(
            mockSuggestionInteractor,
          )..init();
        },
        seed: () => SuggestionsState(
          requests: [mockedSuggestion, mockedSuggestion2],
          inProgress: const [],
          completed: const [],
          isCreateBottomSheetOpened: false,
        ),
        act: (cubit) {
          cubit.vote(SuggestionStatus.requests, 1);
        },
        expect: () => <SuggestionsState>[
          SuggestionsState(
            requests: [upvotedSuggestion, mockedSuggestion],
            inProgress: const [],
            completed: const [],
            isCreateBottomSheetOpened: false,
          ),
        ],
      );
    },
  );
}
