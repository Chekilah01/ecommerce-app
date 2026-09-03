import 'package:final_project/features/cart/presentation/bloc/cart_state.dart';
import 'package:final_project/features/customer/presentation/widgets/cartWidgets/summary_row.dart';
import 'package:flutter/material.dart';

class CartSummary extends StatelessWidget {
  final CartState state;

  const CartSummary({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, -3),
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ],
        ),
        child: Column(
          children: [
            SummaryRow(title: 'Subtotal', value: state.subtotal),

            const SizedBox(height: 8),

            SummaryRow(title: 'Delivery fee', value: state.deliveryFee),

            const SizedBox(height: 12),

            const Divider(),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilory',
                  ),
                ),
                Text(
                  '${state.total.toStringAsFixed(2)} DA',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilory',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Order Now
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.disabled)) {
                      return Colors.grey.shade400;
                    }
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.green.shade800; 
                    }
                    return Colors.green; 
                  }),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  elevation: WidgetStateProperty.all(0),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                child: const Text(
                  'Order Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
