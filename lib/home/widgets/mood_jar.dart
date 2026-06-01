import 'package:flutter/material.dart';

class MoodJar extends StatelessWidget {
  final double fillPercentage;

  const MoodJar({
    super.key,
    this.fillPercentage = 0.6,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 160,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [

          // glass
          Container(
            width: 120,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                width: 4,
                color: Colors.black26,
              ),
            ),
          ),

          // liquid
          Positioned(
            bottom: 0,
            child: Container(
              width: 112,
              height: 150 * fillPercentage,
              decoration: BoxDecoration(
                color: Colors.orange.shade200,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
          ),

          // face
          Positioned(
            top: 55,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),

                SizedBox(width: 24),

                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 80,
            child: Container(
              width: 24,
              height: 12,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}