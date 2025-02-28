import 'package:flutter/material.dart';
import 'package:job_app/lakshika/job_search_filters.dart';

class SearchScreen extends StatelessWidget {
  final List<String> popularRoles = [
    "Designer",
    "Administrator",
    "NGO",
    "Manager",
    "Management",
    "IT",
    "Marketing",
    "Developer",
    "SEO"
  ];
  final bool isDarkMode;
  final VoidCallback onThemeChanged;
  SearchScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Detects whether dark mode is enabled
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black54 : Colors.black26,
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close,
                        color: isDarkMode ? Colors.white : Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    "Search",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search job or position",
                  prefixIcon: Icon(Icons.search,
                      color: Colors.grey), // Always black icon
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black), // Black border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.black), // Black border when inactive
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 2), // Thicker black border when focused
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FiltersScreen(),
                    ),
                  ),
                  child: Text(
                    "Filters",
                    style: TextStyle(
                        color: isDarkMode ? Colors.blue[300] : Colors.blue),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Popular Roles",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.only(top: 5.0),
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
                    return GestureDetector(
                      onTap: () {
                        print("Selected: ${popularRoles[index]}");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.blueGrey[700]
                              : Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          popularRoles[index],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
