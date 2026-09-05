import 'package:final_project/features/order/presentation/widgets/status_badge.dart';
import 'package:final_project/features/order/domain/entities/order_status.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final DateTime date;
  final int itemCount;
  final double total;
  final OrderStatus status;
  final VoidCallback onTap;

  const OrderCard({
    super.key, 
    required this.orderId,
    required this.date,
    required this.itemCount,
    required this.total,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Order #',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(child: Text(orderId, overflow: TextOverflow.ellipsis)),
                StatusBadge(status: status),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              _formatDate(date),
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$itemCount ${itemCount == 1 ? 'item' : 'items'}'),
                Text(
                  '${total.toStringAsFixed(2)} DA',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'View details',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ],
        ),
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