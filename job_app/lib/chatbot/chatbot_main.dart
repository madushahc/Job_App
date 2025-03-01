import 'package:flutter/material.dart';

class ChatbotMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello Chat Bot'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          'Hello Chat Bot!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
