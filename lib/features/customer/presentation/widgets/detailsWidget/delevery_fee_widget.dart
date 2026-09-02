
import 'package:final_project/features/customer/presentation/pages/product_details_page.dart';
import 'package:final_project/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ProductDeleveryFee extends StatelessWidget {
  const ProductDeleveryFee({
    super.key,
    required this.isDarkMode,
    required this.widget,
  });

  final bool isDarkMode;
  final ProductDetailsPage widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(left: AppSizes.sm),
      child: Column(
        children: [
          const SizedBox(height: AppSizes.spaceBtwItems / 2),
          Row(
            children: [
              Icon(
                Iconsax.truck_fast_copy,
                size: 24,
                color: isDarkMode
                    ? Colors.grey.shade400
                    : Colors.grey.shade700,
              ),
              const SizedBox(width: 6),
              Text(
                'Delivery Fee: ',
                style: TextStyle(
                  fontSize: AppSizes.md,
                  color: isDarkMode
                      ? Colors.grey.shade400
                      : Colors.grey.shade700,
                ),
              ),
              Text(
                widget.product.deliveryFee == 0
                    ? 'Free Delivery'
                    : '${widget.product.deliveryFee.toStringAsFixed(2)} DA',
                style: TextStyle(
                  fontSize: AppSizes.md,
                  fontWeight: FontWeight.bold,
                  color: widget.product.deliveryFee == 0
                      ? Colors.green
                      : (isDarkMode
                            ? Colors.white
                            : Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceBtwItems),
        ],
      ),
    );
  }
}
