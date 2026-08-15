import 'package:equatable/equatable.dart';

import '../../domain/entities/product_entity.dart';

enum ProductStatus { initial, loading, success, actionSuccess, failure }

class ProductState extends Equatable {
  final ProductStatus status;
  final List<ProductEntity> products;
  final ProductEntity? selectedProduct;
  final String? errorMessage;
  final String? successMessage;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.selectedProduct,
    this.errorMessage,
    this.successMessage,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<ProductEntity>? products,
    ProductEntity? selectedProduct,
    String? errorMessage,
    String? successMessage,
    bool clearSelectedProduct = false,
    bool clearError = false,
    bool clearSuccessMessage = false,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      selectedProduct: clearSelectedProduct
          ? null
          : selectedProduct ?? this.selectedProduct,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccessMessage
          ? null
          : successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    selectedProduct,
    errorMessage,
    successMessage,
  ];
}
