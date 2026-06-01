import 'package:flutter/material.dart';

import 'widgets/mood_jar.dart';
import '../data/data.dart';
import '../data/entry.dart';
import 'widgets/mood_summary_card.dart';
import '../services/mood_service_instance.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MoodEntry? todayMood;

  @override
  void initState() {
    super.initState();

    todayMood =
        moodService.getMoodForDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Evening",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "How are you feeling today?",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 32),

            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Center(
                child: MoodJar(
                    fillPercentage: 0.7,
                ),
              ),
            ),

            SizedBox(height: 24),

            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: MoodSummaryCard(
                  mood: moodLibrary[4],
                ),
              ),
            ),

            SizedBox(height: 24),

            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text("Recent Journals"),
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).padding.bottom + 100,
            ),
          ],
        ),
      ),
    );
  }
}