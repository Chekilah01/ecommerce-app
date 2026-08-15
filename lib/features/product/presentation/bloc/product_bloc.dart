import 'package:final_project/features/product/domain/repositories/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({ProductRepository? productRepository})
      : _productRepository =
            productRepository ?? ProductRepository(),
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
      final product = await _productRepository.getProductById(
        event.productId,
      );

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
        state.copyWith(
          status: ProductStatus.success,
          selectedProduct: product,
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
      final products =
          await _productRepository.getProductsByCategory(
        event.categoryId,
      );

      emit(
        state.copyWith(
          status: ProductStatus.success,
          products: products,
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
      final products =
          await _productRepository.getFeaturedProducts();

      emit(
        state.copyWith(
          status: ProductStatus.success,
          products: products,
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
      final products =
          await _productRepository.getPopularProducts();

      emit(
        state.copyWith(
          status: ProductStatus.success,
          products: products,
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

  Future<void> _onSearchProducts(
    SearchProducts event,
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
      final products = await _productRepository.searchProducts(
        query: event.query,
        categoryId: event.categoryId,
      );

      emit(
        state.copyWith(
          status: ProductStatus.success,
          products: products,
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

      emit(
        state.copyWith(
          status: ProductStatus.actionSuccess,
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

      emit(
        state.copyWith(
          status: ProductStatus.actionSuccess,
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

      final updatedProducts = state.products
          .where(
            (product) => product.id != event.product.id,
          )
          .toList();

      emit(
        state.copyWith(
          status: ProductStatus.actionSuccess,
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
}