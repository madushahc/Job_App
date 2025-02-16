import 'package:flutter/material.dart';

class CustomNotification extends StatelessWidget {
  const CustomNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Notification",
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Text("This is Notification "),
      ),
    );
  }
}
