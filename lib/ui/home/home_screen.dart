import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/home_provider.dart';
import '../explore/explore_page.dart';
import '../detail/detail_screen.dart'; // [BARU] Import Detail Screen

// ===============================================================
// 1. CLASS UTAMA: HOMESCREEN (Sebagai Navigasi / Wrapper)
// ===============================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State untuk melacak halaman mana yang aktif (0 = Home)
  int _selectedIndex = 0;

  // Daftar Halaman yang akan ditampilkan
  final List<Widget> _pages = [
    const HomeBody(), // Index 0: Halaman Home
    const ExplorePage(), // Index 1: Halaman Explore
    const WishlistPage(), // Index 2: Halaman Wishlist
    const ProfilePage(), // Index 3: Halaman Profile
  ];

  // Fungsi saat tombol navigasi ditekan
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // BODY berubah sesuai halaman yang dipilih di _pages
      body: _pages[_selectedIndex],

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 0),
            _buildNavItem(Icons.explore_outlined, 1),
            _buildNavItem(Icons.list_alt, 2),
            _buildNavItem(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }

  // Widget Helper Tombol Navigasi
  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey,
          size: 28,
        ),
      ),
    );
  }
}

// ===============================================================
// 2. CLASS KONTEN: HOME BODY
// ===============================================================
class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late PageController _promoPageController;
  int _currentPromoIndex = 0;

  final List<String> _promoImages = [
    'assets/images/ob_2.jpg',
    'assets/images/ob_1.jpg',
    'assets/images/ob_3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _promoPageController = PageController(
      viewportFraction: 0.7,
      initialPage: 0,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchHomeData();
    });
  }

  @override
  void dispose() {
    _promoPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              "Wis",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Text(
              "kuyy",
              style: GoogleFonts.poppins(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.grey),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildSectionHeader("Our Promo", showArrow: false),
                  const SizedBox(height: 20),
                  _buildZoomPromoSlider(),
                  const SizedBox(height: 15),
                  _buildPromoIndicator(),
                  const SizedBox(height: 20),
                  _buildSectionHeader("New Destination"),
                  const SizedBox(height: 10),
                  _buildHorizontalList(provider.newDestinations),
                  const SizedBox(height: 20),
                  _buildSectionHeader("Trending Destination"),
                  const SizedBox(height: 10),
                  _buildHorizontalList(provider.trendingDestinations),
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }

  // --- WIDGET HELPER BAWAAN HOME BODY ---
  Widget _buildZoomPromoSlider() {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        controller: _promoPageController,
        itemCount: _promoImages.length,
        onPageChanged: (index) {
          setState(() {
            _currentPromoIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _promoPageController,
            builder: (context, child) {
              double value = 1.0;
              if (_promoPageController.position.haveDimensions) {
                value = _promoPageController.page! - index;
                value = (1 - (value.abs() * 0.2)).clamp(0.8, 1.0);
              } else {
                value = index == 0 ? 1.0 : 0.8;
              }
              return Center(
                child: SizedBox(
                  height: Curves.easeOut.transform(value) * 220,
                  width: Curves.easeOut.transform(value) * 350,
                  child: child,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(_promoImages[index]),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromoIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_promoImages.length, (index) {
        bool isActive = _currentPromoIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title, {bool showArrow = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          if (showArrow)
            const Icon(Icons.arrow_forward, color: Colors.blue, size: 20),
        ],
      ),
    );
  }

  // [MODIFIKASI] Widget List Horizontal dengan Navigasi
  Widget _buildHorizontalList(List<dynamic> data) {
    if (data.isEmpty) return const SizedBox();
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: data.length,
        padding: const EdgeInsets.only(left: 20),
        itemBuilder: (context, index) {
          final item = data[index];
          // Bungkus dengan GestureDetector
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(destination: item),
                ),
              );
            },
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(item.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ===============================================================
// 3. PLACEHOLDER PAGE
// ===============================================================

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wishlist"),
        automaticallyImplyLeading: false,
      ),
      body: const Center(child: Text("Halaman Wishlist")),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        automaticallyImplyLeading: false,
      ),
      body: const Center(child: Text("Halaman Profile")),
    );
  }
}
