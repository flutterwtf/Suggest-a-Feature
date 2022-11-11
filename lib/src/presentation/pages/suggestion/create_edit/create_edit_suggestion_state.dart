import '../../../../domain/entities/suggestion.dart';
import '../../../utils/image_utils.dart';

class CreateEditSuggestionState {
  final Suggestion suggestion;
  final bool isEditing;
  final bool isShowTitleError;
  final bool isSubmitted;
  final bool isLoading;
  final bool isLabelsBottomSheetOpen;
  final bool isPhotoViewOpen;
  final SavingResultMessageType savingImageResultMessageType;
  final int? openPhotoIndex;

  CreateEditSuggestionState({
    required this.suggestion,
    required this.isEditing,
    required this.isShowTitleError,
    required this.isSubmitted,
    required this.isLoading,
    required this.isLabelsBottomSheetOpen,
    required this.isPhotoViewOpen,
    required this.savingImageResultMessageType,
    this.openPhotoIndex,
  });

  CreateEditSuggestionState newState({
    Suggestion? suggestion,
    bool? isEditing,
    bool? isShowTitleError,
    bool? isSubmitted,
    bool? isLoading,
    bool? isLabelsBottomSheetOpen,
    bool? isPhotoViewOpen,
    SavingResultMessageType? savingImageResultMessageType,
    int? openPhotoIndex,
  }) {
    return CreateEditSuggestionState(
      suggestion: suggestion ?? this.suggestion,
      isEditing: isEditing ?? this.isEditing,
      isShowTitleError: isShowTitleError ?? this.isShowTitleError,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      isLoading: isLoading ?? this.isLoading,
      isLabelsBottomSheetOpen: isLabelsBottomSheetOpen ?? this.isLabelsBottomSheetOpen,
      isPhotoViewOpen: isPhotoViewOpen ?? this.isPhotoViewOpen,
      savingImageResultMessageType:
          savingImageResultMessageType ?? this.savingImageResultMessageType,
      openPhotoIndex: openPhotoIndex ?? this.openPhotoIndex,
    );
  }
}
