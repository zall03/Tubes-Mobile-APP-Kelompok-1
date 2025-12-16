import 'dart:async'; // Untuk langganan stream koneksi
import 'package:connectivity_plus/connectivity_plus.dart'; // Library cek sinyal
import 'package:flutter/material.dart';
import 'onboarding_2.dart';
import '../Login_Register/login_screen.dart';

class OnboardingScreenOne extends StatefulWidget {
  const OnboardingScreenOne({super.key});

  @override
  State<OnboardingScreenOne> createState() => _OnboardingScreenOneState();
}

class _OnboardingScreenOneState extends State<OnboardingScreenOne> {
  // Warna utama
  final Color mainColor = const Color(0xFF0074D9);

  // Controller
  late PageController _pageController;

  // State untuk melacak halaman aktif agar indikator bergerak
  // Kita mulai dari 1 karena initialPage di controller adalah 1
  int _currentIndex = 1;

  // Variable untuk langganan status internet
  StreamSubscription? _connectivitySubscription;

  final List<String> _images = [
    'assets/images/ob_1.jpg',
    'assets/images/ob_2.jpg',
    'assets/images/ob_3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    // 1. Setup PageController
    _pageController = PageController(viewportFraction: 0.75, initialPage: 1);

    // 2. Cek Koneksi Internet saat pertama kali buka
    _checkInitialConnection();

    // 3. (Opsional) Memantau jika koneksi putus-nyambung secara live
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      // Jika salah satu result adalah none, berarti offline
      if (results.contains(ConnectivityResult.none)) {
        _showNoInternetNotification();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _connectivitySubscription
        ?.cancel(); // Hentikan pemantauan saat keluar halaman
    super.dispose();
  }

  // --- LOGIKA CEK KONEKSI ---
  Future<void> _checkInitialConnection() async {
    // Cek status saat ini
    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());

    // Jika tidak ada koneksi (none)
    if (connectivityResult.contains(ConnectivityResult.none)) {
      _showNoInternetNotification();
    }
  }

  void _showNoInternetNotification() {
    // Pastikan widget masih aktif sebelum menampilkan snackbar
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating, // Melayang agar lebih modern
        content: Row(
          children: const [
            Icon(Icons.wifi_off, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text("Koneksi Internet Gagal. Periksa jaringan Anda."),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
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
                // UPDATE: Update state saat digeser agar indikator berubah
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
            // UPDATE: Menggunakan loop untuk generate indikator sesuai jumlah gambar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_images.length, (index) {
                // Jika index indikator sama dengan halaman saat ini, warnanya Biru.
                // Jika beda, warnanya Abu.
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

  // Widget Indikator (Desain Tetap)
  Widget _buildIndicator({required Color color}) {
    // Kita tambahkan animasi durasi agar perpindahan warna halus
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
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
