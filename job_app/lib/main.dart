import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:job_app/pages/onboarding.dart';
import 'firebase_options.dart';
import 'package:flutter/scheduler.dart';
import 'package:job_app/components/add_post.dart';
import 'package:job_app/pages/explore_page.dart';
import 'package:job_app/pages/home_page.dart';
import 'package:job_app/pages/profile.dart';
import 'package:job_app/pages/saved_page.dart';
import 'package:job_app/themes/app_themes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:job_app/chatbot/chatbot_main.dart';
import 'package:amicons/amicons.dart';
import 'package:job_app/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyAppLoginWrapper());
}

class MyAppLoginWrapper extends StatelessWidget {
  const MyAppLoginWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: GoogleFonts.poppinsTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme),
      ),
      themeMode: ThemeMode.system,
      home: AuthWrapper(),
    );
  }
}

// New widget to handle authentication state
class AuthWrapper extends StatefulWidget {
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  Future<bool> checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboardingComplete') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If user is logged in, show main app directly
        if (authSnapshot.hasData) {
          return const MyApp();
        }

        // If user is not logged in, check if they need to see onboarding
        return FutureBuilder<bool>(
          future: checkOnboarding(),
          builder: (context, onboardingSnapshot) {
            if (onboardingSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Show onboarding if it hasn't been completed and user is not logged in
            if (!onboardingSnapshot.data!) {
              return OnboardingScreen();
            }

            // If onboarding is complete but user is not logged in, show login screen
            return const LoginScreen();
          },
        );
      },
    );
  }
}

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
      SavedPage(
        isDarkMode: isDarkMode,
        onThemeChanged: () => toggleTheme(!isDarkMode),
      ),
      ProfileScreen(showBackButton: false, isDarkMode: isDarkMode),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UPSEES',
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

// Rest of the HomeScreen code remains the same
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

  Icon getIcon(int index) {
    List<IconData> icons = [
      Amicons.iconly_home,
      Amicons.flaticon_world_sharp,
      Amicons.iconly_bookmark,
      Amicons.iconly_profile,
    ];

    List<IconData> selectedIcons = [
      Amicons.iconly_home_fill,
      Amicons.flaticon_world_sharp_fill,
      Amicons.iconly_bookmark_fill,
      Amicons.iconly_profile_fill,
    ];

    Color selectedColor = isDarkMode ? Colors.black : Colors.white;
    Color unselectedColor = isDarkMode ? Colors.white : Colors.black;

    return Icon(
      currentIndex == index ? selectedIcons[index] : icons[index],
      size: 30,
      color: currentIndex == index ? selectedColor : unselectedColor,
    );
  }

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
          color: isDarkMode ? Colors.blue[900]! : Colors.blue[200]!,
          buttonBackgroundColor:
              isDarkMode ? Colors.lightBlue[400]! : Colors.blue[900]!,
          items: <Widget>[
            getIcon(0),
            getIcon(1),
            getIcon(2),
            getIcon(3),
          ],
          onTap: onTabTapped,
        ),
      ),
      floatingActionButton: currentIndex == 0 || currentIndex == 1
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (currentIndex == 0)
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatbotMain(),
                        ),
                      );
                    },
                    backgroundColor: isDarkMode
                        ? const Color.fromARGB(255, 252, 252, 252)
                        : const Color.fromARGB(255, 255, 255, 255),
                    child: Image.asset(
                      'assets/Upsees.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                if (currentIndex == 1)
                  FloatingActionButton(
                    onPressed: () {
                      print("UPSEES BOT is Working ");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPost(
                            isDarkMode: isDarkMode,
                            onThemeChanged: () => toggleTheme(!isDarkMode),
                          ),
                        ),
                      );
                    },
                    backgroundColor:
                        isDarkMode ? Colors.blue[900] : Colors.blue[200],
                    child: Icon(
                      Amicons.remix_add,
                      size: 30,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
              ],
            )
          : null,
    );
  }
}
