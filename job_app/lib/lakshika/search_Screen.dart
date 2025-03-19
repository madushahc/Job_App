import 'package:flutter/material.dart';
import 'package:job_app/lakshika/job_search_filters.dart';
import 'package:job_app/pages/customcard.dart'; // Import the Customcard screen

class SearchScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  SearchScreen({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController
        .addListener(_onSearchChanged); // Listen to search bar changes
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {}); // Rebuild UI when search bar text changes
  }

  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      _navigateToCustomCard(
          value); // Navigate to Customcard with the search query
    }
  }

  void _navigateToCustomCard(String searchQuery) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Customcard(
          isDarkMode: widget.isDarkMode,
          onThemeChanged: widget.onThemeChanged,
          searchQuery: searchQuery, // Pass the search query
        ),
      ),
    );
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search job or position",
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.close, color: Colors.grey),
                          onPressed: _clearSearch,
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                onSubmitted: _onSearchSubmitted,
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FiltersScreen(
                        onApplyFilters: (Map<String, dynamic> filters) {},
                        jobs: [],
                        isDarkMode: widget.isDarkMode,
                        onThemeChanged: () {},
                      ),
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
                    final item = popularRoles[index];
                    return GestureDetector(
                      onTap: () {
                        _navigateToCustomCard(
                            item); // Navigate with the selected keyword
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
                          item,
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
