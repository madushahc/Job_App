import 'package:flutter/material.dart';
import 'package:job_app/home_page.dart';

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
  // Dummy data for companies
  final List<Map<String, String>> companies = [
    {"name": "Microsoft", "logo": "assets/microsoft.png"},
    {"name": "Google", "logo": "assets/google.png"},
    {"name": "Amazon", "logo": "assets/amazon.png"},
    {"name": "Tesla", "logo": "assets/tesla.png"},
  ];

  @override
  Widget build(BuildContext context) {
    final Color textColor = widget.isDarkMode ? Colors.white : Colors.black87;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title with "See All"
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
                  color: textColor, // Dark mode support
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage1()),
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

        // Horizontal list of companies
        SizedBox(
          height: 110.0, // Ensure proper alignment
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16.0),
            itemCount: companies.length,
            itemBuilder: (context, index) {
              return _buildCompanyCard(
                companies[index]["name"]!,
                companies[index]["logo"]!,
              );
            },
          ),
        ),
      ],
    );
  }

  // Company Card Widget with Dark Mode support
  Widget _buildCompanyCard(String name, String logoPath) {
    return Container(
      margin: const EdgeInsets.only(right: 15.0),
      width: 90.0, // Fixed width for each item
      child: Column(
        children: [
          Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(logoPath),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.isDarkMode
                      ? Colors.white24 // Softer shadow in dark mode
                      : Colors.grey.withOpacity(0.3),
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            name,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: widget.isDarkMode ? Colors.white : Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
