import 'package:flutter/material.dart';
import '../Login_Register/login_screen.dart'; // Pastikan path benar

class OnboardingScreenTwo extends StatefulWidget {
  const OnboardingScreenTwo({super.key});

  @override
  State<OnboardingScreenTwo> createState() => _OnboardingScreenTwoState();
}

class _OnboardingScreenTwoState extends State<OnboardingScreenTwo> {
  // Warna utama
  final Color mainColor = const Color(0xFF0074D9);

  // Controller
  late PageController _pageController;

  // State untuk melacak posisi gambar aktif (Default: 1 karena initialPage: 1)
  int _currentIndex = 1;

  // Daftar gambar
  final List<String> _images = [
    'assets/images/ob_1.jpg',
    'assets/images/ob_2.jpg',
    'assets/images/ob_3.jpg',
  ];

  @override
  void initState() {
    super.initState();
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

            // --- 1. BAGIAN GAMBAR (SLIDER / CAROUSEL) ---
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                // UPDATE: Mengubah state saat halaman digeser
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(_images[index]),
                        fit: BoxFit.cover,
                      ),
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

            // --- 2. INDIKATOR HALAMAN (DINAMIS) ---
            // UPDATE: Menggunakan loop untuk generate warna sesuai posisi aktif
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_images.length, (index) {
                // Tentukan warna: Biru jika aktif, Abu jika tidak
                Color color = (_currentIndex == index)
                    ? mainColor
                    : Colors.grey.shade300;
                return _buildIndicator(color: color);
              }),
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
                        const TextSpan(text: "All Your\n"),
                        TextSpan(
                          text: "destination",
                          style: TextStyle(color: mainColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "TravelEase brings unforgettable journeys to everyone, offering curated destinations, smart guides, and seamless experiences that inspire every explorer.",
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

            // --- 4. TOMBOL GET STARTED ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Indikator dengan Animasi Halus
  Widget _buildIndicator({required Color color}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), // Efek transisi warna
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
