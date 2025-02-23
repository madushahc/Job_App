import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:job_app/pages/explore_page.dart';
import 'package:job_app/pages/home_page.dart';
import 'package:job_app/pages/profile_page.dart';
import 'package:job_app/pages/saved_page.dart';
import 'package:job_app/themes/app_themes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:job_app/madusha/settings.dart' as Settings;
import 'package:amicons/amicons.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    isDarkMode = brightness == Brightness.dark;
  }

  void toggleTheme(bool isDark) {
    setState(() {
      isDarkMode = isDark;
    });
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomePage(
        isDarkMode: isDarkMode,
        toggleTheme: toggleTheme,
      ),
      ExplorePage(
        isDarkMode: isDarkMode,
        onThemeChanged: () => toggleTheme(!isDarkMode),
      ),
      SavedPage(),
      ProfilePage(),
      Settings.Settings(
        isDarkMode: isDarkMode,
        onThemeChanged: () => toggleTheme(!isDarkMode),
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: AppTheme.dark.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      theme: AppTheme.light.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: HomeScreen(
        isDarkMode: isDarkMode,
        toggleTheme: toggleTheme,
        currentIndex: _currentIndex,
        onTabTapped: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        screens: screens,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> toggleTheme;
  final int currentIndex;
  final Function(int) onTabTapped;
  final List<Widget> screens;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
    required this.currentIndex,
    required this.onTabTapped,
    required this.screens,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.blue[50],
      extendBody: true,
      body: screens[currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        child: CurvedNavigationBar(
          height: 70.0,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          color: isDarkMode ? Colors.blue[400]! : Colors.blue[200]!,
          buttonBackgroundColor:
              isDarkMode ? Colors.lightBlue[900]! : Colors.blue[800]!,
          items: <Widget>[
            Icon(Amicons.iconly_home, size: 30),
            Icon(Amicons.flaticon_world_sharp, size: 30),
            Icon(Amicons.iconly_bookmark, size: 30),
            Icon(Amicons.iconly_profile, size: 30),
          ],
          onTap: onTabTapped,
        ),
      ),
    );
  }
}
