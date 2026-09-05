import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status.dart';
import 'order_item_model.dart';

class OrderModel extends Equatable {
  final String id;
  final String userId;

  final String firstName;
  final String lastName;
  final String phone;
  final String wilaya;
  final String commune;

  final List<OrderItemModel> items;

  final double subtotal;
  final double deliveryFee;
  final double total;

  final OrderStatus status;

  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.wilaya,
    required this.commune,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromMap(String id, Map<String, dynamic> data) {
    return OrderModel(
      id: id,
      userId: data['userId'] as String,

      firstName: data['firstName'] as String,
      lastName: data['lastName'] as String,
      phone: data['phone'] as String,
      wilaya: data['wilaya'] as String,
      commune: data['commune'] as String,

      items: (data['items'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                OrderItemModel.fromMap(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),

      subtotal: (data['subtotal'] as num).toDouble(),
      deliveryFee: (data['deliveryFee'] as num).toDouble(),
      total: (data['total'] as num).toDouble(),

      status: OrderStatus.values.firstWhere(
        (status) => status.name == data['status'],
        orElse: () => OrderStatus.pending,
      ),

      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  factory OrderModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    if (data == null) {
      throw Exception('Order document does not exist.');
    }

    return OrderModel.fromMap(doc.id, data);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,

      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'wilaya': wilaya,
      'commune': commune,

      'items': items.map((item) => item.toMap()).toList(),

      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,

      'status': status.name,

      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      wilaya: wilaya,
      commune: commune,
      items: items.map((item) => item.toEntity()).toList(),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      userId: entity.userId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      phone: entity.phone,
      wilaya: entity.wilaya,
      commune: entity.commune,
      items: entity.items.map(OrderItemModel.fromEntity).toList(),
      subtotal: entity.subtotal,
      deliveryFee: entity.deliveryFee,
      total: entity.total,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    firstName,
    lastName,
    phone,
    wilaya,
    commune,
    items,
    subtotal,
    deliveryFee,
    total,
    status,
    createdAt,
    updatedAt,
  ];
}
