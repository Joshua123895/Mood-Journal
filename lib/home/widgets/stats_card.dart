import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({super.key});
  final double borderRadius = 20;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final svgWidth = constraints.maxWidth * 0.4;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              Positioned(
                left: 20,
                top: 16,
                bottom: 14,
                child: SizedBox(
                  width: constraints.maxWidth - 2 * borderRadius - svgWidth,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "It's okay to not be okay.",
                        style: TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Spacer(),
                      SizedBox(height: 12),
                      Text(
                        "Give yourself grace and rest when you need it.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: borderRadius / 2,
                bottom: borderRadius / 2,
                child: Container(
                  width: svgWidth,
                  height: 200,
                  color: Colors.red.withAlpha(120),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
