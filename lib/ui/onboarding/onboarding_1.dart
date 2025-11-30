import 'package:flutter/material.dart';
import 'onboarding_2.dart'; // Import halaman kedua
import '../Login_Register/login_screen.dart'; // Import halaman login

class OnboardingScreenOne extends StatefulWidget {
  const OnboardingScreenOne({super.key});

  @override
  State<OnboardingScreenOne> createState() => _OnboardingScreenOneState();
}

class _OnboardingScreenOneState extends State<OnboardingScreenOne> {
  // Warna utama
  final Color mainColor = const Color(0xFF0074D9);

  // Controller untuk slider gambar
  late PageController _pageController;

  // Daftar gambar untuk Onboarding 1
  final List<String> _images = [
    'assets/images/ob_1.jpg', // Gambar slide kiri
    'assets/images/ob_2.jpg', // Gambar slide tengah (Utama)
    'assets/images/ob_3.jpg', // Gambar slide kanan
  ];

  @override
  void initState() {
    super.initState();
    // viewportFraction 0.75 agar gambar samping terlihat sedikit
    // initialPage: 1 agar mulai dari gambar tengah
    _pageController = PageController(viewportFraction: 0.75, initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- 1. BAGIAN GAMBAR (SLIDER) ---
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(_images[index]),
                        fit: BoxFit.cover, // Gambar memenuhi kotak
                      ),
                      // Shadow agar gambar terlihat timbul
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // --- 2. INDIKATOR HALAMAN ---
            // Sesuai request: [Abu, BIRU, Abu]
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIndicator(color: Colors.grey.shade300),
                _buildIndicator(color: mainColor), // Yang aktif (Tengah)
                _buildIndicator(color: Colors.grey.shade300),
              ],
            ),

            const SizedBox(height: 30),

            // --- 3. JUDUL & DESKRIPSI ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: 'Inter',
                      ),
                      children: [
                        const TextSpan(text: "Discover Your Favorite\n"),
                        TextSpan(
                          text: "destination",
                          style: TextStyle(color: mainColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "ExploreNow brings the world closer, offering vibrant attractions, user-friendly guidance, and great value that enhances every trip",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // --- 4. TOMBOL (Skip & Next) ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Row(
                children: [
                  // Tombol SKIP
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: mainColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Tombol NEXT
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OnboardingScreenTwo(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Indikator
  Widget _buildIndicator({required Color color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 4,
      width: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
