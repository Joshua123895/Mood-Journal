import 'package:flutter/material.dart';
import '../../theme/app_constants.dart';

class GreetingHeader extends StatelessWidget {
  final String greeting;
  final String subtitle;

  const GreetingHeader({
    super.key,
    required this.greeting,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Insets.xl),
        Text(
          greeting,
          style: const TextStyle(
            fontSize: FontSizes.title,
            fontWeight: FontWeights.bold,
          ),
        ),
        const SizedBox(height: Insets.sm),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: FontSizes.lg,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
