import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class CreateOrder extends OrderEvent {
  const CreateOrder();
}

class LoadOrders extends OrderEvent {
  final String? userId;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadOrders({this.userId, this.startDate, this.endDate});

  @override
  List<Object?> get props => [userId, startDate, endDate];
}

class LoadOrderById extends OrderEvent {
  final String orderId;

  const LoadOrderById(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class ConfirmOrder extends OrderEvent {
  final String orderId;

  const ConfirmOrder(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class CancelOrder extends OrderEvent {
  final String orderId;

  const CancelOrder(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class ClearOrderState extends OrderEvent {
  const ClearOrderState();
}
