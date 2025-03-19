import 'package:flutter/material.dart';

class CustomNotification extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const CustomNotification({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context); // Closes the current page
              },
              icon: Icon(Icons.close),
              iconSize: 30.0,
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Notification",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'This is the notifications page.',
          style: TextStyle(
            fontSize: 18.0,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
