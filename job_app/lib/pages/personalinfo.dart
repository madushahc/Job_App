import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  String _profileImageUrl = '';
  bool _isUploadingImage = false;
  // Text editing controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _aboutMeController.dispose();
    _skillsController.dispose();
    _experienceController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        if (doc.exists && doc.data()!.containsKey('profileImageUrl')) {
          setState(() {
            _profileImageUrl = doc.data()!['profileImageUrl'];
          });
        }
      } catch (e) {
        print('Error loading profile image: $e');
      }
    }
  }

  Future<void> _updateProfileImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image == null) return;

      setState(() {
        _isUploadingImage = true;
      });

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user!.uid}.jpg');

      await storageRef.putFile(File(image.path));
      final downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'profileImageUrl': downloadUrl});

      setState(() {
        _profileImageUrl = downloadUrl;
        _isUploadingImage = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully')),
        );
      }
    } catch (e) {
      setState(() {
        _isUploadingImage = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile picture: $e')),
        );
      }
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in first')),
      );
    }
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text(
          'Personal Information',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.blue[50],
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No user data found'));
          }
          final userData = snapshot.data!.data()
              as Map<String, dynamic>; // Update controllers with current data
          _nameController.text = userData['name']?.toString() ?? '';
          _emailController.text = userData['email']?.toString() ?? '';
          _phoneController.text = userData['phone']?.toString() ?? '';
          _aboutMeController.text = userData['aboutMe']?.toString() ?? '';

          // Handle skills that might be stored as a List
          var skills = userData['skills'];
          _skillsController.text =
              skills is List ? skills.join(', ') : (skills?.toString() ?? '');

          _experienceController.text = userData['experience']?.toString() ?? '';

          // Handle language that might be stored as a List
          var language = userData['language'];
          _languageController.text = language is List
              ? language.join(', ')
              : (language?.toString() ?? '');
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _updateProfileImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImageUrl.isNotEmpty
                            ? NetworkImage(_profileImageUrl)
                            : const AssetImage('assets/default_profile.png')
                                as ImageProvider,
                        child: _isUploadingImage
                            ? const CircularProgressIndicator()
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Basic Information',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('Full Name', _nameController),
                  _buildTextField('Email', _emailController),
                  _buildTextField('Phone Number', _phoneController),
                  const SizedBox(height: 24),
                  Text(
                    'Professional Information',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('About Me', _aboutMeController, maxLines: 4),
                  _buildTextField('Experience', _experienceController,
                      maxLines: 3),
                  _buildTextField('Skills', _skillsController, maxLines: 3),
                  _buildTextField('Language', _languageController, maxLines: 2),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
