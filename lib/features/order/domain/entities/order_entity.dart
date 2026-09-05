import 'package:equatable/equatable.dart';
import 'package:final_project/features/order/domain/entities/order_status.dart';

import 'order_item_entity.dart';


class OrderEntity extends Equatable {
  final String id;
  final String userId;

  final String firstName;
  final String lastName;
  final String phone;
  final String wilaya;
  final String commune;

  final List<OrderItemEntity> items;

  final double subtotal;
  final double deliveryFee;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderEntity({
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