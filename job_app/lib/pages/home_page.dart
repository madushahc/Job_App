import 'package:flutter/material.dart';
import 'package:job_app/madusha/customappbar.dart';
import 'package:job_app/madusha/featured_jobs.dart';
import 'package:job_app/madusha/reccomandjobs.dart';
import 'package:job_app/madusha/searchbutton.dart';

class HomePage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> toggleTheme;

  const HomePage(
      {super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.blue[50],
      extendBody: true,
      appBar: CustomAppBar(
        isDarkMode: isDarkMode,
        onThemeChanged: () => toggleTheme(!isDarkMode),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            SearchButton(
                isDarkMode: isDarkMode,
                onThemeChanged: () => toggleTheme(!isDarkMode)),
            FeaturedJobs(
                isDarkMode: isDarkMode,
                onThemeChanged: () => toggleTheme(!isDarkMode)),
            Reccomandjobs(
                isDarkMode: isDarkMode,
                onThemeChanged: () => toggleTheme(!isDarkMode)),
          ],
        ),
      ),
    );
  }
}
