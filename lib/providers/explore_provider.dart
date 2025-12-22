import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/destination_model.dart';

class ExploreProvider extends ChangeNotifier {
  // 1. Daftar Kategori
  final List<String> categories = [
    'Semua',
    'Gunung',
    'Pantai',
    'Curug',
    'Danau',
  ];
  String selectedCategory = 'Semua';

  // 2. State Data
  bool isLoading = false;
  List<DestinationModel> _allDestinations = []; // Data mentah (Private)

  // [BARU] Getter agar data bisa diakses dari DetailScreen
  List<DestinationModel> get allDestinations => _allDestinations;

  // Client Supabase
  final _supabase = Supabase.instance.client;

  // Constructor
  ExploreProvider() {
    fetchExploreData();
  }

  // 3. Fungsi Ambil Data Supabase
  Future<void> fetchExploreData() async {
    isLoading = true;
    notifyListeners();

    try {
      // Ambil semua data dari Supabase
      final List<dynamic> response = await _supabase
          .from('destinations')
          .select();

      _allDestinations = response
          .map((json) => DestinationModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint("Error Explore Supabase: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // 4. Getter: Mengambil data yang sudah difilter (Untuk Halaman Explore)
  List<DestinationModel> get filteredDestinations {
    if (selectedCategory == 'Semua') {
      return _allDestinations;
    }
    // Filter logika (Case Insensitive: gunung == Gunung)
    return _allDestinations
        .where(
          (item) =>
              item.category.toLowerCase() == selectedCategory.toLowerCase(),
        )
        .toList();
  }

  // 5. Fungsi Mengganti Kategori
  void changeCategory(String newCategory) {
    selectedCategory = newCategory;
    notifyListeners(); // Update UI agar GridView berubah
  }
}
