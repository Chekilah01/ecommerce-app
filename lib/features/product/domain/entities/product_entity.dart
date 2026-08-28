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

  ProductEntity copyWith({
    String? name,
    String? description,
    double? price,
    double? deliveryFee,
    int? stock,
    String? categoryId,
    String? mainImageUrl,
    String? mainImagePublicId,
    List<ProductImage>? additionalImages,
    bool? isFeatured,
    int? salesCount,
    double? averageRating,
    int? ratingCount,
    DateTime? updatedAt,
  }) {
    return ProductEntity(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      stock: stock ?? this.stock,
      categoryId: categoryId ?? this.categoryId,
      mainImageUrl: mainImageUrl ?? this.mainImageUrl,
      mainImagePublicId: mainImagePublicId ?? this.mainImagePublicId,
      additionalImages: additionalImages ?? this.additionalImages,
      isFeatured: isFeatured ?? this.isFeatured,
      salesCount: salesCount ?? this.salesCount,
      averageRating: averageRating ?? this.averageRating,
      ratingCount: ratingCount ?? this.ratingCount,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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
