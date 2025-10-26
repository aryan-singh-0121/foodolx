// order_confirm_page.dart
// Shows an animated confirmation (Lottie) and food image in center, similar to NaviPay/PhonePe animation.
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OrderConfirmPage extends StatelessWidget {
  final String foodImage;
  OrderConfirmPage({required this.foodImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie success animation (add asset at assets/animations/order_success.json)
            Lottie.asset('assets/animations/order_success.json', height: 200),
            SizedBox(height: 20),
            CircleAvatar(backgroundImage: AssetImage(foodImage), radius: 60),
            SizedBox(height: 16),
            Text('Order Confirmed!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Your food is being prepared 🍽️', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 24),
            ElevatedButton(onPressed: () => Navigator.popUntil(context, (route) => route.isFirst), child: Text('Back to Home')),
          ],
        ),
      ),
    );
  }
}
