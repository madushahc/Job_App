import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });
  final bool isDarkMode;
  final VoidCallback? onThemeChanged;

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool isDarkMode = false;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  } // Add this line to simulate the isDarkMode property

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Create Post",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 90, // Set the desired width
                height: 40, // Set the desired height
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(15), // Set the border radius
                  border: Border.all(
                    color: widget.isDarkMode ? Colors.white : Colors.blue,
                  ),
                  color: widget.isDarkMode ? Colors.white : Colors.blue,
                ),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.transparent),
                  ),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: widget.isDarkMode ? Colors.blue : Colors.white,
                    ),
                  ),
                  onPressed: () {
                    // Add your save functionality here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Post saved!',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          centerTitle: true,
          toolbarHeight: 70.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                maxLength: 50,
                style: TextStyle(
                  color: widget.isDarkMode
                      ? Colors.white
                      : Colors.black, // Adapts to dark/light mode
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  hintText: 'Add Your Title',
                  hintStyle: TextStyle(fontSize: 20),
                  fillColor: Colors.transparent,
                  border: UnderlineInputBorder(),
                  contentPadding: const EdgeInsets.all(16.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  maxLength: 500,
                  minLines: 5,
                  maxLines: 10,
                  style: TextStyle(
                    color: widget.isDarkMode
                        ? Colors.white
                        : Colors.black, // Adapts to dark/light mode
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(fontSize: 20),
                    fillColor: Colors.transparent,
                    filled: true,
                    border: UnderlineInputBorder(),
                    contentPadding: const EdgeInsets.all(16.0),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
