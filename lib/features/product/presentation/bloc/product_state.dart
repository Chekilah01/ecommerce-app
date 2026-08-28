import 'package:equatable/equatable.dart';

import '../../domain/entities/product_entity.dart';

enum ProductStatus { initial, loading, success, actionSuccess, failure }

class ProductState extends Equatable {
  final ProductStatus status;

  final List<ProductEntity> allProducts;
  final List<ProductEntity> products;
  final ProductEntity? selectedProduct;

  final int totalProducts;
  final int featuredProductsCount;
  final int lowStockProductsCount;
  final int outOfStockProductsCount;
  final List<ProductEntity> topSellingProducts;

  final String? errorMessage;
  final String? successMessage;

  const ProductState({
    this.status = ProductStatus.initial,
    this.allProducts = const [],
    this.products = const [],
    this.selectedProduct,

    this.totalProducts = 0,
    this.featuredProductsCount = 0,
    this.lowStockProductsCount = 0,
    this.outOfStockProductsCount = 0,
    this.topSellingProducts = const [],

    this.errorMessage,
    this.successMessage,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<ProductEntity>? allProducts,
    List<ProductEntity>? products,
    ProductEntity? selectedProduct,

    int? totalProducts,
    int? featuredProductsCount,
    int? lowStockProductsCount,
    int? outOfStockProductsCount,
    List<ProductEntity>? topSellingProducts,

    String? errorMessage,
    String? successMessage,
    bool clearSelectedProduct = false,
    bool clearError = false,
    bool clearSuccessMessage = false,
  }) {
    return ProductState(
      status: status ?? this.status,
      allProducts: allProducts ?? this.allProducts,
      products: products ?? this.products,

      selectedProduct: clearSelectedProduct
          ? null
          : selectedProduct ?? this.selectedProduct,

      totalProducts: totalProducts ?? this.totalProducts,
      featuredProductsCount:
          featuredProductsCount ?? this.featuredProductsCount,
      lowStockProductsCount:
          lowStockProductsCount ?? this.lowStockProductsCount,
      outOfStockProductsCount:
          outOfStockProductsCount ?? this.outOfStockProductsCount,
      topSellingProducts: topSellingProducts ?? this.topSellingProducts,

      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,

      successMessage: clearSuccessMessage
          ? null
          : successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allProducts,
    products,
    selectedProduct,

    totalProducts,
    featuredProductsCount,
    lowStockProductsCount,
    outOfStockProductsCount,
    topSellingProducts,

    errorMessage,
    successMessage,
  ];
}
