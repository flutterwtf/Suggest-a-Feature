import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/status_bottom_sheet.dart';

import '../../../../domain/entities/suggestion.dart';
import '../../../di/injector.dart';
import '../../../utils/assets_strings.dart';
import '../../../utils/constants/numeric_constants.dart';
import '../../../utils/context_utils.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/image_utils.dart';
import '../../../utils/typedefs.dart';
import '../../theme/suggestions_theme.dart';
import '../../widgets/add_event_photo_button.dart';
import '../../widgets/bottom_sheets/base_bottom_sheet.dart';
import '../../widgets/bottom_sheets/label_bottom_sheet.dart';
import '../../widgets/clickable_list_item.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/network_image.dart';
import '../../widgets/photo_view.dart';
import '../../widgets/small_photo_preview.dart';
import '../../widgets/suggestions_labels.dart';
import '../../widgets/switch.dart';
import '../../widgets/text_field.dart';
import 'create_edit_suggestion_cubit.dart';
import 'create_edit_suggestion_state.dart';

class CreateEditSuggestionBottomSheet extends StatefulWidget {
  final Suggestion? suggestion;
  final VoidCallback onClose;
  final SheetController controller;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;
  final OnSaveToGalleryCallback? onSaveToGallery;

  const CreateEditSuggestionBottomSheet({
    required this.onClose,
    required this.controller,
    required this.onUploadMultiplePhotos,
    required this.onSaveToGallery,
    this.suggestion,
    super.key,
  });

  @override
  CreateEditSuggestionBottomSheetState createState() =>
      CreateEditSuggestionBottomSheetState();
}

