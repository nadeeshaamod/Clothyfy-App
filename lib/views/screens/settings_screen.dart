// views/screens/settings_screen.dart
// Basic settings screen

import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../widgets/reusable_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  bool marketing = false;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ClothyfyAppBar(showBack: true, title: 'SETTINGS'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SettingTile(
            title: 'Push Notifications',
            subtitle: 'Order updates and new drops',
            value: notifications,
            onChanged: (value) => setState(() => notifications = value),
          ),
          const SizedBox(height: 12),
          _SettingTile(
            title: 'Marketing Emails',
            subtitle: 'Exclusive offers and product news',
            value: marketing,
            onChanged: (value) => setState(() => marketing = value),
          ),
          const SizedBox(height: 12),
          _SettingTile(
            title: 'Dark Mode',
            subtitle: 'Preview theme toggle',
            value: darkMode,
            onChanged: (value) => setState(() => darkMode = value),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.dark,
                    )),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.grey)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
