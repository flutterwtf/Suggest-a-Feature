import 'dart:async';

import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/domain/data_interfaces/suggestion_repository.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/domain/utils/suggestion_validator.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/create_edit/create_edit_suggestion_state.dart';
import 'package:suggest_a_feature/src/presentation/utils/image_utils.dart';

class CreateEditSuggestionManager extends StatefulWidget {
  final Suggestion? suggestion;
  final Widget child;

  const CreateEditSuggestionManager({
    required this.child,
    this.suggestion,
    super.key,
  });

  static CreateEditSuggestionStateManager of(BuildContext context) {
    return (context
            .dependOnInheritedWidgetOfExactType<
              _InheritedCreateEditSuggestion
            >()!)
        .suggestionManager;
  }

  @override
  CreateEditSuggestionStateManager createState() =>
      CreateEditSuggestionStateManager();
}

class CreateEditSuggestionStateManager
    extends State<CreateEditSuggestionManager> {
  late CreateEditSuggestionState state;
  late final SuggestionRepository _suggestionRepository;

  @override
  void initState() {
    super.initState();
    _suggestionRepository = i.suggestionRepository;
    state = CreateEditSuggestionState(
      suggestion: widget.suggestion ?? Suggestion.empty(),
      savingImageResultMessageType: SavingResultMessageType.none,
      isShowTitleError: false,
      isShowDescriptionError: false,
      isEditing: widget.suggestion != null,
      isSubmitted: false,
      isLoading: false,
      isLabelsBottomSheetOpen: false,
      isStatusBottomSheetOpen: false,
      isPhotoViewOpen: false,
    );
  }

  void _update(CreateEditSuggestionState newState) {
    if (newState != state) {
      setState(() {
        state = newState;
      });
    }
  }

  void reset() {
    _update(
      state.newState(
        savingImageResultMessageType: SavingResultMessageType.none,
      ),
    );
  }

  Future<void> addUploadedPhotos(Future<List<String>?> urls) async {
    _update(state.newState(isLoading: true));
    final photos = await urls;
    if (photos != null) {
      _update(
        state.newState(
          suggestion: state.suggestion.copyWith(
            images: <String>[...photos, ...state.suggestion.images],
          ),
          isLoading: false,
        ),
      );
    }
  }

  void removePhoto(String path) {
    _update(
      state.newState(
        suggestion: state.suggestion.copyWith(
          images: state.suggestion.images..remove(path),
        ),
        isPhotoViewOpen: false,
      ),
    );
  }

  Future<void> showSavingResultMessage(Future<bool?> isSuccess) async {
    final savingResult = await isSuccess;
    if (savingResult != null) {
      _update(
        state.newState(
          savingImageResultMessageType: savingResult
              ? SavingResultMessageType.success
              : SavingResultMessageType.fail,
        ),
      );
    }
  }

  void changeSuggestionAnonymity({required bool isAnonymous}) {
    _update(
      state.newState(
        suggestion: state.suggestion.copyWith(isAnonymous: isAnonymous),
      ),
    );
  }

  void changeLabelsBottomSheetStatus({required bool isLabelsBottomSheetOpen}) {
    _update(state.newState(isLabelsBottomSheetOpen: isLabelsBottomSheetOpen));
  }

  void changeStatusBottomSheetStatus({required bool isStatusBottomSheetOpen}) {
    _update(state.newState(isStatusBottomSheetOpen: isStatusBottomSheetOpen));
  }

  void changePhotoViewStatus({required bool isPhotoViewOpen}) {
    _update(state.newState(isPhotoViewOpen: isPhotoViewOpen));
  }

  void onPhotoClick(int index) {
    _update(state.newState(isPhotoViewOpen: true, openPhotoIndex: index));
  }

  void changeSuggestionTitle(String text) {
    _update(
      state.newState(
        suggestion: state.suggestion.copyWith(title: text),
        isShowTitleError: false,
      ),
    );
  }

  void changeSuggestionDescription(String text) {
    _update(
      state.newState(
        suggestion: state.suggestion.copyWith(description: text),
        isShowDescriptionError: false,
      ),
    );
  }

  void selectLabels(List<SuggestionLabel> selectedLabels) {
    _update(
      state.newState(
        suggestion: state.suggestion.copyWith(labels: selectedLabels),
      ),
    );
  }

  void changeStatus(SuggestionStatus status) {
    _update(
      state.newState(
        suggestion: state.suggestion.copyWith(status: status),
      ),
    );
  }

  Future<void> saveSuggestion() async {
    if (state.isLoading) {
      return;
    }
    final titleError = SuggestionValidator.validate(
      state.suggestion.title,
      requiredErrorText: i.localizations.titleRequiredError,
      rules: i.titleValidationRules,
    );
    final descriptionError = SuggestionValidator.validate(
      state.suggestion.description,
      requiredErrorText: i.localizations.descriptionRequiredError,
      rules: i.descriptionValidationRules,
    );
    if (titleError != null || descriptionError != null) {
      _update(
        state.newState(
          isShowTitleError: titleError != null,
          isShowDescriptionError: descriptionError != null,
          titleErrorText: titleError,
          descriptionErrorText: descriptionError,
        ),
      );
      return;
    }
    final suggestion = state.suggestion.copyWith(
      title: state.suggestion.title.trim(),
      description: state.suggestion.description?.trim(),
    );
    if (state.isEditing) {
      await _suggestionRepository.updateSuggestion(suggestion);
    } else {
      final model = CreateSuggestionModel(
        title: suggestion.title,
        description: suggestion.description,
        labels: suggestion.labels,
        images: suggestion.images,
        authorId: i.userId,
        isAnonymous: suggestion.isAnonymous,
      );
      await _suggestionRepository.createSuggestion(model);
    }
    _update(state.newState(isSubmitted: true));
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedCreateEditSuggestion(
      suggestionManager: this,
      child: widget.child,
    );
  }
}

class _InheritedCreateEditSuggestion extends InheritedWidget {
  final CreateEditSuggestionStateManager suggestionManager;

  const _InheritedCreateEditSuggestion({
    required this.suggestionManager,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedCreateEditSuggestion old) => true;
}
