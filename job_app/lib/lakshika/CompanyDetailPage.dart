import 'package:flutter/material.dart';

class CompanyDetailPage extends StatefulWidget {
  final Map<String, String> company;

  CompanyDetailPage({required this.company});

  @override
  _CompanyDetailPageState createState() => _CompanyDetailPageState();
}

class _CompanyDetailPageState extends State<CompanyDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.company["name"]!)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(widget.company["logo"]!, width: 80, height: 80),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.company["name"]!,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(widget.company["type"]!,
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 5),
                Text(widget.company["location"]!,
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                launchURL(widget.company["website"]!);
              },
              child: Text("Visit Website"),
            ),
          ],
        ),
      ),
    );
  }

  void launchURL(String s) {
    // Implement URL launch functionality
  }
}
