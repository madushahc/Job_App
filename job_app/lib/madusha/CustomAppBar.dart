import 'package:flutter/material.dart';
import 'package:job_app/madusha/CustomMenuBar.dart';
import 'package:job_app/madusha/CustomNotification.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: Colors.blue[50],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomMenubar(),
                  ),
                );
              },
              icon: const Icon(Icons.list),
              iconSize: 35.0,
            ),
            Container(
              width: 50.0,
              height: 50.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle, // Makes the image circular
                image: DecorationImage(
                  image: AssetImage('assets/profile.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black87,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomNotification(),
                  ),
                );
              },
              icon: const Icon(
                Icons.notifications,
                size: 35.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
