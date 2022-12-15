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
      final mockSuggestionInteractor = MockSuggestionInteractor();
      final emptySuggestionsState = SuggestionsState(
        requests: [mockedSuggestion, mockedSuggestion2],
        inProgress: [mockedSuggestion, mockedSuggestion2],
        completed: [mockedSuggestion, mockedSuggestion2],
        isCreateBottomSheetOpened: false,
        activeTab: SuggestionStatus.requests,
      );
      final upvotedSuggestion = mockedSuggestion2.copyWith(
        votedUserIds: {mockedSuggestionAuthor.id},
      );

      blocTest<SuggestionsCubit, SuggestionsState>(
        'open CreateBottomSheet',
        build: () {
          return SuggestionsCubit(
            mockSuggestionInteractor,
          );
        },
        seed: () => emptySuggestionsState,
        act: (cubit) => cubit.openCreateBottomSheet(),
        expect: () => [
          SuggestionsState(
            requests: [mockedSuggestion, mockedSuggestion2],
            inProgress: [mockedSuggestion, mockedSuggestion2],
            completed: [mockedSuggestion, mockedSuggestion2],
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
          requests: [mockedSuggestion, mockedSuggestion2],
          inProgress: [mockedSuggestion, mockedSuggestion2],
          completed: [mockedSuggestion, mockedSuggestion2],
          isCreateBottomSheetOpened: true,
        ),
        act: (cubit) => cubit.closeCreateBottomSheet(),
        expect: () => [emptySuggestionsState],
      );

      blocTest<SuggestionsCubit, SuggestionsState>(
        'change active tab',
        build: () {
          return SuggestionsCubit(
            mockSuggestionInteractor,
          );
        },
        seed: () => emptySuggestionsState,
        act: (cubit) => cubit.changeActiveTab(SuggestionStatus.completed),
        expect: () => [
          SuggestionsState(
            requests: [mockedSuggestion, mockedSuggestion2],
            inProgress: [mockedSuggestion, mockedSuggestion2],
            completed: [mockedSuggestion, mockedSuggestion2],
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
        act: (cubit) async => cubit.vote(SuggestionStatus.requests, 1),
        expect: () => [
          SuggestionsState(
            requests: [mockedSuggestion, upvotedSuggestion],
            inProgress: [mockedSuggestion, mockedSuggestion2],
            completed: [mockedSuggestion, mockedSuggestion2],
            isCreateBottomSheetOpened: false,
          ),
        ],
      );
    },
  );
}
