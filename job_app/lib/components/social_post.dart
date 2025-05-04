import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SocialPost extends StatefulWidget {
  @override
  _SocialPostState createState() => _SocialPostState();
}

class _SocialPostState extends State<SocialPost> {
  final Stream<QuerySnapshot> _postsStream = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('createdAt', descending: true)
      .snapshots();
  Future<void> _toggleLike(String postId, bool currentLikeStatus) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please sign in to like posts')),
      );
      return;
    }

    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final postDoc = await transaction.get(postRef);
        if (!postDoc.exists) return;

        List<String> likes = List<String>.from(postDoc.data()?['likes'] ?? []);
        List<String> dislikes =
            List<String>.from(postDoc.data()?['dislikes'] ?? []);

        if (currentLikeStatus) {
          // Unlike
          likes.remove(user.uid);
        } else {
          // Like
          if (!likes.contains(user.uid)) {
            likes.add(user.uid);
            // Remove from dislikes if present
            dislikes.remove(user.uid);
          }
        }

        transaction.update(postRef, {
          'likes': likes,
          'dislikes': dislikes,
        });
      });
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  Future<void> _toggleDislike(String postId, bool currentDislikeStatus) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please sign in to dislike posts')),
      );
      return;
    }

    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final postDoc = await transaction.get(postRef);
        if (!postDoc.exists) return;

        List<String> likes = List<String>.from(postDoc.data()?['likes'] ?? []);
        List<String> dislikes =
            List<String>.from(postDoc.data()?['dislikes'] ?? []);

        if (currentDislikeStatus) {
          // Remove dislike
          dislikes.remove(user.uid);
        } else {
          // Add dislike
          if (!dislikes.contains(user.uid)) {
            dislikes.add(user.uid);
            // Remove from likes if present
            likes.remove(user.uid);
          }
        }

        transaction.update(postRef, {
          'likes': likes,
          'dislikes': dislikes,
        });
      });
    } catch (e) {
      print('Error toggling dislike: $e');
    }
  }

  void _showCommentDialog(BuildContext context, String postId) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please sign in to comment')),
      );
      return;
    }

    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Comment'),
        content: TextField(
          controller: commentController,
          decoration: InputDecoration(
            hintText: 'Write your comment...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (commentController.text.trim().isNotEmpty) {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('comments')
                        .add({
                      'text': commentController.text.trim(),
                      'userId': user.uid,
                      'userName': user.displayName ?? 'Anonymous',
                      'createdAt': Timestamp.now(),
                    });
                    Navigator.pop(context);
                  } catch (e) {
                    print('Error adding comment: $e');
                  }
                }
              }
            },
            child: Text('Post'),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Future<void> _deletePost(String postId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Delete the post document
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post deleted successfully')),
      );
    } catch (e) {
      print('Error deleting post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post. Please try again.')),
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Post'),
        content: Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePost(postId);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color subtextColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[800]!;
    final Color cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: _postsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data!.docs;

        if (posts.isEmpty) {
          return Center(child: Text('No posts yet'));
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index].data() as Map<String, dynamic>;
            final postId = posts[index].id;
            final createdAt = (post['createdAt'] as Timestamp).toDate();

            List<String> likes = List<String>.from(post['likes'] ?? []);
            List<String> dislikes = List<String>.from(post['dislikes'] ?? []);

            bool isLiked = user != null && likes.contains(user.uid);
            bool isDisliked = user != null && dislikes.contains(user.uid);

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                            backgroundImage: post['userProfileImage'] != null
                                ? NetworkImage(post['userProfileImage'])
                                : AssetImage('assets/default_profile.png')
                                    as ImageProvider,
                            radius: 24,
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post['userName'] ?? 'Anonymous',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: textColor),
                              ),
                              Text(
                                _getTimeAgo(createdAt),
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
                        post['title'] ?? '',
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        post['description'] ?? '',
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
                                  Amicons.remix_thumb_up,
                                  color: isLiked ? Colors.blue : textColor,
                                ),
                                onPressed: () => _toggleLike(postId, isLiked),
                              ),
                              Text(
                                likes.length.toString(),
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
                                  color: isDisliked ? Colors.red : textColor,
                                ),
                                onPressed: () =>
                                    _toggleDislike(postId, isDisliked),
                              ),
                              Text(
                                dislikes.length.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: textColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),

                          // Comment Button
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(postId)
                                .collection('comments')
                                .snapshots(),
                            builder: (context, snapshot) {
                              int commentCount = snapshot.hasData
                                  ? snapshot.data!.docs.length
                                  : 0;
                              return Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Amicons.flaticon_comment_alt_rounded,
                                      color: textColor,
                                    ),
                                    onPressed: () =>
                                        _showCommentDialog(context, postId),
                                  ),
                                  Text(
                                    commentCount.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: textColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              );
                            },
                          ),

                          // Delete Button (Visible only to post owner)
                          if (user != null && post['userId'] == user.uid)
                            IconButton(
                              icon: Icon(
                                Amicons.iconly_delete_fill,
                                color: Colors.red,
                              ),
                              onPressed: () =>
                                  _showDeleteConfirmation(context, postId),
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
      },
    );
  }
}
