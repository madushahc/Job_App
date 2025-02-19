import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:job_app/home_page.dart';
import 'package:job_app/madusha/settings.dart';

class CustomMenubar extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const CustomMenubar({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color iconColor = isDarkMode ? Colors.white70 : Colors.black45;
    final Color tileColor = isDarkMode ? Colors.black : Colors.white;
    final Color highlightColor =
        isDarkMode ? Colors.blue[300]! : Colors.blue[700]!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: tileColor,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Amicons.remix_close, size: 40.0, color: iconColor),
          ),
        ],
        toolbarHeight: 100.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 40.0),
              width: 40.0,
              height: 60.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Upsees.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              "  UPSEES",
              style: TextStyle(
                color: highlightColor,
                fontWeight: FontWeight.bold,
                fontSize: 27.0,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[200],
      body: Column(
        children: [
          // Profile Picture & Name
          Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/profile.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Andrew Russell",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage1()),
                  ),
                  child: Text(
                    "View Profile",
                    style: TextStyle(color: highlightColor),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          // Menu Items
          _buildMenuItem(
            context,
            icon: Icons.description_outlined,
            label: "Applications",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage1()),
            ),
            color: textColor,
          ),
          _buildMenuItem(
            context,
            icon: Icons.info_outline,
            label: "Personal Information",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage1()),
            ),
            color: textColor,
          ),
          _buildMenuItem(
            context,
            icon: Icons.settings,
            label: "Settings",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Settings(
                  isDarkMode: isDarkMode,
                  onThemeChanged: onThemeChanged,
                ),
              ),
            ),
            color: textColor,
          ),
          _buildMenuItem(
            context,
            icon: Icons.logout,
            label: "Logout",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage1()),
            ),
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  /// Helper method to build menu items
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, size: 30.0, color: color),
      title: Text(
        label,
        style: TextStyle(color: color, fontSize: 18.0),
      ),
      onTap: onTap,
    );
  }
}
