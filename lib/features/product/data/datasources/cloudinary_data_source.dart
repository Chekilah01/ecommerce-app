import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/cloudinary_upload_result.dart';

class CloudinaryDataSource {
  final String _cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;

  final String _uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET']!;

  final String _apiKey = dotenv.env['CLOUDINARY_API_KEY']!;

  final String _apiSecret = dotenv.env['CLOUDINARY_API_SECRET']!;

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

  Future<void> deleteImage(String publicId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final signatureString =
        'public_id=$publicId&timestamp=$timestamp$_apiSecret';

    final signature = sha1.convert(utf8.encode(signatureString)).toString();

    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/destroy',
    );

    final response = await http.post(
      uri,
      body: {
        'public_id': publicId,
        'timestamp': timestamp.toString(),
        'api_key': _apiKey,
        'signature': signature,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Cloudinary deletion failed: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['result'] != 'ok') {
      throw Exception('Cloudinary deletion failed: ${data['result']}');
    }
  }
}
