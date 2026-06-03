import 'package:flutter/material.dart';
import '../../data/data.dart';
import '../face.dart';

class MoodRow extends StatelessWidget {
  const MoodRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: moodLibrary.map((m) {
          return Column(
            children: [
              ClipOval(
                child: Container(
                  width: 44,
                  height: 44,
                  color: m.bgColor,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: MoodFace(data: m),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
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
