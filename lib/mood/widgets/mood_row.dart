import 'package:flutter/material.dart';
import '../../data/data.dart';
import '../../theme/app_constants.dart';
import '../face.dart';

class MoodRow extends StatelessWidget {
  const MoodRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.moodRowHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: moodLibrary.map((m) {
          return Column(
            children: [
              ClipOval(
                child: Container(
                  width: Sizes.moodFaceMedium,
                  height: Sizes.moodFaceMedium,
                  color: m.bgColor,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: const EdgeInsets.all(Insets.xl),
                      child: MoodFace(data: m),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Insets.xs),
              Text(
                m.label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
