import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/suggestion.dart';
import '../../../../domain/interactors/suggestion_interactor.dart';
import '../../../di/injector.dart';
import '../../../utils/image_utils.dart';
import 'create_edit_suggestion_state.dart';

class CreateEditSuggestionCubit extends Cubit<CreateEditSuggestionState> {
  final SuggestionInteractor _suggestionInteractor;

  CreateEditSuggestionCubit(this._suggestionInteractor)
      : super(
          CreateEditSuggestionState(
            suggestion: Suggestion.empty(),
            savingImageResultMessageType: SavingResultMessageType.none,
            isShowTitleError: false,
            isEditing: false,
            isSubmitted: false,
            isLoading: false,
            isLabelsBottomSheetOpen: false,
            isPhotoViewOpen: false,
          ),
        );

  void init(Suggestion? suggestion) {
    emit(state.newState(suggestion: suggestion, isEditing: suggestion != null));
  }

  void reset() {
    emit(state.newState(savingImageResultMessageType: SavingResultMessageType.none));
  }

  Future<void> addUploadedPhotos(Future<List<String>?> urls) async {
    emit(state.newState(isLoading: true));
    final List<String>? photos = await urls;
    if (photos != null) {
      emit(
        state.newState(
          suggestion:
              state.suggestion.copyWith(images: <String>[...photos, ...state.suggestion.images]),
          isLoading: false,
        ),
      );
    }
  }

  void removePhoto(String path) {
    emit(
      state.newState(
        suggestion: state.suggestion.copyWith(images: state.suggestion.images..remove(path)),
        isPhotoViewOpen: false,
      ),
    );
  }

  Future<void> showSavingResultMessage(Future<bool?> isSuccess) async {
    final bool? savingResult = await isSuccess;
    if (savingResult != null) {
      emit(
        state.newState(
          savingImageResultMessageType:
              savingResult ? SavingResultMessageType.success : SavingResultMessageType.fail,
        ),
      );
    }
  }

  void changeSuggestionAnonymity(bool isAnonymous) {
    emit(state.newState(suggestion: state.suggestion.copyWith(isAnonymous: isAnonymous)));
  }

  void changeLabelsBottomSheetStatus(bool isLabelsBottomSheetOpen) {
    emit(state.newState(isLabelsBottomSheetOpen: isLabelsBottomSheetOpen));
  }

  void changePhotoViewStatus(bool isPhotoViewOpen) {
    emit(state.newState(isPhotoViewOpen: isPhotoViewOpen));
  }

  void onPhotoClick(int index) {
    emit(state.newState(isPhotoViewOpen: true, openPhotoIndex: index));
  }

  void changeSuggestionTitle(String text) {
    emit(
      state.newState(
        suggestion: state.suggestion.copyWith(title: text),
        isShowTitleError: false,
      ),
    );
  }

  void changeSuggestionDescription(String text) {
    emit(
      state.newState(
        suggestion: state.suggestion.copyWith(description: text),
      ),
    );
  }

  void selectLabels(List<SuggestionLabel> selectedLabels) {
    emit(state.newState(suggestion: state.suggestion.copyWith(labels: selectedLabels)));
  }

  Future<void> saveSuggestion() async {
    if (state.suggestion.title.isEmpty || state.isLoading) {
      emit(state.newState(isShowTitleError: true));
      return;
    }
    if (state.isEditing) {
      await _suggestionInteractor.updateSuggestion(state.suggestion);
    } else {
      final CreateSuggestionModel model = CreateSuggestionModel(
        title: state.suggestion.title,
        description: state.suggestion.description,
        labels: state.suggestion.labels,
        images: state.suggestion.images,
        authorId: i.userId,
        isAnonymous: state.suggestion.isAnonymous,
      );
      await _suggestionInteractor.createSuggestion(model);
    }
    emit(state.newState(isSubmitted: true));
  }
}
