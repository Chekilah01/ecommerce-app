import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingItem extends StatelessWidget {
  final String animation;
  final String title;
  final String subtitle;

  const OnboardingItem({
    super.key,
    required this.animation,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 60),

          Expanded(
            flex: 6,
            child: Lottie.asset(
              animation,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 30),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}