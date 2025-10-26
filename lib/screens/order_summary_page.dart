// order_summary_page.dart
// Shows Flipkart-style bill with itemized prices, delivery charge, and QR scanner/payment section.
import 'package:flutter/material.dart';
import 'order_confirm_page.dart';

class OrderSummaryPage extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final double deliveryCharge = 17.0;

  OrderSummaryPage({required this.items});

  @override
  Widget build(BuildContext context) {
    double subtotal = items.fold(0, (sum, item) => sum + (item['price'] ?? 0));
    double total = subtotal + deliveryCharge;

    return Scaffold(
      appBar: AppBar(title: Text('Order Summary')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bill Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            ...items.map((item) => ListTile(title: Text(item['name']), trailing: Text('₹${item['price']}'))),
            Divider(),
            ListTile(title: Text('Delivery Charge'), trailing: Text('₹${deliveryCharge.toStringAsFixed(0)}')),
            Divider(thickness: 2),
            ListTile(title: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)), trailing: Text('₹${total.toStringAsFixed(0)}')),
            SizedBox(height: 16),
            Text('Delivery in 30–40 mins', style: TextStyle(color: Colors.green)),
            Text('Delay possible: +10 mins', style: TextStyle(color: Colors.grey, fontSize: 12)),
            SizedBox(height: 24),
            Center(child: Image.asset('assets/images/payment_qr.png', height: 160)),
            SizedBox(height: 8),
            Center(child: Text('Scan to Pay (Auto confirm after payment)')),
            SizedBox(height: 16),
            Center(child: ElevatedButton(onPressed: () {
              // In demo, assume payment done and go to confirmation
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrderConfirmPage(foodImage: items.first['image'])));
            }, child: Text('I have paid'))),
          ],
        ),
      ),
    );
  }
}
