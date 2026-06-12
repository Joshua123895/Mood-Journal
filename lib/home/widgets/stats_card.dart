import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/tips.dart';
import '../../theme/app_constants.dart';

class StatsCard extends StatefulWidget {
  final List<StatsCardVariation> variations;

  const StatsCard({super.key, required this.variations});

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  final int _currentIndex = 1;
  final double _jarArea = 0.3;
  final double _jarOutline = 8;
  final double _cardHeight = 160;

  @override
  Widget build(BuildContext context) {
    final variation = widget.variations[_currentIndex];

    return SizedBox(
      width: double.infinity,
      height: _cardHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final svgWidth = constraints.maxWidth * _jarArea;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: _cardHeight,
                decoration: BoxDecoration(
                  color: variation.jarColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(Radii.card),
                ),
              ),
              Positioned(
                left: Insets.cardPaddingLarge,
                top: Insets.lg,
                bottom: Insets.md,
                child: SizedBox(
                  width: constraints.maxWidth - 2 * Radii.card - svgWidth - Insets.xl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        variation.title,
                        style: const TextStyle(
                          fontSize: FontSizes.lg,
                          fontWeight: FontWeights.semibold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: Insets.base),
                      Text(
                        variation.body,
                        style: TextStyle(
                          fontSize: FontSizes.md,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: Radii.card * 1.5,
                bottom: Radii.card / 2,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 1),
                      child: SvgPicture.asset(
                        'assets/icons/tips/jar/jar_highlight.svg',
                        width: svgWidth - _jarOutline/4,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 1),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          variation.jarColor,
                          BlendMode.srcIn,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/tips/jar/jar_fill.svg',
                          width: svgWidth - _jarOutline/4,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        variation.jarColor,
                        BlendMode.srcIn,
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/tips/jar/jar_outline.svg',
                        width: svgWidth,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: svgWidth * 0.3),
                      child: SvgPicture.asset(
                        'assets/icons/tips/face/${variation.faceAsset}',
                        width: svgWidth * 0.45,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: svgWidth * 0.9),
                      child: SvgPicture.asset(
                        'assets/icons/tips/top/${variation.topAsset}',
                        width: svgWidth,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
