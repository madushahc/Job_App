import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';

class SocialPost extends StatelessWidget {
  final List<String> _posts = [
    'Post 1',
    'Post 2',
    'Post 3',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color subtextColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[800]!;
    final Color cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
              right: 16.0, left: 16.0, top: 8.0, bottom: 8.0),
          child: Card(
            color: cardColor,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/profile.jpeg'),
                            radius: 24,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 10),
                            Text(
                              'Elon Musk',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: textColor),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '11 min ago',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: subtextColor),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Prioritizing User Feedback',
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Regularly gather and integrate user insights through testing and surveys to ensure the app meets real needs.',
                    style: TextStyle(fontSize: 14, color: subtextColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Amicons.lucide_thumbs_up),
                            onPressed: () {},
                          ),
                          Text(
                            '30',
                            style: TextStyle(
                                fontSize: 16,
                                color: textColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Amicons.lucide_thumbs_down),
                            onPressed: () {},
                          ),
                          Text(
                            '2',
                            style: TextStyle(
                                fontSize: 16,
                                color: textColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Amicons.flaticon_comment_alt_rounded),
                            onPressed: () {},
                          ),
                          Text(
                            '10',
                            style: TextStyle(
                                fontSize: 16,
                                color: textColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
