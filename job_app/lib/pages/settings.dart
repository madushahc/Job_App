import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:job_app/pages/CustomNotification.dart';

/// The [AppTheme] defines light and dark themes for the app.
abstract final class AppTheme {
  static ThemeData light = FlexThemeData.light(scheme: FlexScheme.blue);
  static ThemeData dark = FlexThemeData.dark(scheme: FlexScheme.blue);
}

class Settings extends StatefulWidget {
  const Settings(
      {super.key, required this.isDarkMode, required this.onThemeChanged});

  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
        centerTitle: true,
        toolbarHeight: 80.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSettingsItem(
              icon: Icons.person_outline,
              title: "Account",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.notifications_outlined,
              title: "Notifications",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomNotification(
                        isDarkMode: widget.isDarkMode,
                        onThemeChanged: widget.onThemeChanged,
                      ),
                    ));
              },
            ),
            _buildSettingsItem(
              icon: Icons.lock_outline,
              title: "Privacy & Security",
              onTap: () {},
            ),
            _buildDarkModeSwitch(),
          ],
        ),
      ),
    );
  }

  // 🔹 Reusable Settings Tile
  Widget _buildSettingsItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Card(
      margin: EdgeInsets.only(top: 15.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 28, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontSize: 18.0)),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  // 🔹 Dark Mode Switch
  Widget _buildDarkModeSwitch() {
    return Card(
      margin: EdgeInsets.only(top: 15.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        title: const Text("Dark Mode", style: TextStyle(fontSize: 18.0)),
        secondary: const Icon(Icons.dark_mode_outlined,
            size: 28, color: Colors.blueAccent),
        value: widget.isDarkMode,
        onChanged: (bool value) {
          widget.onThemeChanged(); // Toggle theme
        },
      ),
    );
  }
}
