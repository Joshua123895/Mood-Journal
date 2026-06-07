import 'package:flutter/material.dart';
import '../../theme/app_constants.dart';

class MoodJar extends StatelessWidget {
  final double fillPercentage;
  final int moodScore;
  final double jarWidth = 150;
  final double jarHeight = 200;
  final double capWidth = 100;
  final double capHeight = 10;
  final double borderWidth = 4;
  final double borderRadius = 36;

  const MoodJar({
    super.key,
    this.fillPercentage = 0.7,
    this.moodScore = 80,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = fillPercentage > 0.6 ? Colors.white : Colors.black;
    return SizedBox(
      width: jarWidth,
      height: jarHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // glass
          Container(
            width: jarWidth,
            height: jarHeight - capHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Radii.xxl),
              border: Border.all(
                width: borderWidth,
                color: Colors.black26,
              ),
            ),
          ),

          // liquid
          Positioned(
            bottom: borderWidth,
            child: ClipPath(
              clipper: JarClipper(borderRadius),
              child: Container(
                width: jarWidth - 2 * borderWidth,
                height: jarHeight - capHeight - 2 * borderWidth,

                alignment: Alignment.bottomCenter,

                child: FractionallySizedBox(
                  alignment: Alignment.bottomCenter,
                  heightFactor: fillPercentage.clamp(0.05, 1.0),
                  child: Container(
                    width: double.infinity,
                    color: Colors.blue.shade400.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),

          // cap
          Positioned(
            top: 0,
            child: Container(
              width: capWidth,
              height: capHeight,
              decoration: BoxDecoration(
                color: Colors.brown.shade300,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),

          // score text centered
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$moodScore",
                  style: TextStyle(
                    fontSize: FontSizes.hero,
                    fontWeight: FontWeights.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  "Mood Score",
                  style: TextStyle(
                    fontSize: FontSizes.sm,
                    fontWeight: FontWeights.medium,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class JarClipper extends CustomClipper<Path> {
  final double borderRadius;

  JarClipper(this.borderRadius);

  @override
  Path getClip(Size size) {
    final path = Path();

    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ),
    );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
