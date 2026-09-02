import 'package:final_project/features/customer/presentation/widgets/detailsWidget/price_widget.dart';
import 'package:final_project/features/customer/presentation/widgets/detailsWidget/product_description.dart';
import 'package:final_project/features/customer/presentation/widgets/detailsWidget/product_image_slider.dart';
import 'package:final_project/features/customer/presentation/widgets/detailsWidget/product_title_widget.dart';
import 'package:final_project/features/customer/presentation/widgets/detailsWidget/rating_widget.dart';
import 'package:final_project/features/customer/presentation/widgets/detailsWidget/reviews_widget.dart';
import 'package:final_project/features/product/domain/entities/product_entity.dart';
import 'package:final_project/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductEntity product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBody: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              //TODO:color shouldn't be fixed
              backgroundColor: Colors.white,
            ),
            child: const Icon(Iconsax.arrow_left_copy, size: 24),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductImageSlider(widget: widget),

            Padding(
              padding: EdgeInsetsGeometry.only(
                right: AppSizes.defaultSpace,
                left: AppSizes.defaultSpace,
                bottom: AppSizes.defaultSpace,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductTitle(widget: widget),

                  RatingWidget(widget: widget),

                  ProductPrice(widget: widget),

                  ProductDescription(widget: widget),

                  ReviewsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.fromLTRB(
            AppSizes.md,
            AppSizes.sm,
            AppSizes.md,
            AppSizes.md,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                //TODO: add to cart + don't forget to disable button when out of stock!
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.white : Colors.black,
                foregroundColor: isDarkMode ? Colors.black : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Iconsax.shopping_cart_copy, size: 24),
              label: Text(
                'Add to Cart',
                style: TextStyle(
                  fontSize: AppSizes.md,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
