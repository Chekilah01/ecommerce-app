import 'package:equatable/equatable.dart';

import '../../domain/entities/order_entity.dart';

enum OrderStatusState { initial, loading, success, actionSuccess, failure }

class OrderState extends Equatable {
  final OrderStatusState status;
  final List<OrderEntity> orders;
  final OrderEntity? selectedOrder;

  final String? pendingOrderId;
  final String? createdOrderId;

  final int totalOrders;
  final int pendingOrders;
  final int confirmedOrders;
  final int cancelledOrders;
  final double revenue;

  final String? errorMessage;
  final String? successMessage;

  const OrderState({
    this.status = OrderStatusState.initial,
    this.orders = const [],
    this.selectedOrder,
    this.pendingOrderId,
    this.createdOrderId,
    this.totalOrders = 0,
    this.pendingOrders = 0,
    this.confirmedOrders = 0,
    this.cancelledOrders = 0,
    this.revenue = 0,
    this.errorMessage,
    this.successMessage,
  });

  OrderState copyWith({
    OrderStatusState? status,
    List<OrderEntity>? orders,
    OrderEntity? selectedOrder,
    String? pendingOrderId,
    String? createdOrderId,
    int? totalOrders,
    int? pendingOrders,
    int? confirmedOrders,
    int? cancelledOrders,
    double? revenue,
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
      totalOrders: totalOrders ?? this.totalOrders,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      confirmedOrders: confirmedOrders ?? this.confirmedOrders,
      cancelledOrders: cancelledOrders ?? this.cancelledOrders,
      revenue: revenue ?? this.revenue,
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
    totalOrders,
    pendingOrders,
    confirmedOrders,
    cancelledOrders,
    revenue,
    errorMessage,
    successMessage,
  ];
}
