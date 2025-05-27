import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/pages/Register_page.dart';
import 'package:job_app/pages/OTP_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
        textTheme: GoogleFonts.poppinsTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: GoogleFonts.poppinsTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade800,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: ForgotPasswordScreen(),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: 28),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 20),
            Image.asset(
              "assets/Forgot password img.png",
              width: 300,
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Forgot your Password ?",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Enter your Email address",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Enter email",
                hintStyle: TextStyle(color: Colors.grey.shade400),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OTPVerificationPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                "Send Code",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Haven’t an account?",
                    style: GoogleFonts.poppins(fontSize: 14)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Register",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
