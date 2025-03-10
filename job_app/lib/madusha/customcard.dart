import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_app/madusha/jobdetailscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Customcard extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;
  final String searchQuery; // Add this line

  const Customcard({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.searchQuery, // Add this line
  });

  @override
  State<Customcard> createState() => _CustomcardState();
}

class _CustomcardState extends State<Customcard> {
  List<dynamic> jobs = [];
  bool isLoading = true;
  String errorMessage = '';
  List<dynamic> savedJobs = [];

  @override
  void initState() {
    super.initState();
    fetchJobs();
    loadSavedJobs();
  }

  // Load saved jobs from SharedPreferences
  Future<void> loadSavedJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedJobsJson = prefs.getStringList('savedJobs') ?? [];
    setState(() {
      savedJobs = savedJobsJson.map((job) => jsonDecode(job)).toList();
    });
  }

  // Save a job to SharedPreferences
  Future<void> saveJob(Map<String, dynamic> job) async {
    final prefs = await SharedPreferences.getInstance();
    final jobJson = jsonEncode(job);
    savedJobs.add(job);
    await prefs.setStringList(
        'savedJobs', savedJobs.map((j) => jsonEncode(j)).toList());
    setState(() {});
  }

  // Remove a job from SharedPreferences
  Future<void> removeJob(Map<String, dynamic> job) async {
    final prefs = await SharedPreferences.getInstance();
    savedJobs.removeWhere((j) => j['job_id'] == job['job_id']);
    await prefs.setStringList(
        'savedJobs', savedJobs.map((j) => jsonEncode(j)).toList());
    setState(() {});
  }

  // Toggle save state for a job
  void _toggleSave(int index) async {
    final job = jobs[index];
    if (savedJobs.any((j) => j['job_id'] == job['job_id'])) {
      await removeJob(job); // Remove job if already saved
    } else {
      await saveJob(job); // Save job if not already saved
    }
  }

  Future<void> fetchJobs() async {
    print("Fetching job details...");

    final String query =
        widget.searchQuery; // Use the search query from the widget
    const int numPages = 20; // Increase for more jobs

    final String url =
        'https://jsearch.p.rapidapi.com/search?query=$query&num_pages=$numPages';
    final Uri uri = Uri.parse(url);

    final headers = {
      'x-rapidapi-host': 'jsearch.p.rapidapi.com',
      'x-rapidapi-key':
          '02e57dea4amsh5d35b1f8ef8ac3ap1c0bdbjsn7d6f596d0010', // Replace with actual key
    };

    try {
      final response = await http.get(uri, headers: headers);

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = response.body;
        final json = jsonDecode(body);
        print("Fetched Data: $json");

        if (json['data'] != null && json['data'].isNotEmpty) {
          setState(() {
            jobs = json['data']; // Store multiple jobs
            isLoading = false;
          });
          print("Jobs list fetched successfully");
        } else {
          setState(() {
            isLoading = false;
            errorMessage = "No jobs found";
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "Failed to fetch job details: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error fetching job details: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color subtitleColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[700]!;
    final Color cardColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    final Color iconColor = isDarkMode ? Colors.white : Colors.blueAccent;
    final Color tagBackground =
        isDarkMode ? Colors.blueGrey[800]! : Colors.blue[50]!;
    final Color tagTextColor =
        isDarkMode ? Colors.blueAccent : Colors.blueAccent;
    final Color locationColor = isDarkMode ? Colors.white70 : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.searchQuery}"), // Display the search query in the AppBar
        centerTitle: true, // Center the title
      ),
      body: Column(
        children: [
          SizedBox(height: 10.0), // Reduced extra spacing
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                ) // Show loading indicator while fetching
              : errorMessage.isNotEmpty
                  ? Center(
                      child: Text(errorMessage),
                    ) // Show error message if fetch failed
                  : Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, bottom: 15.0),
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          final job = jobs[index];
                          final title = job["job_title"] ?? "";
                          final company = job["employer_name"] ?? "";
                          final logo = job["employer_logo"];
                          final city = job["job_city"] ?? "";
                          final state = job["job_state"] ?? "";
                          final country = job["job_country"] ?? "";
                          final currency = job["job_salary_currency"] ?? "";
                          final salary =
                              job["job_min_salary"]?.toString() ?? "";
                          final position = job["job_job_title"] ?? "";
                          final industry = job["employer_company_type"] ?? "";
                          final type = job["job_employment_type"] ?? "";

                          return Padding(
                            padding: EdgeInsets.only(bottom: 15.0),
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
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                color: cardColor,
                                elevation: 4.0,
                                margin: EdgeInsets.only(right: 16.0, top: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: textColor,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                if (company.isNotEmpty)
                                                  Text(
                                                    company,
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: subtitleColor,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                              ],
                                            ),
                                          ),
                                          // Save Icon
                                          IconButton(
                                            icon: Icon(
                                              savedJobs.any((j) =>
                                                      j['job_id'] ==
                                                      job['job_id'])
                                                  ? Icons.bookmark_added_rounded
                                                  : Icons.bookmark_add_outlined,
                                              size: 30.0,
                                              color: savedJobs.any((j) =>
                                                      j['job_id'] ==
                                                      job['job_id'])
                                                  ? Colors.blue
                                                  : Colors.grey,
                                            ),
                                            onPressed: () => _toggleSave(index),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12.0),
                                      Wrap(
                                        spacing: 8.0,
                                        runSpacing: 8.0,
                                        children: [
                                          if (industry.isNotEmpty)
                                            _buildTag(industry, tagBackground,
                                                tagTextColor),
                                          if (type.isNotEmpty)
                                            _buildTag(type, tagBackground,
                                                tagTextColor),
                                          if (position.isNotEmpty)
                                            _buildTag(position, tagBackground,
                                                tagTextColor),
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (currency.isNotEmpty ||
                                              salary.isNotEmpty)
                                            Flexible(
                                              flex:
                                                  1, // Adjust flex value as needed
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
                                            flex:
                                                2, // Give more space to the location
                                            child: Row(
                                              children: [
                                                Icon(Icons.location_on,
                                                    color: Colors.red,
                                                    size: 20.0),
                                                SizedBox(width: 5.0),
                                                Expanded(
                                                  // Use Expanded inside the Row to handle text overflow
                                                  child: Text(
                                                    "$city, $state, $country",
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: locationColor,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                          );
                        },
                      ),
                    ),
        ],
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
