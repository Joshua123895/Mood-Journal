import 'package:flutter/material.dart';
import '../services/mood_service_instance.dart';
import '../theme/app_constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.navBar,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Insets.pageHorizontal),
        children: [
          const SizedBox(height: Insets.xl),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(Icons.person, size: 40, color: Colors.grey.shade600),
                ),
                const SizedBox(height: Insets.base),
                const Text(
                  'User',
                  style: TextStyle(
                    fontSize: FontSizes.title,
                    fontWeight: FontWeights.bold,
                  ),
                ),
                const Text(
                  'user@email.com',
                  style: TextStyle(
                    fontSize: FontSizes.md,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Insets.xxl * 1.5),
          _buildSettingItem(
            icon: Icons.palette,
            title: 'Theme',
            subtitle: 'Light mode',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage reminders',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'Version 1.0.0',
            onTap: () {},
          ),
          const Divider(height: Insets.xxl),
          _buildSettingItem(
            icon: Icons.delete_outline,
            title: 'Reset All Data',
            subtitle: 'Clear journals, goals, and reminders',
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Reset All Data?'),
                  content: const Text('This will delete all your journals, goals, and reminders.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Reset', style: TextStyle(color: Colors.red)),
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
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: Insets.base),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.darkButton),
        title: Text(title, style: const TextStyle(fontWeight: FontWeights.medium)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
