import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/cloudinary_upload_result.dart';

class CloudinaryDataSource {
  static const String _cloudName = 'i7skceeq';
  static const String _uploadPreset = 'ecom_app_products';

  Future<CloudinaryUploadResult> uploadImage(XFile image) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] = _uploadPreset;

    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('Cloudinary upload failed: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    return CloudinaryUploadResult(
      url: data['secure_url'] as String,
      publicId: data['public_id'] as String,
    );
  }
}
