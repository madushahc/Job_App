import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatefulWidget {
  final Map<String, dynamic> message;

  const MessageBubble({super.key, required this.message});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.message["isUserMessage"]) {
      _fetchUserProfileImage();
    }
  }

  Future<void> _fetchUserProfileImage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          setState(() {
            _profileImageUrl = docSnapshot.data()?['profileImageUrl'];
          });
        }
      }
    } catch (e) {
      print('Error fetching user profile image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message["isUserMessage"] as bool;
    final text = widget.message["text"] as String;
    final timestamp = widget.message["timestamp"] as DateTime;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser)
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Image.asset('assets/bot_icon.png'),
            ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                left: isUser ? 60 : 8,
                right: isUser ? 8 : 60,
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: isUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isUser
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.poppins(
                      color: isUser
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}',
                    style: GoogleFonts.poppins(
                      color: (isUser
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurfaceVariant)
                          .withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser)
            CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              backgroundImage: _profileImageUrl != null
                  ? NetworkImage(_profileImageUrl!)
                  : const AssetImage('assets/default_profile.png')
                      as ImageProvider,
            ),
        ],
      ),
    );
  }
}
