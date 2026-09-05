import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/order/data/models/order_model.dart';
import 'package:final_project/features/order/domain/entities/order_status.dart';

class OrderRemoteDataSource {
  final FirebaseFirestore _firestore;

  OrderRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _ordersCollection =>
      _firestore.collection('orders');

  String generateOrderId() {
    return _ordersCollection.doc().id;
  }

  Future<String> createOrder(OrderModel order, String orderId) async {
    final orderRef = _ordersCollection.doc(orderId);

    final orderWithId = OrderModel(
      id: orderId,
      userId: order.userId,
      firstName: order.firstName,
      lastName: order.lastName,
      phone: order.phone,
      wilaya: order.wilaya,
      commune: order.commune,
      items: order.items,
      subtotal: order.subtotal,
      deliveryFee: order.deliveryFee,
      total: order.total,
      status: order.status,
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
    );

    await orderRef.set(orderWithId.toFirestore());

    return orderId;
  }

  Future<List<OrderModel>> getOrders({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    Query<Map<String, dynamic>> query = _ordersCollection;

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    if (startDate != null) {
      query = query.where(
        'createdAt',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
      );
    }

    if (endDate != null) {
      query = query.where('createdAt', isLessThan: Timestamp.fromDate(endDate));
    }

    query = query.orderBy('createdAt', descending: true);

    final snapshot = await query.get();

    return snapshot.docs.map(OrderModel.fromFirestore).toList();
  }

  Future<OrderModel> getOrderById(String orderId) async {
    final doc = await _ordersCollection.doc(orderId).get();

    return OrderModel.fromFirestore(doc);
  }

  Future<void> confirmOrder(String orderId) async {
    await _firestore.runTransaction((transaction) async {
      final orderRef = _ordersCollection.doc(orderId);

      final orderDoc = await transaction.get(orderRef);

      if (!orderDoc.exists) {
        throw Exception('Order does not exist.');
      }

      final orderData = orderDoc.data();

      if (orderData == null) {
        throw Exception('Order data could not be loaded.');
      }

      final currentStatus = orderData['status'] as String;

      if (currentStatus != OrderStatus.pending.name) {
        throw Exception('Only pending orders can be confirmed.');
      }

      final items = (orderData['items'] as List<dynamic>? ?? [])
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();

      final productSnapshots =
          <String, DocumentSnapshot<Map<String, dynamic>>>{};

      for (final item in items) {
        final productId = item['productId'] as String;

        final productRef = _firestore.collection('products').doc(productId);

        final productDoc = await transaction.get(productRef);

        if (!productDoc.exists) {
          throw Exception('Product $productId no longer exists.');
        }

        productSnapshots[productId] = productDoc;
      }

      for (final item in items) {
        final productId = item['productId'] as String;
        final quantity = (item['quantity'] as num).toInt();

        final productDoc = productSnapshots[productId]!;
        final productData = productDoc.data();

        if (productData == null) {
          throw Exception('Product $productId could not be loaded.');
        }

        final currentStock = (productData['stock'] as num).toInt();

        if (currentStock < quantity) {
          throw Exception(
            'Not enough stock for ${productData['name']}. '
            'Available: $currentStock, requested: $quantity.',
          );
        }

        final currentSalesCount =
            (productData['salesCount'] as num?)?.toInt() ?? 0;

        transaction.update(productDoc.reference, {
          'stock': currentStock - quantity,
          'salesCount': currentSalesCount + quantity,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      transaction.update(orderRef, {
        'status': OrderStatus.confirmed.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> cancelOrder(String orderId) async {
    final orderRef = _ordersCollection.doc(orderId);

    final orderDoc = await orderRef.get();

    if (!orderDoc.exists) {
      throw Exception('Order does not exist.');
    }

    final data = orderDoc.data();

    if (data == null) {
      throw Exception('Order data could not be loaded.');
    }

    final currentStatus = data['status'] as String;

    if (currentStatus != OrderStatus.pending.name) {
      throw Exception('Only pending orders can be cancelled.');
    }

    await orderRef.update({
      'status': OrderStatus.cancelled.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<OrderModel?> findOrderById(String orderId) async {
    final doc = await _ordersCollection.doc(orderId).get();

    if (!doc.exists) {
      return null;
    }

    return OrderModel.fromFirestore(doc);
  }
}
