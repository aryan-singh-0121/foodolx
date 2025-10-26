// story_widget.dart
import 'package:flutter/material.dart';

class StoryWidget extends StatelessWidget {
  final String shopName;
  final String profilePic;
  final bool isVerified;
  final List<String> storyImages;

  StoryWidget({required this.shopName, required this.profilePic, required this.isVerified, required this.storyImages});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(radius: 30, backgroundImage: profilePic.isNotEmpty ? NetworkImage(profilePic) : null, backgroundColor: Colors.grey[300]),
              if (isVerified) Positioned(bottom: 0, right: 0, child: Container(decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: Icon(Icons.check_circle, color: Colors.blueAccent, size: 18))),
            ],
          ),
          SizedBox(height: 5),
          Container(width: 70, child: Text(shopName, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
