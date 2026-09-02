
import 'package:final_project/features/customer/presentation/pages/product_details_page.dart';
import 'package:final_project/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProductTitle extends StatelessWidget {
  const ProductTitle({
    super.key,
    required this.widget,
  });

  final ProductDetailsPage widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(AppSizes.sm),
      child: Center(
        child: Text(
          widget.product.name,
          style: TextStyle(
            fontSize: AppSizes.fontSizeTitle,
            fontFamily: 'Gilory',
          ),
        ),
      ),
    );
  }
}
