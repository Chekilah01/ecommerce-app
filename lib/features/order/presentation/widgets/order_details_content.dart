
import 'package:final_project/features/order/domain/entities/order_entity.dart';
import 'package:final_project/features/order/presentation/widgets/delivery_information.dart';
import 'package:final_project/features/order/presentation/widgets/order_header.dart';
import 'package:final_project/features/order/presentation/widgets/order_item_card.dart';
import 'package:final_project/features/order/presentation/widgets/price_summary.dart';
import 'package:flutter/material.dart';

class OrderDetailsContent extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailsContent({super.key, 
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderHeader(order: order),

          const SizedBox(height: 20),

          const Text(
            'Items',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OrderItemCard(item: item),
            ),
          ),

          const SizedBox(height: 8),

          PriceSummary(order: order),

          const SizedBox(height: 20),

          DeliveryInformation(order: order),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
