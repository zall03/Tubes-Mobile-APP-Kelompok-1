import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/destination_model.dart';
import '../../providers/explore_provider.dart';
import '../../providers/wishlist_provider.dart';

class DetailScreen extends StatefulWidget {
  final DestinationModel destination;
  const DetailScreen({super.key, required this.destination});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ExploreProvider>(context, listen: false);
      if (provider.allDestinations.isEmpty) {
        provider.fetchExploreData();
      }
    });
  }

  Future<void> _selectDateAndAddWishlist(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                  ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (!mounted) return;
      Provider.of<WishlistProvider>(
        context,
        listen: false,
      ).addToWishlist(widget.destination, picked);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Jadwal ke ${widget.destination.name} berhasil disimpan!",
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Variabel Tema
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).colorScheme.onSurface;

    final exploreProvider = Provider.of<ExploreProvider>(context);
    final List<DestinationModel> relatedDestinations =
        exploreProvider.allDestinations
            .where(
              (item) =>
                  item.category.toLowerCase() ==
                      widget.destination.category.toLowerCase() &&
                  item.id != widget.destination.id,
            )
            .toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- GAMBAR UTAMA ---
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.destination.imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- NAMA & KATEGORI ---
            Text(
              widget.destination.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Kategori: ${widget.destination.category}",
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.7),
              ),
            ),

            const SizedBox(height: 12),

            // --- [BARU] LOKASI ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on,
                    color: Colors.redAccent, size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.destination.location, // Mengambil data lokasi
                    style: TextStyle(
                      fontSize: 15,
                      color: textColor.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // --- RATING ---
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 20),
                const SizedBox(width: 4),
                Text(
                  widget.destination.rating.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // --- [BARU] DESKRIPSI ---
            Text(
              "Tentang Wisata",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.destination.description, // Mengambil data deskripsi
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.5, // Spasi antar baris agar nyaman dibaca
                color: textColor.withOpacity(0.8),
              ),
            ),

            const SizedBox(height: 24),

            // --- TOMBOL ADD WISHLIST ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _selectDateAndAddWishlist(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Add Wishlist & Schedule",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- REKOMENDASI LAINNYA ---
            if (relatedDestinations.isNotEmpty) ...[
              Text(
                "Other Destination",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: relatedDestinations.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                  itemBuilder: (context, index) => _buildRecommendationCard(
                    context,
                    relatedDestinations[index],
                    textColor,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 30), // Padding bawah tambahan
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    DestinationModel item,
    Color textColor,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(destination: item),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              item.imageUrl,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 120,
            child: Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
