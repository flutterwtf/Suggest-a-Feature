// import 'dart:io';
// import 'dart:typed_data';
// import 'package:path/path.dart';

// import '../../domain/utils/wrapper.dart';
// import '../interfaces/i_image_repository.dart';

// class ImageRepository implements IImageRepository {
//   static const imageExtension = '.jpg';

//   final IFileDataSource _fileDataSource;
//   final IRemoteDataSource _remoteDataSource;
//   final IPhotoPickerClient _photoPickerClient;
//   final IPermissionsClient _permissionsClient;
//   final IGallerySaverClient _gallerySaverClient;

//   ImageRepository(
//     this._fileDataSource,
//     this._remoteDataSource,
//     this._photoPickerClient,
//     this._permissionsClient,
//     this._gallerySaverClient,
//   );

//   @override
//   Future<Uint8List?> loadImageBytes(String url, {bool unmodifiableUrl = false}) async {
//     final localImage = await _fileDataSource.getImageBytes(url);
//     if (localImage != null) {
//       return localImage;
//     }

//     final remoteImageRes = await _remoteDataSource.downloadImage(url, unmodifiableUrl);
//     if (remoteImageRes.success()) {
//       await _fileDataSource.saveImageBytes(url, remoteImageRes.data!);
//       return remoteImageRes.data!;
//     }
//     return null;
//   }

//   @override
//   Future<Wrapper<Uint8List>> downloadImage(String url, {bool unmodifiableUrl = false}) {
//     return _remoteDataSource.downloadImage(url, unmodifiableUrl);
//   }

//   @override
//   Future<bool> saveImageToGallery({required String imageName, required String url}) async {
//     Future<bool> iosPermission() async =>
//         await _permissionsClient.requestPhotosPermission() ||
//         await _permissionsClient.requestStoragePermission();

//     if (Platform.isIOS && await iosPermission() ||
//         Platform.isAndroid && await _permissionsClient.requestStoragePermission()) {
//       final rawImage = await loadImageBytes(url);
//       if (rawImage != null && rawImage.isNotEmpty) {
//         return _gallerySaverClient.savePhoto(rawImage, imageName);
//       }
//       return false;
//     }
//     return false;
//   }

//   @override
//   Future<List<String>?> pickMultiplePhotos({
//     required int quality,
//     required int availableNumberOfPhotos,
//   }) {
//     return _photoPickerClient.pickMultiplePhotos(
//       quality: quality,
//       availableNumberOfPhotos: availableNumberOfPhotos,
//     );
//   }

//   @override
//   Future<String?> pickPhoto({required int quality}) {
//     return _photoPickerClient.pickPhoto(quality: quality);
//   }

//   @override
//   Future<Wrapper<String>> uploadImage({
//     String? path,
//     Uint8List? bytes,
//   }) {
//     assert(
//       (path != null || bytes != null) && !(path != null && bytes != null),
//       'Either image path or bytes should be provided',
//     );
//     late final Uint8List imageBytes;
//     var filename = 'image';
//     if (path != null) {
//       final image = File(path);
//       filename = basenameWithoutExtension(image.path);
//       imageBytes = image.readAsBytesSync();
//     } else {
//       imageBytes = bytes!;
//     }
//     return _remoteDataSource.uploadImage(
//       bytes: imageBytes,
//       fileName: filename + imageExtension,
//     );
//   }
// }
