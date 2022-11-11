import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../../domain/entities/comment.dart';
import '../../../domain/entities/suggestion.dart';
import '../../../domain/entities/suggestion_author.dart';
import '../../di/injector.dart';
import '../../utils/assets_strings.dart';
import '../../utils/dimensions.dart';
import '../../utils/context_utils.dart';
import '../../utils/date_utils.dart';
import '../../utils/image_utils.dart';
import '../../utils/typedefs.dart';
import '../theme/suggestions_theme.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/bottom_sheets/confirmation_bottom_sheet.dart';
import '../widgets/bottom_sheets/create_comment_bottom_sheet.dart';
import '../widgets/bottom_sheets/edit_delete_bottom_sheet.dart';
import '../widgets/bottom_sheets/notification_bottom_sheet.dart';
import '../widgets/elevated_button.dart';
import '../widgets/icon_button.dart';
import '../widgets/network_image.dart';
import '../widgets/photo_view.dart';
import '../widgets/suggestions_labels.dart';
import '../widgets/votes_counter.dart';
import 'create_edit/create_edit_suggestion_bottom_sheet.dart';
import 'suggestion_cubit.dart';
import 'suggestion_state.dart';

class SuggestionPage extends StatefulWidget {
  final Suggestion suggestion;
  final OnUploadMultiplePhotosCallback onUploadMultiplePhotos;
  final OnSaveToGalleryCallback onSaveToGallery;
  final OnGetUserById onGetUserById;

  const SuggestionPage({
    Key? key,
    required this.suggestion,
    required this.onUploadMultiplePhotos,
    required this.onSaveToGallery,
    required this.onGetUserById,
  }) : super(key: key);

  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  final SuggestionCubit _cubit = i.suggestionCubit;

