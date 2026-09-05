import 'package:final_project/features/order/data/datasources/order_remote_datasource.dart';
import 'package:final_project/features/order/data/models/order_model.dart';
import 'package:final_project/features/order/domain/entities/order_entity.dart';

class OrderRepository {
  final OrderRemoteDataSource _orderRemoteDataSource;

  OrderRepository({OrderRemoteDataSource? orderRemoteDataSource})
    : _orderRemoteDataSource = orderRemoteDataSource ?? OrderRemoteDataSource();

  Future<String> createOrder(OrderEntity order, String orderId) async {
    final orderModel = OrderModel.fromEntity(order);

    return await _orderRemoteDataSource.createOrder(orderModel, orderId);
  }

  Future<List<OrderEntity>> getOrders({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final orders = await _orderRemoteDataSource.getOrders(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );

    return orders.map((order) => order.toEntity()).toList();
  }

  Future<OrderEntity> getOrderById(String orderId) async {
    final order = await _orderRemoteDataSource.getOrderById(orderId);

    return order.toEntity();
  }

  Future<void> confirmOrder(String orderId) async {
    await _orderRemoteDataSource.confirmOrder(orderId);
  }

  Future<void> cancelOrder(String orderId) async {
    await _orderRemoteDataSource.cancelOrder(orderId);
  }

  String generateOrderId() {
    return _orderRemoteDataSource.generateOrderId();
  }

  Future<OrderEntity?> findOrderById(String orderId) async {
    final order = await _orderRemoteDataSource.findOrderById(orderId);

    return order?.toEntity();
  }
}
