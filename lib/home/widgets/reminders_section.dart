import 'package:flutter/material.dart';
import '../../data/reminder_entry.dart';
import '../../services/mood_service_instance.dart';
import '../../services/notification_service.dart';
import '../../theme/app_constants.dart';
import '../../widgets/shared_widgets.dart';
import 'section_header.dart';

class RemindersSection extends StatefulWidget {
  const RemindersSection({super.key});

  @override
  State<RemindersSection> createState() => _RemindersSectionState();
}

class _RemindersSectionState extends State<RemindersSection> {
  List<ReminderEntry> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final reminders = moodService.getAllReminders();
    setState(() {
      _reminders = reminders;
    });
  }

  Future<void> _showAddReminderDialog() async {
    TimeOfDay selectedTime = TimeOfDay.now();
    String repeat = 'daily';
    final TextEditingController labelController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('Add Reminder'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: labelController,
                    decoration: InputDecoration(
                      labelText: 'Label',
                      hintText: 'e.g. Log your mood',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Radii.md),
                      ),
                    ),
                  ),
                  const SizedBox(height: Insets.base),
                  ListTile(
                    title: const Text('Time'),
                    subtitle: Text(selectedTime.format(ctx)),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: ctx,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setDialogState(() {
                          selectedTime = picked;
                        });
                      }
                    },
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: repeat,
                    decoration: InputDecoration(
                      labelText: 'Repeat',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Radii.md),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'daily', child: Text('Daily')),
                      DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                      DropdownMenuItem(value: 'custom', child: Text('Custom')),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(() {
                          repeat = v;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final label = labelController.text.trim();
                    if (label.isEmpty) return;
                    final entry = ReminderEntry(
                      label: label,
                      hour: selectedTime.hour,
                      minute: selectedTime.minute,
                      repeat: repeat,
                    );
                    await moodService.saveReminder(entry);
                    final now = DateTime.now();
                    final scheduled = DateTime(
                      now.year, now.month, now.day,
                      entry.hour, entry.minute,
                    );
                    await NotificationService().scheduleNotification(
                      id: DateTime.now().millisecondsSinceEpoch % 100000,
                      title: 'Mood Jar Reminder',
                      body: entry.label,
                      scheduledDate: scheduled,
                    );
                    _loadReminders();
                    if (!ctx.mounted) return;
                    Navigator.of(ctx).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Reminders"),
        const SizedBox(height: Insets.base),
        if (_reminders.isNotEmpty)
          ..._reminders.map((r) {
            final timeStr =
                '${r.hour.toString().padLeft(2, '0')}:${r.minute.toString().padLeft(2, '0')}';
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: Insets.md),
              padding: const EdgeInsets.all(Insets.cardPadding),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(Radii.card),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.label,
                          style: const TextStyle(
                            fontSize: FontSizes.md,
                            fontWeight: FontWeights.semibold,
                          ),
                        ),
                        const SizedBox(height: Insets.xs),
                        Text(
                          '$timeStr • ${r.repeat}',
                          style: TextStyle(
                            fontSize: FontSizes.sm,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Switch(
                      value: r.active,
                      activeTrackColor: Colors.purple,
                      onChanged: (v) {
                        setState(() {
                          r.active = v;
                        });
                        r.save();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 28),
                      onPressed: () async {
                        await moodService.deleteReminder(r);
                        _loadReminders();
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        if (_reminders.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: Insets.xl),
            child: Center(
              child: Text(
                "No reminders yet",
                style: TextStyle(
                  fontSize: FontSizes.md,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        const SizedBox(height: Insets.base),
        GestureDetector(
          onTap: _showAddReminderDialog,
          child: const DashedBorderBox(
            child: Center(
              child: Text(
                "+ Add reminder",
                style: TextStyle(
                  fontSize: FontSizes.lg,
                  fontWeight: FontWeights.semibold,
                  color: Colors.purple,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
