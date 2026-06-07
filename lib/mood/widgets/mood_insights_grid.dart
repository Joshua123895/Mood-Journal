import 'package:flutter/material.dart';

const Map<String, String> _moodEmojis = {
  "Sad": "😢",
  "Anxious": "😰",
  "Stressed": "😫",
  "Calm": "😌",
  "Happy": "😊",
  "Loved": "😍",
};

class MoodInsightsGrid extends StatelessWidget {
  final String mostCommon;
  final String leastCommon;
  final String bestDay;
  final String averageMood;

  const MoodInsightsGrid({
    super.key,
    required this.mostCommon,
    required this.leastCommon,
    required this.bestDay,
    required this.averageMood,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _InsightCard(
                title: "Most Common",
                value: mostCommon,
                emoji: _moodEmojis[mostCommon] ?? "",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InsightCard(
                title: "Least Common",
                value: leastCommon,
                emoji: _moodEmojis[leastCommon] ?? "",
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _InsightCard(
                title: "Best Day",
                value: bestDay,
                emoji: _moodEmojis[bestDay] ?? "",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InsightCard(
                title: "Average Mood",
                value: averageMood,
                emoji: _moodEmojis[averageMood] ?? "",
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final String value;
  final String emoji;

  const _InsightCard({
    required this.title,
    required this.value,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
