import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amicons/amicons.dart';

class CustomNotification extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const CustomNotification({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

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

  String _getNotificationText(Map<String, dynamic> notification) {
    switch (notification['type']) {
      case 'like':
        return '${notification['fromUserName']} liked your post';
      case 'dislike':
        return '${notification['fromUserName']} disliked your post';
      case 'comment':
        return '${notification['fromUserName']} commented on your post';
      default:
        return 'New notification';
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .doc(notificationId)
          .update({'read': true});
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close),
              iconSize: 30.0,
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Notifications",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      body: user == null
          ? Center(
              child: Text(
                'Please sign in to see notifications',
                style: TextStyle(
                  fontSize: 18.0,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('notifications')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('Notification error: ${snapshot.error}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          'Unable to load notifications',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No Notifications.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic>? notification;
                    String? notificationId;
                    DateTime createdAt;
                    bool isRead = false;

                    try {
                      final doc = snapshot.data!.docs[index];
                      notification = doc.data() as Map<String, dynamic>;
                      notificationId = doc.id;

                      // Handle potential null or invalid timestamp
                      if (notification['createdAt'] is Timestamp) {
                        createdAt =
                            (notification['createdAt'] as Timestamp).toDate();
                      } else {
                        createdAt = DateTime.now();
                      }

                      isRead = notification['read'] ?? false;
                    } catch (e) {
                      print(
                          'Error processing notification at index $index: $e');
                      return SizedBox.shrink(); // Skip invalid notifications
                    }

                    if (notification == null || notificationId == null) {
                      return SizedBox.shrink();
                    }

                    return Dismissible(
                      key: Key(notificationId),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        try {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('notifications')
                              .doc(notificationId)
                              .delete();
                        } catch (e) {
                          print('Error deleting notification: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to delete notification')),
                          );
                        }
                      },
                      child: ListTile(
                        onTap: notificationId != null
                            ? () => _markAsRead(notificationId!)
                            : null,
                        leading: CircleAvatar(
                          backgroundColor: notification['type'] == 'like'
                              ? Colors.blue
                              : notification['type'] == 'dislike'
                                  ? Colors.red
                                  : Colors.green,
                          child: Icon(
                            notification['type'] == 'like'
                                ? Icons.thumb_up
                                : notification['type'] == 'dislike'
                                    ? Icons.thumb_down
                                    : Amicons.flaticon_comment_alt_rounded,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          _getNotificationText(notification),
                          style: TextStyle(
                            fontWeight:
                                isRead ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(_getTimeAgo(createdAt)),
                        trailing: !isRead
                            ? Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
