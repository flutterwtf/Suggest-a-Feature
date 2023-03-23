import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suggest_a_feature/src/domain/entities/admin_settings.dart';
import 'package:suggest_a_feature/src/domain/entities/comment.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion_author.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/create_edit/create_edit_suggestion_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/suggestion_cubit.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/suggestion_state.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/appbar_widget.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/avatar_widget.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/confirmation_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/create_comment_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/edit_delete_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/notification_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/icon_button.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/network_image.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/photo_view.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/suggestions_elevated_button.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/suggestions_labels.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/votes_counter.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:suggest_a_feature/src/presentation/utils/context_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/date_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/src/presentation/utils/image_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/platform_check.dart';
import 'package:suggest_a_feature/src/presentation/utils/typedefs.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

class SuggestionPage extends StatefulWidget {
  final Suggestion suggestion;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;
  final OnSaveToGalleryCallback? onSaveToGallery;
  final OnGetUserById onGetUserById;

  const SuggestionPage({
    required this.suggestion,
    required this.onUploadMultiplePhotos,
    required this.onSaveToGallery,
    required this.onGetUserById,
    super.key,
  });

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  final SuggestionCubit _cubit = i.suggestionCubit;

  @override
  void initState() {
    super.initState();
    _cubit.init(
      suggestion: widget.suggestion,
      getUserById: widget.onGetUserById,
      isAdmin: i.isAdmin,
    );
  }

