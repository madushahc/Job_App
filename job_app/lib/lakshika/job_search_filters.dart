import 'package:flutter/material.dart';
import 'package:job_app/pages/filterpage.dart';

class FiltersScreen extends StatefulWidget {
  final List<Map<String, dynamic>> jobs;
  final VoidCallback onThemeChanged;
  final bool isDarkMode;
  final Function(Map<String, dynamic>) onApplyFilters;
  const FiltersScreen({
    super.key,
    required this.jobs,
    required this.onApplyFilters,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  FiltersScreenState createState() => FiltersScreenState();
}

class FiltersScreenState extends State<FiltersScreen> {
  String _selectedCompanyType = 'Any';
  String _selectedLocation = 'Any';
  String _selectedJobPostDate = 'Any time';
  final Set<String> _selectedJobTypes = {};

  final List<String> _companyTypes = [
    'Any',
    'Computer Services',
    'IT',
    'Finance',
    'Healthcare',
    'Education',
    'Retail',
    'Manufacturing',
    'Telecommunications',
    'Transportation',
    'Hospitality',
    'Media & Entertainment',
    'Real Estate',
    'Energy',
    'Nonprofit',
    'Government',
    'Consulting',
    'Engineering',
    'Biotechnology',
    'Pharmaceuticals',
    'Automotive',
    'Aerospace',
    'E-commerce',
    'Food & Beverage',
    'Construction',
  ];
  final List<String> _locations = [
    'Any',
    "Alabama",
    "Alaska",
    "Arizona",
    "Arkansas",
    "California",
    "Colorado",
    "Connecticut",
    "Delaware",
    "Florida",
    "Georgia",
    "Hawaii",
    "Idaho",
    "Illinois",
    "Indiana",
    "Iowa",
    "Kansas",
    "Kentucky",
    "Louisiana",
    "Maine",
    "Maryland",
    "Massachusetts",
    "Michigan",
    "Minnesota",
    "Mississippi",
    "Missouri",
    "Montana",
    "Nebraska",
    "Nevada",
    "New Hampshire",
    "New Jersey",
    "New Mexico",
    "New York",
    "North Carolina",
    "North Dakota",
    "Ohio",
    "Oklahoma",
    "Oregon",
    "Pennsylvania",
    "Rhode Island",
    "South Carolina",
    "South Dakota",
    "Tennessee",
    "Texas",
    "Utah",
    "Vermont",
    "Virginia",
    "Washington",
    "West Virginia",
    "Wisconsin",
    "Wyoming"
  ];
  final List<String> _jobPostDates = [
    'Any time',
    'Last 24 hours',
    'Last week',
    'Last month',
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final dividerColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Filters',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.clear, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdownSection(
                isDarkMode,
                title: "Company Type",
                value: _selectedCompanyType,
                items: _companyTypes,
                textColor: textColor,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCompanyType = newValue!;
                  });
                },
              ),
              Divider(color: dividerColor),
              _buildDropdownSection(
                isDarkMode,
                title: "Location",
                value: _selectedLocation,
                items: _locations,
                textColor: textColor,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLocation = newValue!;
                  });
                },
              ),
              Divider(color: dividerColor),
              _buildDropdownSection(
                isDarkMode,
                title: "Job Post Date",
                value: _selectedJobPostDate,
                items: _jobPostDates,
                textColor: textColor,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedJobPostDate = newValue!;
                  });
                },
              ),
              Divider(color: dividerColor),
              _buildJobTypeSection(textColor, isDarkMode),
              Divider(color: dividerColor),
              const SizedBox(height: 8),
              _buildFooterButtons(isDarkMode, context, textColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownSection(
    bool isDarkMode, {
    required String title,
    required String value,
    required List<String> items,
    required Color textColor,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
        ),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: isDarkMode ? Colors.grey[900] : Colors.white,
          style: TextStyle(color: textColor),
          icon: Icon(
            Icons.arrow_drop_down,
            color: textColor,
          ),
          underline: Container(
            height: 1,
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildJobTypeSection(Color textColor, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Job Type",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _buildJobTypeChip('Full time', isDarkMode, textColor),
            _buildJobTypeChip('Part-time', isDarkMode, textColor),
            _buildJobTypeChip('Internship', isDarkMode, textColor),
          ],
        ),
      ],
    );
  }

  Widget _buildJobTypeChip(String label, bool isDarkMode, Color textColor) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: _selectedJobTypes.contains(label) ? Colors.white : textColor,
        ),
      ),
      selected: _selectedJobTypes.contains(label),
      selectedColor: Colors.blue,
      backgroundColor: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _selectedJobTypes.add(label);
          } else {
            _selectedJobTypes.remove(label);
          }
        });
      },
    );
  }

  Widget _buildFooterButtons(
      bool isDarkMode, BuildContext context, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _selectedCompanyType = 'Any';
              _selectedLocation = 'Any';
              _selectedJobPostDate = 'Any time';
              _selectedJobTypes.clear();
            });
          },
          child: Text(
            'Reset',
            style: TextStyle(color: Colors.red[500], fontSize: 16),
          ),
        ),
        const SizedBox(width: 150),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            // Collect the selected filters
            final filters = {
              'companyType': _selectedCompanyType,
              'location': _selectedLocation,
              'jobPostDate': _selectedJobPostDate,
              'jobTypes': _selectedJobTypes.toList(),
            };

            // Pass the filters to the Filterpage and navigate
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Filterpage(
                  isDarkMode: widget.isDarkMode, // Pass the current theme mode
                  onThemeChanged:
                      widget.onThemeChanged, // Pass the theme change callback
                  filters: filters, // Pass the selected filters
                ),
              ),
            );
          },
          child: const Text('Apply', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
