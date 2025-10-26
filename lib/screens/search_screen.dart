// search_screen.dart
// Simple screen to search shops/dishes (stubbed UI calling Firestore).
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search dish or shop'),
              onChanged: (v) => setState(() => query = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Dishes').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final results = snapshot.data!.docs.where((d) {
                  final m = d.data() as Map<String, dynamic>;
                  final name = (m['name'] ?? '').toString().toLowerCase();
                  final shop = (m['shopName'] ?? '').toString().toLowerCase();
                  return name.contains(query) || shop.contains(query);
                }).toList();
                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final m = results[index].data() as Map<String, dynamic>;
                    return ListTile(title: Text(m['name'] ?? 'Dish'), subtitle: Text(m['shopName'] ?? 'Shop'));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
