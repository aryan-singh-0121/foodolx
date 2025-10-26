// food_video_card.dart
// Shows a video (network or asset), dish info, rating, and order button which adds to cart.
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodVideoCard extends StatefulWidget {
  final String shopName;
  final bool shopVerified;
  final String dishName;
  final String videoUrl;
  final double rating;
  final double price;
  final bool isVegetarian;
  final String dishId; // used for orders/reviews

  FoodVideoCard({
    required this.shopName,
    required this.shopVerified,
    required this.dishName,
    required this.videoUrl,
    required this.rating,
    required this.price,
    required this.isVegetarian,
    required this.dishId,
  });

  @override
  _FoodVideoCardState createState() => _FoodVideoCardState();
}

class _FoodVideoCardState extends State<FoodVideoCard> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl.startsWith('http')) {
      _controller = VideoPlayerController.network(widget.videoUrl)..initialize().then((_) {
        setState(() {});
        _controller?.setLooping(true);
        _controller?.play();
      });
    } else if (widget.videoUrl.isNotEmpty) {
      _controller = VideoPlayerController.asset(widget.videoUrl)..initialize().then((_) {
        setState(() {});
        _controller?.setLooping(true);
        _controller?.play();
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> addToCart() async {
    // demoUserId should be replaced by real authenticated user id
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'demoUserId';
    final cartRef = FirebaseFirestore.instance.collection('Users').doc(userId).collection('Cart').doc(widget.dishId);
    final doc = await cartRef.get();
    if (doc.exists) {
      final qty = (doc.data()!['quantity'] ?? 1) + 1;
      await cartRef.update({'quantity': qty});
    } else {
      await cartRef.set({
        'name': widget.dishName,
        'price': widget.price,
        'image': '', // optional: image URL
        'quantity': 1,
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added ${widget.dishName} to cart')));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.all(8), child: Row(children: [Text(widget.shopName, style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(width: 6), if (widget.shopVerified) Icon(Icons.check_circle, color: Colors.blueAccent, size: 18)])),
          _controller != null && _controller!.value.isInitialized ? AspectRatio(aspectRatio: _controller!.value.aspectRatio, child: VideoPlayer(_controller!)) : Container(height: 200, color: Colors.grey[300], child: Center(child: CircularProgressIndicator())),
          Padding(padding: EdgeInsets.all(8), child: Row(children: [Expanded(child: Text(widget.dishName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))), Container(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: widget.isVegetarian ? Colors.green : Colors.red, borderRadius: BorderRadius.circular(5)), child: Text(widget.isVegetarian ? 'Veg' : 'Non-Veg', style: TextStyle(color: Colors.white, fontSize: 12)))])),
          Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Row(children: List.generate(5, (i) => Icon(i < widget.rating.round() ? Icons.star : Icons.star_border, color: Colors.orange, size: 18)))),
          SizedBox(height: 8),
          Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('₹${widget.price.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), ElevatedButton(onPressed: addToCart, child: Text('Add to Cart'))])),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
