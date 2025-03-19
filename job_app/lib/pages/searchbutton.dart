import 'package:flutter/material.dart';
import 'package:job_app/lakshika/search_Screen.dart';

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
    final buttonColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final borderColor = isDarkMode ? Colors.white : Colors.black;
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final textColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0, right: 10.0, left: 10.0),
      child: SizedBox(
        width: 370,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
              side: BorderSide(color: borderColor, width: 2),
            ),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(
                isDarkMode: isDarkMode,
                onThemeChanged: onThemeChanged,
              ),
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              Icon(
                Icons.search,
                color: iconColor,
                size: 30.0,
              ),
              const SizedBox(width: 10),
              Text(
                "  Search here...",
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
