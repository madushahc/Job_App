import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key, this.onThemeChanged});

  final VoidCallback? onThemeChanged;

  @override
  State<ExplorePage> createState() => _HomePageState();
}

class _HomePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Explore',
            style: TextStyle(fontSize: 60, color: Colors.white),
          ),
        ),
      );
}
