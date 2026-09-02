import 'package:final_project/features/customer/presentation/pages/product_details_page.dart';
import 'package:final_project/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({super.key, required this.widget});

  final ProductDetailsPage widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Iconsax.star, color: Colors.amber, size: 24),
        SizedBox(width: AppSizes.spaceBtwItems / 2),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${widget.product.averageRating}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.md,
                ),
              ),
              TextSpan(
                text: ' (${widget.product.ratingCount} Reviews)',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
