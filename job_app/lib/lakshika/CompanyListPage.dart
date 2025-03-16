import 'package:flutter/material.dart';
import 'package:job_app/lakshika/CompanyDetailPage.dart';

class CompanyListPage extends StatefulWidget {
  const CompanyListPage({super.key});

  @override
  State<CompanyListPage> createState() => _CompanyListPageState();
}

class _CompanyListPageState extends State<CompanyListPage> {
  final List<Map<String, String>> companies = [
    {
      "name": "Microsoft",
      "type": "Technology",
      "logo": "https://logo.clearbit.com/microsoft.com",
      "website": "https://www.microsoft.com",
      "location": "Redmond, Washington, USA"
    },
    {
      "name": "Google",
      "type": "Technology",
      "logo": "https://logo.clearbit.com/google.com",
      "website": "https://www.google.com",
      "location": "Mountain View, California, USA"
    },
    {
      "name": "Amazon",
      "type": "E-commerce",
      "logo": "https://logo.clearbit.com/amazon.com",
      "website": "https://www.amazon.com",
      "location": "Seattle, Washington, USA"
    },
    {
      "name": "Tesla",
      "type": "Automotive",
      "logo": "https://logo.clearbit.com/tesla.com",
      "website": "https://www.tesla.com",
      "location": "Palo Alto, California, USA"
    },
    {
      "name": "Apple",
      "type": "Technology",
      "logo": "https://logo.clearbit.com/apple.com",
      "website": "https://www.apple.com",
      "location": "Cupertino, California, USA"
    },
    {
      "name": "Meta (Facebook)",
      "type": "Social Media & Technology",
      "logo": "https://logo.clearbit.com/meta.com",
      "website": "https://about.meta.com",
      "location": "Menlo Park, California, USA"
    },
    {
      "name": "Intel",
      "type": "Semiconductor & AI",
      "logo": "https://logo.clearbit.com/intel.com",
      "website": "https://www.intel.com",
      "location": "Santa Clara, California, USA"
    },
    {
      "name": "IBM",
      "type": "Cloud Computing & AI",
      "logo": "https://logo.clearbit.com/ibm.com",
      "website": "https://www.ibm.com",
      "location": "Armonk, New York, USA"
    },
    {
      "name": "Oracle",
      "type": "Cloud Computing & Database",
      "logo": "https://logo.clearbit.com/oracle.com",
      "website": "https://www.oracle.com",
      "location": "Austin, Texas, USA"
    },
    {
      "name": "Cisco",
      "type": "Networking & Security",
      "logo": "https://logo.clearbit.com/cisco.com",
      "website": "https://www.cisco.com",
      "location": "San Jose, California, USA"
    },
    {
      "name": "Samsung",
      "type": "Electronics & Technology",
      "logo": "https://logo.clearbit.com/samsung.com",
      "website": "https://www.samsung.com",
      "location": "Suwon, South Korea"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Company List")),
      body: ListView.builder(
        itemCount: companies.length,
        itemBuilder: (context, index) {
          final company = companies[index];
          return Card(
            child: ListTile(
              leading: Image.network(company["logo"]!, width: 50, height: 50),
              title: Text(company["name"]!),
              subtitle: Text(company["type"]!),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompanyDetailPage(company: company),
                    ),
                  );
                },
                child: Text("Learn More"),
              ),
            ),
          );
        },
      ),
    );
  }
}
