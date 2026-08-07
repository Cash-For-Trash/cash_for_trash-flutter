import 'dart:developer';
import 'dart:io';

// ignore: implementation_imports
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService {
  late Cloudinary _cloudinary;

  CloudinaryService() {
    final cloudinaryUrl = dotenv.env['CLOUDINARY_URL'] ?? '';
    _cloudinary = Cloudinary.fromStringUrl(cloudinaryUrl);
    _cloudinary.config.urlConfig.secure = true;
  }

  Future<String?> uploadImage(
    File file, {
    String folderName = 'collection_requests',
  }) async {
    try {
      final fileName = file.path.split(RegExp(r'[/\\]')).last;
      final String publicIdWithoutExt = fileName.replaceAll(
        RegExp(r'(\.(webp|png|jpg|jpeg|gif|webg))+$', caseSensitive: false),
        '',
      );

      final response = await _cloudinary.uploader().upload(
        file,
        params: UploadParams(
          folder: "cash_for_trash/$folderName",
          publicId: publicIdWithoutExt.isNotEmpty
              ? publicIdWithoutExt
              : fileName,
        ),
      );

      if (response != null && response.data != null) {
        return response.data!.secureUrl;
      }
      return null;
    } catch (e, stack) {
      log("Cloudinary upload exception: $e");
      log(stack.toString());
      return null;
    }
  }
}
