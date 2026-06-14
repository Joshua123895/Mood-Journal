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
		var reminders = moodService.getAllReminders();
		if (reminders.isEmpty) {
			await moodService.saveReminder(
				ReminderEntry(label: 'Journal reminder', hour: 21, minute: 0, repeat: 'daily'),
			);
			await moodService.saveReminder(
				ReminderEntry(label: 'Mood check-in', hour: 15, minute: 0, repeat: 'daily'),
			);
			reminders = moodService.getAllReminders();
		}
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

	String _formatTime(int hour, int minute) {
		final period = hour < 12 ? 'AM' : 'PM';
		final h = hour % 12 == 0 ? 12 : hour % 12;
		final m = minute.toString().padLeft(2, '0');
		final periodWord = hour < 12
				? 'morning'
				: hour < 17
						? 'afternoon'
						: 'evening';
		return 'Every $periodWord at $h:$m $period';
	}

	@override
	Widget build(BuildContext context) {
		const activeColor = Color(0xFF6C63FF);

		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				SectionHeader(
					title: "Reminders",
					actionLabel: "See all",
					onAction: () {},
				),
				const SizedBox(height: Insets.base),
				if (_reminders.isNotEmpty)
					Container(
						width: double.infinity,
						decoration: BoxDecoration(
							color: Colors.transparent,
							borderRadius: BorderRadius.circular(Radii.card),
							border: Border.all(color: Colors.grey.shade200, width: 1),
						),
						child: Column(
							children: _reminders.asMap().entries.map((e) {
								final i = e.key;
								final r = e.value;
								return Column(
									children: [
										Padding(
											padding: const EdgeInsets.symmetric(
												horizontal: Insets.cardPadding,
												vertical: Insets.md,
											),
											child: Row(
												children: [
													Icon(
														i == 0 ? Icons.notifications_none : Icons.circle_outlined,
														color: Colors.grey.shade400,
														size: 22,
													),
													const SizedBox(width: Insets.base),
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
																const SizedBox(height: 2),
																Text(
																	_formatTime(r.hour, r.minute),
																	style: TextStyle(
																		fontSize: FontSizes.sm,
																		color: Colors.grey.shade500,
																	),
																),
															],
														),
													),
													Switch(
														value: r.active,
														activeThumbColor: Colors.white,
														activeTrackColor: activeColor,
														onChanged: (v) {
															setState(() => r.active = v);
															r.save();
														},
													),
												],
											),
										),
										if (i < _reminders.length - 1)
											Divider(height: 1, color: Colors.grey.shade200),
									],
								);
							}).toList(),
						),
					),
				if (_reminders.isEmpty)
					const Padding(
						padding: EdgeInsets.symmetric(vertical: Insets.xl),
						child: Center(
							child: Text(
								"No reminders yet",
								style: TextStyle(fontSize: FontSizes.md, color: Colors.grey),
							),
						),
					),
				const SizedBox(height: Insets.base),
				GestureDetector(
					onTap: _showAddReminderDialog,
					child: const DashedBorderBox(
						child: Center(
							child: Text(
								"+ Add Reminder",
								style: TextStyle(
									fontSize: FontSizes.lg,
									fontWeight: FontWeights.semibold,
									color: activeColor,
								),
							),
						),
					),
				),
			],
		);
	}
}
