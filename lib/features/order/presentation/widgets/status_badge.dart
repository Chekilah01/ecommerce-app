import 'package:final_project/features/order/domain/entities/order_status.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const StatusBadge({super.key, 
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final String text;
    final Color color;

    switch (status) {
      case OrderStatus.pending:
        text = 'Pending';
        color = Colors.orange;

      case OrderStatus.confirmed:
        text = 'Confirmed';
        color = Colors.green;

      case OrderStatus.cancelled:
        text = 'Cancelled';
        color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}