  @override
  void initState() {
    _cubit.init(widget.suggestion, widget.onGetUserById);
    super.initState();
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
      listenWhen: (previous, current) {
        return previous.savingImageResultMessageType == SavingResultMessageType.none &&
                current.savingImageResultMessageType != SavingResultMessageType.none ||
            !previous.isPopped && current.isPopped;
      },
      listener: (context, state) {
        if (state.savingImageResultMessageType != SavingResultMessageType.none) {
          state.savingImageResultMessageType == SavingResultMessageType.success
              ? BotToast.showText(text: context.localization.savingImageSuccess)
              : BotToast.showText(text: context.localization.savingImageError);
        }
        if (state.isPopped) {
          Navigator.of(context).pop();
        }
        _cubit.reset();
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: _appBar(state),
              backgroundColor: theme.primaryBackgroundColor,
              body: _mainContent(state),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.marginSmall),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(child: _newCommentButton()),
                  const SizedBox(width: Dimensions.marginDefault),
                  Flexible(child: _upvoteButton(state)),
                ],
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
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            _userInfo(state.author, state.suggestion.isAnonymous),
            _suggestionInfo(state.suggestion),
            const SizedBox(height: Dimensions.marginSmall),
            if (state.suggestion.images.isNotEmpty) ...[
              _attachedImages(state.suggestion.images),
              const SizedBox(height: Dimensions.marginSmall),
            ],
            if (state.suggestion.comments.isNotEmpty) _commentList(state.suggestion.comments),
            state.suggestion.isVoted
                ? const SizedBox(
                    height: Dimensions.size2x * 2 + Dimensions.marginMiddle,
                  )
                : const SizedBox(
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
        return _openConfirmationBottomSheet(context.localization.deletionQuestion);
      case SuggestionBottomSheetType.notification:
        return _openNotificationBottomSheet(state.suggestion.shouldNotifyAfterCompleted);
      case SuggestionBottomSheetType.editDelete:
        return _openEditDeleteBottomSheet(state.suggestion);
      case SuggestionBottomSheetType.createEdit:
        return _openCreateEditBottomSheet(state.suggestion);
      case SuggestionBottomSheetType.createComment:
        return _openCreateCommentBottomSheet();
      case SuggestionBottomSheetType.none:
      default:
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
      onCreateComment: (text, isAnonymous) => _cubit.createComment(
        text,
        isAnonymous,
        widget.onGetUserById,
      ),
    );
  }

  Widget _openNotificationBottomSheet(bool isNotificationOn) {
    final sheetController = SheetController();
    return NotificationSuggestionBottomSheet(
      controller: sheetController,
      isNotificationOn: isNotificationOn,
      onChangeNotification: _cubit.changeNotification,
      onCancel: ([_]) => sheetController.collapse()?.then((_) => _cubit.closeBottomSheet()),
    );
  }

  Widget _openEditDeleteBottomSheet(Suggestion suggestion) {
    final sheetController = SheetController();
    return EditDeleteSuggestionBottomSheet(
      creationDate: suggestion.creationTime,
      controller: sheetController,
      onCancel: ([_]) => sheetController.collapse()?.then((_) => _cubit.closeBottomSheet()),
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
        _cubit.closeBottomSheet();
        _cubit.deleteSuggestion();
      },
      onCancel: ([_]) => sheetController.collapse()?.then((_) => _cubit.closeBottomSheet()),
      onConfirmAsset: AssetStrings.checkIconImage,
      onCancelText: context.localization.cancel,
      onConfirmText: context.localization.yesDelete,
    );
  }

  Widget _userInfo(SuggestionAuthor author, bool isAnonymous) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.marginDefault),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(context.localization.postedBy, style: theme.textMSecondary),
          _avatar(author.avatar),
          Expanded(
            child: Text(
              author.username.isEmpty ? context.localization.anonymousAuthorName : author.username,
              style: theme.textM,
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
        children: [
          Padding(
            padding: const EdgeInsets.only(left: Dimensions.margin3x + 5),
            child: SuggestionLabels(labels: suggestion.labels),
          ),
          const SizedBox(height: Dimensions.marginDefault + 5),
          _suggestionHeaderContent(
            isVoted: suggestion.isVoted,
            upvotesCount: suggestion.upvotesCount,
            title: suggestion.title,
          ),
          const SizedBox(height: Dimensions.marginDefault),
          if (suggestion.description != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: Dimensions.marginSmall),
              child: Text(
                suggestion.description!,
                style: theme.textM,
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
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _cubit.vote,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.marginSmall),
            child: VotesCounter(
              isVoted: isVoted,
              upvotesCount: upvotesCount,
            ),
          ),
        ),
        const SizedBox(width: Dimensions.marginSmall),
        Expanded(
          child: Text(title, style: theme.textMPlusBold),
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
        children: [
          Text(
            context.localization.attachedPhotos,
            style: theme.textMSecondaryBold,
          ),
          const SizedBox(height: Dimensions.marginMiddle),
          Wrap(
            spacing: Dimensions.marginDefault,
            runSpacing: Dimensions.marginDefault,
            children: images.map((image) => _wrappedAttachedImage(images, image)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _wrappedAttachedImage(List<String> images, String attachedImage) {
    return GestureDetector(
      onTap: () {
        showDialog(
          useSafeArea: false,
          barrierColor: Colors.black,
          context: context,
          useRootNavigator: false,
          builder: (context) {
            return PhotoView(
              onDownloadClick: (path) => _cubit.showSavingResultMessage(
                widget.onSaveToGallery(path),
              ),
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
          borderRadius: BorderRadius.all(Radius.circular(Dimensions.smallCircularRadius)),
        ),
        child: FittedBox(
          child: SuggestionsNetworkImage(url: attachedImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _commentList(List<Comment> comments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: theme.secondaryBackgroundColor,
          padding: const EdgeInsets.only(
            top: Dimensions.marginDefault,
            left: Dimensions.marginDefault,
          ),
          child: Text(
            context.localization.commentsTitle,
            style: theme.textMBold.copyWith(color: theme.secondaryTextColor),
          ),
        ),
        Wrap(runSpacing: 2, children: comments.map(_commentCard).toList()),
      ],
    );
  }

  Widget _commentCard(Comment comment) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.marginDefault),
      color: theme.secondaryBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AvatarWidget(
                backgroundColor: theme.primaryBackgroundColor,
                avatar: comment.author.avatar,
                size: Dimensions.bigSize,
              ),
              const SizedBox(width: Dimensions.marginDefault),
              Expanded(
                child: Text(
                  comment.author.username.isEmpty
                      ? context.localization.anonymousAuthorName
                      : comment.author.username,
                  style: theme.textMBold,
                ),
              ),
              Text(
                comment.creationTime.formatComment(context.localization.localeName),
                style: theme.textMSecondary,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: Dimensions.margin3x),
            child: Text(
              comment.text,
              style: theme.textM,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
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
      visible: !state.suggestion.isVoted,
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
