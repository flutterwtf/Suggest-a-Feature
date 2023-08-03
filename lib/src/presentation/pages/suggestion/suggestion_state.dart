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

  const SuggestionState({
    required this.isPopped,
    required this.isEditable,
    required this.author,
    required this.suggestion,
    required this.savingImageResultMessageType,
    required this.bottomSheetType,
    required this.loadingComments,
  });

  SuggestionState newState({
    bool? isPopped,
    bool? isEditable,
    SuggestionAuthor? author,
    Suggestion? suggestion,
    SavingResultMessageType? savingImageResultMessageType,
    SuggestionBottomSheetType? bottomSheetType,
    bool? loadingComments,
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
