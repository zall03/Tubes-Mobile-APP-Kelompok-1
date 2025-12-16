import 'package:flutter/material.dart';
import '../../data/models/destination_model.dart'; // Pastikan import model Anda benar

class DetailScreen extends StatelessWidget {
  final DestinationModel destination;

  const DetailScreen({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar transparan/minimalis sesuai desain
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context), // Navigasi kembali
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Gambar Utama (Rounded)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  destination.imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Nama Destinasi & Deskripsi
            Text(
              destination.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Sesuai warna desain
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Kategori: ${destination.category} • Deskripsi singkat tempat wisata yang menakjubkan ini.",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // 3. Rating
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 20),
                const SizedBox(width: 4),
                Text(
                  destination.rating.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 4. Tombol Add Wishlist (Bisa dipakai untuk Shared Preferences nanti)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implementasi simpan ke Shared Preferences
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Ditambahkan ke Wishlist!"),
                    ), //
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Add Wishlist",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 5. Other Destination (Horizontal List)
            const Text(
              "Other Destination",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160, // Tinggi area scroll horizontal
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Contoh data dummy
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return _buildRecommendationCard();
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      // Catatan: BottomNavigationBar biasanya ada di MainScreen, bukan di DetailScreen
    );
  }

  // Widget kecil untuk item rekomendasi
  Widget _buildRecommendationCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: Colors.grey[200],
            width: 120,
            height: 120,
            child: const Icon(
              Icons.image,
              color: Colors.grey,
            ), // Placeholder gambar
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Nama Wisata",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }
}
