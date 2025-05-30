import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailsPage extends StatefulWidget {
  final Map<String, dynamic> job;
  final bool isSaved;
  final Function(bool) onSaveChanged;

  const JobDetailsPage({
    super.key,
    required this.job,
    required this.isSaved,
    required this.onSaveChanged,
  });

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  int _selectedTab = 0;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.isSaved;
  }

  String _removeHtmlTags(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  List<String> _parseDescription(String description) {
    final List<String> lines = description.split('\n');
    return lines.where((line) => line.trim().isNotEmpty).toList();
  }

  Future<void> _showApplyOptionsDialog(
      BuildContext context, bool isDarkMode) async {
    final applyOptions = widget.job["apply_options"] ?? [];
    if (applyOptions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No application links available')),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            "Select an Apply Option",
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          )),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: applyOptions.map<Widget>((option) {
                final String publisher =
                    option["publisher"] ?? "Unknown Publisher";
                final String applyLink = option["apply_link"] ?? "";

                return ListTile(
                  leading: Icon(Icons.open_in_new, color: Colors.blue),
                  title: Text(publisher),
                  onTap: () async {
                    final Uri url = Uri.parse(Uri.decodeFull(applyLink));

                    if (await canLaunch(url.toString())) {
                      await launch(url.toString());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch the URL.')),
                      );
                    }
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final title = widget.job["job_title"] ?? "";
    final salary = widget.job["job_min_salary"]?.toString() ?? "";
    final company = widget.job["employer_name"] ?? "";
    final industry = widget.job["employer_company_type"] ?? "";
    final type = widget.job["job_employment_type"] ?? "";
    final posttime = widget.job["job_posted_at_datetime_utc"] ?? "";
    final endtime = widget.job["job_offer_expiration_datetime_utc"] ?? "";
    final position = widget.job["job_job_title"] ?? "";
    final total = widget.job["job_onet_job_zone"] ?? "";
    final location =
        "${widget.job["job_city"] ?? ""}, ${widget.job["job_state"] ?? ""}, ${widget.job["job_country"] ?? ""}";
    final logo = widget.job["employer_logo"];
    final description = _removeHtmlTags(widget.job["job_description"] ?? "");
    final requirements = widget.job["job_highlights"]?["Qualifications"] ?? [];
    final responsibilities =
        widget.job["job_highlights"]?["Responsibilities"] ?? [];
    final descriptionLines = _parseDescription(description);

    final List<Widget> _tabsContent = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description:",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.blue[200] : Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          ...descriptionLines.map((line) {
            return Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 5),
              child: Text(
                line.startsWith("•") ? line : "• $line",
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            );
          }).toList(),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (requirements.isNotEmpty) ...[
            Text(
              "Qualifications:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.blue[200] : Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            ...requirements.map((requirement) {
              return Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 5),
                child: Text(
                  "• $requirement",
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              );
            }).toList()
          ],
          const SizedBox(height: 20),
          if (responsibilities.isNotEmpty) ...[
            Text(
              "Responsibilities:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.blue[200] : Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            ...responsibilities.map((responsibility) {
              return Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 5),
                child: Text(
                  "• $responsibility",
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              );
            }).toList()
          ],
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "About the Job:",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.blue[200] : Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          if (title.isNotEmpty) ...[
            Wrap(
              children: [
                Padding(padding: EdgeInsets.all(10.0)),
                Text(
                  "Job Title : ",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
          if (industry.isNotEmpty) ...[
            Wrap(
              children: [
                Padding(padding: EdgeInsets.all(10.0)),
                Text(
                  "Company : ",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Center(
                  child: Text(
                    industry,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
          if (position.isNotEmpty) ...[
            Wrap(
              children: [
                Padding(padding: EdgeInsets.all(10.0)),
                Text(
                  "Job Position : ",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Center(
                  child: Text(
                    position,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
          if (type.isNotEmpty) ...[
            Wrap(
              children: [
                Padding(padding: EdgeInsets.all(10.0)),
                Text(
                  "Job Type : ",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Center(
                  child: Text(
                    type,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
          if (posttime.isNotEmpty) ...[
            Wrap(
              children: [
                Padding(padding: EdgeInsets.all(10.0)),
                Text(
                  "Job Post Date : ",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Center(
                  child: Text(
                    posttime,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
          if (endtime.isNotEmpty) ...[
            Wrap(
              children: [
                Padding(padding: EdgeInsets.all(10.0)),
                Text(
                  "Job End Date : ",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Center(
                  child: Text(
                    endtime,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
          if (total.isNotEmpty) ...[
            Wrap(
              children: [
                Padding(padding: EdgeInsets.all(10.0)),
                Text(
                  "Job vacancy : ",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Center(
                  child: Text(
                    total,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Colors.grey[900]!, Colors.grey[800]!]
                        : [Color(0xFFFDE8D6), Color(0xFFF8C5A2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back,
                              size: 35, color: textColor),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isBookmarked = !_isBookmarked;
                              widget.onSaveChanged(_isBookmarked);
                            });
                          },
                          icon: Icon(
                            _isBookmarked
                                ? Icons.bookmark_added_rounded
                                : Icons.bookmark_add_outlined,
                            size: 35,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    CircleAvatar(
                      backgroundImage: logo != null
                          ? NetworkImage(logo)
                          : AssetImage("assets/non.jpg") as ImageProvider,
                      radius: 35,
                    ),
                    const SizedBox(height: 10),

                    Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: textColor,
                        ),
                      ),
                    ),
                    Text(
                      company,
                      style: TextStyle(
                        color: isDarkMode ? Colors.blue[200] : Colors.blue,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Location
                    Wrap(
                      children: [
                        Text(
                          salary,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Colors.red, size: 20.0),
                            Text(
                              location,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTabButton("  Description  ", 0, isDarkMode),
                    _buildTabButton("  Requirements  ", 1, isDarkMode),
                    _buildTabButton("  About  ", 2, isDarkMode),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20),
                child: _tabsContent[_selectedTab],
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  fixedSize: MaterialStateProperty.all(Size(200, 50)),
                  alignment: Alignment.center,
                ),
                onPressed: () async {
                  await _showApplyOptionsDialog(context, isDarkMode);
                },
                child: Text(
                  "Apply Now",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, int index, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: _selectedTab == index
              ? isDarkMode
                  ? Colors.blue[800]!
                  : Colors.blue
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _selectedTab == index
                ? isDarkMode
                    ? Colors.blue[800]!
                    : Colors.blue
                : Colors.grey,
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: _selectedTab == index
                ? Colors.white
                : Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
