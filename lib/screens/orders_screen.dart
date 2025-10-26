// orders_screen.dart
// Displays user's orders (active & history) with status updates.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersScreen extends StatelessWidget {
  final userId = 'demoUserId'; // replace with real user id

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Orders').where('userId', isEqualTo: userId).orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return Center(child: Text('No orders yet'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final d = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: d['dishImage'] != null ? Image.network(d['dishImage'], width: 60, height: 60, fit: BoxFit.cover) : Icon(Icons.fastfood),
                title: Text(d['dishName'] ?? 'Dish'),
                subtitle: Text('Status: ${d['status'] ?? 'Pending'}'),
                trailing: Text(d['timestamp'] != null ? (d['timestamp'] as Timestamp).toDate().toLocal().toString().split('.')[0] : ''),
              );
            },
          );
        },
      ),
    );
  }
}
