import 'package:equatable/equatable.dart';

import '../../domain/entities/cart_item_entity.dart';

enum CartStatus {
  initial,
  loading,
  success,
  actionSuccess,
  failure,
}

class CartState extends Equatable {
  final CartStatus status;
  final List<CartItemEntity> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String? errorMessage;
  final String? successMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.total = 0,
    this.errorMessage,
    this.successMessage,
  });

  CartState copyWith({
    CartStatus? status,
    List<CartItemEntity>? items,
    double? subtotal,
    double? deliveryFee,
    double? total,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccessMessage = false,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
      successMessage: clearSuccessMessage
          ? null
          : successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        subtotal,
        deliveryFee,
        total,
        errorMessage,
        successMessage,
      ];
}