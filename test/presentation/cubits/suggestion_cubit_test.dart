import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/suggestion_cubit.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/suggestion_state.dart';
import 'package:suggest_a_feature/src/presentation/utils/image_utils.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

import '../../utils/mocked_entities.dart';
import '../../utils/shared_mocks.mocks.dart';

void main() {
  group(
    'suggestion cubit',
    () {
      final MockSuggestionInteractor mockSuggestionInteractor = MockSuggestionInteractor();
      final MockSuggestionsTheme mockSuggestionsTheme = MockSuggestionsTheme();
      final MockSuggestionsDataSource mockSuggestionsDataSource = MockSuggestionsDataSource();

      final SuggestionState emptySuggestionState = SuggestionState(
        isPopped: false,
        isEditable: false,
        author: const SuggestionAuthor.empty(),
        savingImageResultMessageType: SavingResultMessageType.none,
        bottomSheetType: SuggestionBottomSheetType.none,
        suggestion: mockedSuggestion,
      );

      final Suggestion commentedSuggestion =
          mockedSuggestion.copyWith(comments: <Comment>[mockedComment]);

      setUp(() {
        i.init(
          theme: mockSuggestionsTheme,
          userId: '1',
          suggestionsDataSource: mockSuggestionsDataSource,
        );
      });

      blocTest<SuggestionCubit, SuggestionState>(
        'create comment',
        build: () {
          when(mockSuggestionInteractor.createComment(mockedCreateCommentModel))
              .thenAnswer((_) async => mockedComment);
          return SuggestionCubit(
            mockSuggestionInteractor,
          );
        },
        seed: () => emptySuggestionState,
        act: (SuggestionCubit cubit) => cubit.createComment(
          'Comment1',
          true,
          (String id) async => mockedSuggestionAuthor,
        ),
        expect: () => <SuggestionState>[
          SuggestionState(
            isPopped: false,
            isEditable: false,
            author: const SuggestionAuthor.empty(),
            savingImageResultMessageType: SavingResultMessageType.none,
            bottomSheetType: SuggestionBottomSheetType.none,
            suggestion: commentedSuggestion,
          ),
        ],
      );

      blocTest<SuggestionCubit, SuggestionState>(
        'delete suggestion',
        build: () {
          return SuggestionCubit(
            mockSuggestionInteractor,
          );
        },
        seed: () => emptySuggestionState,
        act: (SuggestionCubit cubit) => cubit.deleteSuggestion(),
        expect: () => <SuggestionState>[
          SuggestionState(
            isPopped: true,
            isEditable: false,
            author: const SuggestionAuthor.empty(),
            savingImageResultMessageType: SavingResultMessageType.none,
            bottomSheetType: SuggestionBottomSheetType.none,
            suggestion: mockedSuggestion,
          ),
        ],
      );

      blocTest<SuggestionCubit, SuggestionState>(
        'upvote',
        build: () {
          return SuggestionCubit(
            mockSuggestionInteractor,
          );
        },
        seed: () => emptySuggestionState,
        act: (SuggestionCubit cubit) => cubit.vote(),
        expect: () => <SuggestionState>[
          SuggestionState(
            isPopped: false,
            isEditable: false,
            author: const SuggestionAuthor.empty(),
            savingImageResultMessageType: SavingResultMessageType.none,
            bottomSheetType: SuggestionBottomSheetType.none,
            suggestion: mockedSuggestion.copyWith(
              votedUserIds: <String>{mockedSuggestionAuthor.id},
            ),
          ),
        ],
      );

      blocTest<SuggestionCubit, SuggestionState>(
        'downvote',
        build: () {
          return SuggestionCubit(
            mockSuggestionInteractor,
          );
        },
        seed: () => SuggestionState(
          isPopped: false,
          isEditable: false,
          author: const SuggestionAuthor.empty(),
          savingImageResultMessageType: SavingResultMessageType.none,
          bottomSheetType: SuggestionBottomSheetType.none,
          suggestion: mockedSuggestion.copyWith(
            votedUserIds: <String>{},
          ),
        ),
        act: (SuggestionCubit cubit) => cubit.vote(),
        expect: () => <SuggestionState>[emptySuggestionState],
      );

      blocTest<SuggestionCubit, SuggestionState>(
        'add notification',
        build: () {
          return SuggestionCubit(
            mockSuggestionInteractor,
          );
        },
        seed: () => emptySuggestionState,
        act: (SuggestionCubit cubit) => cubit.changeNotification(true),
        expect: () => <SuggestionState>[
          SuggestionState(
            isPopped: false,
            isEditable: false,
            author: const SuggestionAuthor.empty(),
            savingImageResultMessageType: SavingResultMessageType.none,
            bottomSheetType: SuggestionBottomSheetType.none,
            suggestion: mockedSuggestion.copyWith(
              notifyUserIds: <String>{mockedSuggestionAuthor.id},
            ),
          ),
        ],
      );

      blocTest<SuggestionCubit, SuggestionState>(
        'delete notification',
        build: () {
          return SuggestionCubit(
            mockSuggestionInteractor,
          );
        },
        seed: () => SuggestionState(
          isPopped: false,
          isEditable: false,
          author: const SuggestionAuthor.empty(),
          savingImageResultMessageType: SavingResultMessageType.none,
          bottomSheetType: SuggestionBottomSheetType.none,
          suggestion: mockedSuggestion.copyWith(
            notifyUserIds: <String>{},
          ),
        ),
        act: (SuggestionCubit cubit) => cubit.changeNotification(false),
        expect: () => <SuggestionState>[emptySuggestionState],
      );

      blocTest<SuggestionCubit, SuggestionState>(
        'show successful result message',
        build: () {
          return SuggestionCubit(
            mockSuggestionInteractor,
          );
        },
        seed: () => emptySuggestionState,
        act: (SuggestionCubit cubit) => cubit.showSavingResultMessage(Future<bool>.value(true)),
        expect: () => <SuggestionState>[
          SuggestionState(
            isPopped: false,
            isEditable: false,
            author: const SuggestionAuthor.empty(),
            savingImageResultMessageType: SavingResultMessageType.success,
            bottomSheetType: SuggestionBottomSheetType.none,
            suggestion: mockedSuggestion,
          ),
        ],
      );

      blocTest<SuggestionCubit, SuggestionState>(
        'show failed result message',
        build: () {
          return SuggestionCubit(
            mockSuggestionInteractor,
          );
        },
        seed: () => emptySuggestionState,
        act: (SuggestionCubit cubit) => cubit.showSavingResultMessage(Future<bool>.value(false)),
        expect: () => <SuggestionState>[
          SuggestionState(
            isPopped: false,
            isEditable: false,
            author: const SuggestionAuthor.empty(),
            savingImageResultMessageType: SavingResultMessageType.fail,
            bottomSheetType: SuggestionBottomSheetType.none,
            suggestion: mockedSuggestion,
          ),
        ],
      );

      blocTest<SuggestionCubit, SuggestionState>(
        'open Bottom Sheet',
        build: () {
          return SuggestionCubit(
            mockSuggestionInteractor,
          );
        },
        seed: () => emptySuggestionState,
        act: (SuggestionCubit cubit) => cubit.openCreateCommentBottomSheet(),
        expect: () => <SuggestionState>[
          SuggestionState(
            isPopped: false,
            isEditable: false,
            author: const SuggestionAuthor.empty(),
            savingImageResultMessageType: SavingResultMessageType.none,
            bottomSheetType: SuggestionBottomSheetType.createComment,
            suggestion: mockedSuggestion,
          ),
        ],
      );
    },
  );
}
