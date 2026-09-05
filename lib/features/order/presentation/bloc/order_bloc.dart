import 'dart:async';

import 'package:final_project/core/network/network_info.dart';
import 'package:final_project/features/cart/presentation/bloc/cart_event.dart';
import 'package:final_project/features/order/domain/repositories/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:final_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:final_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:final_project/features/order/domain/entities/order_entity.dart';
import 'package:final_project/features/order/domain/entities/order_item_entity.dart';
import 'package:final_project/features/order/domain/entities/order_status.dart';

import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;
  final AuthBloc _authBloc;
  final CartBloc _cartBloc;
  final NetworkInfo _networkInfo;
  late final StreamSubscription<AuthState> _authSubscription;

  OrderBloc({
    OrderRepository? orderRepository,
    required AuthBloc authBloc,
    required CartBloc cartBloc,
    NetworkInfo? networkInfo,
  }) : _orderRepository = orderRepository ?? OrderRepository(),
       _authBloc = authBloc,
       _cartBloc = cartBloc,
       _networkInfo = networkInfo ?? NetworkInfo(),
       super(const OrderState()) {
    on<CreateOrder>(_onCreateOrder);
    on<LoadOrders>(_onLoadOrders);
    on<LoadOrderById>(_onLoadOrderById);
    on<ConfirmOrder>(_onConfirmOrder);
    on<CancelOrder>(_onCancelOrder);
    on<ClearOrderState>(_onClearOrderState);

    _authSubscription = _authBloc.stream.listen((authState) {
      if (authState is Unauthenticated) {
        add(const ClearOrderState());
      }
    });
  }

  String? get _userId {
    final authState = _authBloc.state;

    if (authState is Authenticated) {
      return authState.user.uid;
    }

    return null;
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrderState> emit,
  ) async {
    if (state.status == OrderStatusState.loading) {
      return;
    }

    final authState = _authBloc.state;

    if (authState is! Authenticated) {
      emit(
        state.copyWith(
          status: OrderStatusState.failure,
          errorMessage: 'User is not authenticated.',
          clearSuccessMessage: true,
          clearCreatedOrderId: true,
        ),
      );
      return;
    }

    final cartItems = _cartBloc.state.items;

    if (cartItems.isEmpty) {
      emit(
        state.copyWith(
          status: OrderStatusState.failure,
          errorMessage: 'Your cart is empty.',
          clearSuccessMessage: true,
          clearCreatedOrderId: true,
        ),
      );
      return;
    }

    final hasInternet = await _networkInfo.isConnected;

    if (!hasInternet) {
      emit(
        state.copyWith(
          status: OrderStatusState.failure,
          errorMessage: 'Please check your internet connection and try again.',
          clearSuccessMessage: true,
          clearCreatedOrderId: true,
        ),
      );
      return;
    }

    String? orderId = state.pendingOrderId;

    orderId ??= _orderRepository.generateOrderId();

    emit(
      state.copyWith(
        status: OrderStatusState.loading,
        pendingOrderId: orderId,
        clearError: true,
        clearSuccessMessage: true,
        clearCreatedOrderId: true,
      ),
    );

    try {
      final user = authState.user;

      final orderItems = cartItems.map((cartItem) {
        return OrderItemEntity(
          productId: cartItem.product.id,
          productName: cartItem.product.name,
          productImageUrl: cartItem.product.mainImageUrl,
          price: cartItem.product.price,
          deliveryFee: cartItem.product.deliveryFee,
          quantity: cartItem.quantity,
        );
      }).toList();

      final order = OrderEntity(
        id: orderId,
        userId: user.uid,
        firstName: user.firstName,
        lastName: user.lastName,
        phone: user.phone,
        wilaya: user.wilaya,
        commune: user.commune,
        items: orderItems,
        subtotal: _cartBloc.state.subtotal,
        deliveryFee: _cartBloc.state.deliveryFee,
        total: _cartBloc.state.total,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final existingOrder = await _orderRepository.findOrderById(orderId);

      if (existingOrder != null) {
        if (existingOrder.userId != user.uid) {
          throw Exception('Unable to create the order. Please try again.');
        }

        _cartBloc.add(const ClearCart());

        emit(
          state.copyWith(
            status: OrderStatusState.actionSuccess,
            createdOrderId: existingOrder.id,
            clearPendingOrderId: true,
            successMessage: 'Order created successfully.',
            clearError: true,
          ),
        );

        return;
      }

      final createdOrderId = await _orderRepository
          .createOrder(order, orderId)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException(
                'Please check your internet connection and try again.',
              );
            },
          );

      _cartBloc.add(const ClearCart());

      emit(
        state.copyWith(
          status: OrderStatusState.actionSuccess,
          createdOrderId: createdOrderId,
          clearPendingOrderId: true,
          successMessage: 'Order created successfully.',
          clearError: true,
        ),
      );
    } on TimeoutException catch (e) {
      emit(
        state.copyWith(
          status: OrderStatusState.failure,
          errorMessage: e.message,
          clearSuccessMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderStatusState.failure,
          errorMessage: e.toString(),
          clearSuccessMessage: true,
        ),
      );
    }
  }

  Future<void> _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    final userId = event.userId ?? _userId;

    emit(state.copyWith(status: OrderStatusState.loading, clearError: true));

    try {
      final orders = await _orderRepository.getOrders(
        userId: userId,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      emit(
        state.copyWith(
          status: OrderStatusState.success,
          orders: orders,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderStatusState.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadOrderById(
    LoadOrderById event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderStatusState.loading, clearError: true));

    try {
      final order = await _orderRepository.getOrderById(event.orderId);

      emit(
        state.copyWith(
          status: OrderStatusState.success,
          selectedOrder: order,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderStatusState.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onConfirmOrder(
    ConfirmOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OrderStatusState.loading,
        clearError: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      await _orderRepository.confirmOrder(event.orderId);

      await _refreshOrderAfterStatusChange(
        event.orderId,
        OrderStatus.confirmed,
        emit,
        'Order confirmed successfully.',
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderStatusState.failure,
          errorMessage: e.toString(),
          clearSuccessMessage: true,
        ),
      );
    }
  }

  Future<void> _onCancelOrder(
    CancelOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OrderStatusState.loading,
        clearError: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      await _orderRepository.cancelOrder(event.orderId);

      await _refreshOrderAfterStatusChange(
        event.orderId,
        OrderStatus.cancelled,
        emit,
        'Order cancelled successfully.',
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderStatusState.failure,
          errorMessage: e.toString(),
          clearSuccessMessage: true,
        ),
      );
    }
  }

  Future<void> _refreshOrderAfterStatusChange(
    String orderId,
    OrderStatus newStatus,
    Emitter<OrderState> emit,
    String successMessage,
  ) async {
    final updatedOrders = state.orders.map((order) {
      if (order.id != orderId) {
        return order;
      }

      return OrderEntity(
        id: order.id,
        userId: order.userId,
        firstName: order.firstName,
        lastName: order.lastName,
        phone: order.phone,
        wilaya: order.wilaya,
        commune: order.commune,
        items: order.items,
        subtotal: order.subtotal,
        deliveryFee: order.deliveryFee,
        total: order.total,
        status: newStatus,
        createdAt: order.createdAt,
        updatedAt: DateTime.now(),
      );
    }).toList();

    OrderEntity? updatedSelectedOrder = state.selectedOrder;

    if (updatedSelectedOrder != null && updatedSelectedOrder.id == orderId) {
      updatedSelectedOrder = OrderEntity(
        id: updatedSelectedOrder.id,
        userId: updatedSelectedOrder.userId,
        firstName: updatedSelectedOrder.firstName,
        lastName: updatedSelectedOrder.lastName,
        phone: updatedSelectedOrder.phone,
        wilaya: updatedSelectedOrder.wilaya,
        commune: updatedSelectedOrder.commune,
        items: updatedSelectedOrder.items,
        subtotal: updatedSelectedOrder.subtotal,
        deliveryFee: updatedSelectedOrder.deliveryFee,
        total: updatedSelectedOrder.total,
        status: newStatus,
        createdAt: updatedSelectedOrder.createdAt,
        updatedAt: DateTime.now(),
      );
    }

    emit(
      state.copyWith(
        status: OrderStatusState.actionSuccess,
        orders: updatedOrders,
        selectedOrder: updatedSelectedOrder,
        successMessage: successMessage,
        clearError: true,
      ),
    );
  }

  void _onClearOrderState(ClearOrderState event, Emitter<OrderState> emit) {
    emit(const OrderState());
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
