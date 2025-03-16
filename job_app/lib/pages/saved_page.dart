import 'package:flutter/material.dart';
import 'package:job_app/madusha/jobdetailscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SavedPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;
  const SavedPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  List<dynamic> savedJobs = [];

  @override
  void initState() {
    super.initState();
    loadSavedJobs();
  }

  Future<void> loadSavedJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedJobsJson = prefs.getStringList('savedJobs') ?? [];
    setState(() {
      savedJobs = savedJobsJson.map((job) => jsonDecode(job)).toList();
    });
  }

  Future<void> saveJob(Map<String, dynamic> job) async {
    final prefs = await SharedPreferences.getInstance();
    final jobJson = jsonEncode(job);
    savedJobs.add(job);
    await prefs.setStringList(
        'savedJobs', savedJobs.map((j) => jsonEncode(j)).toList());
    setState(() {});
  }

  Future<void> removeJob(Map<String, dynamic> job) async {
    final prefs = await SharedPreferences.getInstance();
    savedJobs.removeWhere((j) => j['job_id'] == job['job_id']);
    await prefs.setStringList(
        'savedJobs', savedJobs.map((j) => jsonEncode(j)).toList());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.blue[50],
      appBar: AppBar(
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.blue[50],
        title: Center(
            child: Text(
          "Saved Jobs",
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
      body: ListView.builder(
        itemCount: savedJobs.length,
        itemBuilder: (context, index) {
          final bool isDarkMode =
              Theme.of(context).brightness == Brightness.dark;
          final Color textColor = isDarkMode ? Colors.white : Colors.black87;
          final Color subtitleColor =
              isDarkMode ? Colors.grey[400]! : Colors.grey[700]!;
          final Color cardColor = isDarkMode ? Colors.grey[800]! : Colors.white;
          final Color iconColor = isDarkMode ? Colors.white : Colors.blueAccent;
          final Color tagBackground =
              isDarkMode ? Colors.blueGrey[800]! : Colors.blue[50]!;
          final Color tagTextColor =
              isDarkMode ? Colors.blueAccent : Colors.blueAccent;
          final Color locationColor =
              isDarkMode ? Colors.white70 : Colors.black87;

          final job = savedJobs[index];
          final title = job["job_title"] ?? "";
          final company = job["employer_name"] ?? "";
          final logo = job["employer_logo"];
          final city = job["job_city"] ?? "";
          final state = job["job_state"] ?? "";
          final country = job["job_country"] ?? "";
          final currency = job["job_salary_currency"] ?? "";
          final salary = job["job_min_salary"]?.toString() ?? "";
          final position = job["job_job_title"] ?? "";
          final industry = job["employer_company_type"] ?? "";
          final type = job["job_employment_type"] ?? "";

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: SizedBox(
                  width: MediaQuery.of(context)
                      .size
                      .width, // Set a bounded width for each item
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailsPage(
                            job: job,
                            isSaved: savedJobs.any((j) =>
                                j['job_id'] ==
                                job['job_id']), // Pass saved state
                            onSaveChanged: (isSaved) {
                              if (isSaved) {
                                saveJob(job); // Save the job
                              } else {
                                removeJob(job); // Remove the job
                              }
                              loadSavedJobs(); // Reload the saved jobs list
                            },
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: cardColor,
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Profile Image
                                logo != null
                                    ? Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(logo),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[300],
                                        ),
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 30.0,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                SizedBox(width: 12.0),
                                // Job Title & Company
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (title.isNotEmpty)
                                        Text(
                                          title,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      if (company.isNotEmpty)
                                        Text(
                                          company,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: subtitleColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => removeJob(job),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (industry.isNotEmpty)
                                  _buildTag(
                                      industry, tagBackground, tagTextColor),
                                if (type.isNotEmpty)
                                  _buildTag(type, tagBackground, tagTextColor),
                                if (position.isNotEmpty)
                                  _buildTag(
                                      position, tagBackground, tagTextColor),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (currency.isNotEmpty || salary.isNotEmpty)
                                  Flexible(
                                    flex: 1, // Adjust flex value as needed
                                    child: Text(
                                      "$currency $salary",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                Flexible(
                                  flex: 2, // Give more space to the location
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Colors.red, size: 20.0),
                                      SizedBox(width: 5.0),
                                      Expanded(
                                        // Use Expanded inside the Row to handle text overflow
                                        child: Text(
                                          "$city, $state, $country",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: locationColor,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTag(String text, Color background, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.blueAccent, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
        ),
      ),
    );
  }
}
