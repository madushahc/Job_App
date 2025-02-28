import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key? key}) : super(key: key);

  @override
  FiltersScreenState createState() => FiltersScreenState();
}

class FiltersScreenState extends State<FiltersScreen> {
  String _lastUpdate = 'Any time';
  final Set<String> _selectedJobTypes = {};
  double _minSalary = 10;
  double _maxSalary = 20;
  bool _expandLastUpdate = true;
  bool _expandJobType = true;
  bool _expandSalary = true;
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final cardColor =
        isDarkMode ? Colors.grey[900] ?? Colors.black : Colors.white;
    final dividerColor = isDarkMode
        ? Colors.grey[700] ?? Colors.grey
        : Colors.grey[300] ?? Colors.grey;

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
              _buildCollapsibleSection(
                title: "Last update",
                isExpanded: _expandLastUpdate,
                textColor: textColor,
                onToggle: () =>
                    setState(() => _expandLastUpdate = !_expandLastUpdate),
                child: Column(
                  children: [
                    _buildRadioOption('Recent', textColor),
                    _buildRadioOption('Last week', textColor),
                    _buildRadioOption('Last month', textColor),
                    _buildRadioOption('Any time', textColor),
                  ],
                ),
              ),
              Divider(color: dividerColor),
              _buildLocationField(textColor, cardColor),
              Divider(color: dividerColor),
              _buildCollapsibleSection(
                title: "Job type",
                isExpanded: _expandJobType,
                textColor: textColor,
                onToggle: () =>
                    setState(() => _expandJobType = !_expandJobType),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _buildJobTypeChip('Full time', isDarkMode),
                    _buildJobTypeChip('Part-time', isDarkMode),
                    _buildJobTypeChip('Internship', isDarkMode),
                  ],
                ),
              ),
              Divider(color: dividerColor),
              _buildCollapsibleSection(
                title: "Salary",
                isExpanded: _expandSalary,
                textColor: textColor,
                onToggle: () => setState(() => _expandSalary = !_expandSalary),
                child: Row(
                  children: [
                    Text("\$${_minSalary.toInt()}k",
                        style: TextStyle(color: textColor)),
                    Expanded(
                      child: RangeSlider(
                        values: RangeValues(_minSalary, _maxSalary),
                        min: 10,
                        max: 50,
                        divisions: 50,
                        activeColor: Colors.blue,
                        labels: RangeLabels("\$${_minSalary.toInt()}k",
                            "\$${_maxSalary.toInt()}k"),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _minSalary = values.start;
                            _maxSalary = values.end;
                          });
                        },
                      ),
                    ),
                    Text("\$${_maxSalary.toInt()}k",
                        style: TextStyle(color: textColor)),
                  ],
                ),
              ),
              Divider(color: dividerColor),
              const SizedBox(height: 8),
              _buildFooterButtons(isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  /// Location Input Field
  Widget _buildLocationField(Color textColor, Color cardColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.location_on, color: Colors.blue),
          ),
          Expanded(
            child: TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: "Enter location",
                border: InputBorder.none,
                hintStyle: TextStyle(color: textColor.withAlpha(150)),
              ),
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  /// Collapsible Sections
  Widget _buildCollapsibleSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
    required Color textColor,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor)),
              Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: textColor.withAlpha(150)),
            ],
          ),
        ),
        if (isExpanded)
          Padding(padding: const EdgeInsets.only(top: 8), child: child),
      ],
    );
  }

  /// Radio List for "Last Update" filter
  Widget _buildRadioOption(String text, Color textColor) {
    return RadioListTile<String>(
      title: Text(text, style: TextStyle(color: textColor)),
      value: text,
      groupValue: _lastUpdate,
      onChanged: (String? value) {
        setState(() {
          _lastUpdate = value!;
        });
      },
    );
  }

  /// Job Type Selection Chips
  Widget _buildJobTypeChip(String label, bool isDarkMode) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedJobTypes.contains(label),
      selectedColor: Colors.blue,
      backgroundColor: isDarkMode
          ? Colors.grey[800] ?? Colors.black
          : Colors.grey[200] ?? Colors.grey,
      labelStyle: TextStyle(
          color: _selectedJobTypes.contains(label)
              ? Colors.white
              : (isDarkMode ? Colors.white : Colors.black)),
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

  /// Reset & Apply Buttons
  Widget _buildFooterButtons(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _lastUpdate = 'Any time';
              _selectedJobTypes.clear();
              _minSalary = 10;
              _maxSalary = 20;
              _locationController.clear();
            });
          },
          child: Text('Reset',
              style: TextStyle(color: Colors.red[500], fontSize: 16)),
        ),
        const SizedBox(width: 150),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, foregroundColor: Colors.white),
          onPressed: () {},
          child: const Text('Apply', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
