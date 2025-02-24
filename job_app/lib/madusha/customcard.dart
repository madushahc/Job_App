import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({super.key});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    // Determine the current theme (light or dark)
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color subtitleColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[700]!;
    final Color cardColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    final Color iconColor = isDarkMode ? Colors.white : Colors.blueAccent;
    final Color tagBackground =
        isDarkMode ? Colors.blueGrey[800]! : Colors.blue[50]!;
    final Color tagTextColor =
        isDarkMode ? Colors.blueAccent : Colors.blueAccent;
    final Color locationColor = isDarkMode ? Colors.white70 : Colors.black87;

    return Center(
      child: Container(
        height: 220.0,
        width: 380.0,
        child: Card(
          color: cardColor,
          elevation: 4.0,
          margin: EdgeInsets.only(right: 16.0, top: 12.0, bottom: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 6.0,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile Image
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/profile.jpeg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    // Job Title & Company
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Software Engineer",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Microsoft",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: subtitleColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Save Icon
                    Icon(
                      Amicons.vuesax_save_2,
                      size: 30.0,
                      color: iconColor,
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                // Job Tags
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTag("IT", tagBackground, tagTextColor),
                    _buildTag("Full Time", tagBackground, tagTextColor),
                    _buildTag("Junior", tagBackground, tagTextColor),
                  ],
                ),
                SizedBox(height: 10.0),
                // Salary & Location
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "\$",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          "1000 ",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 20.0),
                        SizedBox(width: 5.0),
                        Text(
                          "California, USA",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: locationColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Badge Widget for Job Type Tags
  Widget _buildTag(String text, Color background, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.blueAccent, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
        ),
      ),
    );
  }
}
