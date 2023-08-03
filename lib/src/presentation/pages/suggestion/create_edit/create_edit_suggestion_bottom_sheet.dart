import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/create_edit/create_edit_suggestion_cubit.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/create_edit/create_edit_suggestion_cubit_scope.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/create_edit/create_edit_suggestion_state.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/add_event_photo_button.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/base_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/label_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/status_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/clickable_list_item.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/network_image.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/photo_view.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/small_photo_preview.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/suggestions_labels.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/suggestions_switch.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/suggestions_text_field.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:suggest_a_feature/src/presentation/utils/constants/numeric_constants.dart';
import 'package:suggest_a_feature/src/presentation/utils/context_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/src/presentation/utils/image_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/typedefs.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

class CreateEditSuggestionBottomSheet extends StatefulWidget {
  final Suggestion? suggestion;
  final VoidCallback onClose;
  final SheetController controller;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;
  final OnSaveToGalleryCallback? onSaveToGallery;

  const CreateEditSuggestionBottomSheet({
    required this.onClose,
    required this.controller,
    this.suggestion,
    this.onUploadMultiplePhotos,
    this.onSaveToGallery,
    super.key,
  });

  @override
  State<CreateEditSuggestionBottomSheet> createState() =>
      _CreateEditSuggestionBottomSheetState();
}

