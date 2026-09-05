
import 'package:final_project/features/order/domain/entities/order_entity.dart';
import 'package:final_project/features/order/presentation/widgets/info_row.dart';
import 'package:flutter/material.dart';

class DeliveryInformation extends StatelessWidget {
  final OrderEntity order;

  const DeliveryInformation({super.key, 
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          InfoRow(
            icon: Icons.person_outline,
            title: 'Name',
            value: '${order.firstName} ${order.lastName}',
          ),

          const SizedBox(height: 10),

          InfoRow(
            icon: Icons.phone_outlined,
            title: 'Phone',
            value: order.phone,
          ),

          const SizedBox(height: 10),

          InfoRow(
            icon: Icons.location_on_outlined,
            title: 'Address',
            value: '${order.commune}, ${order.wilaya}',
          ),
        ],
      ),
    );
  }
}
