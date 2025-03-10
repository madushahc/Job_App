import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
        textTheme: GoogleFonts.poppinsTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: GoogleFonts.poppinsTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade800,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
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
                        backgroundImage: _profileImagePath != null
                            ? FileImage(File(_profileImagePath!))
                            : AssetImage("assets/default_profile.png")
                                as ImageProvider,
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
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            border: OutlineInputBorder(),
                          ),
                        ),
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  "Done",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
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
          color: Theme.of(context).inputDecorationTheme.fillColor,
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
        decoration: InputDecoration(
          labelText: "About me",
          border: OutlineInputBorder(),
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
        decoration: InputDecoration(
          labelText: "Work Experience",
          border: OutlineInputBorder(),
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
                label: Text(skill),
                backgroundColor: Colors.blue[200],
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
                label: Text(language),
                backgroundColor: Colors.blue[200],
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
