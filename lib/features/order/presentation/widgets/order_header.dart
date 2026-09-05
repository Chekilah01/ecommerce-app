
import 'package:final_project/features/order/domain/entities/order_entity.dart';
import 'package:final_project/features/order/presentation/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class OrderHeader extends StatelessWidget {
  final OrderEntity order;

  const OrderHeader({super.key, 
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
          Row(
            children: [
              const Text(
                'Order #',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  order.id,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              StatusBadge(
                status: order.status,
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            'Placed on ${_formatDate(order.createdAt)}',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/$year • $hour:$minute';
  }
}
