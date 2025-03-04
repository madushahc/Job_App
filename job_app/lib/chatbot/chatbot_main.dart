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
          seedColor: const Color.fromARGB(255, 41, 182, 246),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 39, 237, 255),
        ),
      ),
      home: const HomePage(),
    );
  }
}
