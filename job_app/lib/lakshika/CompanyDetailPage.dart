import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../config/cloudinary_config.dart';

class CompanyDetailPage extends StatefulWidget {
  final String companyName;

  const CompanyDetailPage({super.key, required this.companyName});

  @override
  State<CompanyDetailPage> createState() => _CompanyDetailPageState();
}

class _CompanyDetailPageState extends State<CompanyDetailPage> {
  Map<String, dynamic>? companyData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchCompanyData();
  }

  Future<void> fetchCompanyData() async {
    final url = Uri.parse(
      'https://jsearch.p.rapidapi.com/search?query=${Uri.encodeComponent(widget.companyName)}&page=1&num_pages=1&country=us&date_posted=all',
    );

    try {
      final response =
          await http.get(url, headers: RapidApiConfig.getHeaders());
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['data'] != null && json['data'].isNotEmpty) {
          final List data = json['data'];
          final matchingCompany = data.firstWhere(
            (item) => (item['employer_name'] as String)
                .toLowerCase()
                .contains(widget.companyName.toLowerCase()),
            orElse: () => null,
          );

          if (matchingCompany != null) {
            setState(() {
              companyData = matchingCompany;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              errorMessage = 'No details found for "${widget.companyName}".';
            });
          }
        } else {
          setState(() {
            isLoading = false;
            errorMessage = 'No company details found.';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Error fetching data: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to fetch details: $e';
      });
    }
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey[400]! : Colors.grey[700]!;

    return Scaffold(
      appBar: AppBar(title: Text('Company Details')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),

                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: (companyData?['employer_logo'] !=
                                    null)
                                ? NetworkImage(companyData!['employer_logo'])
                                : null,
                            child: companyData?['employer_logo'] == null
                                ? Icon(Icons.image_not_supported, size: 50)
                                : null,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Company Name
                        Center(
                          child: Text(
                            companyData?['employer_name'] ?? 'No name',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),

                        // Company Type
                        if ((companyData?['employer_company_type'] ?? '')
                            .isNotEmpty)
                          Center(
                            child: Text(
                              companyData!['employer_company_type'],
                              style: TextStyle(
                                fontSize: 16,
                                color: subtitleColor,
                                height: 1.6,
                              ),
                            ),
                          ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.redAccent),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "${companyData?['job_city'] ?? 'City'}, ${companyData?['job_state'] ?? 'State'}, ${companyData?['job_country'] ?? 'Country'}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: subtitleColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Website Link
                        if ((companyData?['employer_website'] ?? '').isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Visit Website", style: sectionTitleStyle()),
                              SizedBox(height: 6),
                              GestureDetector(
                                onTap: () => _launchURL(
                                    companyData!['employer_website']),
                                child: Text(
                                  companyData!['employer_website'],
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }

  TextStyle sectionTitleStyle() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.teal,
    );
  }

  TextStyle sectionContentStyle() {
    return TextStyle(
      fontSize: 16,
      height: 1.6,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white70
          : Colors.black87,
    );
  }
}
