import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String productId;
  final String productName;
  final String productImageUrl;
  final double price;
  final double deliveryFee;
  final int quantity;

  const OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.price,
    required this.deliveryFee,
    required this.quantity,
  });

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
