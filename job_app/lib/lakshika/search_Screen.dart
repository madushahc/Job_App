import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JobSearchScreen(),
    );
  }
}

class JobSearchScreen extends StatelessWidget {
  final List<String> popularRoles = [
    "Designer",
    "Administrate",
    "NGO",
    "Manager",
    "Management",
    "IT",
    "Marketing",
    "Developer",
    "SEO"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 350,
          height: MediaQuery.of(context).size.height * 0.9, // Increased height

          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text("Search",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(width: 48), // Keeps spacing balanced
                ],
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search job or position",
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text("Filters", style: TextStyle(color: Colors.blue)),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Popular Roles",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.5,
                ),
                itemCount: popularRoles.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(popularRoles[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
