import 'package:equatable/equatable.dart';
import 'package:final_project/features/product/data/models/product_model.dart';

import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends Equatable {
  final ProductModel product;
  final int quantity;

  const CartItemModel({
    required this.product,
    required this.quantity,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      product: ProductModel.fromMap(
        map['productId'] as String,
        Map<String, dynamic>.from(
          map['product'] as Map,
        ),
      ),
      quantity: (map['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'product': product.toFirestore(),
      'quantity': quantity,
    };
  }

  CartItemEntity toEntity() {
    return CartItemEntity(
      product: product.toEntity(),
      quantity: quantity,
    );
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      product: ProductModel.fromEntity(entity.product),
      quantity: entity.quantity,
    );
  }

  @override
  List<Object?> get props => [
        product,
        quantity,
      ];
}