class _CreateEditSuggestionBottomSheetState
    extends State<CreateEditSuggestionBottomSheet> {
  late final SheetController _labelsSheetController;
  late final SheetController _statusesSheetController;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final FocusNode _titleFocusNode;
  late final FocusNode _descriptionFocusNode;

  @override
  void initState() {
    super.initState();
    _labelsSheetController = SheetController();
    _statusesSheetController = SheetController();
    _titleController = TextEditingController(text: widget.suggestion?.title);
    _descriptionController =
        TextEditingController(text: widget.suggestion?.description);
    _titleFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  bool _listenWhen(
    CreateEditSuggestionState previous,
    CreateEditSuggestionState current,
  ) {
    return previous.savingImageResultMessageType !=
            current.savingImageResultMessageType ||
        previous.isSubmitted != current.isSubmitted ||
        previous.isPhotoViewOpen != current.isPhotoViewOpen ||
        previous.isLabelsBottomSheetOpen != current.isLabelsBottomSheetOpen ||
        previous.suggestion.labels != current.suggestion.labels ||
        previous.suggestion.status != current.suggestion.status;
  }

  void _listener(BuildContext context, CreateEditSuggestionState state) {
    final cubit = context.read<CreateEditSuggestionCubit>();
    if (state.savingImageResultMessageType != SavingResultMessageType.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.savingImageResultMessageType ==
                    SavingResultMessageType.success
                ? context.localization.savingImageSuccess
                : context.localization.savingImageError,
          ),
        ),
      );
    } else if (state.isSubmitted) {
      widget.onClose();
    } else if (state.isPhotoViewOpen) {
      _openPhotoView(state, cubit);
    }
    cubit.reset();
  }

  @override
  Widget build(BuildContext context) {
    return CreateEditSuggestionCubitScope(
      suggestion: widget.suggestion,
      child: BlocConsumer<CreateEditSuggestionCubit, CreateEditSuggestionState>(
        listenWhen: _listenWhen,
        listener: _listener,
        builder: (_, state) {
          if (state.isLabelsBottomSheetOpen) {
            return _LabelsBottomSheet(
              suggestionLabels: state.suggestion.labels,
              labelsSheetController: _labelsSheetController,
            );
          } else if (state.isStatusBottomSheetOpen && i.isAdmin) {
            return _StatusesBottomSheet(
              suggestionStatus: state.suggestion.status,
              statusesSheetController: _statusesSheetController,
            );
          } else if (!state.isPhotoViewOpen) {
            return _CreateEditSuggestionBottomSheet(
              titleFocusNode: _titleFocusNode,
              controller: widget.controller,
              onUploadMultiplePhotos: widget.onUploadMultiplePhotos,
              descriptionController: _descriptionController,
              descriptionFocusNode: _descriptionFocusNode,
              titleController: _titleController,
              onClose: widget.onClose,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _openPhotoView(
    CreateEditSuggestionState state,
    CreateEditSuggestionCubit cubit,
  ) async {
    await showDialog<void>(
      useSafeArea: false,
      barrierColor: Colors.black,
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return PhotoView(
          initialIndex: state.openPhotoIndex!,
          onDeleteClick: cubit.removePhoto,
          onDownloadClick: widget.onSaveToGallery != null
              ? (String path) =>
                  cubit.showSavingResultMessage(widget.onSaveToGallery!(path))
              : null,
          photos: state.suggestion.images,
          previousNavBarColor: context.theme.colorScheme.surface,
        );
      },
    );
    cubit.changePhotoViewStatus(isPhotoViewOpen: false);
  }
}

class _CreateEditSuggestionBottomSheet extends StatelessWidget {
  final FocusNode titleFocusNode;
  final SheetController controller;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;
  final TextEditingController descriptionController;
  final FocusNode descriptionFocusNode;
  final TextEditingController titleController;
  final VoidCallback onClose;

  const _CreateEditSuggestionBottomSheet({
    required this.titleFocusNode,
    required this.controller,
    required this.descriptionController,
    required this.descriptionFocusNode,
    required this.titleController,
    required this.onClose,
    this.onUploadMultiplePhotos,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateEditSuggestionCubit>();
    return BaseBottomSheet(
      controller: controller,
      onOpen: titleFocusNode.requestFocus,
      onClose: ([_]) => onClose(),
      backgroundColor: context.theme.bottomSheetTheme.backgroundColor ??
          context.theme.colorScheme.background,
      previousNavBarColor: context.theme.colorScheme.background,
      previousStatusBarColor: context.theme.colorScheme.surfaceVariant,
      initialSnapping: 0.85,
      contentBuilder: (context, sheetState) {
        return _EditSuggestionBottomSheetListView(
          titleController: titleController,
          descriptionController: descriptionController,
          titleFocusNode: titleFocusNode,
          descriptionFocusNode: descriptionFocusNode,
          onUploadMultiplePhotos: onUploadMultiplePhotos,
          onTitleChanged: cubit.changeSuggestionTitle,
          onDescriptionChanged: cubit.changeSuggestionDescription,
          onLabelChanged: (value) => cubit.changeLabelsBottomSheetStatus(
            isLabelsBottomSheetOpen: value,
          ),
          onAnonymityChanged: (value) => cubit.changeSuggestionAnonymity(
            isAnonymous: value,
          ),
          onStatusChanged: (value) => cubit.changeStatusBottomSheetStatus(
            isStatusBottomSheetOpen: value,
          ),
          onSave: cubit.saveSuggestion,
        );
      },
    );
  }
}

class _LabelItems extends StatelessWidget {
  final List<SuggestionLabel> labels;
  final ValueChanged<bool> changeLabelsBottomSheetStatus;

  const _LabelItems({
    required this.labels,
    required this.changeLabelsBottomSheetStatus,
  });

  @override
  Widget build(BuildContext context) {
    return ClickableListItem(
      title: Text(
        context.localization.labels,
        style: context.theme.textTheme.labelLarge
            ?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
      ),
      trailing: labels.isNotEmpty
          ? SuggestionLabels(labels: labels)
          : SvgPicture.asset(
              AssetStrings.plusIconThickImage,
              package: AssetStrings.packageName,
              colorFilter: ColorFilter.mode(
                context.theme.colorScheme.onBackground,
                BlendMode.srcIn,
              ),
              height: Dimensions.defaultSize,
            ),
      onClick: () => changeLabelsBottomSheetStatus(true),
      verticalPadding: Dimensions.marginDefault,
    );
  }
}

class _SuggestionStatus extends StatelessWidget {
  final SuggestionStatus suggestionStatus;
  final ValueChanged<bool> changeStatusBottomSheetStatus;

  const _SuggestionStatus({
    required this.suggestionStatus,
    required this.changeStatusBottomSheetStatus,
  });

  String _suggestionStatus(BuildContext context) {
    switch (suggestionStatus) {
      case SuggestionStatus.completed:
        return context.localization.completed;
      case SuggestionStatus.inProgress:
        return context.localization.inProgress;
      case SuggestionStatus.requests:
        return context.localization.requests;
      case SuggestionStatus.declined:
        return context.localization.declined;
      case SuggestionStatus.duplicated:
        return context.localization.duplicated;
      case SuggestionStatus.unknown:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClickableListItem(
      title: Text(
        context.localization.status,
        style: context.theme.textTheme.labelLarge
            ?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
      ),
      trailing: Text(
        _suggestionStatus(context),
        style: context.theme.textTheme.labelLarge,
      ),
      onClick: () => changeStatusBottomSheetStatus(true),
      verticalPadding: Dimensions.marginDefault,
    );
  }
}

class _SaveSubmitButton extends StatelessWidget {
  final bool isEditing;
  final bool isLoading;
  final VoidCallback saveSuggestion;

  const _SaveSubmitButton({
    required this.isEditing,
    required this.isLoading,
    required this.saveSuggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.marginDefault,
      ),
      child: FilledButton(
        onPressed: isLoading ? () {} : saveSuggestion,
        child: Text(
          isEditing ? context.localization.save : context.localization.suggest,
        ),
      ),
    );
  }
}

class _PostAnonymously extends StatelessWidget {
  final bool isAnonymously;
  final ValueChanged<bool> changeSuggestionAnonymity;

  const _PostAnonymously({
    required this.isAnonymously,
    required this.changeSuggestionAnonymity,
  });

  @override
  Widget build(BuildContext context) {
    return ClickableListItem(
      title: Text(
        context.localization.postAnonymously,
        style: context.theme.textTheme.labelLarge
            ?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
      ),
      trailing: SuggestionsSwitch(
        value: isAnonymously,
        onChanged: changeSuggestionAnonymity,
      ),
    );
  }
}

class _PhotoPickerItem extends StatelessWidget {
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;

  const _PhotoPickerItem({
    required this.onUploadMultiplePhotos,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEditSuggestionCubit, CreateEditSuggestionState>(
      buildWhen: (previous, current) =>
          previous.isLoading != current.isLoading ||
          previous.suggestion.images != current.suggestion.images,
      builder: (context, state) {
        final cubit = context.read<CreateEditSuggestionCubit>();

        if (state.suggestion.images.isNotEmpty) {
          final tileWidth = state.suggestion.images.length == 1
              ? (MediaQuery.of(context).size.width - Dimensions.margin3x) / 2
              : (MediaQuery.of(context).size.width - Dimensions.margin4x) / 3;

          return SizedBox(
            height:
                MediaQuery.of(context).size.height * Dimensions.smallSize / 100,
            child: Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.marginMiddle),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: state.suggestion.images.length + 1,
                itemBuilder: (BuildContext context, int i) {
                  return _PhotoItem(
                    isAddButtonShown: i == 0,
                    isLoading: state.isLoading,
                    imageUrl: i != 0 ? state.suggestion.images[i - 1] : '',
                    tileWidth: state.suggestion.images.length > 2
                        ? tileWidth * 0.9
                        : tileWidth,
                    onUploadPhotos: () {
                      final availableNumOfPhotos = maxPhotosForOneSuggestion -
                          state.suggestion.images.length;
                      if (availableNumOfPhotos > 0) {
                        cubit.addUploadedPhotos(
                          onUploadMultiplePhotos!(
                            availableNumOfPhotos: availableNumOfPhotos,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.localization.eventPhotosRestriction,
                            ),
                          ),
                        );
                      }
                    },
                    onPhotoClick: () => cubit.onPhotoClick(i - 1),
                  );
                },
              ),
            ),
          );
        }

        return _AddButton(
          isLoading: state.isLoading,
          isSmall: state.suggestion.images.isNotEmpty,
          onUploadPhotos: () => cubit.addUploadedPhotos(
            onUploadMultiplePhotos!(
              availableNumOfPhotos: maxPhotosForOneSuggestion,
            ),
          ),
        );
      },
    );
  }
}

class _PhotoItem extends StatelessWidget {
  final bool isAddButtonShown;
  final bool isLoading;
  final String imageUrl;
  final VoidCallback onUploadPhotos;
  final double tileWidth;
  final VoidCallback onPhotoClick;

  const _PhotoItem({
    required this.isAddButtonShown,
    required this.isLoading,
    required this.imageUrl,
    required this.onUploadPhotos,
    required this.tileWidth,
    required this.onPhotoClick,
  });

  @override
  Widget build(BuildContext context) {
    if (isAddButtonShown) {
      return GestureDetector(
        onTap: onUploadPhotos,
        child: AddPhotoButton(
          width: tileWidth,
          height: (MediaQuery.of(context).size.width - 80) / 3,
          style: context.theme.textTheme.labelLarge!,
          isLoading: isLoading,
        ),
      );
    } else {
      return GestureDetector(
        onTap: onPhotoClick,
        child: Container(
          margin: const EdgeInsets.only(
            right: Dimensions.marginDefault,
          ),
          width: tileWidth,
          height: 98,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(Dimensions.smallCircularRadius),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.cover,
            child: SuggestionsNetworkImage(
              url: imageUrl,
            ),
          ),
        ),
      );
    }
  }
}

class _AddButton extends StatelessWidget {
  final bool isLoading;
  final bool isSmall;
  final VoidCallback onUploadPhotos;

  const _AddButton({
    required this.isLoading,
    required this.isSmall,
    required this.onUploadPhotos,
  });

  @override
  Widget build(BuildContext context) {
    return ClickableListItem(
      title: Text(
        context.localization.addPhoto,
        style: context.theme.textTheme.labelLarge
            ?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
      ),
      trailing: isLoading
          ? CircularProgressIndicator(
              strokeWidth: 1,
              valueColor: AlwaysStoppedAnimation<Color>(
                context.theme.colorScheme.onBackground,
              ),
            )
          : SvgPicture.asset(
              AssetStrings.plusIconThickImage,
              package: AssetStrings.packageName,
              colorFilter: ColorFilter.mode(
                context.theme.colorScheme.onBackground,
                BlendMode.srcIn,
              ),
              height: isSmall ? Dimensions.smallSize : Dimensions.defaultSize,
            ),
      onClick: onUploadPhotos,
      verticalPadding: Dimensions.marginDefault,
    );
  }
}

class _PhotoPreview extends StatefulWidget {
  final List<String> suggestionImages;
  final VoidCallback onPreviewClick;

  const _PhotoPreview({
    required this.suggestionImages,
    required this.onPreviewClick,
  });

  @override
  _PhotoPreviewState createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<_PhotoPreview> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPreviewClick,
      child: SizedBox(
        width: widget.suggestionImages.length <= 3
            ? Dimensions.microSize +
                Dimensions.smallSize * widget.suggestionImages.length
            : Dimensions.veryBigSize,
        child: Stack(
          children: [
            if (widget.suggestionImages.isNotEmpty)
              SizedBox(
                width: Dimensions.defaultSize,
                child: SmallPhotoPreview(
                  src: widget.suggestionImages[0],
                  heroTag: 'photo_view',
                  backgroundColor: context.theme.colorScheme.surfaceVariant,
                ),
              ),
            if (widget.suggestionImages.length >= 2)
              Container(
                width: Dimensions.largeSize,
                padding: const EdgeInsets.only(left: Dimensions.marginDefault),
                child: SmallPhotoPreview(
                  src: widget.suggestionImages[1],
                  heroTag: 'photo_view',
                  backgroundColor: context.theme.colorScheme.surfaceVariant,
                ),
              ),
            if (widget.suggestionImages.length >= 3)
              Container(
                width: Dimensions.veryBigSize,
                padding: const EdgeInsets.only(left: Dimensions.margin2x),
                child: SmallPhotoPreview(
                  src: widget.suggestionImages[2],
                  heroTag: 'photo_view',
                  backgroundColor: context.theme.colorScheme.surfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EditSuggestionBottomSheetListView extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final FocusNode titleFocusNode;
  final FocusNode descriptionFocusNode;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<bool> onLabelChanged;
  final ValueChanged<bool> onStatusChanged;
  final ValueChanged<bool> onAnonymityChanged;
  final VoidCallback onSave;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;

  const _EditSuggestionBottomSheetListView({
    required this.titleController,
    required this.descriptionController,
    required this.titleFocusNode,
    required this.descriptionFocusNode,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onLabelChanged,
    required this.onStatusChanged,
    required this.onAnonymityChanged,
    required this.onSave,
    required this.onUploadMultiplePhotos,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEditSuggestionCubit, CreateEditSuggestionState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.marginSmall,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            SuggestionsTextField(
              controller: titleController,
              focusNode: titleFocusNode,
              hintText: context.localization.title,
              padding: const EdgeInsets.fromLTRB(
                Dimensions.marginDefault,
                Dimensions.marginDefault,
                Dimensions.marginSmall,
                Dimensions.marginDefault,
              ),
              onChanged: (text) {
                if (state.suggestion.title != text) {
                  onTitleChanged(text);
                }
              },
              isShowError: state.isShowTitleError,
            ),
            const SizedBox(height: Dimensions.marginDefault),
            SuggestionsTextField(
              controller: descriptionController,
              focusNode: descriptionFocusNode,
              hintText: context.localization.description,
              padding: const EdgeInsets.fromLTRB(
                Dimensions.marginDefault,
                Dimensions.marginDefault,
                Dimensions.marginSmall,
                Dimensions.marginDefault,
              ),
              onChanged: (String text) {
                if (state.suggestion.description != text) {
                  onDescriptionChanged(text);
                }
              },
            ),
            const SizedBox(height: Dimensions.marginBig),
            const Divider(thickness: 0.5, height: 1.5),
            _LabelItems(
              labels: state.suggestion.labels,
              changeLabelsBottomSheetStatus: onLabelChanged,
            ),
            ..._suggestionStatus(
              isEditing: state.isEditing,
              status: state.suggestion.status,
            ),
            ..._multiplePicker(
              isImagesEmpty: state.suggestion.images.isEmpty,
            ),
            ..._anonymitySwitch(
              isEditing: state.isEditing,
              isAnonymous: state.suggestion.isAnonymous,
            ),
            _SaveSubmitButton(
              isEditing: state.isEditing,
              isLoading: state.isLoading,
              saveSuggestion: onSave,
            ),
          ],
        );
      },
    );
  }

  List<Widget> _suggestionStatus({
    required bool isEditing,
    required SuggestionStatus status,
  }) {
    if (i.isAdmin && isEditing) {
      return [
        const Divider(thickness: 0.5, height: 1.5),
        _SuggestionStatus(
          suggestionStatus: status,
          changeStatusBottomSheetStatus: onStatusChanged,
        ),
      ];
    }
    return [];
  }

  List<Widget> _multiplePicker({required bool isImagesEmpty}) {
    if (onUploadMultiplePhotos != null) {
      return [
        if (!isImagesEmpty)
          const SizedBox.shrink()
        else
          const _DividerWithIndent(),
        _PhotoPickerItem(
          onUploadMultiplePhotos: onUploadMultiplePhotos,
        ),
      ];
    }
    return [];
  }

  List<Widget> _anonymitySwitch({
    required bool isEditing,
    required bool isAnonymous,
  }) {
    if (!isEditing) {
      return [
        const _DividerWithIndent(),
        const SizedBox(height: Dimensions.marginSmall),
        _PostAnonymously(
          isAnonymously: isAnonymous,
          changeSuggestionAnonymity: onAnonymityChanged,
        ),
        const SizedBox(height: Dimensions.marginSmall),
      ];
    }
    return [];
  }
}

class _StatusesBottomSheet extends StatelessWidget {
  final SuggestionStatus suggestionStatus;
  final SheetController statusesSheetController;

  const _StatusesBottomSheet({
    required this.suggestionStatus,
    required this.statusesSheetController,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateEditSuggestionCubit>();
    return StatusBottomSheet(
      controller: statusesSheetController,
      selectedStatus: suggestionStatus,
      onCancel: ([_]) async {
        await statusesSheetController.collapse();
        cubit.changeStatusBottomSheetStatus(
          isStatusBottomSheetOpen: false,
        );
      },
      onDone: (status) async {
        cubit.changeStatus(status);
        await statusesSheetController.collapse();
        cubit.changeStatusBottomSheetStatus(
          isStatusBottomSheetOpen: false,
        );
      },
    );
  }
}

class _LabelsBottomSheet extends StatelessWidget {
  final List<SuggestionLabel> suggestionLabels;
  final SheetController labelsSheetController;

  const _LabelsBottomSheet({
    required this.suggestionLabels,
    required this.labelsSheetController,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateEditSuggestionCubit>();
    return LabelBottomSheet(
      controller: labelsSheetController,
      selectedLabels: suggestionLabels,
      onCancel: ([_]) async {
        await labelsSheetController.collapse();
        cubit.changeLabelsBottomSheetStatus(
          isLabelsBottomSheetOpen: false,
        );
      },
      onDone: (labels) async {
        cubit.selectLabels(labels);
        await labelsSheetController.collapse();
        cubit.changeLabelsBottomSheetStatus(
          isLabelsBottomSheetOpen: false,
        );
      },
    );
  }
}

class _DividerWithIndent extends StatelessWidget {
  const _DividerWithIndent();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 0.5,
      height: 1.5,
      indent: Dimensions.marginDefault,
      endIndent: Dimensions.marginDefault,
    );
  }
}
