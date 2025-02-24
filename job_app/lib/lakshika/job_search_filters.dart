import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FiltersScreen(),
    );
  }
}

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String? _lastUpdate = 'Any time';
  bool _fullTime = true;
  bool _partTime = false;
  bool _internship = false;
  bool _projectBased = false;
  double _minSalary = 13;
  double _maxSalary = 25;
  bool _expandLastUpdate = true;
  bool _expandJobType = true;
  bool _expandSalary = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Filters',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Centers the title properly
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCollapsibleSection(
              title: "Last update",
              isExpanded: _expandLastUpdate,
              onToggle: () =>
                  setState(() => _expandLastUpdate = !_expandLastUpdate),
              child: Column(
                children: [
                  _buildRadioOption('Recent'),
                  _buildRadioOption('Last week'),
                  _buildRadioOption('Last month'),
                  _buildRadioOption('Any time'),
                ],
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(
                      'Location:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Text('Los Angeles, San Jose,...',
                        style: TextStyle(color: Colors.black54)),
                  ],
                ),
                Icon(Icons.edit, color: Colors.grey),
              ],
            ),
            Divider(),
            _buildCollapsibleSection(
              title: "Job type",
              isExpanded: _expandJobType,
              onToggle: () => setState(() => _expandJobType = !_expandJobType),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                alignment:
                    WrapAlignment.start, // Aligns all chips to the start (left)
                children: [
                  _buildJobTypeChip('Full time', _fullTime,
                      (value) => setState(() => _fullTime = value)),
                  _buildJobTypeChip('Part-time', _partTime,
                      (value) => setState(() => _partTime = value)),
                  _buildJobTypeChip('Internship', _internship,
                      (value) => setState(() => _internship = value)),
                  _buildJobTypeChip('Project-based', _projectBased,
                      (value) => setState(() => _projectBased = value)),
                ],
              ),
            ),
            Divider(),
            _buildCollapsibleSection(
              title: "Salary",
              isExpanded: _expandSalary,
              onToggle: () => setState(() => _expandSalary = !_expandSalary),
              child: Row(
                children: [
                  Text("\$${_minSalary.toInt()}k"),
                  Expanded(
                    child: RangeSlider(
                      values: RangeValues(_minSalary, _maxSalary),
                      min: 10,
                      max: 50,
                      divisions: 8,
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
                  Text("\$${_maxSalary.toInt()}k"),
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _lastUpdate = 'Any time';
                      _fullTime = true;
                      _partTime = false;
                      _internship = false;
                      _projectBased = false;
                      _minSalary = 13;
                      _maxSalary = 25;
                    });
                  },
                  child: Text(
                    'Reset',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ),
                SizedBox(width: 150),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {},
                  child: Text('Apply', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsibleSection(
      {required String title,
      required bool isExpanded,
      required VoidCallback onToggle,
      required Widget child}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black54),
            ],
          ),
        ),
        if (isExpanded) Padding(padding: EdgeInsets.only(top: 8), child: child),
      ],
    );
  }

  Widget _buildRadioOption(String text) {
    return RadioListTile<String>(
      title: Text(text),
      value: text,
      groupValue: _lastUpdate,
      onChanged: (String? value) {
        setState(() {
          _lastUpdate = value;
        });
      },
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildJobTypeChip(
      String label, bool isSelected, Function(bool) onSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.blue,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      onSelected: onSelected,
    );
  }
}
