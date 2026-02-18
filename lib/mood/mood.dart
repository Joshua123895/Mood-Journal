import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

import 'mood_face.dart' show MoodFacePage;

class MoodPage extends StatelessWidget {
  const MoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // // ===== JAR IMAGE ===== (error)
        // Image.asset(
        //   "assets/images/jar.png",
        //   height: 120,
        // ),
        // ===== BUTTONS =====
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 120),
              // Image.asset(
              //   "assets/image/jar.png",
              //   height: 240,
              // ),
              ElevatedButton(
                onPressed: () {
                  _openOverlay(context);
                },
                // onPressed: () {},
                child: const Text("Add Mood +"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {},
                child: const Text("History"),
              ),
            ],
          ),
        ),

        SizedBox(
          height: MediaQuery.of(context).padding.bottom + 108,
        ),
      ],
    );
  }
  
  void _openOverlay(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // 👈 allows transparency
        barrierColor: Colors.black.withAlpha(120),
        pageBuilder: (_, _, _) => MoodFacePage(),
        transitionsBuilder: (_, animation, _, child) {
          final offsetTween = Tween(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOut));

          return SlideTransition(
            position: animation.drive(offsetTween),
            child: child,
          );
        },
      ),
    );
  }
}
