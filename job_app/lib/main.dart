import 'package:flutter/material.dart';
import 'package:job_app/madusha/customappbar.dart';

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
      title: 'Flutter Demo',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: AppTheme.dark,
      theme: AppTheme.light,
      home: CustomAppBar(),
    );
  }
}
