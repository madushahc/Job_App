import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final user = FirebaseAuth.instance.currentUser;
  String _profileImageUrl = '';
  // Text editing controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _workExperienceController =
      TextEditingController();
  final TextEditingController _languagesController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _aboutMeController.dispose();
    _skillsController.dispose();
    _workExperienceController.dispose();
    _languagesController.dispose();
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

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              controller.text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              maxLines: maxLines,
            ),
          ),
        ],
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
            fontWeight: FontWeight.normal,
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

          // Get user data
          final userData = snapshot.data!.data() as Map<String, dynamic>;

          // Update controllers with current data
          _nameController.text = userData['name']?.toString() ?? '';
          _emailController.text = userData['email']?.toString() ?? '';
          _phoneController.text = userData['phoneNumber']?.toString() ?? '';
          _aboutMeController.text = userData['aboutMe']?.toString() ?? '';
          _workExperienceController.text =
              userData['workExperience']?.toString() ?? '';
          _languagesController.text = userData['languages'] is List
              ? (userData['languages'] as List).join(', ')
              : userData['languages']?.toString() ?? '';
          _skillsController.text = userData['skills'] is List
              ? (userData['skills'] as List).join(', ')
              : userData['skills']?.toString() ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImageUrl.isNotEmpty
                        ? NetworkImage(_profileImageUrl)
                        : const AssetImage('assets/default_profile.png')
                            as ImageProvider,
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
                _buildTextField('Work Experience', _workExperienceController,
                    maxLines: 3),
                _buildTextField('Skills', _skillsController, maxLines: 3),
                _buildTextField('Languages', _languagesController, maxLines: 2),
              ],
            ),
          );
        },
      ),
    );
  }
}
