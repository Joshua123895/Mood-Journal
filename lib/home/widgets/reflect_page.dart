import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/entry.dart';
import '../../services/mood_service_instance.dart';
import '../../theme/app_constants.dart';

class ReflectPage extends StatefulWidget {
  const ReflectPage({super.key});

  @override
  State<ReflectPage> createState() => _ReflectPageState();
}

class _ReflectPageState extends State<ReflectPage> {
  final TextEditingController _controller = TextEditingController();
  late final String _prompt;

  static const List<String> _prompts = [
    "What made you smile today?",
    "What's one thing you're grateful for?",
    "How did you show kindness to someone?",
    "What challenged you today?",
    "What did you learn about yourself?",
    "Describe a moment of peace you experienced.",
    "What would you do differently today?",
    "Who made a positive impact on your day?",
    "What are you looking forward to tomorrow?",
    "How did your body feel today?",
  ];

  @override
  void initState() {
    super.initState();
    _prompt = _prompts[Random().nextInt(_prompts.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final today = DateTime.now();
    final todayEntry = moodService.getMoodForDate(today);
    final mood = todayEntry?.mood ?? 3;

    final entry = MoodEntry(
      date: today,
      mood: mood,
      note: text,
    );
    await moodService.saveMood(entry);
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reflection saved!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflect'),
        backgroundColor: AppColors.actionReflect,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: FontSizes.lg,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Insets.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Insets.xl),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Insets.lg),
              decoration: BoxDecoration(
                color: AppColors.actionReflect.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Radii.card),
              ),
              child: Text(
                _prompt,
                style: const TextStyle(
                  fontSize: FontSizes.xl,
                  fontWeight: FontWeights.semibold,
                ),
              ),
            ),
            const SizedBox(height: Insets.xl),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Write your thoughts...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Radii.card),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.all(Insets.lg),
                ),
              ),
            ),
            const SizedBox(height: Insets.base),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: FontSizes.lg,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
