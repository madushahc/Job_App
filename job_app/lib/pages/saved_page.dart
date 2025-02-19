import 'package:flutter/material.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key, this.onThemeChanged});

  final VoidCallback? onThemeChanged;

  @override
  State<SavedPage> createState() => _HomePageState();
}

class _HomePageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.green,
        body: Center(
          child: Text(
            'Saved',
            style: TextStyle(fontSize: 60, color: Colors.white),
          ),
        ),
      );
}
