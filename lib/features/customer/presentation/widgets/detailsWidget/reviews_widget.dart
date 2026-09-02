import 'package:final_project/utils/constants/colors.dart';
import 'package:final_project/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'See Reviews',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.light
                          : AppColors.dark,
                      fontFamily: 'Gilroy',
                      fontSize: AppSizes.md,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Iconsax.arrow_right_3_copy),
                ],
              ),
            ),
            const Divider(height: 2),
          ],
        ),
      ),
    );
  }
}