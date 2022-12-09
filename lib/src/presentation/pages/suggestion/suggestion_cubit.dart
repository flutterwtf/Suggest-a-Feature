import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/comment.dart';
import '../../../domain/entities/suggestion.dart';
import '../../../domain/entities/suggestion_author.dart';
import '../../../domain/interactors/suggestion_interactor.dart';
import '../../di/injector.dart';
import '../../utils/image_utils.dart';
import '../../utils/typedefs.dart';
import 'suggestion_state.dart';

class SuggestionCubit extends Cubit<SuggestionState> {
  final SuggestionInteractor _suggestionInteractor;
  StreamSubscription<List<Suggestion>>? _suggestionSubscription;

  SuggestionCubit(this._suggestionInteractor)
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

  void init(Suggestion suggestion, OnGetUserById getUserById) async {
    emit(
      state.newState(
        suggestion: suggestion,
        isEditable:
            i.userId == suggestion.authorId && suggestion.status == SuggestionStatus.requests,
      ),
    );
    _suggestionSubscription?.cancel();
    _suggestionSubscription = _suggestionInteractor.suggestionsStream.listen(_onNewSuggestions);
    _loadComments(getUserById, suggestion.id);
    if (!suggestion.isAnonymous) {
      _loadAuthorProfile(getUserById, suggestion.authorId);
    }
  }

  void _loadAuthorProfile(OnGetUserById getUserById, String userId) async {
    if (!_suggestionInteractor.userInfo.containsKey(userId)) {
      final author = await getUserById(userId);
      if (author != null) {
        _suggestionInteractor.userInfo[userId] = author;
        emit(state.newState(author: author));
      }
    } else {
      emit(state.newState(author: _suggestionInteractor.userInfo[userId]));
    }
  }

  void _loadComments(OnGetUserById getUserById, String suggestionId) async {
    final comments = await _suggestionInteractor.getAllComments(suggestionId);
    if (comments.data != null) {
      final extendedComments = await Future.wait(
        comments.data!.map(
          (e) async => e.copyWith(
            author: e.isAnonymous ? null : await getUserById(e.author.id),
          ),
        ),
      );
      emit(
        state.newState(
          suggestion: state.suggestion.copyWith(comments: extendedComments.toList()),
        ),
      );
      _suggestionInteractor.refreshSuggestions(state.suggestion);
    }
  }

  void dispose() {
    _suggestionSubscription?.cancel();
    _suggestionSubscription = null;
  }

  void reset() {
    emit(state.newState(savingImageResultMessageType: SavingResultMessageType.none));
  }

  void openCreateEditBottomSheet() {
    emit(state.newState(bottomSheetType: SuggestionBottomSheetType.createEdit));
  }

  void openConfirmationBottomSheet() {
    emit(state.newState(bottomSheetType: SuggestionBottomSheetType.confirmation));
  }

  void openEditDeleteBottomSheet() {
    emit(state.newState(bottomSheetType: SuggestionBottomSheetType.editDelete));
  }

  void openNotificationBottomSheet() {
    emit(state.newState(bottomSheetType: SuggestionBottomSheetType.notification));
  }

  void openCreateCommentBottomSheet() {
    emit(state.newState(bottomSheetType: SuggestionBottomSheetType.createComment));
  }

  void closeBottomSheet() {
    emit(state.newState(bottomSheetType: SuggestionBottomSheetType.none));
  }

  void _onNewSuggestions(List<Suggestion> suggestions) {
    emit(state.newState(suggestion: suggestions.firstWhere((e) => e.id == state.suggestion.id)));
  }

  void showSavingResultMessage(Future<bool?> isSuccess) async {
    final savingResult = await isSuccess;
    if (savingResult != null) {
      emit(
        state.newState(
          savingImageResultMessageType:
              savingResult ? SavingResultMessageType.success : SavingResultMessageType.fail,
        ),
      );
    }
  }

  void createComment(String text, bool isAnonymous, OnGetUserById getUserById) async {
    final comment = await _suggestionInteractor.createComment(
      CreateCommentModel(
        authorId: i.userId,
        isAnonymous: isAnonymous,
        text: text,
        suggestionId: state.suggestion.id,
      ),
    );
    if (comment.success() && comment.data != null) {
      emit(
        state.newState(
          suggestion: state.suggestion.copyWith(
            comments: [
              ...state.suggestion.comments,
              comment.data!.copyWith(
                author:
                    comment.data!.isAnonymous ? null : await getUserById(comment.data!.author.id),
              ),
            ],
          ),
        ),
      );
      _suggestionInteractor.refreshSuggestions(state.suggestion);
    }
  }

  void deleteSuggestion() async {
    _suggestionSubscription?.cancel();
    _suggestionSubscription = null;
    await _suggestionInteractor.deleteSuggestion(state.suggestion.id);
    emit(state.newState(isPopped: true));
  }

  void vote() {
    final isVoted = state.suggestion.votedUserIds.contains(i.userId);
    final newVotedUserIds = {...state.suggestion.votedUserIds};

    !isVoted
        ? _suggestionInteractor.upvote(state.suggestion.id)
        : _suggestionInteractor.downvote(state.suggestion.id);
    emit(
      state.newState(
        suggestion: state.suggestion.copyWith(
          votedUserIds: !isVoted
              ? {...newVotedUserIds..add(i.userId)}
              : {...newVotedUserIds..remove(i.userId)},
        ),
      ),
    );
  }

  void changeNotification(bool isNotificationOn) async {
    final newNotifyUserIds = {...state.suggestion.notifyUserIds};

    isNotificationOn
        ? await _suggestionInteractor.addNotifyToUpdateUser(state.suggestion.id)
        : await _suggestionInteractor.deleteNotifyToUpdateUser(state.suggestion.id);
    emit(
      state.newState(
        suggestion: state.suggestion.copyWith(
          notifyUserIds: isNotificationOn
              ? {...newNotifyUserIds..add(i.userId)}
              : {...newNotifyUserIds..remove(i.userId)},
        ),
      ),
    );
  }
}
