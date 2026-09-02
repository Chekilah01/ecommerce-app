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
    final isOutOfStock = widget.product.stock <= 0;

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
              backgroundColor: isDarkMode ? Colors.black : Colors.white,
            ),
            child: Icon(
              Iconsax.arrow_left_copy,
              size: 24,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductImageSlider(widget: widget),
            Padding(
              padding: const EdgeInsets.only(
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
                  const ReviewsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.md,
            AppSizes.sm,
            AppSizes.md,
            AppSizes.md,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: isOutOfStock
                  ? null
                  : () {
                      // TODO: Add to cart action
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.white : Colors.black,
                foregroundColor: isDarkMode ? Colors.black : Colors.white,
                disabledBackgroundColor: Colors.grey.shade400,
                disabledForegroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(
                isOutOfStock ? Icons.close_rounded : Iconsax.shopping_cart_copy,
                size: 24,
              ),
              label: Text(
                isOutOfStock ? 'Out of Stock' : 'Add to Cart',
                style: const TextStyle(
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
