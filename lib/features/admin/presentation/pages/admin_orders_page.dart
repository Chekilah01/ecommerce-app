import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/no_products.svg',
            height: 60,
            width: 60,
            ),
          ],
        )
          ),
          );
  }
}
