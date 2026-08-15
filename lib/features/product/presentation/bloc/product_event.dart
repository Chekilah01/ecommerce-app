import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/entities/product_image_entity.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class LoadProductById extends ProductEvent {
  final String productId;

  const LoadProductById(this.productId);

  @override
  List<Object?> get props => [productId];
}

class LoadFeaturedProducts extends ProductEvent {
  const LoadFeaturedProducts();
}

class LoadPopularProducts extends ProductEvent {
  const LoadPopularProducts();
}

class LoadProductsByCategory extends ProductEvent {
  final String categoryId;

  const LoadProductsByCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class SearchProducts extends ProductEvent {
  final String query;
  final String categoryId;

  const SearchProducts({this.query = '', this.categoryId = 'all'});

  @override
  List<Object?> get props => [query, categoryId];
}

class CreateProduct extends ProductEvent {
  final String name;
  final String description;
  final double price;
  final double deliveryFee;
  final int stock;
  final String categoryId;
  final XFile mainImage;
  final List<XFile> additionalImages;
  final bool isFeatured;

  const CreateProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.deliveryFee,
    required this.stock,
    required this.categoryId,
    required this.mainImage,
    this.additionalImages = const [],
    this.isFeatured = false,
  });

  @override
  List<Object?> get props => [
    name,
    description,
    price,
    deliveryFee,
    stock,
    categoryId,
    mainImage,
    additionalImages,
    isFeatured,
  ];
}

class UpdateProduct extends ProductEvent {
  final ProductEntity product;
  final XFile? newMainImage;
  final List<ProductImage> keptAdditionalImages;
  final List<XFile> newAdditionalImages;

  const UpdateProduct({
    required this.product,
    this.newMainImage,
    this.keptAdditionalImages = const [],
    this.newAdditionalImages = const [],
  });

  @override
  List<Object?> get props => [
    product,
    newMainImage,
    keptAdditionalImages,
    newAdditionalImages,
  ];
}

class DeleteProduct extends ProductEvent {
  final ProductEntity product;

  const DeleteProduct(this.product);

  @override
  List<Object?> get props => [product];
}
