import 'dart:async';

import 'package:flutter/material.dart';
import 'package:job_app/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  bool isLastPage = false;

  List<OnboardingContent> contents = [
    OnboardingContent(
      title: "Welcome to UPSEES",
      image: "assets/onboard3.png",
      description: "Find your Dream job here",
    ),
    OnboardingContent(
      title: "Explore Opportunities",
      image: "assets/onboard2.png",
      description: "Discover internships, Jobs and Career paths",
    ),
    OnboardingContent(
      title: "Connect, Learn and Grow",
      image: "assets/onboard1.png",
      description: "Your Network, Your Knowlege, Your Next Step",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: contents.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                  isLastPage = contents.length - 1 == page;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        contents[index].image,
                        height: 300,
                      ),
                      SizedBox(height: 20),
                      Text(
                        contents[index].title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        contents[index].description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: isLastPage
                ? getStarted(context)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Skip button
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blueGrey,
                        ),
                        onPressed: () =>
                            _pageController.jumpToPage(contents.length - 1),
                        child: const Text("Skip"),
                      ),

                      //Indicator
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: contents.length,
                        onDotClicked: (index) => _pageController.animateToPage(
                            index,
                            duration: Duration(microseconds: 600),
                            curve: Curves.easeIn),
                        effect: WormEffect(
                            dotHeight: 12,
                            dotWidth: 12,
                            activeDotColor: Colors.blue),
                      ),

                      //Next button
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        onPressed: () => _pageController.nextPage(
                            duration: const Duration(microseconds: 600),
                            curve: Curves.easeIn),
                        child: const Text("Next"),
                      ),
                    ],
                  ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Container buildDot(int index) {
    return Container(
      height: 10,
      width: 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _currentPage == index ? Colors.blue : Colors.grey,
      ),
    );
  }
}

class OnboardingContent {
  String title;
  String image;
  String description;

  OnboardingContent({
    required this.title,
    required this.image,
    required this.description,
  });
}

Widget getStarted(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * .9,
    height: 55,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () async {
        // Save that onboarding is complete
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('onboardingComplete', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
      child: Text(
        "Get Started",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
