import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:final_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:final_project/features/cart/domain/entities/cart_item_entity.dart';
import 'package:final_project/features/cart/domain/repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  final AuthBloc _authBloc;
  late final StreamSubscription<AuthState> _authSubscription;

  CartBloc({CartRepository? cartRepository, required AuthBloc authBloc})
    : _cartRepository = cartRepository ?? CartRepository(),
      _authBloc = authBloc,
      super(const CartState()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<IncreaseCartItemQuantity>(_onIncreaseCartItemQuantity);
    on<DecreaseCartItemQuantity>(_onDecreaseCartItemQuantity);
    on<RemoveCartItem>(_onRemoveCartItem);
    on<ClearCart>(_onClearCart);
    on<ClearCartState>(_onClearCartState);

    _authSubscription = _authBloc.stream.listen((authState) {
      if (authState is Authenticated) {
        add(const LoadCart());
      } else if (authState is Unauthenticated) {
        add(const ClearCartState());
      }
    });

    final currentAuthState = _authBloc.state;

    if (currentAuthState is Authenticated) {
      add(const LoadCart());
    }
  }

  String? get _userId {
    final authState = _authBloc.state;

    if (authState is Authenticated) {
      return authState.user.uid;
    }

    return null;
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    final userId = _userId;

    if (userId == null) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'User is not authenticated.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: CartStatus.loading, clearError: true));

    try {
      final items = await _cartRepository.getCart(userId);

      emit(
        state.copyWith(
          status: CartStatus.success,
          items: items,
          subtotal: _calculateSubtotal(items),
          deliveryFee: _calculateDeliveryFee(items),
          total: _calculateTotal(items),
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final userId = _userId;

    if (userId == null) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'User is not authenticated.',
        ),
      );
      return;
    }

    if (event.product.stock <= 0) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'This product is out of stock.',
        ),
      );
      return;
    }

    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    try {
      if (existingIndex == -1) {
        final newItem = CartItemEntity(product: event.product, quantity: 1);

        await _cartRepository.addToCart(userId, newItem);

        final updatedItems = [...state.items, newItem];

        _emitUpdatedCart(emit, updatedItems, 'Product added to cart');
      } else {
        final existingItem = state.items[existingIndex];

        if (existingItem.quantity >= event.product.stock) {
          emit(
            state.copyWith(
              status: CartStatus.failure,
              errorMessage: 'You cannot add more than available stock.',
            ),
          );
          return;
        }

        final newQuantity = existingItem.quantity + 1;

        await _cartRepository.updateQuantity(
          userId,
          event.product.id,
          newQuantity,
        );

        final updatedItems = [...state.items];

        updatedItems[existingIndex] = CartItemEntity(
          product: event.product,
          quantity: newQuantity,
        );

        _emitUpdatedCart(emit, updatedItems, 'Product quantity updated.');
      }
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onIncreaseCartItemQuantity(
    IncreaseCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    final userId = _userId;

    if (userId == null) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'User is not authenticated.',
        ),
      );
      return;
    }

    final index = state.items.indexWhere(
      (item) => item.product.id == event.productId,
    );

    if (index == -1) {
      return;
    }

    final item = state.items[index];

    if (item.quantity >= item.product.stock) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'You cannot exceed the available stock.',
        ),
      );
      return;
    }

    final newQuantity = item.quantity + 1;

    try {
      await _cartRepository.updateQuantity(
        userId,
        event.productId,
        newQuantity,
      );

      final updatedItems = [...state.items];

      updatedItems[index] = CartItemEntity(
        product: item.product,
        quantity: newQuantity,
      );

      _emitUpdatedCart(emit, updatedItems, null);
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onDecreaseCartItemQuantity(
    DecreaseCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    final userId = _userId;

    if (userId == null) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'User is not authenticated.',
        ),
      );
      return;
    }

    final index = state.items.indexWhere(
      (item) => item.product.id == event.productId,
    );

    if (index == -1) {
      return;
    }

    final item = state.items[index];

    // Quantity cannot go below 1.
    if (item.quantity <= 1) {
      return;
    }

    final newQuantity = item.quantity - 1;

    try {
      await _cartRepository.updateQuantity(
        userId,
        event.productId,
        newQuantity,
      );

      final updatedItems = [...state.items];

      updatedItems[index] = CartItemEntity(
        product: item.product,
        quantity: newQuantity,
      );

      _emitUpdatedCart(emit, updatedItems, null);
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onRemoveCartItem(
    RemoveCartItem event,
    Emitter<CartState> emit,
  ) async {
    final userId = _userId;

    if (userId == null) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'User is not authenticated.',
        ),
      );
      return;
    }

    try {
      await _cartRepository.removeFromCart(userId, event.productId);

      final updatedItems = state.items
          .where((item) => item.product.id != event.productId)
          .toList();

      _emitUpdatedCart(emit, updatedItems, 'Product removed from cart.');
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    final userId = _userId;

    if (userId == null) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'User is not authenticated.',
        ),
      );
      return;
    }

    try {
      await _cartRepository.clearCart(userId);

      _emitUpdatedCart(emit, [], 'Cart cleared');
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  double _calculateSubtotal(List<CartItemEntity> items) {
    return items.fold(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  double _calculateDeliveryFee(List<CartItemEntity> items) {
    return items.fold(0, (sum, item) => sum + item.product.deliveryFee);
  }

  double _calculateTotal(List<CartItemEntity> items) {
    return _calculateSubtotal(items) + _calculateDeliveryFee(items);
  }

  void _emitUpdatedCart(
    Emitter<CartState> emit,
    List<CartItemEntity> items,
    String? successMessage,
  ) {
    emit(
      state.copyWith(
        status: CartStatus.actionSuccess,
        items: items,
        subtotal: _calculateSubtotal(items),
        deliveryFee: _calculateDeliveryFee(items),
        total: _calculateTotal(items),
        successMessage: successMessage,
        clearSuccessMessage: successMessage == null,
        clearError: true,
      ),
    );
  }

  void _onClearCartState(ClearCartState event, Emitter<CartState> emit) {
    emit(const CartState());
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