  @override
  void dispose() {
    _cubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuggestionCubit, SuggestionState>(
      bloc: _cubit,
      listenWhen: (SuggestionState previous, SuggestionState current) {
        return previous.savingImageResultMessageType ==
                    SavingResultMessageType.none &&
                current.savingImageResultMessageType !=
                    SavingResultMessageType.none ||
            !previous.isPopped && current.isPopped;
      },
      listener: (BuildContext context, SuggestionState state) {
        if (state.savingImageResultMessageType !=
            SavingResultMessageType.none) {
          state.savingImageResultMessageType == SavingResultMessageType.success
              ? BotToast.showText(text: context.localization.savingImageSuccess)
              : BotToast.showText(text: context.localization.savingImageError);
        }
        if (state.isPopped) {
          Navigator.of(context).pop();
        }
        _cubit.reset();
      },
      builder: (BuildContext context, SuggestionState state) {
        return Stack(
          children: <Widget>[
            Scaffold(
              appBar: _appBar(state),
              backgroundColor: theme.primaryBackgroundColor,
              body: _mainContent(state),
            ),
            SafeArea(
              top: false,
              bottom: SuggestionsPlatform.isIOS,
              child: Container(
                padding: const EdgeInsets.only(bottom: Dimensions.marginSmall),
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Flexible(child: _newCommentButton()),
                    const SizedBox(width: Dimensions.marginDefault),
                    if (state.suggestion.votedUserIds.contains(i.userId))
                      const SizedBox.shrink()
                    else
                      Flexible(child: _upvoteButton(state)),
                  ],
                ),
              ),
            ),
            _bottomSheet(state),
          ],
        );
      },
    );
  }

  Widget _mainContent(SuggestionState state) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _userInfo(state.author, state.suggestion.isAnonymous),
            _suggestionInfo(state.suggestion),
            const SizedBox(height: Dimensions.marginSmall),
            if (state.suggestion.images.isNotEmpty) ...<Widget>[
              _attachedImages(state.suggestion.images),
              const SizedBox(height: Dimensions.marginSmall),
            ],
            if (state.suggestion.comments.isNotEmpty)
              _commentList(state.suggestion.comments),
            if (state.suggestion.votedUserIds.contains(i.userId))
              const SizedBox(
                height: Dimensions.size2x * 2 + Dimensions.marginMiddle,
              )
            else
              const SizedBox(
                height: Dimensions.size2x * 3 + Dimensions.margin2x,
              ),
          ],
        ),
      ),
    );
  }

  SuggestionsAppBar _appBar(SuggestionState state) {
    return SuggestionsAppBar(
      onBackClick: Navigator.of(context).pop,
      screenTitle: context.localization.suggestion,
      trailing: Padding(
        padding: const EdgeInsets.only(right: Dimensions.marginDefault),
        child: state.isEditable
            ? SuggestionsIconButton(
                onClick: _cubit.openEditDeleteBottomSheet,
                imageIcon: AssetStrings.penIconImage,
              )
            : SuggestionsIconButton(
                onClick: _cubit.openNotificationBottomSheet,
                imageIcon: AssetStrings.notificationsIconImage,
              ),
      ),
    );
  }

  Widget _bottomSheet(SuggestionState state) {
    switch (state.bottomSheetType) {
      case SuggestionBottomSheetType.confirmation:
        return _openConfirmationBottomSheet(
          context.localization.deletionQuestion,
        );
      case SuggestionBottomSheetType.notification:
        return _openNotificationBottomSheet(
          state.suggestion.notifyUserIds.contains(i.userId),
        );
      case SuggestionBottomSheetType.editDelete:
        return _openEditDeleteBottomSheet(state.suggestion);
      case SuggestionBottomSheetType.createEdit:
        return _openCreateEditBottomSheet(state.suggestion);
      case SuggestionBottomSheetType.createComment:
        return _openCreateCommentBottomSheet();
      case SuggestionBottomSheetType.none:
        return Container();
    }
  }

  Widget _openCreateCommentBottomSheet() {
    final sheetController = SheetController();
    return CreateCommentBottomSheet(
      controller: sheetController,
      onClose: ([_]) async {
        await sheetController.collapse();
        _cubit.closeBottomSheet();
      },
      onCreateComment: (
        String text, {
        required bool isAnonymous,
        required bool postedByAdmin,
      }) {
        _cubit.createComment(
          text,
          widget.onGetUserById,
          isAnonymous: isAnonymous,
          postedByAdmin: postedByAdmin,
        );
      },
    );
  }

  Widget _openNotificationBottomSheet(bool isNotificationOn) {
    final sheetController = SheetController();
    return NotificationSuggestionBottomSheet(
      controller: sheetController,
      isNotificationOn: isNotificationOn,
      onChangeNotification: (bool isNotificationOn) =>
          _cubit.changeNotification(
        isNotificationOn: isNotificationOn,
      ),
      onCancel: ([_]) =>
          sheetController.collapse()?.then((_) => _cubit.closeBottomSheet()),
    );
  }

  Widget _openEditDeleteBottomSheet(Suggestion suggestion) {
    final sheetController = SheetController();
    return EditDeleteSuggestionBottomSheet(
      creationDate: suggestion.creationTime,
      controller: sheetController,
      onCancel: ([_]) =>
          sheetController.collapse()?.then((_) => _cubit.closeBottomSheet()),
      onEditClick: _cubit.openCreateEditBottomSheet,
      onDeleteClick: _cubit.openConfirmationBottomSheet,
    );
  }

  Widget _openCreateEditBottomSheet(Suggestion suggestion) {
    final sheetController = SheetController();
    return CreateEditSuggestionBottomSheet(
      onClose: ([_]) async {
        await sheetController.collapse();
        _cubit.closeBottomSheet();
      },
      onSaveToGallery: widget.onSaveToGallery,
      onUploadMultiplePhotos: widget.onUploadMultiplePhotos,
      controller: sheetController,
      suggestion: suggestion,
    );
  }

  Widget _openConfirmationBottomSheet(String confirmationQuestion) {
    final sheetController = SheetController();
    return ConfirmationBottomSheet(
      controller: sheetController,
      question: confirmationQuestion,
      onConfirm: () {
        _cubit
          ..closeBottomSheet()
          ..deleteSuggestion();
      },
      onCancel: ([_]) => sheetController.collapse()?.then(
            (_) => _cubit.closeBottomSheet(),
          ),
      onConfirmAsset: AssetStrings.checkIconImage,
      onCancelText: context.localization.cancel,
      onConfirmText: context.localization.yesDelete,
    );
  }

  Widget _userInfo(SuggestionAuthor author, bool isAnonymous) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.marginDefault),
      child: Row(
        children: <Widget>[
          Text(
            context.localization.postedBy,
            style: theme.textSmallPlusSecondary,
          ),
          _avatar(author.avatar),
          Expanded(
            child: Text(
              author.username.isEmpty
                  ? context.localization.anonymousAuthorName
                  : author.username,
              style: theme.textSmallPlus,
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(String? avatar) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.marginDefault,
        right: Dimensions.marginSmall,
      ),
      child: AvatarWidget(
        backgroundColor: theme.secondaryBackgroundColor,
        avatar: avatar,
        iconPadding: Dimensions.marginMicro,
        size: Dimensions.defaultSize,
      ),
    );
  }

  Widget _suggestionInfo(Suggestion suggestion) {
    return Container(
      color: theme.secondaryBackgroundColor,
      padding: const EdgeInsets.only(
        left: Dimensions.marginDefault,
        right: Dimensions.marginBig,
        top: Dimensions.marginDefault,
        bottom: Dimensions.marginSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: Dimensions.margin3x + 5),
            child: SuggestionLabels(labels: suggestion.labels),
          ),
          const SizedBox(height: Dimensions.marginDefault + 5),
          _suggestionHeaderContent(
            isVoted: suggestion.votedUserIds.contains(i.userId),
            upvotesCount: suggestion.upvotesCount,
            title: suggestion.title,
          ),
          const SizedBox(height: Dimensions.marginDefault),
          if (suggestion.description != null) ...<Widget>[
            Padding(
              padding: const EdgeInsets.only(left: Dimensions.marginSmall),
              child: Text(
                suggestion.description!,
                style: theme.textSmallPlus,
              ),
            ),
            const SizedBox(height: Dimensions.marginDefault),
          ],
        ],
      ),
    );
  }

  Widget _suggestionHeaderContent({
    required bool isVoted,
    required int upvotesCount,
    required String title,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _cubit.vote,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Dimensions.marginSmall),
            child: VotesCounter(
              isVoted: isVoted,
              upvotesCount: upvotesCount,
            ),
          ),
        ),
        const SizedBox(width: Dimensions.marginSmall),
        Expanded(
          child: Text(title, style: theme.textMediumBold),
        ),
      ],
    );
  }

  Widget _attachedImages(List<String> images) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        left: Dimensions.marginDefault,
        top: Dimensions.marginDefault,
        right: Dimensions.marginDefault,
        bottom: Dimensions.marginBig,
      ),
      color: theme.secondaryBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.localization.attachedPhotos,
            style: theme.textSmallPlusSecondaryBold,
          ),
          const SizedBox(height: Dimensions.marginMiddle),
          Wrap(
            spacing: Dimensions.marginDefault,
            runSpacing: Dimensions.marginDefault,
            children: images
                .map((String image) => _wrappedAttachedImage(images, image))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _wrappedAttachedImage(List<String> images, String attachedImage) {
    return GestureDetector(
      onTap: () {
        showDialog<void>(
          useSafeArea: false,
          barrierColor: Colors.black,
          context: context,
          useRootNavigator: false,
          builder: (BuildContext context) {
            return PhotoView(
              onDownloadClick: widget.onSaveToGallery != null
                  ? (String path) => _cubit
                      .showSavingResultMessage(widget.onSaveToGallery!(path))
                  : null,
              initialIndex: images.indexOf(attachedImage),
              photos: images,
              previousNavBarColor: theme.primaryBackgroundColor,
            );
          },
        );
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 80) / 3,
        height: (MediaQuery.of(context).size.width - 80) / 3,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(Dimensions.smallCircularRadius),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.cover,
          child: SuggestionsNetworkImage(url: attachedImage),
        ),
      ),
    );
  }

  Widget _commentList(List<Comment> comments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          color: theme.secondaryBackgroundColor,
          padding: const EdgeInsets.only(
            top: Dimensions.marginDefault,
            left: Dimensions.marginDefault,
          ),
          child: Text(
            context.localization.commentsTitle,
            style: theme.textSmallPlusBold
                .copyWith(color: theme.secondaryTextColor),
          ),
        ),
        Wrap(
          runSpacing: 2,
          children: comments.map(_commentCard).toList(),
        ),
      ],
    );
  }

  Widget _commentCard(Comment comment) {
    final author = _getDisplayedAuthor(comment);
    return Container(
      padding: const EdgeInsets.all(Dimensions.marginDefault),
      color: theme.secondaryBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AvatarWidget(
                backgroundColor: theme.primaryBackgroundColor,
                avatar: author.avatar,
                size: Dimensions.bigSize,
              ),
              const SizedBox(width: Dimensions.marginDefault),
              Expanded(
                child: Text(
                  author.username,
                  style: theme.textSmallPlusBold,
                ),
              ),
              Text(
                comment.creationTime
                    .formatComment(context.localization.localeName),
                style: theme.textSmallPlusSecondary,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: Dimensions.margin3x),
            child: Text(
              comment.text,
              style: theme.textSmallPlus,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  SuggestionAuthor _getDisplayedAuthor(Comment comment) {
    if (comment.isFromAdmin) {
      return i.adminSettings ??
          AdminSettings(
            id: comment.author.id,
            username: context.localization.adminAuthorName,
          );
    } else if (comment.isAnonymous) {
      return SuggestionAuthor(
        id: comment.author.id,
        username: context.localization.anonymousAuthorName,
      );
    }

    return comment.author;
  }

  Widget _newCommentButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.marginDefault,
      ),
      child: SuggestionsElevatedButton(
        buttonText: context.localization.newComment,
        onClick: _cubit.openCreateCommentBottomSheet,
        backgroundColor: theme.secondaryBackgroundColor,
        textColor: theme.primaryTextColor,
      ),
    );
  }

  Widget _upvoteButton(SuggestionState state) {
    return Visibility(
      visible: !state.suggestion.votedUserIds.contains(i.userId),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(
            right: Dimensions.marginDefault,
          ),
          child: SuggestionsElevatedButton(
            onClick: _cubit.vote,
            imageIcon: AssetStrings.suggestionsUpvoteArrow,
            buttonText: context.localization.upvote,
          ),
        ),
      ),
    );
  }
}
