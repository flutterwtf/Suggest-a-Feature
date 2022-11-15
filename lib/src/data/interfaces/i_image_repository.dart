import 'dart:typed_data';

import '../../domain/utils/wrapper.dart';

abstract class IImageRepository {
  Future<String?> pickPhoto({required int quality});
  Future<List<String>?> pickMultiplePhotos({
    required int quality,
    required int availableNumberOfPhotos,
  });

  /// This method used to download image and save it in Documents Directory
  /// If this file is already exists just return it from local storage
  Future<Uint8List?> loadImageBytes(String imageUrl, {bool unmodifiableUrl = false});
  Future<Wrapper<Uint8List>> downloadImage(String url, {bool unmodifiableUrl = false});
  Future<Wrapper<String>> uploadImage({
    String? path,
    Uint8List? bytes,
  });

  Future<bool> saveImageToGallery({required String imageName, required String url});
}
