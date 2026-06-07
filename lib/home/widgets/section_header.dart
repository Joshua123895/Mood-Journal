import 'package:flutter/material.dart';
import '../../theme/app_constants.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: FontSizes.lg,
            fontWeight: FontWeights.semibold,
            color: Colors.black,
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: const TextStyle(
                fontSize: FontSizes.md,
                color: Colors.black,
                fontWeight: FontWeights.semibold,
              ),
            ),
          ),
      ],
    );
  }
}
