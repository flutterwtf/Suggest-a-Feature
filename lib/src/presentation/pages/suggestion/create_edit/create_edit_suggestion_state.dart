import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/presentation/utils/image_utils.dart';

class CreateEditSuggestionState {
  final Suggestion suggestion;
  final bool isEditing;
  final bool isShowTitleError;
  final bool isShowDescriptionError;
  final String? titleErrorText;
  final String? descriptionErrorText;
  final bool isSubmitted;
  final bool isLoading;
  final bool isLabelsBottomSheetOpen;
  final bool isStatusBottomSheetOpen;
  final bool isPhotoViewOpen;
  final SavingResultMessageType savingImageResultMessageType;
  final int? openPhotoIndex;

  CreateEditSuggestionState({
    required this.suggestion,
    required this.isEditing,
    required this.isShowTitleError,
    required this.isShowDescriptionError,
    required this.isSubmitted,
    required this.isLoading,
    required this.isLabelsBottomSheetOpen,
    required this.isPhotoViewOpen,
    required this.savingImageResultMessageType,
    required this.isStatusBottomSheetOpen,
    this.openPhotoIndex,
    this.titleErrorText,
    this.descriptionErrorText,
  });

  CreateEditSuggestionState newState({
    Suggestion? suggestion,
    bool? isEditing,
    bool? isShowTitleError,
    bool? isShowDescriptionError,
    bool? isSubmitted,
    bool? isLoading,
    bool? isLabelsBottomSheetOpen,
    bool? isStatusBottomSheetOpen,
    bool? isPhotoViewOpen,
    SavingResultMessageType? savingImageResultMessageType,
    int? openPhotoIndex,
    String? titleErrorText,
    String? descriptionErrorText,
  }) {
    return CreateEditSuggestionState(
      suggestion: suggestion ?? this.suggestion,
      isEditing: isEditing ?? this.isEditing,
      isShowTitleError: isShowTitleError ?? this.isShowTitleError,
      isShowDescriptionError:
          isShowDescriptionError ?? this.isShowDescriptionError,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      isLoading: isLoading ?? this.isLoading,
      isLabelsBottomSheetOpen:
          isLabelsBottomSheetOpen ?? this.isLabelsBottomSheetOpen,
      isStatusBottomSheetOpen:
          isStatusBottomSheetOpen ?? this.isStatusBottomSheetOpen,
      isPhotoViewOpen: isPhotoViewOpen ?? this.isPhotoViewOpen,
      savingImageResultMessageType:
          savingImageResultMessageType ?? this.savingImageResultMessageType,
      openPhotoIndex: openPhotoIndex ?? this.openPhotoIndex,
      titleErrorText: titleErrorText ?? this.titleErrorText,
      descriptionErrorText: descriptionErrorText ?? this.descriptionErrorText,
    );
  }
}
