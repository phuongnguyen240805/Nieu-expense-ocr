import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:image_picker/image_picker.dart';

class CameraCaptureException implements Exception {
  const CameraCaptureException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Service to handle capturing and picking images from the device.
class CameraCaptureService {
  final ImagePicker _picker = ImagePicker();

  /// Captures an image from the camera.
  /// Returns the file path or null if cancelled/denied.
  Future<String?> captureFromCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );
    return _imagePath(image);
  }

  /// Picks an image from the gallery.
  /// Returns the file path or null if cancelled/denied.
  Future<String?> pickFromGallery() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    return _imagePath(image);
  }

  /// Restores an image if Android recreated MainActivity while the picker ran.
  Future<String?> retrieveLostImage() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return null;

    final response = await _picker.retrieveLostData();
    if (response.exception case final exception?) {
      throw CameraCaptureException(
        'Không thể khôi phục ảnh đã chọn: ${exception.message ?? exception.code}',
      );
    }
    return response.file?.path;
  }

  Future<String?> _imagePath(XFile? image) async {
    if (image == null) return null;
    if (!kIsWeb) return image.path;
    // Persist the image with the expense instead of storing a temporary blob URL.
    final bytes = await image.readAsBytes();
    final mimeType = image.mimeType ?? 'image/jpeg';
    return 'data:$mimeType;base64,${base64Encode(bytes)}';
  }
}
