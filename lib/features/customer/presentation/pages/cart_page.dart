import 'package:final_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:final_project/features/cart/presentation/bloc/cart_state.dart';
import 'package:final_project/features/customer/presentation/widgets/cartWidgets/cart_item_card.dart';
import 'package:final_project/features/customer/presentation/widgets/cartWidgets/cart_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state.status == CartStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
              ),
            );
          }

          if (state.status == CartStatus.actionSuccess &&
              state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == CartStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.items.isEmpty) {
            //TODO : SVG EMPTY CART
            return const Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = state.items[index];

                    return CartItemCard(
                      item: item,
                    );
                  },
                ),
              ),

              CartSummary(
                state: state,
              ),
            ],
          );
        },
      ),
    );
  }
}