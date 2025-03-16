import 'package:flutter/material.dart';
import 'home_page.dart';

void main() => runApp(const ChatbotMain());

class ChatbotMain extends StatelessWidget {
  const ChatbotMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UPSEES Assistant',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 38, 129, 240),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 38, 129, 240),
        ),
      ),
      home: const HomePage(),
    );
  }
}
