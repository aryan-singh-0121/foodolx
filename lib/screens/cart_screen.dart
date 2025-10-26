// cart_screen.dart
// Shows items added to cart, allows quantity changes, and proceeds to address entry.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'address_page.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final userId = 'demoUserId'; // Replace with FirebaseAuth.instance.currentUser.uid

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Users').doc(userId).collection('Cart').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) return Center(child: Text('Cart is empty'));

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final d = docs[index];
                    final data = d.data() as Map<String, dynamic>;
                    int qty = (data['quantity'] ?? 1).toInt();
                    double price = (data['price'] ?? 0).toDouble();
                    return ListTile(
                      leading: data['image'] != null ? Image.network(data['image'], width: 60, height: 60, fit: BoxFit.cover) : SizedBox(width: 60, height: 60),
                      title: Text(data['name'] ?? 'Item'),
                      subtitle: Text('₹${price.toStringAsFixed(2)} x $qty'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: Icon(Icons.remove), onPressed: () {
                            final newQty = qty - 1;
                            if (newQty <= 0) d.reference.delete(); else d.reference.update({'quantity': newQty});
                          }),
                          Text('$qty'),
                          IconButton(icon: Icon(Icons.add), onPressed: () => d.reference.update({'quantity': qty + 1})),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () async {
                // Navigate to Address page, onNext will push to Order Summary
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddressPage(onNext: () {
                  // After address, you should calculate totals from cart and go to OrderSummaryPage
                  // For simplicity, we pop here. In real app, pass cart items to summary.
                })));
              },
              child: Text('Proceed to Address'),
            ),
          ),
        ],
      ),
    );
  }
}
