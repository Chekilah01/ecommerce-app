import 'package:equatable/equatable.dart';

import '../../domain/entities/order_item_entity.dart';

class OrderItemModel extends Equatable {
  final String productId;
  final String productName;
  final String productImageUrl;
  final double price;
  final double deliveryFee;
  final int quantity;

  const OrderItemModel({
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.price,
    required this.deliveryFee,
    required this.quantity,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map['productId'] as String,
      productName: map['productName'] as String,
      productImageUrl: map['productImageUrl'] as String,
      price: (map['price'] as num).toDouble(),
      deliveryFee: (map['deliveryFee'] as num).toDouble(),
      quantity: (map['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImageUrl': productImageUrl,
      'price': price,
      'deliveryFee': deliveryFee,
      'quantity': quantity,
    };
  }

  OrderItemEntity toEntity() {
    return OrderItemEntity(
      productId: productId,
      productName: productName,
      productImageUrl: productImageUrl,
      price: price,
      deliveryFee: deliveryFee,
      quantity: quantity,
    );
  }

  factory OrderItemModel.fromEntity(OrderItemEntity entity) {
    return OrderItemModel(
      productId: entity.productId,
      productName: entity.productName,
      productImageUrl: entity.productImageUrl,
      price: entity.price,
      deliveryFee: entity.deliveryFee,
      quantity: entity.quantity,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    productName,
    productImageUrl,
    price,
    deliveryFee,
    quantity,
  ];
}
