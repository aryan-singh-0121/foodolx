// order_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> placeOrder(String userId, List<Map<String, dynamic>> items, Map<String, dynamic> address) async {
    final doc = await _firestore.collection('Orders').add({
      'userId': userId,
      'items': items,
      'address': address,
      'status': 'Pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Stream<QuerySnapshot> getUserOrders(String userId) {
    return _firestore.collection('Orders').where('userId', isEqualTo: userId).snapshots();
  }
}
