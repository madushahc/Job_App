import 'package:flutter/material.dart';

class Reccomandjobs extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const Reccomandjobs({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isDarkMode ? Colors.black : Colors.blue[50]!;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;

    return SafeArea(
      child: Column(
        children: [
          Container(
            color: backgroundColor,
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "recommand Jobs",
                  style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // Add other widgets/content here as per your design
              ],
            ),
          ),
        ],
      ),
    );
  }
}
