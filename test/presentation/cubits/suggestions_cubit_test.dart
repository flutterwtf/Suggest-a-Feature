import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_cubit.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_state.dart';

import '../../utils/mocked_entities.dart';
import '../../utils/shared_mocks.mocks.dart';

void main() {
  group(
    'suggestions cubit',
    () {
      final MockSuggestionInteractor mockSuggestionInteractor = MockSuggestionInteractor();
      final SuggestionsState emptySuggestionsState = SuggestionsState(
        requests: <Suggestion>[mockedSuggestion, mockedSuggestion2],
        inProgress: <Suggestion>[mockedSuggestion, mockedSuggestion2],
        completed: <Suggestion>[mockedSuggestion, mockedSuggestion2],
        isCreateBottomSheetOpened: false,
      );
      final Suggestion upvotedSuggestion = mockedSuggestion2.copyWith(
        votedUserIds: <String>{mockedSuggestionAuthor.id},
      );

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
        act: (SuggestionsCubit cubit) => cubit.changeActiveTab(SuggestionStatus.completed),
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
          return SuggestionsCubit(
            mockSuggestionInteractor,
          );
        },
        seed: () => emptySuggestionsState,
        act: (SuggestionsCubit cubit) async => cubit.vote(SuggestionStatus.requests, 1),
        expect: () => <SuggestionsState>[
          SuggestionsState(
            requests: <Suggestion>[mockedSuggestion, upvotedSuggestion],
            inProgress: <Suggestion>[mockedSuggestion, mockedSuggestion2],
            completed: <Suggestion>[mockedSuggestion, mockedSuggestion2],
            isCreateBottomSheetOpened: false,
          ),
        ],
      );
    },
  );
}
