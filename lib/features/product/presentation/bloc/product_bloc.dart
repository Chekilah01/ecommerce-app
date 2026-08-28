import 'dart:async';

import 'package:final_project/features/product/domain/repositories/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({ProductRepository? productRepository})
    : _productRepository = productRepository ?? ProductRepository(),
      super(const ProductState()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductById>(_onLoadProductById);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<LoadFeaturedProducts>(_onLoadFeaturedProducts);
    on<LoadPopularProducts>(_onLoadPopularProducts);
    on<SearchProducts>(_onSearchProducts);
    on<CreateProduct>(_onCreateProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProductStatus.loading,
        clearError: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      final products = await _productRepository.getProducts();

      emit(
        state.copyWith(
          status: ProductStatus.success,
          allProducts: products,
          products: products,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString(),
          clearSuccessMessage: true,
        ),
      );
    }
  }

  Future<void> _onLoadProductById(
    LoadProductById event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProductStatus.loading,
        clearError: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      final product = await _productRepository.getProductById(event.productId);

      if (product == null) {
        emit(
          state.copyWith(
            status: ProductStatus.failure,
            errorMessage: 'Product not found.',
          ),
        );
        return;
      }

      emit(
        state.copyWith(status: ProductStatus.success, selectedProduct: product),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProductStatus.loading,
        clearError: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      final products = await _productRepository.getProductsByCategory(
        event.categoryId,
      );

      emit(state.copyWith(status: ProductStatus.success, products: products));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadFeaturedProducts(
    LoadFeaturedProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProductStatus.loading,
        clearError: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      final products = await _productRepository.getFeaturedProducts();

      emit(state.copyWith(status: ProductStatus.success, products: products));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadPopularProducts(
    LoadPopularProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProductStatus.loading,
        clearError: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      final products = await _productRepository.getPopularProducts();

      emit(state.copyWith(status: ProductStatus.success, products: products));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    final normalizedQuery = event.query.trim().toLowerCase();
    final normalizedCategory = event.categoryId.trim().toLowerCase();

    final filteredProducts = state.allProducts.where((product) {
      final matchesCategory =
          normalizedCategory == 'all' ||
          product.categoryId.toLowerCase() == normalizedCategory;

      final matchesQuery =
          normalizedQuery.isEmpty ||
          product.name.toLowerCase().contains(normalizedQuery);

      return matchesCategory && matchesQuery;
    }).toList();

    emit(
      state.copyWith(
        status: ProductStatus.success,
        products: filteredProducts,
        clearError: true,
        clearSuccessMessage: true,
      ),
    );
  }

  Future<void> _onCreateProduct(
    CreateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProductStatus.loading,
        clearError: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      await _productRepository.createProduct(
        name: event.name,
        description: event.description,
        price: event.price,
        deliveryFee: event.deliveryFee,
        stock: event.stock,
        categoryId: event.categoryId,
        mainImage: event.mainImage,
        additionalImages: event.additionalImages,
        isFeatured: event.isFeatured,
      );

      final products = await _productRepository.getProducts();

      emit(
        state.copyWith(
          status: ProductStatus.actionSuccess,
          allProducts: products,
          products: products,
          successMessage: 'Product created successfully.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProductStatus.loading,
        clearError: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      await _productRepository.updateProduct(
        product: event.product,
        newMainImage: event.newMainImage,
        keptAdditionalImages: event.keptAdditionalImages,
        newAdditionalImages: event.newAdditionalImages,
      );

      final products = await _productRepository.getProducts();

      emit(
        state.copyWith(
          status: ProductStatus.actionSuccess,
          allProducts: products,
          products: products,
          successMessage: 'Product updated successfully.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProductStatus.loading,
        clearError: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      await _productRepository.deleteProduct(event.product);

      final updatedAllProducts = state.allProducts
          .where((product) => product.id != event.product.id)
          .toList();

      final updatedProducts = state.products
          .where((product) => product.id != event.product.id)
          .toList();

      emit(
        state.copyWith(
          status: ProductStatus.actionSuccess,
          allProducts: updatedAllProducts,
          products: updatedProducts,
          successMessage: 'Product deleted successfully.',
          clearSelectedProduct: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProductStatus.loading,
        clearError: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      final products = await _productRepository.getProducts();

      final totalProducts = products.length;

      final featuredProductsCount = products
          .where((product) => product.isFeatured)
          .length;

      final lowStockProductsCount = products
          .where((product) => product.stock > 0 && product.stock <= 5)
          .length;

      final outOfStockProductsCount = products
          .where((product) => product.stock == 0)
          .length;

      final sortedProducts = List.of(products)
        ..sort((a, b) => b.salesCount.compareTo(a.salesCount));

      final topSellingProducts = sortedProducts.take(5).toList();

      emit(
        state.copyWith(
          status: ProductStatus.success,
          allProducts: products,
          totalProducts: totalProducts,
          featuredProductsCount: featuredProductsCount,
          lowStockProductsCount: lowStockProductsCount,
          outOfStockProductsCount: outOfStockProductsCount,
          topSellingProducts: topSellingProducts,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString(),
          clearSuccessMessage: true,
        ),
      );
    }
  }
}
