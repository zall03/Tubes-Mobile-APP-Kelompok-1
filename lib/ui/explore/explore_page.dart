import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/explore_provider.dart';
import '../../data/models/destination_model.dart';
import '../detail/detail_screen.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExploreProvider>(context);

    // Variabel Tema
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Warna Search Bar (Gelap di Dark Mode, Abu terang di Light Mode)
    final searchBarColor = isDark ? Colors.grey[800] : Colors.grey[100];

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // --- SEARCH BAR ---
              TextField(
                style: TextStyle(color: textColor), // Warna teks ketikan
                decoration: InputDecoration(
                  hintText: "Search destination...",
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: const Icon(Icons.tune, color: Colors.grey),
                  filled: true,
                  fillColor: searchBarColor, // Dinamis
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 20,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- DROPDOWN ---
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0074D9), // Biru tetap
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: provider.selectedCategory,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    dropdownColor: const Color(0xFF0074D9),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        provider.changeCategory(newValue);
                      }
                    },
                    items: provider.categories.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- GRID VIEW ---
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.filteredDestinations.isEmpty
                    ? Center(
                        child: Text(
                          "Tidak ada wisata ditemukan",
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      )
                    : GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: provider.filteredDestinations.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 0.75,
                            ),
                        itemBuilder: (context, index) {
                          final item = provider.filteredDestinations[index];
                          // Kirim context agar navigator bekerja
                          return _buildDestinationCard(
                            context,
                            item,
                            textColor,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationCard(
    BuildContext context,
    DestinationModel item,
    Color textColor,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(destination: item),
          ),
        );
      },
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
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: textColor, // Dinamis
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            item.category,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
