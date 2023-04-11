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
  final OnGetUserById onGetUserById;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;
  final OnSaveToGalleryCallback? onSaveToGallery;

  const SuggestionPage({
    required this.suggestion,
    required this.onGetUserById,
    this.onUploadMultiplePhotos,
    this.onSaveToGallery,
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

  bool _listenWhen(SuggestionState previous, SuggestionState current) {
    return previous.savingImageResultMessageType ==
                SavingResultMessageType.none &&
            current.savingImageResultMessageType !=
                SavingResultMessageType.none ||
        !previous.isPopped && current.isPopped;
  }

  void _listener(BuildContext context, SuggestionState state) {
    if (state.savingImageResultMessageType != SavingResultMessageType.none) {
      state.savingImageResultMessageType == SavingResultMessageType.success
          ? BotToast.showText(text: context.localization.savingImageSuccess)
          : BotToast.showText(text: context.localization.savingImageError);
    }
    if (state.isPopped) {
      Navigator.of(context).pop();
    }
    _cubit.reset();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuggestionCubit, SuggestionState>(
      bloc: _cubit,
      listenWhen: _listenWhen,
      listener: _listener,
      builder: (BuildContext context, SuggestionState state) {
        return Stack(
          children: <Widget>[
            Scaffold(
              appBar: _appBar(state),
              backgroundColor: theme.primaryBackgroundColor,
              body: _MainContent(
                state: state,
                cubit: _cubit,
                onSaveToGallery: widget.onSaveToGallery,
              ),
            ),
            SafeArea(
              top: false,
              bottom: SuggestionsPlatform.isIOS,
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom +
                      Dimensions.marginSmall,
                ),
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Flexible(child: _NewCommentButton(cubit: _cubit)),
                    const SizedBox(width: Dimensions.marginDefault),
                    if (state.suggestion.votedUserIds.contains(i.userId))
                      const SizedBox.shrink()
                    else
                      Flexible(
                        child: _UpvoteButton(
                          state: state,
                          cubit: _cubit,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            _BottomSheet(
              state: state,
              cubit: _cubit,
              onUploadMultiplePhotos: widget.onUploadMultiplePhotos,
              onSaveToGallery: widget.onSaveToGallery,
              onGetUserById: widget.onGetUserById,
            ),
          ],
        );
      },
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
}

class _MainContent extends StatelessWidget {
  final SuggestionState state;
  final SuggestionCubit cubit;
  final OnSaveToGalleryCallback? onSaveToGallery;

  const _MainContent({
    required this.state,
    required this.cubit,
    required this.onSaveToGallery,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _UserInfo(
              author: state.author,
              isAnonymous: state.suggestion.isAnonymous,
            ),
            _SuggestionInfo(suggestion: state.suggestion, cubit: cubit),
            const SizedBox(height: Dimensions.marginSmall),
            if (state.suggestion.images.isNotEmpty) ...<Widget>[
              _AttachedImages(
                onSaveToGallery: onSaveToGallery,
                cubit: cubit,
                images: state.suggestion.images,
              ),
              const SizedBox(height: Dimensions.marginSmall),
            ],
            if (state.suggestion.comments.isNotEmpty)
              _CommentList(comments: state.suggestion.comments),
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
}

class _UserInfo extends StatelessWidget {
  final SuggestionAuthor author;
  final bool isAnonymous;

  const _UserInfo({
    required this.author,
    required this.isAnonymous,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.marginDefault),
      child: Row(
        children: <Widget>[
          Text(
            context.localization.postedBy,
            style: theme.textSmallPlusSecondary,
          ),
          _Avatar(avatar: author.avatar),
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
}

class _SuggestionInfo extends StatelessWidget {
  final Suggestion suggestion;
  final SuggestionCubit cubit;

  const _SuggestionInfo({required this.suggestion, required this.cubit});

  @override
  Widget build(BuildContext context) {
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
          _SuggestionHeaderContent(
            cubit: cubit,
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
}

class _AttachedImages extends StatelessWidget {
  final OnSaveToGalleryCallback? onSaveToGallery;
  final SuggestionCubit cubit;
  final List<String> images;

  const _AttachedImages({
    required this.cubit,
    required this.images,
    this.onSaveToGallery,
  });

  @override
  Widget build(BuildContext context) {
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
                .map(
                  (String image) => _WrappedAttachedImage(
                    onSaveToGallery: onSaveToGallery,
                    cubit: cubit,
                    images: images,
                    attachedImage: image,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _CommentList extends StatelessWidget {
  final List<Comment> comments;

  const _CommentList({required this.comments});

  @override
  Widget build(BuildContext context) {
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
          children: comments
              .map((Comment comment) => _CommentCard(comment: comment))
              .toList(),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? avatar;

  const _Avatar({this.avatar});

  @override
  Widget build(BuildContext context) {
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
}

class _SuggestionHeaderContent extends StatelessWidget {
  final SuggestionCubit cubit;
  final bool isVoted;
  final int upvotesCount;
  final String title;

  const _SuggestionHeaderContent({
    required this.cubit,
    required this.isVoted,
    required this.upvotesCount,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: cubit.vote,
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
}

class _WrappedAttachedImage extends StatelessWidget {
  final SuggestionCubit cubit;
  final List<String> images;
  final String attachedImage;
  final OnSaveToGalleryCallback? onSaveToGallery;

  const _WrappedAttachedImage({
    required this.cubit,
    required this.attachedImage,
    required this.images,
    this.onSaveToGallery,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog<void>(
          useSafeArea: false,
          barrierColor: Colors.black,
          context: context,
          useRootNavigator: false,
          builder: (BuildContext context) {
            return PhotoView(
              onDownloadClick: onSaveToGallery != null
                  ? (String path) =>
                      cubit.showSavingResultMessage(onSaveToGallery!(path))
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
}

class _CommentCard extends StatelessWidget {
  final Comment comment;

  const _CommentCard({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.marginDefault),
      color: theme.secondaryBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _CommentInfo(
            comment: comment,
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
}

class _BottomSheet extends StatelessWidget {
  final SuggestionState state;
  final SuggestionCubit cubit;
  final OnGetUserById onGetUserById;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;
  final OnSaveToGalleryCallback? onSaveToGallery;

  const _BottomSheet({
    required this.state,
    required this.cubit,
    required this.onGetUserById,
    this.onUploadMultiplePhotos,
    this.onSaveToGallery,
  });

  @override
  Widget build(BuildContext context) {
    switch (state.bottomSheetType) {
      case SuggestionBottomSheetType.confirmation:
        return _OpenConfirmationBottomSheet(
          confirmationQuestion: context.localization.deletionQuestion,
          cubit: cubit,
        );
      case SuggestionBottomSheetType.notification:
        return _OpenNotificationBottomSheet(
          isNotificationOn: state.suggestion.notifyUserIds.contains(i.userId),
          cubit: cubit,
        );
      case SuggestionBottomSheetType.editDelete:
        return _OpenEditDeleteBottomSheet(
          suggestion: state.suggestion,
          cubit: cubit,
        );
      case SuggestionBottomSheetType.createEdit:
        return _OpenCreateEditBottomSheet(
          suggestion: state.suggestion,
          cubit: cubit,
          onUploadMultiplePhotos: onUploadMultiplePhotos,
          onSaveToGallery: onSaveToGallery,
        );
      case SuggestionBottomSheetType.createComment:
        return _OpenCreateCommentBottomSheet(
          cubit: cubit,
          onGetUserById: onGetUserById,
        );
      case SuggestionBottomSheetType.none:
        return Container();
    }
  }
}

class _OpenConfirmationBottomSheet extends StatelessWidget {
  final String confirmationQuestion;
  final SuggestionCubit cubit;

  const _OpenConfirmationBottomSheet({
    required this.confirmationQuestion,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final sheetController = SheetController();
    return ConfirmationBottomSheet(
      controller: sheetController,
      question: confirmationQuestion,
      onConfirm: () {
        cubit
          ..closeBottomSheet()
          ..deleteSuggestion();
      },
      onCancel: ([_]) => sheetController.collapse()?.then(
            (_) => cubit.closeBottomSheet(),
          ),
      onConfirmAsset: AssetStrings.checkIconImage,
      onCancelText: context.localization.cancel,
      onConfirmText: context.localization.yesDelete,
    );
  }
}

class _OpenNotificationBottomSheet extends StatelessWidget {
  final bool isNotificationOn;
  final SuggestionCubit cubit;

  const _OpenNotificationBottomSheet({
    required this.isNotificationOn,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final sheetController = SheetController();
    return NotificationSuggestionBottomSheet(
      controller: sheetController,
      isNotificationOn: isNotificationOn,
      onChangeNotification: (bool isNotificationOn) => cubit.changeNotification(
        isNotificationOn: isNotificationOn,
      ),
      onCancel: ([_]) =>
          sheetController.collapse()?.then((_) => cubit.closeBottomSheet()),
    );
  }
}

class _OpenEditDeleteBottomSheet extends StatelessWidget {
  final Suggestion suggestion;
  final SuggestionCubit cubit;

  const _OpenEditDeleteBottomSheet({
    required this.suggestion,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final sheetController = SheetController();
    return EditDeleteSuggestionBottomSheet(
      creationDate: suggestion.creationTime,
      controller: sheetController,
      onCancel: ([_]) =>
          sheetController.collapse()?.then((_) => cubit.closeBottomSheet()),
      onEditClick: cubit.openCreateEditBottomSheet,
      onDeleteClick: cubit.openConfirmationBottomSheet,
    );
  }
}

class _OpenCreateEditBottomSheet extends StatelessWidget {
  final Suggestion suggestion;
  final SuggestionCubit cubit;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;
  final OnSaveToGalleryCallback? onSaveToGallery;

  const _OpenCreateEditBottomSheet({
    required this.suggestion,
    required this.cubit,
    this.onUploadMultiplePhotos,
    this.onSaveToGallery,
  });

  @override
  Widget build(BuildContext context) {
    final sheetController = SheetController();
    return CreateEditSuggestionBottomSheet(
      onClose: ([_]) async {
        await sheetController.collapse();
        cubit.closeBottomSheet();
      },
      onSaveToGallery: onSaveToGallery,
      onUploadMultiplePhotos: onUploadMultiplePhotos,
      controller: sheetController,
      suggestion: suggestion,
    );
  }
}

class _OpenCreateCommentBottomSheet extends StatelessWidget {
  final SuggestionCubit cubit;
  final OnGetUserById onGetUserById;

  const _OpenCreateCommentBottomSheet({
    required this.cubit,
    required this.onGetUserById,
  });

  @override
  Widget build(BuildContext context) {
    final sheetController = SheetController();
    return CreateCommentBottomSheet(
      controller: sheetController,
      onClose: ([_]) async {
        await sheetController.collapse();
        cubit.closeBottomSheet();
      },
      onCreateComment: (
        String text, {
        required bool isAnonymous,
        required bool postedByAdmin,
      }) {
        cubit.createComment(
          text,
          onGetUserById,
          isAnonymous: isAnonymous,
          postedByAdmin: postedByAdmin,
        );
      },
    );
  }
}

class _NewCommentButton extends StatelessWidget {
  final SuggestionCubit cubit;

  const _NewCommentButton({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.marginDefault,
      ),
      child: SuggestionsElevatedButton(
        buttonText: context.localization.newComment,
        onClick: cubit.openCreateCommentBottomSheet,
        backgroundColor: theme.secondaryBackgroundColor,
        textColor: theme.primaryTextColor,
      ),
    );
  }
}

class _UpvoteButton extends StatelessWidget {
  final SuggestionState state;
  final SuggestionCubit cubit;

  const _UpvoteButton({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !state.suggestion.votedUserIds.contains(i.userId),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(
            right: Dimensions.marginDefault,
          ),
          child: SuggestionsElevatedButton(
            onClick: cubit.vote,
            imageIconPath: AssetStrings.suggestionsUpvoteArrow,
            buttonText: context.localization.upvote,
          ),
        ),
      ),
    );
  }
}

class _CommentInfo extends StatelessWidget {
  final Comment comment;

  const _CommentInfo({required this.comment});

  @override
  Widget build(BuildContext context) {
    final author = _getDisplayedAuthor(comment, context);
    return Row(
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
          comment.creationTime.formatComment(context.localization.localeName),
          style: theme.textSmallPlusSecondary,
        ),
      ],
    );
  }

  SuggestionAuthor _getDisplayedAuthor(Comment comment, BuildContext context) {
    if (comment.isFromAdmin) {
      return i.adminSettings ??
          AdminSettings(
            id: comment.author.id,
            username: context.localization.adminAuthorName,
          );
    } else if (comment.isAnonymous || comment.author.username.isEmpty) {
      return SuggestionAuthor(
        id: comment.author.id,
        username: context.localization.anonymousAuthorName,
      );
    }

    return comment.author;
  }
}
