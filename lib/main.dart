// main.dart
// Entry point for FoolDolx Flutter app.
// Initializes Firebase and shows SplashScreen -> Authentication -> Home flow.
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';

// If you generated firebase_options.dart with flutterfire, import it here.
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase. Replace with DefaultFirebaseOptions.currentPlatform if available.
  await Firebase.initializeApp();
  runApp(FoolDolxApp());
}

class FoolDolxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoolDolx',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.white,
      ),
      // Register routes for navigation
      routes: {
        '/': (context) => SplashScreen(),
      },
    );
  }
}
