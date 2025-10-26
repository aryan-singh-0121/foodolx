// ai_suggestions_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class AISuggestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getSuggestions(String userId) async {
    final userDoc = await _firestore.collection('Users').doc(userId).get();
    final liked = userDoc.exists ? (userDoc.data()?['likedDishes'] ?? []) : [];

    if (liked.isEmpty) {
      final top = await _firestore.collection('Dishes').orderBy('rating', descending: true).limit(5).get();
      return top.docs.map((d) { final m = d.data() as Map<String, dynamic>; m['id'] = d.id; return m; }).toList();
    }

    Set<String> cats = {};
    for (var id in liked) {
      final ds = await _firestore.collection('Dishes').doc(id).get();
      if (ds.exists) {
        final name = (ds.data()?['name'] ?? '').toString().toLowerCase();
        if (name.contains('pizza')) cats.add('pizza');
        if (name.contains('sushi')) cats.add('sushi');
        if (name.contains('burger')) cats.add('burger');
      }
    }

    if (cats.isEmpty) {
      final top = await _firestore.collection('Dishes').orderBy('rating', descending: true).limit(5).get();
      return top.docs.map((d) { final m = d.data() as Map<String, dynamic>; m['id'] = d.id; return m; }).toList();
    }

    final topAll = await _firestore.collection('Dishes').orderBy('rating', descending: true).limit(50).get();
    final res = <Map<String, dynamic>>[];
    for (var doc in topAll.docs) {
      final m = doc.data() as Map<String, dynamic>;
      final name = (m['name'] ?? '').toString().toLowerCase();
      for (var k in cats) {
        if (name.contains(k)) { m['id'] = doc.id; res.add(m); break; }
      }
    }
    return res.take(5).toList();
  }
}
