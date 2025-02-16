import 'package:flutter/material.dart';
import 'package:job_app/home_page.dart';
import 'package:job_app/madusha/customnotification.dart';

class CustomMenubar extends StatelessWidget {
  const CustomMenubar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Upsees.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                "  UPSEES",
                style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 27.0),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 15.0),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/profile.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Text(
            "Andrew Russell",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 23.0),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
            child: Text(
              "View Profile",
              style: TextStyle(
                color: Colors.blue[400],
              ),
            ),
          ),
          Container(
            width: 400,
            height: 100.0,
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 50.0,
                      bottom: 60.0,
                    ),
                  ),
                  Icon(
                    Icons.description_outlined,
                    size: 30.0,
                    color: Colors.grey,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    child: Text(
                      "    Applicantions",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 50.0,
                      bottom: 60.0,
                    ),
                  ),
                  Icon(
                    Icons.info_outline,
                    size: 30.0,
                    color: Colors.grey,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    child: Text(
                      "    Personal Information",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 50.0,
                      bottom: 60.0,
                    ),
                  ),
                  Icon(
                    Icons.settings,
                    size: 30.0,
                    color: Colors.grey,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    child: Text(
                      "    Sttings",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 50.0,
                      bottom: 60.0,
                    ),
                  ),
                  Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 30.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    child: Text(
                      "    Logout",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
