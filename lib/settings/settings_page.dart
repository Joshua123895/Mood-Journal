import 'package:flutter/material.dart';
import '../services/mood_service_instance.dart';
import '../theme/app_constants.dart';

class SettingsPage extends StatefulWidget {
	const SettingsPage({super.key});

	@override
	State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
	bool _darkMode = false;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.white,
			appBar: AppBar(
				title: const Text(
					'Settings',
					style: TextStyle(fontWeight: FontWeights.semibold, fontSize: FontSizes.xl),
				),
				backgroundColor: Colors.white,
				foregroundColor: Colors.black87,
				elevation: 0,
			),
			body: ListView(
				children: [
					// Profile header
					Padding(
						padding: const EdgeInsets.symmetric(
							horizontal: Insets.pageHorizontal,
							vertical: Insets.lg,
						),
						child: Row(
							children: [
								CircleAvatar(
									radius: 32,
									backgroundColor: Colors.grey.shade200,
									child: Icon(Icons.person, size: 32, color: Colors.grey.shade500),
								),
								const SizedBox(width: Insets.lg),
								const Expanded(
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Text(
												'Jane Doe',
												style: TextStyle(
													fontSize: FontSizes.xl,
													fontWeight: FontWeights.bold,
												),
											),
											SizedBox(height: 2),
											Text(
												'jane.doe@email.com',
												style: TextStyle(
													fontSize: FontSizes.md,
													color: Colors.grey,
												),
											),
										],
									),
								),
								const Icon(Icons.chevron_right, color: Colors.grey),
							],
						),
					),

					const Divider(height: 1, indent: Insets.pageHorizontal, endIndent: Insets.pageHorizontal),
					const SizedBox(height: Insets.md),

					// Menu items
					_buildItem(
						iconBg: const Color(0xFFE8F5E9),
						icon: Icons.person_outline,
						iconColor: const Color(0xFF4CAF50),
						title: 'My Profile',
						onTap: () {},
					),
					_buildItem(
						iconBg: const Color(0xFFEDE7F6),
						icon: Icons.water_drop_outlined,
						iconColor: const Color(0xFF7C4DFF),
						title: 'Jar Preferences',
						onTap: () {},
					),
					_buildItem(
						iconBg: const Color(0xFFFFF8E1),
						icon: Icons.notifications_none,
						iconColor: const Color(0xFFFFA000),
						title: 'Notifications',
						onTap: () {},
					),
					_buildItem(
						iconBg: const Color(0xFFE3F2FD),
						icon: Icons.lock_outline,
						iconColor: const Color(0xFF1E88E5),
						title: 'Privacy & Security',
						onTap: () {},
					),
					_buildItem(
						iconBg: const Color(0xFFEDE7F6),
						icon: Icons.cloud_upload_outlined,
						iconColor: const Color(0xFF9575CD),
						title: 'Backup & Restore',
						onTap: () {},
					),
					_buildToggleItem(
						iconBg: const Color(0xFFEDE7F6),
						icon: Icons.dark_mode_outlined,
						iconColor: const Color(0xFF5C6BC0),
						title: 'Dark Mode',
						value: _darkMode,
						onChanged: (val) => setState(() => _darkMode = val),
					),
					_buildItem(
						iconBg: const Color(0xFFFFEBEE),
						icon: Icons.help_outline,
						iconColor: const Color(0xFFE53935),
						title: 'Help & Support',
						onTap: () {},
					),
					_buildItem(
						iconBg: const Color(0xFFE3F2FD),
						icon: Icons.info_outline,
						iconColor: const Color(0xFF1E88E5),
						title: 'About Mood Jar',
						onTap: () {},
					),

					const SizedBox(height: Insets.xxl),

					// Log Out button
					Padding(
						padding: const EdgeInsets.symmetric(horizontal: Insets.pageHorizontal),
						child: GestureDetector(
							onTap: () async {
								final confirmed = await showDialog<bool>(
									context: context,
									builder: (ctx) => AlertDialog(
										title: const Text('Reset All Data?'),
										content: const Text(
												'This will delete all your journals, goals, and reminders.'),
										actions: [
											TextButton(
												onPressed: () => Navigator.of(ctx).pop(false),
												child: const Text('Cancel'),
											),
											TextButton(
												onPressed: () => Navigator.of(ctx).pop(true),
												child: const Text('Reset',
														style: TextStyle(color: Colors.red)),
											),
										],
									),
								);
								if (confirmed == true) {
									await moodService.clearAll();
									if (!context.mounted) return;
									ScaffoldMessenger.of(context).showSnackBar(
										const SnackBar(content: Text('All data cleared')),
									);
								}
							},
							child: Container(
								width: double.infinity,
								padding: const EdgeInsets.symmetric(vertical: Insets.lg),
								decoration: BoxDecoration(
									color: const Color(0xFFFFF0F0),
									borderRadius: BorderRadius.circular(Radii.card),
								),
								child: const Row(
									mainAxisAlignment: MainAxisAlignment.center,
									children: [
										Icon(Icons.logout, color: Colors.red, size: 20),
										SizedBox(width: Insets.md),
										Text(
											'Log Out',
											style: TextStyle(
												color: Colors.red,
												fontSize: FontSizes.lg,
												fontWeight: FontWeights.semibold,
											),
										),
									],
								),
							),
						),
					),

					const SizedBox(height: Insets.xxl),
				],
			),
		);
	}

	Widget _buildItem({
		required Color iconBg,
		required IconData icon,
		required Color iconColor,
		required String title,
		required VoidCallback onTap,
	}) {
		return Column(
			children: [
				ListTile(
					contentPadding: const EdgeInsets.symmetric(
						horizontal: Insets.pageHorizontal,
						vertical: Insets.xs,
					),
					leading: Container(
						width: 40,
						height: 40,
						decoration: BoxDecoration(
							color: iconBg,
							borderRadius: BorderRadius.circular(Radii.sm),
						),
						child: Icon(icon, color: iconColor, size: 22),
					),
					title: Text(
						title,
						style: const TextStyle(
							fontSize: FontSizes.lg,
							fontWeight: FontWeights.medium,
						),
					),
					trailing: const Icon(Icons.chevron_right, color: Colors.grey),
					onTap: onTap,
				),
				const Divider(height: 1, indent: 72, endIndent: Insets.pageHorizontal),
			],
		);
	}

	Widget _buildToggleItem({
		required Color iconBg,
		required IconData icon,
		required Color iconColor,
		required String title,
		required bool value,
		required ValueChanged<bool> onChanged,
	}) {
		return Column(
			children: [
				ListTile(
					contentPadding: const EdgeInsets.symmetric(
						horizontal: Insets.pageHorizontal,
						vertical: Insets.xs,
					),
					leading: Container(
						width: 40,
						height: 40,
						decoration: BoxDecoration(
							color: iconBg,
							borderRadius: BorderRadius.circular(Radii.sm),
						),
						child: Icon(icon, color: iconColor, size: 22),
					),
					title: Text(
						title,
						style: const TextStyle(
							fontSize: FontSizes.lg,
							fontWeight: FontWeights.medium,
						),
					),
					trailing: Switch(
						value: value,
						onChanged: onChanged,
						activeThumbColor: Colors.white,
						activeTrackColor: const Color(0xFF5C6BC0),
					),
				),
				const Divider(height: 1, indent: 72, endIndent: Insets.pageHorizontal),
			],
		);
	}
}
