import 'package:final_project/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:final_project/features/cart/data/models/cart_item_model.dart';
import 'package:final_project/features/cart/domain/entities/cart_item_entity.dart';

class CartRepository {
  final CartRemoteDataSource _cartRemoteDataSource;

  CartRepository({
    CartRemoteDataSource? cartRemoteDataSource,
  }) : _cartRemoteDataSource =
           cartRemoteDataSource ?? CartRemoteDataSource();

  Future<List<CartItemEntity>> getCart(String userId) async {
    final cartItems = await _cartRemoteDataSource.getCart(userId);

    return cartItems.map((item) => item.toEntity()).toList();
  }

  Future<void> addToCart(
    String userId,
    CartItemEntity item,
  ) async {
    final cartItemModel = CartItemModel.fromEntity(item);

    await _cartRemoteDataSource.addToCart(
      userId,
      cartItemModel,
    );
  }

  Future<void> updateQuantity(
    String userId,
    String productId,
    int quantity,
  ) async {
    await _cartRemoteDataSource.updateQuantity(
      userId,
      productId,
      quantity,
    );
  }

  Future<void> removeFromCart(
    String userId,
    String productId,
  ) async {
    await _cartRemoteDataSource.removeFromCart(
      userId,
      productId,
    );
  }

  Future<void> clearCart(String userId) async {
    await _cartRemoteDataSource.clearCart(userId);
  }
}