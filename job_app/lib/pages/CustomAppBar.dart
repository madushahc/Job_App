import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:job_app/test.dart';
import 'package:job_app/pages/CustomMenuBar.dart';
import 'package:job_app/pages/CustomNotification.dart';
import 'package:job_app/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;
  final String userName;
  final String? userProfileImage;

  const CustomAppBar({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.userName,
    this.userProfileImage,
  });

  Widget _buildNotificationIcon(Color iconColor) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return IconButton(
        onPressed: null,
        icon: Icon(Amicons.iconly_notification_3_sharp,
            size: 35.0, color: iconColor),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .where('read', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        int unreadCount = 0;
        if (snapshot.hasData) {
          unreadCount = snapshot.data!.docs.length;
        }

        return Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomNotification(
                      isDarkMode: isDarkMode,
                      onThemeChanged: onThemeChanged,
                    ),
                  ),
                );
              },
              icon: Icon(Amicons.iconly_notification_3_sharp,
                  size: 35.0, color: iconColor),
            ),
            if (unreadCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    unreadCount > 99 ? '99+' : unreadCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isDarkMode ? Colors.black : Colors.blue[50]!;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color iconColor = isDarkMode ? Colors.white : Colors.black;

    return AppBar(
      toolbarHeight: 80.0,
      backgroundColor: backgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      CustomMenubar(
                    isDarkMode: isDarkMode,
                    onThemeChanged: onThemeChanged,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(-1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            icon: Icon(Icons.menu_rounded, color: iconColor),
            iconSize: 35.0,
          ),
          CircleAvatar(
            backgroundImage: userProfileImage != null
                ? NetworkImage(userProfileImage!)
                : AssetImage('assets/default_profile.png') as ImageProvider,
            radius: 25.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back !',
                style: TextStyle(
                  fontSize: 15.0,
                  color: textColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
                  );
                },
                child: Text(
                  userName,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          _buildNotificationIcon(iconColor),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}
