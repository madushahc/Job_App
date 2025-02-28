import 'package:flutter/material.dart';
import 'package:job_app/home_page.dart';
import 'package:job_app/madusha/customcard.dart';

class Reccomandjobs extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const Reccomandjobs({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;

    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recommanded Jobs",
                      style: TextStyle(
                          color: textColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage1(),
                        ),
                      ),
                      child: Text(
                        "see all",
                        style:
                            TextStyle(color: Colors.lightBlue, fontSize: 16.0),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 15.0,
                      children: [
                        CustomCard(),
                        CustomCard(),
                        CustomCard(),
                        CustomCard(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
