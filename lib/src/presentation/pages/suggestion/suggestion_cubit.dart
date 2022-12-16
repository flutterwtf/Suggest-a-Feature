import 'dart:async';
import 'dart:developer';

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

  Future<void> init(Suggestion suggestion, OnGetUserById getUserById) async {
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

  Future<void> _loadAuthorProfile(OnGetUserById getUserById, String userId) async {
    if (!_suggestionInteractor.userInfo.containsKey(userId)) {
      final SuggestionAuthor? author = await getUserById(userId);
      if (author != null) {
        _suggestionInteractor.userInfo[userId] = author;
        emit(state.newState(author: author));
      }
    } else {
      emit(state.newState(author: _suggestionInteractor.userInfo[userId]));
    }
  }

  Future<void> _loadComments(OnGetUserById getUserById, String suggestionId) async {
    try {
      final List<Comment> comments = await _suggestionInteractor.getAllComments(suggestionId);
      final List<Comment> extendedComments = await Future.wait(
        comments.map(
          (Comment e) async => e.copyWith(
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
    } catch (e) {
      log('Comments loading error', error: e);
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
    emit(state.newState(
        suggestion: suggestions.firstWhere((Suggestion e) => e.id == state.suggestion.id)));
  }

  Future<void> showSavingResultMessage(Future<bool?> isSuccess) async {
    final bool? savingResult = await isSuccess;
    if (savingResult != null) {
      emit(
        state.newState(
          savingImageResultMessageType:
              savingResult ? SavingResultMessageType.success : SavingResultMessageType.fail,
        ),
      );
    }
  }

  Future<void> createComment(String text, bool isAnonymous, OnGetUserById getUserById) async {
    try {
      final Comment comment = await _suggestionInteractor.createComment(
        CreateCommentModel(
          authorId: i.userId,
          isAnonymous: isAnonymous,
          text: text,
          suggestionId: state.suggestion.id,
        ),
      );
      emit(
        state.newState(
          suggestion: state.suggestion.copyWith(
            comments: <Comment>[
              ...state.suggestion.comments,
              comment.copyWith(
                author: comment.isAnonymous ? null : await getUserById(comment.author.id),
              ),
            ],
          ),
        ),
      );
      _suggestionInteractor.refreshSuggestions(state.suggestion);
    } catch (e) {
      log('Comment creation error', error: e);
    }
  }

  Future<void> deleteSuggestion() async {
    _suggestionSubscription?.cancel();
    _suggestionSubscription = null;
    await _suggestionInteractor.deleteSuggestion(state.suggestion.id);
    emit(state.newState(isPopped: true));
  }

  void vote() {
    final bool isVoted = state.suggestion.votedUserIds.contains(i.userId);
    final Set<String> newVotedUserIds = <String>{...state.suggestion.votedUserIds};

    !isVoted
        ? _suggestionInteractor.upvote(state.suggestion.id)
        : _suggestionInteractor.downvote(state.suggestion.id);
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

  Future<void> changeNotification(bool isNotificationOn) async {
    final Set<String> newNotifyUserIds = <String>{...state.suggestion.notifyUserIds};

    isNotificationOn
        ? await _suggestionInteractor.addNotifyToUpdateUser(state.suggestion.id)
        : await _suggestionInteractor.deleteNotifyToUpdateUser(state.suggestion.id);
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
