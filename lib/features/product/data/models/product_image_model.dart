import 'package:equatable/equatable.dart';
import 'package:final_project/features/product/domain/entities/product_image_entity.dart';

class ProductImageModel extends Equatable {
  final String url;
  final String publicId;

  const ProductImageModel({required this.url, required this.publicId});

  factory ProductImageModel.fromMap(Map<String, dynamic> map) {
    return ProductImageModel(
      url: map['url'] as String,
      publicId: map['publicId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'url': url, 'publicId': publicId};
  }

  ProductImage toEntity() {
    return ProductImage(url: url, publicId: publicId);
  }

  factory ProductImageModel.fromEntity(ProductImage image) {
    return ProductImageModel(url: image.url, publicId: image.publicId);
  }

  @override
  List<Object?> get props => [url, publicId];
}
