import 'package:equatable/equatable.dart';

import '../../../domain/entities/suggestion.dart';
import '../../../domain/entities/suggestion_author.dart';
import '../../utils/image_utils.dart';

class SuggestionState extends Equatable {
  final bool isPopped;
  final bool isEditable;
  final SuggestionAuthor author;
  final Suggestion suggestion;
  final SavingResultMessageType savingImageResultMessageType;
  final SuggestionBottomSheetType bottomSheetType;

  const SuggestionState({
    required this.isPopped,
    required this.isEditable,
    required this.author,
    required this.suggestion,
    required this.savingImageResultMessageType,
    required this.bottomSheetType,
  });

  SuggestionState newState({
    bool? isPopped,
    bool? isEditable,
    SuggestionAuthor? author,
    Suggestion? suggestion,
    SavingResultMessageType? savingImageResultMessageType,
    SuggestionBottomSheetType? bottomSheetType,
  }) {
    return SuggestionState(
      isPopped: isPopped ?? this.isPopped,
      isEditable: isEditable ?? this.isEditable,
      author: author ?? this.author,
      suggestion: suggestion ?? this.suggestion,
      bottomSheetType: bottomSheetType ?? this.bottomSheetType,
      savingImageResultMessageType:
          savingImageResultMessageType ?? this.savingImageResultMessageType,
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
      ];
}

enum SuggestionBottomSheetType {
  none,
  confirmation,
  notification,
  editDelete,
  createEdit,
  createComment,
}
