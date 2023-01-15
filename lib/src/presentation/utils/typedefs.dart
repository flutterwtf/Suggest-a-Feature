import '../../../suggest_a_feature.dart';

/// The callback which is invoked after uploading multiple photos.
///
/// The function has [Future<List<String>?>] return type and takes 1 named argument [availableNumOfPhotos] which is an [int] object.
typedef OnUploadMultiplePhotosCallback = Future<List<String>?> Function({
  required int availableNumOfPhotos,
});

/// The function has [Future<bool?>] return type and takes 1 positional argument [url] which is a [String] object.
///
/// The [url] argument is a url of the image which we want to save.
typedef OnSaveToGalleryCallback = Future<bool?> Function(String url);

/// The function has [Future<SuggestionAuthor?>] return type and takes 1 positional argument [id] which is a [String] object.
///
/// The [id] argument is an id of the author which we want to get.
typedef OnGetUserById = Future<SuggestionAuthor?> Function(String id);
