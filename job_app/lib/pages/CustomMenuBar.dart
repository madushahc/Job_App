import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:job_app/test.dart';
import 'package:job_app/pages/settings.dart';
import 'package:job_app/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Settings;

class CustomMenubar extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const CustomMenubar({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  _CustomMenubarState createState() => _CustomMenubarState();
}

class _CustomMenubarState extends State<CustomMenubar> {
  String? _userName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          setState(() {
            _userName = docSnapshot.data()?['name'] ?? 'User';
            _isLoading = false;
          });
        } else {
          setState(() {
            _userName = 'User';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _userName = 'Guest';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _userName = 'Error';
        _isLoading = false;
      });
      print('Error fetching user name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final Color iconColor = widget.isDarkMode ? Colors.white : Colors.black45;

    final Color tileColor = widget.isDarkMode ? Colors.black : Colors.white;

    final Color highlightColor =
        widget.isDarkMode ? Colors.blue[300]! : Colors.blue[700]!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: tileColor,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Amicons.remix_close, size: 40.0, color: iconColor),
          ),
        ],
        toolbarHeight: 100.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 40.0),
              width: 40.0,
              height: 60.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Upsees.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              "  UPSEES",
              style: TextStyle(
                color: highlightColor,
                fontWeight: FontWeight.bold,
                fontSize: 27.0,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/profile.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        _userName ?? "User",
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 23.0,
                        ),
                      ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage1()),
                  ),
                  child: Text(
                    "View Profile",
                    style: TextStyle(color: highlightColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          _buildMenuItem(
            context,
            icon: Icons.description_outlined,
            label: "Applications",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage1()),
            ),
            color: textColor,
          ),
          _buildMenuItem(
            context,
            icon: Icons.info_outline,
            label: "Personal Information",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage1()),
            ),
            color: textColor,
          ),
          _buildMenuItem(
            context,
            icon: Icons.settings,
            label: "Settings",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Settings(
                  isDarkMode: widget.isDarkMode,
                  onThemeChanged: widget.onThemeChanged,
                ),
              ),
            ),
            color: textColor,
          ),
          _buildMenuItem(
            context,
            icon: Icons.logout,
            label: "Logout",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            ),
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  /// Helper method to build menu items
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, size: 30.0, color: color),
      title: Text(
        label,
        style: TextStyle(color: color, fontSize: 18.0),
      ),
      onTap: onTap,
    );
  }
}
