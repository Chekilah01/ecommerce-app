import 'package:final_project/features/product/data/datasources/cloudinary_data_source.dart';
import 'package:final_project/features/product/data/datasources/product_remote_data_source.dart';
import 'package:final_project/features/product/data/models/product_image_model.dart';
import 'package:final_project/features/product/data/models/product_model.dart';
import 'package:final_project/features/product/domain/entities/product_entity.dart';
import 'package:final_project/features/product/domain/entities/product_image_entity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ProductRepository {
  final ProductRemoteDataSource _productRemoteDataSource;
  final CloudinaryDataSource _cloudinaryDataSource;
  final Uuid _uuid;

  ProductRepository({
    ProductRemoteDataSource? productRemoteDataSource,
    CloudinaryDataSource? cloudinaryDataSource,
    Uuid? uuid,
  }) : _productRemoteDataSource =
           productRemoteDataSource ?? ProductRemoteDataSource(),
       _cloudinaryDataSource = cloudinaryDataSource ?? CloudinaryDataSource(),
       _uuid = uuid ?? const Uuid();

  Future<List<ProductEntity>> getProducts() async {
    final products = await _productRemoteDataSource.getProducts();

    return products.map((product) => product.toEntity()).toList();
  }

  Future<ProductEntity?> getProductById(String productId) async {
    final product = await _productRemoteDataSource.getProductById(productId);

    return product?.toEntity();
  }

  Future<List<ProductEntity>> getProductsByCategory(String categoryId) async {
    final products = await _productRemoteDataSource.getProductsByCategory(
      categoryId,
    );

    return products.map((product) => product.toEntity()).toList();
  }

  Future<List<ProductEntity>> getFeaturedProducts() async {
    final products = await _productRemoteDataSource.getFeaturedProducts();

    return products.map((product) => product.toEntity()).toList();
  }

  Future<List<ProductEntity>> getPopularProducts() async {
    final products = await _productRemoteDataSource.getPopularProducts();

    return products.map((product) => product.toEntity()).toList();
  }

  Future<void> createProduct({
    required String name,
    required String description,
    required double price,
    required double deliveryFee,
    required int stock,
    required String categoryId,
    required XFile mainImage,
    List<XFile> additionalImages = const [],
    bool isFeatured = false,
  }) async {
    if (additionalImages.length > 5) {
      throw Exception('A product can have a maximum of 5 additional images.');
    }

    final uploadedPublicIds = <String>[];

    try {
      final mainImageResult = await _cloudinaryDataSource.uploadImage(
        mainImage,
      );

      uploadedPublicIds.add(mainImageResult.publicId);

      final additionalImageModels = <ProductImageModel>[];

      for (final image in additionalImages) {
        final result = await _cloudinaryDataSource.uploadImage(image);

        uploadedPublicIds.add(result.publicId);

        additionalImageModels.add(
          ProductImageModel(url: result.url, publicId: result.publicId),
        );
      }

      final now = DateTime.now();

      final product = ProductModel(
        id: _uuid.v4(),
        name: name,
        description: description,
        price: price,
        deliveryFee: deliveryFee,
        stock: stock,
        categoryId: categoryId,
        mainImageUrl: mainImageResult.url,
        mainImagePublicId: mainImageResult.publicId,
        additionalImages: additionalImageModels,
        isFeatured: isFeatured,
        salesCount: 0,
        averageRating: 0,
        ratingCount: 0,
        createdAt: now,
        updatedAt: now,
      );

      await _productRemoteDataSource.createProduct(product);
    } catch (e) {
      for (final publicId in uploadedPublicIds) {
        try {
          await _cloudinaryDataSource.deleteImage(publicId);
        } catch (_) {}
      }

      rethrow;
    }
  }

  Future<void> deleteProduct(ProductEntity product) async {
    await _productRemoteDataSource.deleteProduct(product.id);

    try {
      await _cloudinaryDataSource.deleteImage(product.mainImagePublicId);
    } catch (_) {}

    for (final image in product.additionalImages) {
      try {
        await _cloudinaryDataSource.deleteImage(image.publicId);
      } catch (_) {}
    }
  }

  Future<void> updateProduct({
    required ProductEntity product,
    XFile? newMainImage,
    List<ProductImage> keptAdditionalImages = const [],
    List<XFile> newAdditionalImages = const [],
  }) async {
    if (keptAdditionalImages.length + newAdditionalImages.length > 5) {
      throw Exception('A product can have a maximum of 5 additional images.');
    }

    final newlyUploadedPublicIds = <String>[];

    try {
      String mainImageUrl = product.mainImageUrl;
      String mainImagePublicId = product.mainImagePublicId;

      if (newMainImage != null) {
        final result = await _cloudinaryDataSource.uploadImage(newMainImage);

        newlyUploadedPublicIds.add(result.publicId);

        mainImageUrl = result.url;
        mainImagePublicId = result.publicId;
      }

      final updatedAdditionalImages = <ProductImageModel>[
        ...keptAdditionalImages.map(ProductImageModel.fromEntity),
      ];

      for (final image in newAdditionalImages) {
        final result = await _cloudinaryDataSource.uploadImage(image);

        newlyUploadedPublicIds.add(result.publicId);

        updatedAdditionalImages.add(
          ProductImageModel(url: result.url, publicId: result.publicId),
        );
      }

      final updatedProduct = ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        deliveryFee: product.deliveryFee,
        stock: product.stock,
        categoryId: product.categoryId,
        mainImageUrl: mainImageUrl,
        mainImagePublicId: mainImagePublicId,
        additionalImages: updatedAdditionalImages,
        isFeatured: product.isFeatured,
        salesCount: product.salesCount,
        averageRating: product.averageRating,
        ratingCount: product.ratingCount,
        createdAt: product.createdAt,
        updatedAt: DateTime.now(),
      );

      await _productRemoteDataSource.updateProduct(updatedProduct);
    } catch (e) {
      for (final publicId in newlyUploadedPublicIds) {
        try {
          await _cloudinaryDataSource.deleteImage(publicId);
        } catch (_) {}
      }

      rethrow;
    }

    if (newMainImage != null) {
      try {
        await _cloudinaryDataSource.deleteImage(product.mainImagePublicId);
      } catch (_) {}
    }

    final keptPublicIds = keptAdditionalImages
        .map((image) => image.publicId)
        .toSet();

    for (final oldImage in product.additionalImages) {
      if (!keptPublicIds.contains(oldImage.publicId)) {
        try {
          await _cloudinaryDataSource.deleteImage(oldImage.publicId);
        } catch (_) {}
      }
    }
  }

  Future<List<ProductEntity>> searchProducts({
    String query = '',
    String categoryId = 'all',
  }) async {
    final products = await _productRemoteDataSource.getProducts();

    final normalizedQuery = query.trim().toLowerCase();
    final normalizedCategory = categoryId.trim().toLowerCase();

    final filteredProducts = products.where((product) {
      final matchesCategory =
          normalizedCategory == 'all' ||
          product.categoryId.toLowerCase() == normalizedCategory;

      final matchesQuery =
          normalizedQuery.isEmpty ||
          product.name.toLowerCase().contains(normalizedQuery);

      return matchesCategory && matchesQuery;
    }).toList();

    return filteredProducts.map((product) => product.toEntity()).toList();
  }
}