class CreateEditSuggestionBottomSheetState
    extends State<CreateEditSuggestionBottomSheet>
    with TickerProviderStateMixin {
  final CreateEditSuggestionCubit _cubit = i.createEditSuggestionCubit;
  final SheetController _labelsSheetController = SheetController();
  final SheetController _statusesSheetController = SheetController();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late FocusNode _titleFocusNode;
  late FocusNode _descriptionFocusNode;

  @override
  void initState() {
    _cubit.init(widget.suggestion);
    _titleController = TextEditingController(text: widget.suggestion?.title);
    _descriptionController =
        TextEditingController(text: widget.suggestion?.description);
    super.initState();
    _titleFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
    _titleFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateEditSuggestionCubit, CreateEditSuggestionState>(
      bloc: _cubit,
      listenWhen: (
        CreateEditSuggestionState previous,
        CreateEditSuggestionState current,
      ) {
        return (previous.savingImageResultMessageType ==
                    SavingResultMessageType.none &&
                current.savingImageResultMessageType !=
                    SavingResultMessageType.none) ||
            (!previous.isSubmitted && current.isSubmitted) ||
            (previous.isPhotoViewOpen != current.isPhotoViewOpen);
      },
      listener: (BuildContext context, CreateEditSuggestionState state) {
        if (state.savingImageResultMessageType !=
            SavingResultMessageType.none) {
          state.savingImageResultMessageType == SavingResultMessageType.success
              ? BotToast.showText(text: context.localization.savingImageSuccess)
              : BotToast.showText(text: context.localization.savingImageError);
        } else if (state.isSubmitted) {
          widget.onClose();
        } else if (state.isPhotoViewOpen) {
          _openPhotoView(state);
        }
        _cubit.reset();
      },
      builder: (BuildContext context, CreateEditSuggestionState state) {
        if (state.isLabelsBottomSheetOpen) {
          return _labelsBottomSheet(state.suggestion.labels);
        } else if (state.isStatusBottomSheetOpen && i.adminSettings != null) {
          return _statusesBottomSheet(state.suggestion.status);
        } else if (!state.isPhotoViewOpen) {
          return _createEditSuggestionBottomSheet(state);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _createEditSuggestionBottomSheet(CreateEditSuggestionState state) {
    return BaseBottomSheet(
      controller: widget.controller,
      onOpen: () => _titleFocusNode.requestFocus(),
      onClose: ([_]) => widget.onClose(),
      backgroundColor: theme.bottomSheetBackgroundColor,
      previousNavBarColor: theme.primaryBackgroundColor,
      previousStatusBarColor: theme.primaryBackgroundColor,
      initialSnapping: 0.85,
      contentBuilder: (BuildContext context, SheetState sheetState) {
        return ListView(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.marginSmall,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            SuggestionsTextField(
              controller: _titleController,
              focusNode: _titleFocusNode,
              hintText: context.localization.title,
              padding: const EdgeInsets.fromLTRB(
                Dimensions.marginDefault,
                Dimensions.marginDefault,
                Dimensions.marginSmall,
                Dimensions.marginDefault,
              ),
              onChanged: (String text) {
                if (state.suggestion.title != text) {
                  _cubit.changeSuggestionTitle(text);
                }
              },
              isShowError: state.isShowTitleError,
            ),
            const SizedBox(height: Dimensions.marginDefault),
            SuggestionsTextField(
              controller: _descriptionController,
              focusNode: _descriptionFocusNode,
              hintText: context.localization.description,
              padding: const EdgeInsets.fromLTRB(
                Dimensions.marginDefault,
                Dimensions.marginDefault,
                Dimensions.marginSmall,
                Dimensions.marginDefault,
              ),
              onChanged: (String text) {
                if (state.suggestion.description != text) {
                  _cubit.changeSuggestionDescription(text);
                }
              },
            ),
            const SizedBox(height: Dimensions.marginBig),
            Divider(color: theme.dividerColor, thickness: 0.5, height: 1.5),
            _LabelItems(
              labels: state.suggestion.labels,
              changeLabelsBottomSheetStatus: (value) =>
                  _cubit.changeLabelsBottomSheetStatus(
                isLabelsBottomSheetOpen: value,
              ),
            ),
            if (i.adminSettings != null && state.isEditing) ...<Widget>[
              Divider(color: theme.dividerColor, thickness: 0.5, height: 1.5),
              _SuggestionStatus(
                suggestionStatus: state.suggestion.status,
                changeStatusBottomSheetStatus: (value) =>
                    _cubit.changeStatusBottomSheetStatus(
                  isStatusBottomSheetOpen: value,
                ),
              ),
            ],
            if (widget.onUploadMultiplePhotos != null) ...<Widget>[
              if (state.suggestion.images.isNotEmpty)
                const SizedBox.shrink()
              else
                _dividerWithIndent(),
              _PhotoPickerItem(
                state: state,
                onUploadMultiplePhotos: widget.onUploadMultiplePhotos,
              ),
            ],
            if (!state.isEditing) ...<Widget>[
              _dividerWithIndent(),
              const SizedBox(height: Dimensions.marginSmall),
              _PostAnonymously(
                isAnonymously: state.suggestion.isAnonymous,
                changeSuggestionAnonymity: (value) =>
                    _cubit.changeSuggestionAnonymity(isAnonymous: value),
              ),
              const SizedBox(height: Dimensions.marginSmall),
            ],
            _SaveSubmitButton(
              isEditing: state.isEditing,
              isLoading: state.isLoading,
              saveSuggestion: _cubit.saveSuggestion,
            ),
          ],
        );
      },
    );
  }

  Widget _labelsBottomSheet(List<SuggestionLabel> suggestionList) {
    return LabelBottomSheet(
      controller: _labelsSheetController,
      selectedLabels: suggestionList,
      onCancel: ([_]) => _labelsSheetController.collapse()?.then(
            (_) => _cubit.changeLabelsBottomSheetStatus(
              isLabelsBottomSheetOpen: false,
            ),
          ),
      onDone: (List<SuggestionLabel> labels) {
        _cubit.selectLabels(labels);
        _labelsSheetController.collapse()?.then(
              (_) => _cubit.changeLabelsBottomSheetStatus(
                isLabelsBottomSheetOpen: false,
              ),
            );
      },
    );
  }

  Widget _statusesBottomSheet(SuggestionStatus suggestionStatus) {
    return StatusBottomSheet(
      controller: _statusesSheetController,
      selectedStatus: suggestionStatus,
      onCancel: ([_]) => _statusesSheetController.collapse()?.then(
            (_) => _cubit.changeStatusBottomSheetStatus(
              isStatusBottomSheetOpen: false,
            ),
          ),
      onDone: (SuggestionStatus status) {
        _cubit.changeStatus(status);
        _statusesSheetController.collapse()?.then(
              (_) => _cubit.changeStatusBottomSheetStatus(
                isStatusBottomSheetOpen: false,
              ),
            );
      },
    );
  }

  Widget _dividerWithIndent() {
    return Divider(
      color: theme.dividerColor,
      thickness: 0.5,
      height: 1.5,
      indent: Dimensions.marginDefault,
      endIndent: Dimensions.marginDefault,
    );
  }

  Future<void> _openPhotoView(CreateEditSuggestionState state) async {
    await showDialog<void>(
      useSafeArea: false,
      barrierColor: Colors.black,
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return PhotoView(
          initialIndex: state.openPhotoIndex!,
          onDeleteClick: _cubit.removePhoto,
          onDownloadClick: widget.onSaveToGallery != null
              ? (String path) =>
                  _cubit.showSavingResultMessage(widget.onSaveToGallery!(path))
              : null,
          photos: state.suggestion.images,
          previousNavBarColor: theme.thirdBackgroundColor,
        );
      },
    );
    _cubit.changePhotoViewStatus(isPhotoViewOpen: false);
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
        style: theme.textSmallPlusSecondaryBold,
      ),
      trailing: labels.isNotEmpty
          ? SuggestionLabels(labels: labels)
          : SvgPicture.asset(
              AssetStrings.plusIconThickImage,
              package: AssetStrings.packageName,
              colorFilter: ColorFilter.mode(
                theme.primaryIconColor,
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

  @override
  Widget build(BuildContext context) {
    late final String status;
    switch (suggestionStatus) {
      case SuggestionStatus.completed:
        status = context.localization.completed;
        break;
      case SuggestionStatus.inProgress:
        status = context.localization.inProgress;
        break;
      case SuggestionStatus.requests:
        status = context.localization.requests;
        break;
      case SuggestionStatus.cancelled:
        status = context.localization.cancelled;
        break;
      case SuggestionStatus.duplicate:
        status = context.localization.duplicate;
        break;
      case SuggestionStatus.unknown:
        status = '';
        break;
    }

    return ClickableListItem(
      title: Text(
        context.localization.status,
        style: theme.textSmallPlusSecondaryBold,
      ),
      trailing: Text(
        status,
        style: theme.textSmallPlusBold,
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
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Dimensions.marginDefault),
        child: SuggestionsElevatedButton(
          onClick: saveSuggestion,
          isLoading: isLoading,
          buttonText: isEditing
              ? context.localization.save
              : context.localization.suggest,
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
        style: theme.textSmallPlusSecondaryBold,
      ),
      trailing: SuggestionsSwitch(
        value: isAnonymously,
        onChanged: changeSuggestionAnonymity,
      ),
    );
  }
}

class _PhotoPickerItem extends StatelessWidget {
  final CreateEditSuggestionCubit _cubit = i.createEditSuggestionCubit;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;
  final CreateEditSuggestionState state;

  _PhotoPickerItem({
    required this.state,
    required this.onUploadMultiplePhotos,
  });

  @override
  Widget build(BuildContext context) {
    final double tileWidth = state.suggestion.images.length == 1
        ? (MediaQuery.of(context).size.width - Dimensions.margin3x) / 2
        : (MediaQuery.of(context).size.width - Dimensions.margin4x) / 3;
    return state.suggestion.images.isNotEmpty
        ? SizedBox(
            height:
                MediaQuery.of(context).size.height * Dimensions.smallSize / 100,
            child: Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.marginMiddle),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: state.suggestion.images.length + 1,
                itemBuilder: (BuildContext context, int i) {
                  if (i == 0) {
                    return GestureDetector(
                      onTap: () {
                        final int availableNumOfPhotos =
                            maxPhotosForOneSuggestion -
                                state.suggestion.images.length;
                        availableNumOfPhotos > 0
                            ? _cubit.addUploadedPhotos(
                                onUploadMultiplePhotos!(
                                  availableNumOfPhotos: availableNumOfPhotos,
                                ),
                              )
                            : BotToast.showText(
                                text:
                                    context.localization.eventPhotosRestriction,
                              );
                      },
                      child: AddPhotoButton(
                        width: state.suggestion.images.length > 2
                            ? tileWidth * 0.9
                            : tileWidth,
                        height: (MediaQuery.of(context).size.width - 80) / 3,
                        style: theme.textSmallPlusBold,
                        isLoading: state.isLoading,
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () => _cubit.onPhotoClick(i - 1),
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
                            url: state.suggestion.images[i - 1],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          )
        : ClickableListItem(
            title: Text(
              context.localization.addPhoto,
              style: theme.textSmallPlusSecondaryBold,
            ),
            trailing: state.isLoading
                ? CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(theme.primaryIconColor),
                  )
                : SvgPicture.asset(
                    AssetStrings.plusIconThickImage,
                    package: AssetStrings.packageName,
                    colorFilter: ColorFilter.mode(
                      theme.primaryIconColor,
                      BlendMode.srcIn,
                    ),
                    height: state.suggestion.images.isNotEmpty
                        ? Dimensions.smallSize
                        : Dimensions.defaultSize,
                  ),
            onClick: () => _cubit.addUploadedPhotos(
              onUploadMultiplePhotos!(
                availableNumOfPhotos: maxPhotosForOneSuggestion,
              ),
            ),
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
          children: <Widget>[
            if (widget.suggestionImages.isNotEmpty)
              SizedBox(
                width: Dimensions.defaultSize,
                child: SmallPhotoPreview(
                  src: widget.suggestionImages[0],
                  heroTag: 'photo_view',
                  backgroundColor: theme.secondaryBackgroundColor,
                ),
              ),
            if (widget.suggestionImages.length >= 2)
              Container(
                width: Dimensions.largeSize,
                padding: const EdgeInsets.only(left: Dimensions.marginDefault),
                child: SmallPhotoPreview(
                  src: widget.suggestionImages[1],
                  heroTag: 'photo_view',
                  backgroundColor: theme.secondaryBackgroundColor,
                ),
              ),
            if (widget.suggestionImages.length >= 3)
              Container(
                width: Dimensions.veryBigSize,
                padding: const EdgeInsets.only(left: Dimensions.margin2x),
                child: SmallPhotoPreview(
                  src: widget.suggestionImages[2],
                  heroTag: 'photo_view',
                  backgroundColor: theme.secondaryBackgroundColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
