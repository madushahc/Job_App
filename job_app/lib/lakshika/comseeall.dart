import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_app/lakshika/CompanyDetailPage.dart';

class CompanySeeAll extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;
  const CompanySeeAll({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<CompanySeeAll> createState() => _CompanySeeAllState();
}

class _CompanySeeAllState extends State<CompanySeeAll> {
  List<dynamic> jobs = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    debugPrint("Fetching job details...");

    const String query = "Jobs";
    const int numPages = 20;

    final String url =
        'https://jsearch.p.rapidapi.com/search?query=$query&num_pages=$numPages';
    final Uri uri = Uri.parse(url);

    final headers = {
      'x-rapidapi-host': 'jsearch.p.rapidapi.com',
      'x-rapidapi-key': 'b82235208amsh8a43112a2c5c8e4p19ceb3jsn0ceb21592560',
    };

    try {
      final response = await http.get(uri, headers: headers);
      debugPrint("Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['data'] != null && json['data'].isNotEmpty) {
          setState(() {
            jobs = json['data'];
            isLoading = false;
          });
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
    final Color tagBackground =
        isDarkMode ? Colors.blueGrey[800]! : Colors.blue[50]!;
    final Color tagTextColor = Colors.blueAccent;
    final Color locationColor = isDarkMode ? Colors.white70 : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Company",
            style: TextStyle(color: textColor, fontSize: 20.0),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.0),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, bottom: 15.0),
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          final job = jobs[index];
                          final city = job["job_city"] ?? "";
                          final state = job["job_state"] ?? "";
                          final country = job["job_country"] ?? "";
                          final company = job["employer_name"] ?? "";
                          final logo = job["employer_logo"];
                          final industry = job["employer_company_type"] ?? "";

                          return Padding(
                            padding: EdgeInsets.only(bottom: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CompanyDetailPage(companyName: company),
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
                                          // Clickable logo
                                          logo != null
                                              ? GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CompanyDetailPage(
                                                                companyName:
                                                                    company),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image:
                                                            NetworkImage(logo),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CompanyDetailPage(
                                                                companyName:
                                                                    company),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
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
                                                ),
                                          SizedBox(width: 12.0),
                                          // Job Title & Company
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
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
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                Icon(Icons.location_on,
                                                    color: Colors.red,
                                                    size: 20.0),
                                                SizedBox(width: 5.0),
                                                Expanded(
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
