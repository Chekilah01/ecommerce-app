import 'dart:convert';

import 'package:final_project/features/product/data/datasources/cloudinary_data_source.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryTestPage extends StatefulWidget {
  const CloudinaryTestPage({super.key});

  @override
  State<CloudinaryTestPage> createState() => _CloudinaryTestPageState();
}

class _CloudinaryTestPageState extends State<CloudinaryTestPage> {
  final ImagePicker _picker = ImagePicker();

  bool _isUploading = false;
  String? _imageUrl;
  String? _publicId;

  Future<void> _pickAndUploadImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/i7skceeq/image/upload',
      );

      final request = http.MultipartRequest('POST', url);

      request.fields['upload_preset'] = 'ecom_app_products';

      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _imageUrl = data['secure_url'];
          _publicId = data['public_id'];
        });

        debugPrint('Cloudinary URL: ${data['secure_url']}');
        debugPrint('Cloudinary Public ID: ${data['public_id']}');
      } else {
        debugPrint('Cloudinary error: ${response.body}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: ${response.body}')),
          );
        }
      }
    } catch (e) {
      debugPrint('Upload exception: $e');

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cloudinary Test')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_imageUrl != null)
                Image.network(
                  _imageUrl!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),

              const SizedBox(height: 20),

              if (_publicId != null)
                Text('Public ID:\n$_publicId', textAlign: TextAlign.center),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _isUploading ? null : _pickAndUploadImage,
                child: _isUploading
                    ? const CircularProgressIndicator()
                    : const Text('Pick & Upload Image'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final dataSource = CloudinaryDataSource();

                    await dataSource.deleteImage('pfp');

                    debugPrint('Image deleted successfully');
                  } catch (e) {
                    debugPrint('Delete failed: $e');
                  }
                },
                child: const Text('Delete Test Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
