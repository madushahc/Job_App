import 'package:flutter/material.dart';
import 'package:job_app/madusha/customappbar.dart';
import 'package:job_app/madusha/featured_jobs.dart';
import 'package:job_app/madusha/reccomandjobs.dart';
import 'package:job_app/madusha/searchbutton.dart';
import 'package:job_app/themes/app_themes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Job App",
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: AppTheme.dark,
      theme: AppTheme.light,
      home: HomeScreen(isDarkMode: isDarkMode, toggleTheme: toggleTheme),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const HomeScreen(
      {super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isDarkMode: isDarkMode, onThemeChanged: toggleTheme),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10.0,
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            SearchButton(isDarkMode: isDarkMode, onThemeChanged: toggleTheme),
            FeaturedJobs(isDarkMode: isDarkMode, onThemeChanged: toggleTheme),
            Reccomandjobs(isDarkMode: isDarkMode, onThemeChanged: toggleTheme),
          ],
        ),
      ),
    );
  }
}
