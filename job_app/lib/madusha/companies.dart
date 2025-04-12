import 'package:flutter/material.dart';
import 'package:job_app/home_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_app/lakshika/comseeall.dart';

class PopularCompanies extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const PopularCompanies({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<PopularCompanies> createState() => _PopularCompaniesState();
}

class _PopularCompaniesState extends State<PopularCompanies> {
  List<dynamic> jobs = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    const String query = "jobs";
    const int numPages = 1;

    final String url =
        'https://jsearch.p.rapidapi.com/search?query=$query&num_pages=$numPages';
    final Uri uri = Uri.parse(url);

    final headers = {
      'x-rapidapi-host': 'jsearch.p.rapidapi.com',
      'x-rapidapi-key':
          'b82235208amsh8a43112a2c5c8e4p19ceb3jsn0ceb21592560', // Replace with actual key
    };

    try {
      final response = await http.get(uri, headers: headers);

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
    final Color textColor = widget.isDarkMode ? Colors.white : Colors.black87;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Popular Companies",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompanySeeAll(
                            isDarkMode: widget.isDarkMode,
                            onThemeChanged: widget.onThemeChanged)),
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: Text(
                      "See all",
                      style: TextStyle(color: Colors.lightBlue, fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          height: 150.0, // Increased height for better visibility
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              final company = job["employer_name"] ?? "";
              final logo = job["employer_logo"]?.isNotEmpty == true
                  ? job["employer_logo"]
                  : 'assets/non.jpg'; // Fallback to local asset

              return CompanyCard(
                companyName: company,
                logoUrl: logo,
                isDarkMode: widget.isDarkMode,
              );
            },
          ),
        ),
      ],
    );
  }
}

class CompanyCard extends StatelessWidget {
  final String companyName;
  final String logoUrl;
  final bool isDarkMode;

  const CompanyCard({
    super.key,
    required this.companyName,
    required this.logoUrl,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: 100.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/non.jpg'), // Fallback image
                image: logoUrl.startsWith('http')
                    ? NetworkImage(logoUrl)
                    : AssetImage(logoUrl) as ImageProvider,
                fit: BoxFit.cover,
                width: 80.0,
                height: 80.0,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/non.jpg', // Fallback image
                    fit: BoxFit.cover,
                    width: 80.0,
                    height: 80.0,
                  );
                },
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              companyName,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
