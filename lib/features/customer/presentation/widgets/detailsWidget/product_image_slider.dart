import 'package:final_project/features/customer/presentation/pages/product_details_page.dart';
import 'package:final_project/features/customer/presentation/widgets/detailsWidget/curved_widget.dart';
import 'package:final_project/features/customer/presentation/widgets/detailsWidget/rounded_image.dart';
import 'package:final_project/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ProductImageSlider extends StatefulWidget {
  const ProductImageSlider({
    super.key,
    required this.widget,
  });

  final ProductDetailsPage widget;

  @override
  State<ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  late String _selectedImageUrl;
  late final PageController _pageController;

  List<String> get _images {
    final product = widget.widget.product;
    return [
      product.mainImageUrl,
      ...product.additionalImages.map((img) => img.url),
    ];
  }

  @override
  void initState() {
    super.initState();
    _selectedImageUrl = widget.widget.product.mainImageUrl;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagesList = _images;

    return TCurvedEdgesWidget(
      child: Container(
        color: AppColors.dark,
        child: Stack(
          children: [
            SizedBox(
              height: 400,
              child: PageView.builder(
                controller: _pageController,
                itemCount: imagesList.length,
                onPageChanged: (index) {
                  setState(() {
                    _selectedImageUrl = imagesList[index];
                  });
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showFullScreenImage(context , imagesList[index]),
                    child: Image.network(
                      imagesList[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              right: 5,
              bottom: 30,
              left: 5,
              child: SizedBox(
                height: 80,
                child: Center(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemCount: imagesList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final imageUrl = imagesList[index];
                      final isSelected = imageUrl == _selectedImageUrl;

                      return TRoundedImage(
                        onPressed: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue
                              : (Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.light
                                  : AppColors.dark),
                          width: isSelected ? 3 : 1,
                        ),
                        width: 80,
                        height: 80,
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: AppColors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 80,
                    color: Colors.white54,
                    ),
                ),
                ),
            )
          ],
        ),
      ),
      );
  }
}