import 'package:equatable/equatable.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion_author.dart';
import 'package:suggest_a_feature/src/presentation/utils/image_utils.dart';

class SuggestionState extends Equatable {
  final bool isPopped;
  final bool isEditable;
  final SuggestionAuthor author;
  final Suggestion suggestion;
  final SavingResultMessageType savingImageResultMessageType;
  final SuggestionBottomSheetType bottomSheetType;
  final bool loadingComments;
  final String? selectedCommentId;

  const SuggestionState({
    required this.isPopped,
    required this.isEditable,
    required this.author,
    required this.suggestion,
    required this.savingImageResultMessageType,
    required this.bottomSheetType,
    required this.loadingComments,
    this.selectedCommentId,
  });

  SuggestionState newState({
    bool? isPopped,
    bool? isEditable,
    SuggestionAuthor? author,
    Suggestion? suggestion,
    SavingResultMessageType? savingImageResultMessageType,
    SuggestionBottomSheetType? bottomSheetType,
    bool? loadingComments,
    String? selectedCommentId,
    bool shouldResetSelectedCommentId = false,
  }) {
    return SuggestionState(
      isPopped: isPopped ?? this.isPopped,
      isEditable: isEditable ?? this.isEditable,
      author: author ?? this.author,
      suggestion: suggestion ?? this.suggestion,
      bottomSheetType: bottomSheetType ?? this.bottomSheetType,
      savingImageResultMessageType:
          savingImageResultMessageType ?? this.savingImageResultMessageType,
      loadingComments: loadingComments ?? this.loadingComments,
      selectedCommentId: selectedCommentId ??
          (shouldResetSelectedCommentId ? null : this.selectedCommentId),
    );
  }

  @override
  List<Object?> get props => <Object?>[
        isPopped,
        isEditable,
        author,
        suggestion,
        bottomSheetType,
        savingImageResultMessageType,
        loadingComments,
        selectedCommentId,
      ];
}

enum SuggestionBottomSheetType {
  none,
  confirmation,
  notification,
  editDelete,
  createEdit,
  createComment,
  deleteCommentConfirmation,
}
