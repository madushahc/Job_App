import 'package:flutter/material.dart';
import 'package:job_app/pages/CustomAppBar.dart';
import 'package:job_app/pages/carousel.dart';
import 'package:job_app/pages/companies.dart';
import 'package:job_app/pages/featured_jobs.dart';
import 'package:job_app/pages/reccomandjobs.dart';
import 'package:job_app/pages/searchbutton.dart';

class HomePage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> toggleTheme;

  const HomePage(
      {super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.blue[50],
        extendBody: true,
        appBar: CustomAppBar(
          isDarkMode: isDarkMode,
          onThemeChanged: () => toggleTheme(!isDarkMode),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SearchButton(
                  isDarkMode: isDarkMode,
                  onThemeChanged: () => toggleTheme(!isDarkMode)),
              SizedBox(
                height: 10.0,
              ),
              ImageCarousel(),
              SizedBox(height: 10.0),
              FeaturedJobs(
                  isDarkMode: isDarkMode,
                  onThemeChanged: () => toggleTheme(!isDarkMode)),
              RecomendedJobs(
                  isDarkMode: isDarkMode,
                  onThemeChanged: () => toggleTheme(!isDarkMode)),
              SizedBox(height: 10.0),
              PopularCompanies(
                  isDarkMode: isDarkMode,
                  onThemeChanged: () => toggleTheme(!isDarkMode)),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
