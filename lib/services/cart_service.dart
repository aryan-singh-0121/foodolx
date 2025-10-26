// cart_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToCart(String userId, Map<String, dynamic> dish) async {
    final ref = _firestore.collection('Users').doc(userId).collection('Cart').doc(dish['id']);
    final doc = await ref.get();
    if (doc.exists) {
      final qty = (doc.data()!['quantity'] ?? 1) + 1;
      await ref.update({'quantity': qty});
    } else {
      await ref.set({...dish, 'quantity': 1});
    }
  }

  Stream<QuerySnapshot> getCartItems(String userId) {
    return _firestore.collection('Users').doc(userId).collection('Cart').snapshots();
  }

  Future<void> clearCart(String userId) async {
    final cart = await _firestore.collection('Users').doc(userId).collection('Cart').get();
    for (var doc in cart.docs) await doc.reference.delete();
  }
}
