import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
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
      final mockSuggestionRepository = MockSuggestionRepositoryImpl();
      final mockSuggestionsTheme = MockSuggestionsTheme();
      final mockSuggestionsDataSource = MockSuggestionsDataSource();

      final emptySuggestionState = SuggestionState(
        isPopped: false,
        isEditable: false,
        author: const SuggestionAuthor.empty(),
        savingImageResultMessageType: SavingResultMessageType.none,
        bottomSheetType: SuggestionBottomSheetType.none,
        suggestion: mockedRequestSuggestion,
        loadingComments: false,
      );

      final commentedSuggestion =
          mockedRequestSuggestion.copyWith(comments: [mockedComment]);

      setUp(() {
        i.init(
          theme: mockSuggestionsTheme,
          userId: '1',
          suggestionsDataSource: mockSuggestionsDataSource,
          locale: 'en',
          navigatorKey: GlobalKey<NavigatorState>(),
        );
      });

      blocTest<SuggestionCubit, SuggestionState>(
        'create comment',
        build: () {
          when(mockSuggestionRepository.createComment(mockedCreateCommentModel))
              .thenAnswer((_) async => mockedComment);
          when(mockSuggestionRepository.suggestionsStream).thenAnswer(
            (_) => Stream.value([mockedRequestSuggestion]),
          );
          when(mockSuggestionRepository.userInfo).thenAnswer((_) => {});
          return SuggestionCubit(
            suggestionRepository: mockSuggestionRepository,
            suggestion: mockedRequestSuggestion,
            onGetUserById: (_) => Future.value(const SuggestionAuthor.empty()),
          );
        },
        seed: () => emptySuggestionState,
        act: (SuggestionCubit cubit) => cubit.createComment(
          'Comment1',
          (String id) async => mockedSuggestionAuthor,
          isAnonymous: true,
          postedByAdmin: false,
        ),
        expect: () => <SuggestionState>[
          SuggestionState(
            isPopped: false,
            isEditable: false,
            author: const SuggestionAuthor.empty(),
            savingImageResultMessageType: SavingResultMessageType.none,
            bottomSheetType: SuggestionBottomSheetType.none,
            suggestion: commentedSuggestion,
            loadingComments: false,
          ),
        ],
      );

      blocTest<SuggestionCubit, SuggestionState>(
        'delete suggestion',
        build: () {
          when(mockSuggestionRepository.suggestionsStream).thenAnswer(
            (_) => Stream.value([mockedRequestSuggestion]),
          );
          when(mockSuggestionRepository.userInfo).thenAnswer((_) => {});
          return SuggestionCubit(
            suggestionRepository: mockSuggestionRepository,
            suggestion: mockedRequestSuggestion,
            onGetUserById: (_) => Future.value(const SuggestionAuthor.empty()),
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
            suggestion: mockedRequestSuggestion,
            loadingComments: false,
          ),
        ],
      );

      blocTest<SuggestionCubit, SuggestionState>(
        'upvote',
        build: () {
          when(mockSuggestionRepository.suggestionsStream).thenAnswer(
            (_) => Stream.value([mockedRequestSuggestion]),
          );
          when(mockSuggestionRepository.userInfo).thenAnswer((_) => {});
          return SuggestionCubit(
            suggestionRepository: mockSuggestionRepository,
            suggestion: mockedRequestSuggestion,
            onGetUserById: (_) => Future.value(const SuggestionAuthor.empty()),
          );
        },
        seed: () => emptySuggestionState,
        act: (SuggestionCubit cubit) => cubit.vote(),
        expect: () => [
          SuggestionState(
            isPopped: false,
            isEditable: false,
            author: const SuggestionAuthor.empty(),
            savingImageResultMessageType: SavingResultMessageType.none,
            bottomSheetType: SuggestionBottomSheetType.none,
            suggestion: mockedRequestSuggestion.copyWith(
              votedUserIds: <String>{mockedSuggestionAuthor.id},
            ),
            loadingComments: false,
          ),
          emptySuggestionState,
        ],
      );

      blocTest<SuggestionCubit, SuggestionState>(
        'downvote',
        build: () {
          when(mockSuggestionRepository.suggestionsStream).thenAnswer(
            (_) => Stream.value([mockedRequestSuggestion]),
          );
          when(mockSuggestionRepository.userInfo).thenAnswer((_) => {});
          return SuggestionCubit(
            suggestionRepository: mockSuggestionRepository,
            suggestion: mockedRequestSuggestion,
            onGetUserById: (_) => Future.value(const SuggestionAuthor.empty()),
          );
        },
        seed: () => SuggestionState(
          isPopped: false,
          isEditable: false,
          author: const SuggestionAuthor.empty(),
          savingImageResultMessageType: SavingResultMessageType.none,
          bottomSheetType: SuggestionBottomSheetType.none,
          suggestion: mockedRequestSuggestion.copyWith(
            votedUserIds: <String>{mockedSuggestionAuthor.id},
          ),
          loadingComments: false,
        ),
        act: (SuggestionCubit cubit) => cubit.vote(),
        expect: () => <SuggestionState>[emptySuggestionState],
      );

      blocTest<SuggestionCubit, SuggestionState>(
        'add notification',
        build: () {
          when(mockSuggestionRepository.suggestionsStream).thenAnswer(
            (_) => Stream.value([mockedRequestSuggestion]),
          );
          when(mockSuggestionRepository.userInfo).thenAnswer((_) => {});
          return SuggestionCubit(
            suggestionRepository: mockSuggestionRepository,
            suggestion: mockedRequestSuggestion,
            onGetUserById: (_) => Future.value(const SuggestionAuthor.empty()),
          );
        },
        seed: () => emptySuggestionState,
        act: (SuggestionCubit cubit) => cubit.changeNotification(
          isNotificationOn: true,
        ),
        expect: () => <SuggestionState>[
          SuggestionState(
            isPopped: false,
            isEditable: false,
            author: const SuggestionAuthor.empty(),
            savingImageResultMessageType: SavingResultMessageType.none,
            bottomSheetType: SuggestionBottomSheetType.none,
            suggestion: mockedRequestSuggestion.copyWith(
              notifyUserIds: <String>{mockedSuggestionAuthor.id},
            ),
            loadingComments: false,
          ),
        ],
      );

      blocTest<SuggestionCubit, SuggestionState>(
        'delete notification',
        build: () {
          when(mockSuggestionRepository.suggestionsStream).thenAnswer(
            (_) => Stream.value([mockedRequestSuggestion]),
          );
          when(mockSuggestionRepository.userInfo).thenAnswer((_) => {});
          return SuggestionCubit(
            suggestionRepository: mockSuggestionRepository,
            suggestion: mockedRequestSuggestion,
            onGetUserById: (_) => Future.value(const SuggestionAuthor.empty()),
          );
        },
        seed: () => SuggestionState(
          isPopped: false,
          isEditable: false,
          author: const SuggestionAuthor.empty(),
          savingImageResultMessageType: SavingResultMessageType.none,
          bottomSheetType: SuggestionBottomSheetType.none,
          suggestion: mockedRequestSuggestion.copyWith(
            notifyUserIds: <String>{mockedSuggestionAuthor.id},
          ),
          loadingComments: false,
        ),
        act: (SuggestionCubit cubit) => cubit.changeNotification(
          isNotificationOn: false,
        ),
        expect: () => <SuggestionState>[emptySuggestionState],
      );

      blocTest<SuggestionCubit, SuggestionState>(
        'show successful result message',
        build: () {
          when(mockSuggestionRepository.suggestionsStream).thenAnswer(
            (_) => Stream.value([mockedRequestSuggestion]),
          );
          when(mockSuggestionRepository.userInfo).thenAnswer((_) => {});
          return SuggestionCubit(
            suggestionRepository: mockSuggestionRepository,
            suggestion: mockedRequestSuggestion,
            onGetUserById: (_) => Future.value(const SuggestionAuthor.empty()),
          );
        },
        seed: () => emptySuggestionState,
        act: (SuggestionCubit cubit) =>
            cubit.showSavingResultMessage(Future<bool>.value(true)),
        expect: () => <SuggestionState>[
          SuggestionState(
            isPopped: false,
            isEditable: false,
            author: const SuggestionAuthor.empty(),
            savingImageResultMessageType: SavingResultMessageType.success,
            bottomSheetType: SuggestionBottomSheetType.none,
            suggestion: mockedRequestSuggestion,
            loadingComments: false,
          ),
        ],
      );

      blocTest<SuggestionCubit, SuggestionState>(
        'show failed result message',
        build: () {
          when(mockSuggestionRepository.suggestionsStream).thenAnswer(
            (_) => Stream.value([mockedRequestSuggestion]),
          );
          when(mockSuggestionRepository.userInfo).thenAnswer((_) => {});
          return SuggestionCubit(
            suggestionRepository: mockSuggestionRepository,
            suggestion: mockedRequestSuggestion,
            onGetUserById: (_) => Future.value(const SuggestionAuthor.empty()),
          );
        },
        seed: () => emptySuggestionState,
        act: (SuggestionCubit cubit) =>
            cubit.showSavingResultMessage(Future<bool>.value(false)),
        expect: () => <SuggestionState>[
          SuggestionState(
            isPopped: false,
            isEditable: false,
            author: const SuggestionAuthor.empty(),
            savingImageResultMessageType: SavingResultMessageType.fail,
            bottomSheetType: SuggestionBottomSheetType.none,
            suggestion: mockedRequestSuggestion,
            loadingComments: false,
          ),
        ],
      );

      blocTest<SuggestionCubit, SuggestionState>(
        'open Bottom Sheet',
        build: () {
          when(mockSuggestionRepository.suggestionsStream).thenAnswer(
            (_) => Stream.value([mockedRequestSuggestion]),
          );
          when(mockSuggestionRepository.userInfo).thenAnswer((_) => {});
          return SuggestionCubit(
            suggestionRepository: mockSuggestionRepository,
            suggestion: mockedRequestSuggestion,
            onGetUserById: (_) => Future.value(const SuggestionAuthor.empty()),
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
            suggestion: mockedRequestSuggestion,
            loadingComments: false,
          ),
        ],
      );
    },
  );
}
