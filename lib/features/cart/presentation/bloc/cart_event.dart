import 'package:equatable/equatable.dart';
import 'package:final_project/features/product/domain/entities/product_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {
  const LoadCart();
}

class AddToCart extends CartEvent {
  final ProductEntity product;

  const AddToCart(this.product);

  @override
  List<Object?> get props => [product];
}

class IncreaseCartItemQuantity extends CartEvent {
  final String productId;

  const IncreaseCartItemQuantity(this.productId);

  @override
  List<Object?> get props => [productId];
}

class DecreaseCartItemQuantity extends CartEvent {
  final String productId;

  const DecreaseCartItemQuantity(this.productId);

  @override
  List<Object?> get props => [productId];
}

class RemoveCartItem extends CartEvent {
  final String productId;

  const RemoveCartItem(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ClearCart extends CartEvent {
  const ClearCart();
}

class ClearCartState extends CartEvent {
  const ClearCartState();
}