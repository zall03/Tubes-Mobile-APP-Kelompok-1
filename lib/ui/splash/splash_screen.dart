import 'dart:async';
import 'package:flutter/material.dart';
import '../onboarding/onboarding_1.dart'; // Pastikan path import benar

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Mendefinisikan warna utama sesuai permintaanmu
  final Color mainColor = const Color(0xFF0074D9);

  @override
  void initState() {
    super.initState();
    // Timer 3 detik sebelum pindah
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreenOne()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background Putih
      body: Stack(
        children: [
          // --- BAGIAN TENGAH (LOGO) ---
          Center(
            child: Image.asset(
              'assets/images/logo_wiskuyy.png',
              width: 200,
              fit: BoxFit.contain,
            ),
          ),

          // --- BAGIAN BAWAH (LOADING INDICATOR KOTAK-KOTAK) ---
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(10, (index) {
                // Logika Gradasi Warna menggunakan warna #0074D9
                // index 0 = pudar (10%), index 9 = pekat (100%)
                double opacity = (index + 1) * 0.1;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(
                      opacity,
                    ), // Pakai warna #0074D9
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
