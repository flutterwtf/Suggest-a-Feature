import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suggest_a_feature/src/domain/data_interfaces/suggestion_repository.dart';
import 'package:suggest_a_feature/src/domain/entities/comment.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion_author.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/suggestion_state.dart';
import 'package:suggest_a_feature/src/presentation/utils/image_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/typedefs.dart';

class SuggestionCubit extends Cubit<SuggestionState> {
  final SuggestionRepository _suggestionRepository;
  StreamSubscription<List<Suggestion>>? _suggestionSubscription;

  SuggestionCubit(this._suggestionRepository)
      : super(
          SuggestionState(
            isPopped: false,
            isEditable: false,
            author: const SuggestionAuthor.empty(),
            savingImageResultMessageType: SavingResultMessageType.none,
            bottomSheetType: SuggestionBottomSheetType.none,
            suggestion: Suggestion.empty(),
          ),
        );

  void init({
    required Suggestion suggestion,
    required OnGetUserById getUserById,
    required bool isAdmin,
  }) {
    emit(
      state.newState(
        suggestion: suggestion,
        isEditable: (i.userId == suggestion.authorId &&
                suggestion.status == SuggestionStatus.requests) ||
            isAdmin,
      ),
    );
    _suggestionSubscription?.cancel();
    _suggestionSubscription =
        _suggestionRepository.suggestionsStream.listen(_onNewSuggestions);
    _loadComments(getUserById, suggestion.id);
    if (!suggestion.isAnonymous) {
      _loadAuthorProfile(getUserById, suggestion.authorId);
    }
  }

  Future<void> _loadAuthorProfile(
    OnGetUserById getUserById,
    String userId,
  ) async {
    if (!_suggestionRepository.userInfo.containsKey(userId)) {
      final author = await getUserById(userId);
      if (author != null) {
        _suggestionRepository.userInfo[userId] = author;
        emit(state.newState(author: author));
      }
    } else {
      emit(state.newState(author: _suggestionRepository.userInfo[userId]));
    }
  }

  Future<void> _loadComments(
    OnGetUserById getUserById,
    String suggestionId,
  ) async {
    try {
      final comments = await _suggestionRepository.getAllComments(suggestionId);
      final extendedComments = await Future.wait(
        comments.map(
          (Comment e) async {
            if (!e.isFromAdmin) {
              return e.copyWith(
                author: e.isAnonymous ? null : await getUserById(e.author.id),
              );
            }
            return e;
          },
        ),
      )
        ..sort(
          (a, b) => b.creationTime.compareTo(a.creationTime),
        );
      emit(
        state.newState(
          suggestion: state.suggestion.copyWith(comments: extendedComments),
        ),
      );
      _suggestionRepository.refreshSuggestions(
        state.suggestion,
        saveComments: false,
      );
    } catch (e) {
      log('Comments loading error', error: e);
    }
  }

  void dispose() {
    _suggestionSubscription?.cancel();
    _suggestionSubscription = null;
  }

  void reset() {
    emit(
      state.newState(
        savingImageResultMessageType: SavingResultMessageType.none,
      ),
    );
  }

  void openCreateEditBottomSheet() {
    emit(state.newState(bottomSheetType: SuggestionBottomSheetType.createEdit));
  }

  void openConfirmationBottomSheet() {
    emit(
      state.newState(
        bottomSheetType: SuggestionBottomSheetType.confirmation,
      ),
    );
  }

  void openEditDeleteBottomSheet() {
    emit(state.newState(bottomSheetType: SuggestionBottomSheetType.editDelete));
  }

  void openNotificationBottomSheet() {
    emit(
      state.newState(
        bottomSheetType: SuggestionBottomSheetType.notification,
      ),
    );
  }

  void openCreateCommentBottomSheet() {
    emit(
      state.newState(
        bottomSheetType: SuggestionBottomSheetType.createComment,
      ),
    );
  }

  void closeBottomSheet() {
    emit(state.newState(bottomSheetType: SuggestionBottomSheetType.none));
  }

  void _onNewSuggestions(List<Suggestion> suggestions) {
    emit(
      state.newState(
        suggestion: suggestions
            .firstWhere((Suggestion e) => e.id == state.suggestion.id),
      ),
    );
  }

  Future<void> showSavingResultMessage(Future<bool?> isSuccess) async {
    final savingResult = await isSuccess;
    if (savingResult != null) {
      emit(
        state.newState(
          savingImageResultMessageType: savingResult
              ? SavingResultMessageType.success
              : SavingResultMessageType.fail,
        ),
      );
    }
  }

  Future<void> createComment(
    String text,
    OnGetUserById getUserById, {
    required bool isAnonymous,
    required bool postedByAdmin,
  }) async {
    try {
      final comment = await _suggestionRepository.createComment(
        CreateCommentModel(
          authorId: i.userId,
          isAnonymous: isAnonymous,
          text: text,
          suggestionId: state.suggestion.id,
          isFromAdmin: postedByAdmin,
        ),
      );
      final comments = [comment, ...state.suggestion.comments]
        ..sort((a, b) => b.creationTime.compareTo(a.creationTime));

      emit(
        state.newState(
          suggestion: state.suggestion.copyWith(
            comments: comments,
          ),
        ),
      );
      _suggestionRepository.refreshSuggestions(
        state.suggestion,
        saveComments: false,
      );
    } catch (e) {
      log('Comment creation error', error: e);
    }
  }

  Future<void> deleteSuggestion() async {
    _suggestionSubscription?.cancel();
    _suggestionSubscription = null;
    await _suggestionRepository.deleteSuggestion(state.suggestion.id);
    emit(state.newState(isPopped: true));
  }

  void vote() {
    final isVoted = state.suggestion.votedUserIds.contains(i.userId);
    final newVotedUserIds = <String>{...state.suggestion.votedUserIds};

    isVoted
        ? _suggestionRepository.downvote(state.suggestion.id)
        : _suggestionRepository.upvote(state.suggestion.id);
    emit(
      state.newState(
        suggestion: state.suggestion.copyWith(
          votedUserIds: !isVoted
              ? <String>{...newVotedUserIds..add(i.userId)}
              : <String>{...newVotedUserIds..remove(i.userId)},
        ),
      ),
    );
  }

  Future<void> changeNotification({required bool isNotificationOn}) async {
    final newNotifyUserIds = <String>{...state.suggestion.notifyUserIds};

    isNotificationOn
        ? await _suggestionRepository.addNotifyToUpdateUser(state.suggestion.id)
        : await _suggestionRepository
            .deleteNotifyToUpdateUser(state.suggestion.id);
    emit(
      state.newState(
        suggestion: state.suggestion.copyWith(
          notifyUserIds: isNotificationOn
              ? <String>{...newNotifyUserIds..add(i.userId)}
              : <String>{...newNotifyUserIds..remove(i.userId)},
        ),
      ),
    );
  }
}
