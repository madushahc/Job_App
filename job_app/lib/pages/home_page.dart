import 'package:flutter/material.dart';
import 'package:job_app/pages/CustomAppBar.dart';
import 'package:job_app/pages/carousel.dart';
import 'package:job_app/pages/companies.dart';
import 'package:job_app/pages/featured_jobs.dart';
import 'package:job_app/pages/reccomandjobs.dart';
import 'package:job_app/pages/searchbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> toggleTheme;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = "Loading...";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          setState(() {
            _userName = docSnapshot.data()?['name'] ?? 'User';
            _isLoading = false;
          });
        } else {
          setState(() {
            _userName = 'User';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _userName = 'Guest';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _userName = 'Error';
        _isLoading = false;
      });
      print('Error fetching user name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.blue[50],
        extendBody: true,
        appBar: _isLoading
            ? AppBar(
                title: Text("Loading..."),
                backgroundColor:
                    widget.isDarkMode ? Colors.black : Colors.blue[50],
              )
            : CustomAppBar(
                isDarkMode: widget.isDarkMode,
                onThemeChanged: () => widget.toggleTheme(!widget.isDarkMode),
                userName: _userName,
              ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SearchButton(
                  isDarkMode: widget.isDarkMode,
                  onThemeChanged: () => widget.toggleTheme(!widget.isDarkMode)),
              SizedBox(
                height: 10.0,
              ),
              ImageCarousel(),
              SizedBox(height: 10.0),
              FeaturedJobs(
                  isDarkMode: widget.isDarkMode,
                  onThemeChanged: () => widget.toggleTheme(!widget.isDarkMode)),
              RecomendedJobs(
                  isDarkMode: widget.isDarkMode,
                  onThemeChanged: () => widget.toggleTheme(!widget.isDarkMode)),
              SizedBox(height: 10.0),
              PopularCompanies(
                  isDarkMode: widget.isDarkMode,
                  onThemeChanged: () => widget.toggleTheme(!widget.isDarkMode)),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
