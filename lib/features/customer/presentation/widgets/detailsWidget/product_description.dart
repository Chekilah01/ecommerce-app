import 'package:final_project/features/customer/presentation/pages/product_details_page.dart';
import 'package:final_project/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    super.key,
    required this.widget,
  });

  final ProductDetailsPage widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.spaceBtwInputFields / 2),
      child: Column(
        children: [
          Center(
            child: Text(
              'Description',
              style: TextStyle(
                fontSize: AppSizes.md,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: AppSizes.sm),
          Center(
            child: ReadMoreText(
              widget.product.description,
              trimLines: 5,
              trimMode: TrimMode.Line,
              trimCollapsedText: ' Read more',
              trimExpandedText: ' Less',
              moreStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              lessStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
