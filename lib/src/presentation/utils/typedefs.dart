import '../../../suggest_a_feature.dart';

typedef OnUploadMultiplePhotosCallback = Future<List<String>?> Function({
  required int availableNumOfPhotos,
});
typedef OnSaveToGalleryCallback = Future<bool?> Function(String url);
typedef OnGetUserById = Future<SuggestionAuthor?> Function(String id);
