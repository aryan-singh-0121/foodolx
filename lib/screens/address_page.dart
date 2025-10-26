// address_page.dart
// Collects user address and contact details before checkout.
import 'package:flutter/material.dart';
import 'order_summary_page.dart';

class AddressPage extends StatefulWidget {
  final VoidCallback? onNext;
  AddressPage({this.onNext});

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _building = TextEditingController();
  final _street = TextEditingController();
  final _landmark = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delivery Address')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _phone, decoration: InputDecoration(labelText: 'Phone Number'), keyboardType: TextInputType.phone),
              SizedBox(height: 8),
              TextFormField(controller: _building, decoration: InputDecoration(labelText: 'Building / Flat No')),
              SizedBox(height: 8),
              TextFormField(controller: _street, decoration: InputDecoration(labelText: 'Street / Gali No')),
              SizedBox(height: 8),
              TextFormField(controller: _landmark, decoration: InputDecoration(labelText: 'City / Landmark')),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // For demo, navigate to order summary with mock items
                  final items = [
                    {'name':'Pepperoni Pizza','price':250.0,'image':'assets/images/pizza1.jpg'}
                  ];
                  Navigator.push(context, MaterialPageRoute(builder: (_) => OrderSummaryPage(items: items)));
                }
              }, child: Text('Next → Order Summary')),
            ],
          ),
        ),
      ),
    );
  }
}
