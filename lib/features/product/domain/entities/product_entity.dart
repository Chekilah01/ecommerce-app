import 'package:equatable/equatable.dart';
import 'package:final_project/features/product/domain/entities/product_image_entity.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double deliveryFee;
  final int stock;
  final String categoryId;

  final String mainImageUrl;
  final String mainImagePublicId;

  final List<ProductImage> additionalImages;

  final bool isFeatured;
  final int salesCount;

  final double averageRating;
  final int ratingCount;

  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.deliveryFee,
    required this.stock,
    required this.categoryId,
    required this.mainImageUrl,
    required this.mainImagePublicId,
    required this.additionalImages,
    required this.isFeatured,
    required this.salesCount,
    required this.averageRating,
    required this.ratingCount,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    deliveryFee,
    stock,
    categoryId,
    mainImageUrl,
    mainImagePublicId,
    additionalImages,
    isFeatured,
    salesCount,
    averageRating,
    ratingCount,
    createdAt,
    updatedAt,
  ];
}
