import 'package:flutter/material.dart';

class SummaryRow extends StatelessWidget {
  final String title;
  final double value;

  const SummaryRow({super.key, 
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Gilory',
          )
          ),
        Text(
          '${value.toStringAsFixed(2)} DA',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Gilory'
          ),
        ),
      ],
    );
  }
}