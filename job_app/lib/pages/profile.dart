import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:job_app/config/cloudinary_config.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final bool showBackButton;
  final bool isDarkMode;

  const ProfileScreen({
    super.key,
    this.showBackButton = true,
    required this.isDarkMode,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _workExperienceController =
      TextEditingController();
  final TextEditingController _skillInputController = TextEditingController();
  final TextEditingController _languageInputController =
      TextEditingController();
  List<String> _skills = [];
  List<String> _languages = [];
  String? _profileImagePath;
  String? _profileImageUrl;
  bool _isLoading = true;
  bool _isUploading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        _emailController.text = user.email ?? '';

        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          final userData = docSnapshot.data();

          setState(() {
            _nameController.text = userData?['name'] ?? '';
            _emailController.text = userData?['email'] ?? user.email ?? '';
            _phoneController.text = userData?['phoneNumber'] ?? '';
            _aboutMeController.text = userData?['aboutMe'] ?? '';
            _workExperienceController.text = userData?['workExperience'] ?? '';

            if (userData?['skills'] != null && userData?['skills'] is List) {
              _skills = List<String>.from(userData?['skills']);
            }

            if (userData?['languages'] != null &&
                userData?['languages'] is List) {
              _languages = List<String>.from(userData?['languages']);
            }

            _profileImageUrl = userData?['profileImageUrl'];
          });

          print("User data fetched successfully");
        } else {
          print("User document doesn't exist in Firestore");
        }
      } else {
        setState(() {
          _errorMessage = "No user is logged in";
        });
        print("No user is logged in");
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching data: $e";
      });
      print("Error fetching user data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        if (_profileImagePath != null) {
          await _uploadProfileImage(user.uid);
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phoneNumber': _phoneController.text.trim(),
          'aboutMe': _aboutMeController.text.trim(),
          'workExperience': _workExperienceController.text.trim(),
          'skills': _skills,
          'languages': _languages,
          'updatedAt': Timestamp.now(),
          if (_profileImageUrl != null) 'profileImageUrl': _profileImageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        print("User data updated successfully");
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error saving data: $e";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
      print("Error saving user data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _uploadProfileImage(String userId) async {
    if (_profileImagePath == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Create Cloudinary instance
      final cloudinary = CloudinaryPublic(
        CloudinaryConfig.cloudName,
        CloudinaryConfig.uploadPreset,
        cache: false,
      );

      // Upload to Cloudinary
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          _profileImagePath!,
          resourceType: CloudinaryResourceType.Image,
          folder: 'profile_images',
          tags: ['profile', userId],
        ),
      );

      // Get the secure URL from the response
      setState(() {
        _profileImageUrl = response.secureUrl;
        _isUploading = false;
      });
      print('Profile image uploaded successfully: $_profileImageUrl');
    } catch (e) {
      setState(() {
        _isUploading = false;
        _errorMessage = "Error uploading image: $e";
      });
      print('Error uploading profile image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload profile image: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImagePath = pickedFile.path;
      });
    }
  }

  void _addSkill(String skill) {
    setState(() {
      _skills.add(skill);
    });
    _skillInputController.clear();
  }

  void _addLanguage(String language) {
    setState(() {
      _languages.add(language);
    });
    _languageInputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.grey[900] : Colors.blue[50],
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: widget.isDarkMode ? Colors.white : Colors.blue,
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Text(
                  "Error: $_errorMessage",
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black87,
                  ),
                ))
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.showBackButton)
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, size: 28),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Complete Your Profile",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                          ],
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Complete Your Profile",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                      SizedBox(height: 20),
                      _buildProfileSection(
                        "Profile Info",
                        Icons.edit,
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: _getProfileImage(),
                                  child: _isUploading
                                      ? CircularProgressIndicator()
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _pickImage,
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.blue[300],
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                children: [
                                  _buildTextField("Name", _nameController),
                                  SizedBox(height: 10),
                                  _buildTextField("Email", _emailController),
                                  SizedBox(height: 10),
                                  _buildTextField(
                                      "Phone Number", _phoneController),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildProfileSection("About me", Icons.edit,
                          child: _buildAboutMeSection()),
                      _buildProfileSection("Work Experience", Icons.add,
                          child: _buildExperienceSection()),
                      _buildProfileSection("Skills", Icons.edit,
                          child: _buildSkillChips()),
                      _buildProfileSection("Languages", Icons.edit,
                          child: _buildLanguageChips()),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _saveUserData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.isDarkMode
                                ? Colors.blue[700]
                                : Colors.blue[300],
                            foregroundColor: widget.isDarkMode
                                ? Colors.white
                                : Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text(
                            "Save Profile",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50)
                    ],
                  ),
                ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (_profileImagePath != null) {
      return FileImage(File(_profileImagePath!));
    } else if (_profileImageUrl != null) {
      return NetworkImage(_profileImageUrl!);
    } else {
      return AssetImage("assets/default_profile.png");
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        color: widget.isDarkMode ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: widget.isDarkMode ? Colors.grey[700] : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: widget.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(String title, IconData icon, {Widget? child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: widget.isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
                Icon(icon, color: Colors.grey),
              ],
            ),
            if (child != null) child,
          ],
        ),
      ),
    );
  }

  Widget _buildAboutMeSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: _aboutMeController,
        maxLines: 3,
        style: TextStyle(
          color: widget.isDarkMode ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: "About me",
          labelStyle: TextStyle(
            color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: widget.isDarkMode ? Colors.grey[700] : Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: widget.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: _workExperienceController,
        maxLines: 3,
        style: TextStyle(
          color: widget.isDarkMode ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: "Work Experience",
          labelStyle: TextStyle(
            color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: widget.isDarkMode ? Colors.grey[700] : Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: widget.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillChips() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: _skills.map((skill) {
              return Chip(
                label: Text(
                  skill,
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                backgroundColor:
                    widget.isDarkMode ? Colors.blue[800] : Colors.blue[200],
                onDeleted: () {
                  setState(() {
                    _skills.remove(skill);
                  });
                },
              );
            }).toList(),
          ),
          TextField(
            controller: _skillInputController,
            decoration: InputDecoration(
              labelText: "Add a skill",
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                _addSkill(value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageChips() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: _languages.map((language) {
              return Chip(
                label: Text(
                  language,
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                backgroundColor:
                    widget.isDarkMode ? Colors.blue[800] : Colors.blue[200],
                onDeleted: () {
                  setState(() {
                    _languages.remove(language);
                  });
                },
              );
            }).toList(),
          ),
          TextField(
            controller: _languageInputController,
            decoration: InputDecoration(
              labelText: "Add a language",
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                _addLanguage(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
