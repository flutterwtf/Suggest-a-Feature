import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suggest_a_feature/src/domain/entities/admin_settings.dart';
import 'package:suggest_a_feature/src/domain/entities/comment.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion_author.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/localization/localization_extensions.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/create_edit/create_edit_suggestion_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/suggestion_cubit.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/suggestion_cubit_scope.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/suggestion_state.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/appbar_widget.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/avatar_widget.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/confirmation_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/create_comment_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/edit_delete_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/notification_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/icon_button.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/network_image.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/photo_view.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/suggestions_labels.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/votes_counter.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
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
    required this.onGetUserById,
    this.onUploadMultiplePhotos,
    this.onSaveToGallery,
    super.key,
  });

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  bool _listenWhen(SuggestionState previous, SuggestionState current) {
    return previous.savingImageResultMessageType !=
            current.savingImageResultMessageType ||
        previous.isPopped != current.isPopped ||
        previous.isEditable != current.isEditable ||
        previous.suggestion.votedUserIds != current.suggestion.votedUserIds;
  }

  void _listener(BuildContext context, SuggestionState state) {
    if (state.savingImageResultMessageType != SavingResultMessageType.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.savingImageResultMessageType ==
                    SavingResultMessageType.success
                ? localization.savingImageSuccess
                : localization.savingImageError,
          ),
        ),
      );
    }
    if (state.isPopped) {
      Navigator.of(context).pop();
    }
    context.read<SuggestionCubit>().reset();
  }

  @override
  Widget build(BuildContext context) {
    return SuggestionCubitScope(
      suggestion: widget.suggestion,
      onGetUserById: widget.onGetUserById,
      child: BlocConsumer<SuggestionCubit, SuggestionState>(
        listenWhen: _listenWhen,
        listener: _listener,
        builder: (context, state) {
          final cubit = context.read<SuggestionCubit>();
          return Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Scaffold(
                appBar: _appBar(cubit, state.isEditable),
                backgroundColor: context.theme.scaffoldBackgroundColor,
                body: _MainContent(
                  onSaveToGallery: widget.onSaveToGallery,
                  onCommentTap: cubit.openDeletingCommentConfirmation,
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _NewCommentButton(
                          onClick: cubit.openCreateCommentBottomSheet,
                        ),
                      ),
                      const SizedBox(width: Dimensions.marginDefault),
                      if (state.suggestion.votedUserIds.contains(i.userId))
                        const SizedBox.shrink()
                      else
                        Expanded(
                          child: _UpvoteButton(
                            isVisible: !state.suggestion.votedUserIds
                                .contains(i.userId),
                            onClick: cubit.vote,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              _BottomSheet(
                onUploadMultiplePhotos: widget.onUploadMultiplePhotos,
                onSaveToGallery: widget.onSaveToGallery,
                onGetUserById: widget.onGetUserById,
              ),
            ],
          );
        },
      ),
    );
  }

  SuggestionsAppBar _appBar(SuggestionCubit cubit, bool isEditable) {
    return SuggestionsAppBar(
      onBackClick: Navigator.of(context).pop,
      screenTitle: localization.suggestion,
      trailing: Padding(
        padding: const EdgeInsets.only(right: Dimensions.marginDefault),
        child: isEditable
            ? SuggestionsIconButton(
                onClick: cubit.openEditDeleteBottomSheet,
                imageIcon: AssetStrings.penIconImage,
                color: context.theme.appBarTheme.actionsIconTheme?.color,
              )
            : SuggestionsIconButton(
                onClick: cubit.openNotificationBottomSheet,
                imageIcon: AssetStrings.notificationsIconImage,
                color: context.theme.appBarTheme.actionsIconTheme?.color,
              ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  final ValueChanged<String> onCommentTap;
  final OnSaveToGalleryCallback? onSaveToGallery;

  const _MainContent({
    required this.onCommentTap,
    this.onSaveToGallery,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuggestionCubit, SuggestionState>(
      buildWhen: (previous, current) =>
          previous.author != current.author ||
          previous.suggestion != current.suggestion ||
          previous.loadingComments != current.loadingComments,
      builder: (context, state) {
        final cubit = context.read<SuggestionCubit>();
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                _UserInfo(
                  author: state.author,
                  isAnonymous: state.suggestion.isAnonymous,
                ),
                _SuggestionInfo(
                  suggestion: state.suggestion,
                  onVote: cubit.vote,
                ),
                const SizedBox(height: Dimensions.marginSmall),
                if (state.suggestion.images.isNotEmpty) ...[
                  _AttachedImages(
                    onSaveToGallery: onSaveToGallery,
                    images: state.suggestion.images,
                  ),
                  const SizedBox(height: Dimensions.marginSmall),
                ],
                if (state.loadingComments)
                  const Center(child: CircularProgressIndicator())
                else if (state.suggestion.comments.isNotEmpty)
                  _CommentList(
                    comments: state.suggestion.comments,
                    onCommentTap: onCommentTap,
                  ),
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
      },
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
        children: [
          Text(
            localization.postedBy,
            style: context.theme.textTheme.bodyMedium
                ?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
          ),
          _Avatar(avatar: author.avatar),
          Expanded(
            child: Text(
              author.username.isEmpty
                  ? localization.anonymousAuthorName
                  : author.username,
              style: context.theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionInfo extends StatelessWidget {
  final Suggestion suggestion;
  final VoidCallback onVote;

  const _SuggestionInfo({
    required this.suggestion,
    required this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.colorScheme.surfaceVariant,
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
          _SuggestionHeaderContent(
            onVote: onVote,
            isVoted: suggestion.votedUserIds.contains(i.userId),
            upvotesCount: suggestion.upvotesCount,
            title: suggestion.title,
          ),
          const SizedBox(height: Dimensions.marginDefault),
          if (suggestion.description != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: Dimensions.marginSmall),
              child: Text(
                suggestion.description!,
                style: context.theme.textTheme.bodyMedium,
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
  final List<String> images;

  const _AttachedImages({
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
      color: context.theme.colorScheme.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.attachedPhotos,
            style: context.theme.textTheme.labelLarge
                ?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: Dimensions.marginMiddle),
          Wrap(
            spacing: Dimensions.marginDefault,
            runSpacing: Dimensions.marginDefault,
            children: images
                .map(
                  (image) => _WrappedAttachedImage(
                    onSaveToGallery: onSaveToGallery,
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
  final ValueChanged<String> onCommentTap;

  const _CommentList({required this.comments, required this.onCommentTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: context.theme.colorScheme.surfaceVariant,
          padding: const EdgeInsets.only(
            top: Dimensions.marginDefault,
            left: Dimensions.marginDefault,
          ),
          child: Text(
            localization.commentsTitle,
            style: context.theme.textTheme.labelLarge
                ?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
          ),
        ),
        Wrap(
          runSpacing: 2,
          children: comments
              .map(
                (comment) => _CommentCard(
                  comment: comment,
                  onTap: onCommentTap,
                ),
              )
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
        backgroundColor: context.theme.colorScheme.surfaceVariant,
        avatar: avatar,
        iconPadding: Dimensions.marginMicro,
        size: Dimensions.defaultSize,
      ),
    );
  }
}

class _SuggestionHeaderContent extends StatelessWidget {
  final VoidCallback onVote;
  final bool isVoted;
  final int upvotesCount;
  final String title;

  const _SuggestionHeaderContent({
    required this.onVote,
    required this.isVoted,
    required this.upvotesCount,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onVote,
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
          child: Text(
            title,
            style: context.theme.textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}

class _WrappedAttachedImage extends StatelessWidget {
  final OnSaveToGalleryCallback? onSaveToGallery;
  final List<String> images;
  final String attachedImage;

  const _WrappedAttachedImage({
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
          builder: (_) {
            return PhotoView(
              onDownloadClick: onSaveToGallery != null
                  ? (path) =>
                      context.read<SuggestionCubit>().showSavingResultMessage(
                            onSaveToGallery!(path),
                          )
                  : null,
              initialIndex: images.indexOf(attachedImage),
              photos: images,
              previousNavBarColor: context.theme.colorScheme.background,
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
  final ValueChanged<String> onTap;

  const _CommentCard({required this.comment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: i.isAdmin || i.userId == comment.author.id
          ? () => onTap(comment.id)
          : null,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.marginDefault),
        color: context.theme.colorScheme.surfaceVariant,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CommentInfo(
              comment: comment,
            ),
            Padding(
              padding: const EdgeInsets.only(left: Dimensions.margin3x),
              child: Text(
                comment.text,
                style: context.theme.textTheme.bodyMedium,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;
  final OnSaveToGalleryCallback? onSaveToGallery;
  final OnGetUserById onGetUserById;

  const _BottomSheet({
    required this.onGetUserById,
    this.onUploadMultiplePhotos,
    this.onSaveToGallery,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuggestionCubit, SuggestionState>(
      buildWhen: (previous, current) =>
          previous.bottomSheetType != current.bottomSheetType ||
          previous.suggestion != current.suggestion,
      builder: (context, state) {
        switch (state.bottomSheetType) {
          case SuggestionBottomSheetType.confirmation:
            return const _OpenConfirmationBottomSheet();
          case SuggestionBottomSheetType.notification:
            return _OpenNotificationBottomSheet(
              isNotificationOn:
                  state.suggestion.notifyUserIds.contains(i.userId),
            );
          case SuggestionBottomSheetType.editDelete:
            return _OpenEditDeleteBottomSheet(
              suggestion: state.suggestion,
            );
          case SuggestionBottomSheetType.createEdit:
            return _OpenCreateEditBottomSheet(
              suggestion: state.suggestion,
              onUploadMultiplePhotos: onUploadMultiplePhotos,
              onSaveToGallery: onSaveToGallery,
            );
          case SuggestionBottomSheetType.createComment:
            return _OpenCreateCommentBottomSheet(
              onGetUserById: onGetUserById,
            );
          case SuggestionBottomSheetType.deleteCommentConfirmation:
            return const _OpenCommentConfirmationBottomSheet();
          case SuggestionBottomSheetType.none:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

class _OpenConfirmationBottomSheet extends StatelessWidget {
  const _OpenConfirmationBottomSheet();

  @override
  Widget build(BuildContext context) {
    final sheetController = SheetController();
    final cubit = context.read<SuggestionCubit>();
    return ConfirmationBottomSheet(
      controller: sheetController,
      question: localization.deletionQuestion,
      onConfirm: () {
        cubit
          ..closeBottomSheet()
          ..deleteSuggestion();
      },
      onCancel: ([_]) async {
        await sheetController.collapse();
        cubit.closeBottomSheet();
      },
      onConfirmAsset: AssetStrings.checkIconImage,
      onCancelText: localization.cancel,
      onConfirmText: localization.yesDelete,
    );
  }
}

class _OpenCommentConfirmationBottomSheet extends StatelessWidget {
  const _OpenCommentConfirmationBottomSheet();

  @override
  Widget build(BuildContext context) {
    final sheetController = SheetController();
    final cubit = context.read<SuggestionCubit>();
    return ConfirmationBottomSheet(
      controller: sheetController,
      question: localization.deletionCommentQuestion,
      onConfirm: () {
        cubit
          ..closeBottomSheet()
          ..deleteComment();
      },
      onCancel: ([_]) async {
        await sheetController.collapse();
        cubit.closeBottomSheet();
      },
      onConfirmAsset: AssetStrings.checkIconImage,
      onCancelText: localization.cancel,
      onConfirmText: localization.yesDelete,
    );
  }
}

class _OpenNotificationBottomSheet extends StatelessWidget {
  final bool isNotificationOn;

  const _OpenNotificationBottomSheet({
    required this.isNotificationOn,
  });

  @override
  Widget build(BuildContext context) {
    final sheetController = SheetController();
    final cubit = context.read<SuggestionCubit>();
    return NotificationSuggestionBottomSheet(
      controller: sheetController,
      isNotificationOn: isNotificationOn,
      onChangeNotification: (isNotificationOn) => cubit.changeNotification(
        isNotificationOn: isNotificationOn,
      ),
      onCancel: ([_]) async {
        await sheetController.collapse();
        cubit.closeBottomSheet();
      },
    );
  }
}

class _OpenEditDeleteBottomSheet extends StatelessWidget {
  final Suggestion suggestion;

  const _OpenEditDeleteBottomSheet({
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    final sheetController = SheetController();
    final cubit = context.read<SuggestionCubit>();
    return EditDeleteSuggestionBottomSheet(
      creationDate: suggestion.creationTime,
      controller: sheetController,
      onCancel: ([_]) async {
        await sheetController.collapse();
        cubit.closeBottomSheet();
      },
      onEditClick: cubit.openCreateEditBottomSheet,
      onDeleteClick: cubit.openConfirmationBottomSheet,
    );
  }
}

class _OpenCreateEditBottomSheet extends StatelessWidget {
  final Suggestion suggestion;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;
  final OnSaveToGalleryCallback? onSaveToGallery;

  const _OpenCreateEditBottomSheet({
    required this.suggestion,
    this.onUploadMultiplePhotos,
    this.onSaveToGallery,
  });

  @override
  Widget build(BuildContext context) {
    final sheetController = SheetController();
    final cubit = context.read<SuggestionCubit>();
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
  final OnGetUserById onGetUserById;

  const _OpenCreateCommentBottomSheet({
    required this.onGetUserById,
  });

  @override
  Widget build(BuildContext context) {
    final sheetController = SheetController();
    final cubit = context.read<SuggestionCubit>();
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
  final VoidCallback onClick;

  const _NewCommentButton({required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.marginDefault,
      ),
      child: FilledButton(
        style: context.theme.filledButtonTheme.style?.copyWith(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) => context.theme.colorScheme.secondaryContainer,
          ),
          foregroundColor: MaterialStatePropertyAll(
            context.theme.colorScheme.onSecondaryContainer,
          ),
        ),
        onPressed: onClick,
        child: Text(localization.newComment),
      ),
    );
  }
}

class _UpvoteButton extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onClick;

  const _UpvoteButton({
    required this.isVisible,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(
            right: Dimensions.marginDefault,
          ),
          child: FilledButton(
            onPressed: onClick,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AssetStrings.suggestionsUpvoteArrow,
                  package: AssetStrings.packageName,
                  colorFilter: ColorFilter.mode(
                    context.theme.colorScheme.onPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: Dimensions.marginSmall),
                Flexible(
                  child: Text(
                    localization.upvote,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
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
      children: [
        AvatarWidget(
          backgroundColor: context.theme.colorScheme.background,
          avatar: author.avatar,
          size: Dimensions.bigSize,
        ),
        const SizedBox(width: Dimensions.marginDefault),
        Expanded(
          child: Text(
            author.username,
            style: context.theme.textTheme.labelLarge,
          ),
        ),
        Text(
          comment.creationTime.formatComment(localization.locale),
          style: context.theme.textTheme.bodyMedium
              ?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  SuggestionAuthor _getDisplayedAuthor(Comment comment, BuildContext context) {
    if (comment.isFromAdmin) {
      return i.adminSettings ??
          AdminSettings(
            id: comment.author.id,
            username: localization.adminAuthorName,
          );
    } else if (comment.isAnonymous || comment.author.username.isEmpty) {
      return SuggestionAuthor(
        id: comment.author.id,
        username: localization.anonymousAuthorName,
      );
    }

    return comment.author;
  }
}
