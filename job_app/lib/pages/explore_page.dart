import 'package:flutter/material.dart';
import 'package:job_app/components/social_post.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  final bool isDarkMode;
  final VoidCallback? onThemeChanged;

  @override
  State<ExplorePage> createState() => _HomePageState();
}

class _HomePageState extends State<ExplorePage> {
  bool isDarkMode = false;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.blue[50],
      appBar: AppBar(
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.blue[50],
        title: const Text("Explore",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
        centerTitle: true,
        toolbarHeight: 70.0,
      ),
      body: SocialPost(),
    );
  }
}
