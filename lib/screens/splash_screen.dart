// splash_screen.dart
// Simple splash screen that navigates to Login after a short delay.
import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart';
import 'home_feed_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait 2 seconds then decide navigation based on auth state
    Timer(Duration(seconds: 2), () {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeFeedScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.restaurant_menu, size: 80, color: Colors.deepOrange),
            SizedBox(height: 12),
            Text('FoolDolx', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text('Food. Social. Fast.', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
