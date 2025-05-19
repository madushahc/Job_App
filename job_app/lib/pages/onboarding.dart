import 'package:flutter/material.dart';
import 'package:job_app/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingContent> contents = [
    OnboardingContent(
      title: "welcome to UPSEES",
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
          Row(
            children: [
              //Skip button
              TextButton(
                onPressed: () {},
                child: const Text("Skip"),
              ),

              //Indicator

              //Next button
              TextButton(
                onPressed: () {},
                child: const Text("Next"),
              ),
            ],
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
