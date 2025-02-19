import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.onThemeChanged});

  final VoidCallback? onThemeChanged;

  @override
  State<ProfilePage> createState() => _HomePageState();
}

class _HomePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.purple,
        body: Center(
          child: Text(
            'Profile',
            style: TextStyle(fontSize: 60, color: Colors.white),
          ),
        ),
      );
}
