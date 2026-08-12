import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class ProductRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProductRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _productsCollection =>
      _firestore.collection('products');

  Future<List<ProductModel>> getProducts() async {
    final snapshot = await _productsCollection.get();

    return snapshot.docs
        .map(ProductModel.fromFirestore)
        .toList();
  }

  Future<ProductModel?> getProductById(String productId) async {
    final doc = await _productsCollection.doc(productId).get();

    if (!doc.exists) {
      return null;
    }

    return ProductModel.fromFirestore(doc);
  }

  Future<List<ProductModel>> getProductsByCategory(
    String categoryId,
  ) async {
    final snapshot = await _productsCollection
        .where('categoryId', isEqualTo: categoryId)
        .get();

    return snapshot.docs
        .map(ProductModel.fromFirestore)
        .toList();
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    final snapshot = await _productsCollection
        .where('isFeatured', isEqualTo: true)
        .get();

    return snapshot.docs
        .map(ProductModel.fromFirestore)
        .toList();
  }

  Future<List<ProductModel>> getPopularProducts() async {
    final snapshot = await _productsCollection
        .orderBy('salesCount', descending: true)
        .limit(10)
        .get();

    return snapshot.docs
        .map(ProductModel.fromFirestore)
        .toList();
  }

  Future<void> createProduct(ProductModel product) async {
    await _productsCollection
        .doc(product.id)
        .set(product.toFirestore());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _productsCollection
        .doc(product.id)
        .update(product.toFirestore());
  }

  Future<void> deleteProduct(String productId) async {
    await _productsCollection
        .doc(productId)
        .delete();
  }
}