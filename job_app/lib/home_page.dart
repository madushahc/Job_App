import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onThemeChanged});

  final VoidCallback? onThemeChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onThemeChanged,
        child: Icon(Icons.color_lens),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello World!'),
            ElevatedButton(
              onPressed: () {},
              child: Text('Go to Second Page'),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Go to Third Page'),
            ),
            OutlinedButton(
              onPressed: () {},
              child: Text('Go to Fourth Page'),
            ),
            Switch.adaptive(value: false, onChanged: (v) {}),
          ],
        ),
      ),
    );
  }
}
