import 'package:flutter/material.dart';
import 'package:job_app/lakshika/customsearchbar.dart';

class SearchButton extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const SearchButton({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final buttonColor = isDarkMode ? Colors.black : Colors.white;
    final borderColor = isDarkMode ? Colors.white : Colors.black;
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final textColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0, right: 10.0, left: 10.0),
      child: SizedBox(
        width: 370, // Button width
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor, // Background adapts to theme
            padding: const EdgeInsets.symmetric(vertical: 14), // Padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0), // Rounded corners
              side: BorderSide(
                  color: borderColor, width: 2), // Border color adapts
            ),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomSearchBar(),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center content
            mainAxisSize: MainAxisSize.min, // Prevents unnecessary stretching
            children: [
              Icon(
                Icons.search,
                color: iconColor, // Icon color adapts to theme
                size: 30.0,
              ),
              const SizedBox(width: 10), // Space between icon and text
              Text(
                "Search here...",
                style: TextStyle(
                  color: textColor, // Text color adapts to theme
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
