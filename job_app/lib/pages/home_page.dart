import 'package:flutter/material.dart';
import 'package:job_app/madusha/carousel.dart';
import 'package:job_app/madusha/companies.dart';
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
              Reccomandjobs(
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
