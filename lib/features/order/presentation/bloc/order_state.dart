import 'package:equatable/equatable.dart';

import '../../domain/entities/order_entity.dart';

enum OrderStatusState { initial, loading, success, actionSuccess, failure }

class OrderState extends Equatable {
  final OrderStatusState status;
  final List<OrderEntity> orders;
  final OrderEntity? selectedOrder;

  final String? pendingOrderId;
  final String? createdOrderId;

  final String? errorMessage;
  final String? successMessage;

  const OrderState({
    this.status = OrderStatusState.initial,
    this.orders = const [],
    this.selectedOrder,
    this.pendingOrderId,
    this.createdOrderId,
    this.errorMessage,
    this.successMessage,
  });

  OrderState copyWith({
    OrderStatusState? status,
    List<OrderEntity>? orders,
    OrderEntity? selectedOrder,
    String? pendingOrderId,
    String? createdOrderId,
    String? errorMessage,
    String? successMessage,
    bool clearSelectedOrder = false,
    bool clearPendingOrderId = false,
    bool clearCreatedOrderId = false,
    bool clearError = false,
    bool clearSuccessMessage = false,
  }) {
    return OrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      selectedOrder: clearSelectedOrder
          ? null
          : selectedOrder ?? this.selectedOrder,
      pendingOrderId: clearPendingOrderId
          ? null
          : pendingOrderId ?? this.pendingOrderId,
      createdOrderId: clearCreatedOrderId
          ? null
          : createdOrderId ?? this.createdOrderId,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccessMessage
          ? null
          : successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    orders,
    selectedOrder,
    pendingOrderId,
    createdOrderId,
    errorMessage,
    successMessage,
  ];
}
