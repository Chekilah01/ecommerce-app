
import 'package:final_project/features/customer/presentation/pages/product_details_page.dart';
import 'package:final_project/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProductPrice extends StatelessWidget {
  const ProductPrice({
    super.key,
    required this.widget,
  });

  final ProductDetailsPage widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(AppSizes.sm),
      child: Text(
        'Price : ${widget.product.price} DA',
        style: TextStyle(
          fontFamily: 'Gilory',
          fontSize: AppSizes.lg,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
