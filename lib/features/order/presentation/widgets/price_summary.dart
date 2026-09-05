
import 'package:final_project/features/cart/presentation/widgets/summary_row.dart';
import 'package:final_project/features/order/domain/entities/order_entity.dart';
import 'package:flutter/material.dart';

class PriceSummary extends StatelessWidget {
  final OrderEntity order;

  const PriceSummary({super.key, 
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SummaryRow(
            title: 'Subtotal',
            value: order.subtotal,
          ),

          const SizedBox(height: 10),

          SummaryRow(
            title: 'Delivery fee',
            value: order.deliveryFee,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${order.total.toStringAsFixed(2)} DA',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
