import 'package:flutter/material.dart';
import '../../theme/app_constants.dart';

class JournalHeader extends StatelessWidget {
  const JournalHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Journal",
          style: TextStyle(
            fontSize: FontSizes.title,
            fontWeight: FontWeights.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: Insets.sm),
        Text(
          "Capture your thoughts",
          style: TextStyle(
            fontSize: FontSizes.md,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
