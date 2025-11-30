import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ui/splash/splash_screen.dart'; // 1. Import file splash screen yang baru dibuat

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel App',
      theme: ThemeData(primarySwatch: Colors.blue),
      // 2. Ubah home menjadi SplashScreen
      home: const SplashScreen(),
    );
  }
}
