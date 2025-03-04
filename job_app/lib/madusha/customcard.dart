import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'; // For rendering HTML
import 'package:job_app/madusha/jobdetailscreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> jobs = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            ) // Show loading indicator while fetching
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(errorMessage),
                ) // Show error message if fetch failed
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    final title = job["job_title"] ?? "No Title";
                    final company = job["employer_name"] ?? "Unknown Company";
                    final logo = job["employer_logo"];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetailsPage(job: job),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HtmlWidget(
                                title,
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "Location",
                                style: const TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  logo != null
                                      ? Image.network(
                                          logo,
                                          height: 40,
                                          width: 40,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.image_not_supported,
                                              size: 40,
                                            );
                                          },
                                        )
                                      : const Icon(
                                          Icons.image_not_supported,
                                          size: 40,
                                        ),
                                  const SizedBox(width: 10),
                                  HtmlWidget(
                                    company,
                                    textStyle: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> fetchJobs() async {
    print("Fetching job details...");

    const String query = "jobs"; // General query for all job types
    const int numPages = 1; // Increase for more jobs

    final String url =
        'https://jsearch.p.rapidapi.com/search?query=$query&num_pages=$numPages';
    final Uri uri = Uri.parse(url);

    final headers = {
      'x-rapidapi-host': 'jsearch.p.rapidapi.com',
      'x-rapidapi-key':
          '7b4e3ff2a2msh4baec94f9e23c12p11e56bjsnf5b36a8f5dd6', // Replace with actual key
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
}
