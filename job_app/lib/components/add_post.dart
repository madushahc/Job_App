import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPost extends StatefulWidget {
  const AddPost({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });
  final bool isDarkMode;
  final VoidCallback? onThemeChanged;

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool isDarkMode = false;
  String _userName = '';
  String? _profileImageUrl;
  bool _isLoading = true;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  } // Add this line to simulate the isDarkMode property

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

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
            _profileImageUrl = docSnapshot.data()?['profileImageUrl'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _userName = 'User';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _userName = 'User';
        _isLoading = false;
      });
    }
  }

  Future<void> _savePost() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('posts').add({
          'userId': user.uid,
          'userName': _userName,
          'userProfileImage': _profileImageUrl,
          'title': _titleController.text,
          'description': _descriptionController.text,
          'createdAt': Timestamp.now(),
          'likes': [],
          'dislikes': [],
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post saved successfully!')),
        );

        // Clear the form
        _titleController.clear();
        _descriptionController.clear();

        // Navigate back
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error saving post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save post. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Create Post",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 90,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: widget.isDarkMode ? Colors.white : Colors.blue,
                  ),
                  color: widget.isDarkMode ? Colors.white : Colors.blue,
                ),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.transparent),
                  ),
                  onPressed: _savePost,
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: widget.isDarkMode ? Colors.blue : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          centerTitle: true,
          toolbarHeight: 70.0,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      maxLength: 50,
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Add Your Title',
                        hintStyle: TextStyle(fontSize: 20),
                        fillColor: Colors.transparent,
                        border: UnderlineInputBorder(),
                        contentPadding: const EdgeInsets.all(16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        controller: _descriptionController,
                        maxLength: 500,
                        minLines: 5,
                        maxLines: 10,
                        style: TextStyle(
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Description',
                          hintStyle: TextStyle(fontSize: 20),
                          fillColor: Colors.transparent,
                          filled: true,
                          border: UnderlineInputBorder(),
                          contentPadding: const EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
