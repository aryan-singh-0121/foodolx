// review_widget.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewWidget extends StatefulWidget {
  final String dishId;
  final String currentUserId;
  ReviewWidget({required this.dishId, required this.currentUserId});

  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  double _rating = 0;
  TextEditingController _commentController = TextEditingController();

  Future<void> submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select rating')));
      return;
    }
    await FirebaseFirestore.instance.collection('Reviews').add({
      'userId': widget.currentUserId,
      'dishId': widget.dishId,
      'rating': _rating,
      'comment': _commentController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _commentController.clear();
    setState(() => _rating = 0);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Review submitted')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rate this dish:'),
        Row(children: List.generate(5, (i) => IconButton(icon: Icon(i < _rating ? Icons.star : Icons.star_border, color: Colors.orange), onPressed: () => setState(() => _rating = i + 1.0)))),
        TextField(controller: _commentController, decoration: InputDecoration(hintText: 'Write your review...', border: OutlineInputBorder())),
        SizedBox(height: 8),
        ElevatedButton(onPressed: submitReview, child: Text('Submit Review')),
      ],
    );
  }
}
