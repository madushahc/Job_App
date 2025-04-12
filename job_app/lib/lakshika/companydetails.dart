import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

// --- Main App ---
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Company API App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CompanyListPage(),
    );
  }
}

// --- Company Model ---
class Company {
  final String name;
  final String logoUrl;
  final String website;
  final String type;
  final String location;

  Company({
    required this.name,
    required this.logoUrl,
    required this.website,
    required this.type,
    required this.location,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      logoUrl: json['logo_url'],
      website: json['website'],
      type: json['type'],
      location: json['location'],
    );
  }
}

// --- API Call Function ---
Future<List<Company>> fetchCompanies() async {
  final response = await http.get(
    Uri.parse(
        'https://jsearch.p.rapidapi.com/search?query=developer%20jobs%20in%20chicago&page=1&num_pages=1&country=us&date_posted=all'),
    // Replace with your own API
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => Company.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load company data');
  }
}

// --- Company List Page ---
class CompanyListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Companies')),
      body: FutureBuilder<List<Company>>(
        future: fetchCompanies(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Company> companies = snapshot.data!;
            return ListView.builder(
              itemCount: companies.length,
              itemBuilder: (context, index) {
                final company = companies[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(company.logoUrl),
                  ),
                  title: Text(company.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Location: ${company.location}'),
                      Text('Website: ${company.website}'),
                      Text('Type: ${company.type}'),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompanyDetailPage(company: company),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

// --- Detail Page ---
class CompanyDetailPage extends StatelessWidget {
  final Company company;

  const CompanyDetailPage({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(company.name)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.network(company.logoUrl, height: 100),
            SizedBox(height: 20),
            Text('Name: ${company.name}', style: TextStyle(fontSize: 18)),
            Text('Website: ${company.website}', style: TextStyle(fontSize: 16)),
            Text('Type: ${company.type}', style: TextStyle(fontSize: 16)),
            Text('Location: ${company.location}',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
