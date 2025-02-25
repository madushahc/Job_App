import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';

class SocialPost extends StatefulWidget {
  @override
  _SocialPostState createState() => _SocialPostState();
}

class _SocialPostState extends State<SocialPost> {
  final List<String> _posts = [
    'Post 1',
    'Post 2',
    'Post 3',
    'Post 4',
  ];

  // State lists for likes, dislikes, and comments
  late List<bool> _likedPosts;
  late List<bool> _dislikedPosts;
  late List<int> _likeCounts;
  late List<int> _dislikeCounts;
  late List<int> _commentCounts;

  @override
  void initState() {
    super.initState();
    // Initialize state for each post
    _likedPosts = List.filled(_posts.length, false);
    _dislikedPosts = List.filled(_posts.length, false);
    _likeCounts = List.filled(_posts.length, 0);
    _dislikeCounts = List.filled(_posts.length, 0);
    _commentCounts = List.filled(_posts.length, 0);
  }

  void _toggleLike(int index) {
    setState(() {
      if (_likedPosts[index]) {
        _likedPosts[index] = false;
        _likeCounts[index]--;
      } else {
        _likedPosts[index] = true;
        _likeCounts[index]++;
        if (_dislikedPosts[index]) {
          _dislikedPosts[index] = false;
          _dislikeCounts[index]--;
        }
      }
    });
  }

  void _toggleDislike(int index) {
    setState(() {
      if (_dislikedPosts[index]) {
        _dislikedPosts[index] = false;
        _dislikeCounts[index]--;
      } else {
        _dislikedPosts[index] = true;
        _dislikeCounts[index]++;
        if (_likedPosts[index]) {
          _likedPosts[index] = false;
          _likeCounts[index]--;
        }
      }
    });
  }

  void _addComment(int index) {
    setState(() {
      _commentCounts[index]++;
    });
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Card(
            color: cardColor,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // User Info
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/profile.jpeg'),
                        radius: 24,
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Elon Musk',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: textColor),
                          ),
                          Text(
                            '11 min ago',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: subtextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Post Title & Content
                  Text(
                    'Prioritizing User Feedback',
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Regularly gather and integrate user insights through testing and surveys to ensure the app meets real needs.', // Dynamic content
                    style: TextStyle(fontSize: 14, color: subtextColor),
                  ),

                  // Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(color: Colors.grey, thickness: 1),
                  ),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Like Button
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _likedPosts[index]
                                  ? Amicons.remix_thumb_up_fill
                                  : Amicons.remix_thumb_up,
                              color: _likedPosts[index] ? Colors.blue : null,
                            ),
                            onPressed: () => _toggleLike(index),
                          ),
                          Text(
                            '${_likeCounts[index]}',
                            style: TextStyle(
                                fontSize: 16,
                                color: textColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      // Dislike Button
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Amicons.lucide_thumbs_down,
                              color: _dislikedPosts[index] ? Colors.red : null,
                            ),
                            onPressed: () => _toggleDislike(index),
                          ),
                          Text(
                            '${_dislikeCounts[index]}',
                            style: TextStyle(
                                fontSize: 16,
                                color: textColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      // Comment Button
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Amicons.flaticon_comment_alt_rounded),
                            onPressed: () => _addComment(index),
                          ),
                          Text(
                            '${_commentCounts[index]}',
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
