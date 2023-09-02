import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/domain/data_interfaces/suggestion_repository.dart';
import 'package:suggest_a_feature/src/domain/entities/comment.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion_author.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/suggestion_state.dart';
import 'package:suggest_a_feature/src/presentation/utils/image_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/typedefs.dart';

class SuggestionManager extends StatefulWidget {
  final Suggestion suggestion;
  final OnGetUserById onGetUserById;
  final Widget child;

  const SuggestionManager({
    required this.suggestion,
    required this.onGetUserById,
    required this.child,
    super.key,
  });

  static SuggestionStateManager of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_InheritedSuggestion>()!)
        .suggestionManager;
  }

  @override
  SuggestionStateManager createState() => SuggestionStateManager();
}

class SuggestionStateManager extends State<SuggestionManager> {
  late SuggestionState state;
  late final SuggestionRepository _suggestionRepository;
  StreamSubscription<List<Suggestion>>? _suggestionSubscription;

  @override
  void initState() {
    super.initState();
    _suggestionRepository = i.suggestionRepository;
    state = SuggestionState(
      isPopped: false,
      isEditable: false,
      author: const SuggestionAuthor.empty(),
      savingImageResultMessageType: SavingResultMessageType.none,
      bottomSheetType: SuggestionBottomSheetType.none,
      suggestion: Suggestion.empty(),
      loadingComments: true,
    );
    _init(
      suggestion: widget.suggestion,
      getUserById: widget.onGetUserById,
      isAdmin: i.isAdmin,
    );
  }

  @override
  void dispose() {
    _suggestionSubscription?.cancel();
    _suggestionSubscription = null;
    super.dispose();
  }

  void _init({
    required Suggestion suggestion,
    required OnGetUserById getUserById,
    required bool isAdmin,
  }) {
    _update(
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
        _update(
          state.newState(author: author),
        );
      }
    } else {
      _update(
        state.newState(
          author: _suggestionRepository.userInfo[userId],
        ),
      );
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
      _update(
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
    _update(
      state.newState(loadingComments: false),
    );
  }

  void _update(SuggestionState newState) {
    if (newState != state) {
      setState(() {
        state = newState;
      });
    }
  }

  void reset() {
    _update(
      state.newState(
        savingImageResultMessageType: SavingResultMessageType.none,
      ),
    );
  }

  void openCreateEditBottomSheet() {
    _update(
      state.newState(
        bottomSheetType: SuggestionBottomSheetType.createEdit,
      ),
    );
  }

  void openConfirmationBottomSheet() {
    _update(
      state.newState(
        bottomSheetType: SuggestionBottomSheetType.confirmation,
      ),
    );
  }

  void openEditDeleteBottomSheet() {
    _update(
      state.newState(
        bottomSheetType: SuggestionBottomSheetType.editDelete,
      ),
    );
  }

  void openNotificationBottomSheet() {
    _update(
      state.newState(
        bottomSheetType: SuggestionBottomSheetType.notification,
      ),
    );
  }

  void openCreateCommentBottomSheet() {
    _update(
      state.newState(
        bottomSheetType: SuggestionBottomSheetType.createComment,
      ),
    );
  }

  void closeBottomSheet() {
    _update(
      state.newState(
        bottomSheetType: SuggestionBottomSheetType.none,
      ),
    );
  }

  void _onNewSuggestions(List<Suggestion> suggestions) {
    _update(
      state.newState(
        suggestion: suggestions.firstWhere(
          (Suggestion e) => e.id == state.suggestion.id,
        ),
      ),
    );
  }

  Future<void> showSavingResultMessage(Future<bool?> isSuccess) async {
    final savingResult = await isSuccess;
    if (savingResult != null) {
      _update(
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

      _update(
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
    _update(
      state.newState(isPopped: true),
    );
  }

  void vote() {
    final isVoted = state.suggestion.votedUserIds.contains(i.userId);
    final newVotedUserIds = <String>{
      ...state.suggestion.votedUserIds,
    };

    isVoted
        ? _suggestionRepository.downvote(state.suggestion.id)
        : _suggestionRepository.upvote(state.suggestion.id);
    _update(
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
    final newNotifyUserIds = <String>{
      ...state.suggestion.notifyUserIds,
    };

    isNotificationOn
        ? await _suggestionRepository.addNotifyToUpdateUser(state.suggestion.id)
        : await _suggestionRepository
            .deleteNotifyToUpdateUser(state.suggestion.id);
    _update(
      state.newState(
        suggestion: state.suggestion.copyWith(
          notifyUserIds: isNotificationOn
              ? <String>{...newNotifyUserIds..add(i.userId)}
              : <String>{...newNotifyUserIds..remove(i.userId)},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedSuggestion(
      suggestionManager: this,
      child: widget.child,
    );
  }
}

class _InheritedSuggestion extends InheritedWidget {
  final SuggestionStateManager suggestionManager;

  const _InheritedSuggestion({
    required this.suggestionManager,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedSuggestion old) => true;
}
