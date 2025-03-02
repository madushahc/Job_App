import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final void Function()? onTap;
  const LikeButton({super.key, required this.isLiked, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Amicons.remix_thumb_up_fill : Amicons.remix_thumb_up,
        color: isLiked ? Colors.blue : null,
      ),
    );
  }
}
