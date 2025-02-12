import 'package:flutter/material.dart';

class CustomNotification extends StatelessWidget {
  const CustomNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.close,
              size: 35.0,
            ),
            Text(
              "Notification",
            ),
          ],
        ),
      ),
      body: Center(
        child: Text("This is Notification "),
      ),
    );
  }
}
