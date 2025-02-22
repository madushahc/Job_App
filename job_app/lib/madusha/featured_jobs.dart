import 'package:flutter/material.dart';
import 'package:job_app/home_page.dart';
import 'package:job_app/madusha/customcard.dart';

class FeaturedJobs extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const FeaturedJobs({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Featured Jobs",
                style: TextStyle(
                    color: textColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage1(),
                  ),
                ),
                child: Text(
                  "see all",
                  style: TextStyle(color: Colors.lightBlue, fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0), // Reduced extra spacing
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
          child: Row(
            spacing: 15.0,
            children: [
              CustomCard(),
              CustomCard(),
              CustomCard(),
              CustomCard(),
            ],
          ),
        ),
      ],
    );
  }
}
