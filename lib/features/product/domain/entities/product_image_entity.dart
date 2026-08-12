import 'package:equatable/equatable.dart';

class ProductImage extends Equatable {
  final String url;
  final String publicId;

  const ProductImage({required this.url, required this.publicId});

  @override
  List<Object?> get props => [url, publicId];
}
