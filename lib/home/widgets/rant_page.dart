import 'package:flutter/material.dart';
import '../../data/entry.dart';
import '../../services/mood_service_instance.dart';
import '../../theme/app_constants.dart';

class RantPage extends StatefulWidget {
  const RantPage({super.key});

  @override
  State<RantPage> createState() => _RantPageState();
}

class _RantPageState extends State<RantPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final entry = MoodEntry(
      date: DateTime.now(),
      mood: 2,
      note: text,
    );
    await moodService.saveMood(entry);
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rant saved!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rant'),
        backgroundColor: AppColors.actionRant,
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
          children: [
            const SizedBox(height: Insets.xl),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Let it all out...',
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
