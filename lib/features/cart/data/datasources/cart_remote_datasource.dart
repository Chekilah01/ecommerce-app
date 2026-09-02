import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/cart/data/models/cart_item_model.dart';

class CartRemoteDataSource {
  final FirebaseFirestore _firestore;

  CartRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _cartsCollection =>
      _firestore.collection('carts');

  Future<List<CartItemModel>> getCart(String userId) async {
    final doc = await _cartsCollection.doc(userId).get();

    if (!doc.exists) {
      return [];
    }

    final data = doc.data();

    if (data == null) {
      return [];
    }

    final items = data['items'] as List<dynamic>? ?? [];

    return items
        .map(
          (item) =>
              CartItemModel.fromMap(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<void> addToCart(String userId, CartItemModel item) async {
    final cartRef = _cartsCollection.doc(userId);

    final doc = await cartRef.get();

    if (!doc.exists) {
      await cartRef.set({
        'items': [item.toMap()],
      });

      return;
    }

    final data = doc.data();

    if (data == null) {
      await cartRef.set({
        'items': [item.toMap()],
      });

      return;
    }

    final items = List<Map<String, dynamic>>.from(
      (data['items'] as List<dynamic>? ?? []).map(
        (item) => Map<String, dynamic>.from(item as Map),
      ),
    );

    final existingIndex = items.indexWhere(
      (cartItem) => cartItem['productId'] == item.product.id,
    );

    if (existingIndex == -1) {
      items.add(item.toMap());
    } else {
      items[existingIndex]['quantity'] =
          (items[existingIndex]['quantity'] as num).toInt() + item.quantity;
    }

    await cartRef.update({'items': items});
  }

  Future<void> updateQuantity(
    String userId,
    String productId,
    int quantity,
  ) async {
    final cartRef = _cartsCollection.doc(userId);

    final doc = await cartRef.get();

    if (!doc.exists) {
      return;
    }

    final data = doc.data();

    if (data == null) {
      return;
    }

    final items = List<Map<String, dynamic>>.from(
      (data['items'] as List<dynamic>? ?? []).map(
        (item) => Map<String, dynamic>.from(item as Map),
      ),
    );

    final existingIndex = items.indexWhere(
      (cartItem) => cartItem['productId'] == productId,
    );

    if (existingIndex == -1) {
      return;
    }

    items[existingIndex]['quantity'] = quantity;

    await cartRef.update({'items': items});
  }

  Future<void> removeFromCart(String userId, String productId) async {
    final cartRef = _cartsCollection.doc(userId);

    final doc = await cartRef.get();

    if (!doc.exists) {
      return;
    }

    final data = doc.data();

    if (data == null) {
      return;
    }

    final items = List<Map<String, dynamic>>.from(
      (data['items'] as List<dynamic>? ?? []).map(
        (item) => Map<String, dynamic>.from(item as Map),
      ),
    );

    items.removeWhere((cartItem) => cartItem['productId'] == productId);

    await cartRef.update({'items': items});
  }

  Future<void> clearCart(String userId) async {
    await _cartsCollection.doc(userId).update({'items': []});
  }
}