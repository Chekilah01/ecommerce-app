import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:final_project/features/product/data/models/product_image_model.dart';

import '../../domain/entities/product_entity.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double deliveryFee;
  final int stock;
  final String categoryId;

  final String mainImageUrl;
  final String mainImagePublicId;

  final List<ProductImageModel> additionalImages;

  final bool isFeatured;
  final int salesCount;

  final double averageRating;
  final int ratingCount;

  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductModel({
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

  factory ProductModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    if (data == null) {
      throw Exception('Product document does not exist.');
    }

    return ProductModel(
      id: doc.id,
      name: data['name'] as String,
      description: data['description'] as String,
      price: (data['price'] as num).toDouble(),
      deliveryFee: (data['deliveryFee'] as num).toDouble(),
      stock: (data['stock'] as num).toInt(),
      categoryId: data['categoryId'] as String,

      mainImageUrl: data['mainImageUrl'] as String,
      mainImagePublicId: data['mainImagePublicId'] as String,

      additionalImages: (data['additionalImages'] as List<dynamic>? ?? [])
          .map(
            (image) => ProductImageModel.fromMap(
              Map<String, dynamic>.from(image as Map),
            ),
          )
          .toList(),

      isFeatured: data['isFeatured'] as bool,
      salesCount: (data['salesCount'] as num).toInt(),
      averageRating: (data['averageRating'] as num).toDouble(),
      ratingCount: (data['ratingCount'] as num).toInt(),

      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'deliveryFee': deliveryFee,
      'stock': stock,
      'categoryId': categoryId,

      'mainImageUrl': mainImageUrl,
      'mainImagePublicId': mainImagePublicId,

      'additionalImages': additionalImages
          .map((image) => image.toMap())
          .toList(),

      'isFeatured': isFeatured,
      'salesCount': salesCount,
      'averageRating': averageRating,
      'ratingCount': ratingCount,

      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      deliveryFee: deliveryFee,
      stock: stock,
      categoryId: categoryId,
      mainImageUrl: mainImageUrl,
      mainImagePublicId: mainImagePublicId,
      additionalImages: additionalImages
          .map((image) => image.toEntity())
          .toList(),
      isFeatured: isFeatured,
      salesCount: salesCount,
      averageRating: averageRating,
      ratingCount: ratingCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      deliveryFee: entity.deliveryFee,
      stock: entity.stock,
      categoryId: entity.categoryId,
      mainImageUrl: entity.mainImageUrl,
      mainImagePublicId: entity.mainImagePublicId,
      additionalImages: entity.additionalImages
          .map(ProductImageModel.fromEntity)
          .toList(),
      isFeatured: entity.isFeatured,
      salesCount: entity.salesCount,
      averageRating: entity.averageRating,
      ratingCount: entity.ratingCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
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
