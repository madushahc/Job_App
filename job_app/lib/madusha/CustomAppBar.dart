import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:job_app/home_page.dart';
import 'package:job_app/madusha/custommenubar.dart';
import 'package:job_app/madusha/customnotification.dart';
import 'package:job_app/pages/home_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const CustomAppBar({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isDarkMode ? Colors.black : Colors.blue[50]!;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color iconColor = isDarkMode ? Colors.white : Colors.black;

    return AppBar(
      toolbarHeight: 80.0,
      backgroundColor: backgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomMenubar(
                    isDarkMode: isDarkMode,
                    onThemeChanged: onThemeChanged,
                  ),
                ),
              );
            },
            icon: Icon(Icons.menu_rounded, color: iconColor),
            iconSize: 35.0,
          ),
          Container(
            width: 50.0,
            height: 50.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/profile.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back !',
                style: TextStyle(
                  fontSize: 15.0,
                  color: textColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage1(),
                    ),
                  );
                },
                child: Text(
                  "Andrew Russell",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomNotification(
                    isDarkMode: isDarkMode,
                    onThemeChanged: onThemeChanged,
                  ),
                ),
              );
            },
            icon: Icon(Amicons.iconly_notification_3_sharp,
                size: 35.0, color: iconColor),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}
