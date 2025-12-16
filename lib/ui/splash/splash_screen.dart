import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Pastikan library ini sudah diinstall
import '../onboarding/onboarding_1.dart'; // Pastikan nama file onboarding Anda benar (sesuaikan jika beda)
import '../home/home_screen.dart'; // Pastikan file home_screen.dart sudah dibuat
// import '../auth/login_screen.dart'; // Aktifkan jika butuh redirect ke login (opsional)

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Warna utama (Biru)
  final Color mainColor = const Color(0xFF0074D9);

  @override
  void initState() {
    super.initState();
    // Panggil fungsi pengecekan saat layar pertama kali dibuat
    _checkLoginStatus();
  }

  // --- FUNGSI UTAMA (LOGIKA PINDAH HALAMAN) ---
  Future<void> _checkLoginStatus() async {
    // 1. Durasi splash screen
    var duration = const Duration(seconds: 3);

    // 2. Ambil data login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // 3. Jalankan Timer (JANGAN PAKAI 'return' DI SINI)
    Timer(duration, () {
      if (mounted) {
        if (isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const OnboardingScreenOne(),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- LOGO DI TENGAH ---
          Center(
            child: Image.asset(
              'assets/images/logo_wiskuyy.png', // Pastikan path gambar benar
              width: 200,
              fit: BoxFit.contain,
            ),
          ),

          // --- LOADING BAR DI BAWAH ---
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(10, (index) {
                // Logika gradasi opasitas
                double opacity = (index + 1) * 0.1;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(opacity),
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
