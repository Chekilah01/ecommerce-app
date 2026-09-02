
import 'package:final_project/features/cart/domain/entities/cart_item_entity.dart';
import 'package:final_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:final_project/features/cart/presentation/bloc/cart_event.dart';
import 'package:final_project/features/customer/presentation/widgets/cartWidgets/quantity_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CartItemCard extends StatelessWidget {
  final CartItemEntity item;

  const CartItemCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.mainImageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 90,
                    height: 90,
                    alignment: Alignment.center,
                    child: const Icon(
                      Iconsax.image,
                      size: 30,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilory'
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${product.price.toStringAsFixed(2)} DA',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Gilory',
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      QuantityButton(
                        icon: Iconsax.minus_copy,
                        onPressed: () {
                          context.read<CartBloc>().add(
                            DecreaseCartItemQuantity(product.id),
                          );
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      QuantityButton(
                        icon: Iconsax.add_copy,
                        onPressed: () {
                          context.read<CartBloc>().add(
                            IncreaseCartItemQuantity(product.id),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {
                context.read<CartBloc>().add(
                  RemoveCartItem(product.id),
                );
              },
              icon: const Icon(Iconsax.trash_copy),
            ),
          ],
        ),
      ),
    );
  }
}
