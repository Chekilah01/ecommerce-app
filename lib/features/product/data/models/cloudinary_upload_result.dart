import 'package:equatable/equatable.dart';

class CloudinaryUploadResult extends Equatable {
  final String url;
  final String publicId;

  const CloudinaryUploadResult({required this.url, required this.publicId});

  @override
  List<Object?> get props => [url, publicId];
}
