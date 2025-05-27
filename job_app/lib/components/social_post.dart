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
      bool shouldNotify = false;
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
            shouldNotify = true;
          }
        }

        transaction.update(postRef, {
          'likes': likes,
          'dislikes': dislikes,
        });
      });

      if (shouldNotify) {
        // Only send notification when adding a like for the first time
        try {
          await _sendNotification(postId, 'like');
        } catch (e) {
          print('Error sending like notification: $e');
        }
      }
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
      bool shouldNotify = false;
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
            shouldNotify = true;
          }
        }

        transaction.update(postRef, {
          'likes': likes,
          'dislikes': dislikes,
        });
      });

      if (shouldNotify) {
        // Only send notification when adding a dislike for the first time
        try {
          await _sendNotification(postId, 'dislike');
        } catch (e) {
          print('Error sending dislike notification: $e');
        }
      }
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
                    // Get user's data from Firestore
                    final userDoc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .get();

                    String userName = 'Anonymous';
                    String? userProfileImage;

                    if (userDoc.exists) {
                      final userData = userDoc.data() as Map<String, dynamic>;
                      userName = userData['name'] ??
                          userData['fullName'] ??
                          user.displayName ??
                          'Anonymous';
                      userProfileImage = userData['profileImage'] as String?;
                    }

                    // Add comment with user data
                    await FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('comments')
                        .add({
                      'text': commentController.text.trim(),
                      'userId': user.uid,
                      'userName': userName,
                      'userProfileImage': userProfileImage,
                      'createdAt': Timestamp.now(),
                    });

                    // Send notification for the new comment
                    await _sendNotification(postId, 'comment');
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

  void _showCommentsView(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Comments',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Amicons.flaticon_comment_alt_rounded),
                        onPressed: () {
                          Navigator.pop(context);
                          _showCommentDialog(context, postId);
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(postId)
                          .collection('comments')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('Something went wrong'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No comments yet'));
                        }

                        return ListView.builder(
                          controller: scrollController,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final comment = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            final commentTime =
                                (comment['createdAt'] as Timestamp).toDate();
                            final currentUser =
                                FirebaseAuth.instance.currentUser;
                            final isCommentOwner =
                                currentUser?.uid == comment['userId'];

                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      comment['userProfileImage'] != null &&
                                              comment['userProfileImage']
                                                  .toString()
                                                  .isNotEmpty
                                          ? NetworkImage(
                                              comment['userProfileImage'])
                                          : AssetImage(
                                                  'assets/default_profile.png')
                                              as ImageProvider,
                                  radius: 20,
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      comment['userName'] ?? 'Anonymous',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      _getTimeAgo(commentTime),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(comment['text'] ?? ''),
                                ),
                                trailing: isCommentOwner
                                    ? IconButton(
                                        icon: Icon(Icons.delete_outline,
                                            color: Colors.red, size: 20),
                                        onPressed: () =>
                                            _showDeleteCommentDialog(postId,
                                                snapshot.data!.docs[index].id),
                                      )
                                    : null,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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

  Future<void> _deleteComment(String postId, String commentId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comment deleted successfully')),
      );
    } catch (e) {
      print('Error deleting comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete comment')),
      );
    }
  }

  void _showDeleteCommentDialog(String postId, String commentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Comment'),
        content: Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteComment(postId, commentId);
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

  Future<void> _sendNotification(String postId, String action) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('Cannot send notification: No user logged in');
        return;
      }

      // Get post data to find post owner
      final postDoc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .get();

      if (!postDoc.exists) {
        print('Cannot send notification: Post does not exist');
        return;
      }

      final postData = postDoc.data() as Map<String, dynamic>;
      final postOwnerId = postData['userId'];

      if (postOwnerId == null) {
        print('Cannot send notification: Post has no owner ID');
        return;
      }

      // Don't notify if user is interacting with their own post
      if (user.uid == postOwnerId) {
        print('Skipping notification: User interacting with own post');
        return;
      }

      // Get user's data for notification
      String userName = 'Someone';
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          userName = userData['name'] ??
              userData['fullName'] ??
              user.displayName ??
              'Someone';
        }
      } catch (e) {
        print('Error getting user data for notification: $e');
        // Continue with default userName
      }

      // Create notification
      await FirebaseFirestore.instance
          .collection('users')
          .doc(postOwnerId)
          .collection('notifications')
          .add({
        'type': action,
        'postId': postId,
        'fromUserId': user.uid,
        'fromUserName': userName,
        'createdAt': Timestamp.now(),
        'read': false,
        'postTitle':
            postData['title'] ?? 'A post', // Include post title if available
      });

      print(
          'Notification successfully sent: $action from $userName to user $postOwnerId');
    } catch (e) {
      print('Error sending notification: $e');
    }
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
                          Expanded(
                            child: Column(
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
                          ),
                          if (user != null && post['userId'] == user.uid)
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _showDeleteConfirmation(context, postId),
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
                                onPressed: () async {
                                  await _toggleLike(postId, isLiked);
                                },
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
                                onPressed: () async {
                                  await _toggleDislike(postId, isDisliked);
                                },
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
                              return GestureDetector(
                                onTap: () => _showCommentsView(context, postId),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Amicons.flaticon_comment_alt_rounded,
                                        color: textColor,
                                      ),
                                      onPressed: () =>
                                          _showCommentsView(context, postId),
                                    ),
                                    Text(
                                      commentCount.toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            },
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
