import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/destination_model.dart';

class HomeProvider extends ChangeNotifier {
  bool isLoading = false;
  List<DestinationModel> newDestinations = [];
  List<DestinationModel> trendingDestinations = [];

  // Ambil instance client Supabase
  final _supabase = Supabase.instance.client;

  Future<void> fetchHomeData() async {
    isLoading = true;
    notifyListeners();

    try {
      // 1. Request SEMUA Data ke Table 'destinations'
      final List<dynamic> response = await _supabase
          .from('destinations')
          .select();

      // 2. Konversi ke List Model
      List<DestinationModel> allData = response
          .map((json) => DestinationModel.fromJson(json))
          .toList();

      List<DestinationModel> sortedById = List.from(allData);
      // 3. LOGIKA NEW DESTINATION (6 Terbaru berdasarkan ID)
      sortedById.sort((a, b) {
        int idA = int.tryParse(a.id) ?? 0;
        int idB = int.tryParse(b.id) ?? 0;
        return idB.compareTo(idA); // B banding A = Descending
      });

      // Ambil 6 teratas
      newDestinations = sortedById.take(6).toList();

      // 4. LOGIKA TRENDING DESTINATION (6 Terbaik berdasarkan Rating)
      List<DestinationModel> sortedByRating = List.from(allData);

      // Sort Descending (Besar ke Kecil) berdasarkan Rating
      sortedByRating.sort((a, b) => b.rating.compareTo(a.rating));

      // Ambil 6 teratas
      trendingDestinations = sortedByRating.take(6).toList();
    } catch (e) {
      debugPrint("Error fetching Supabase data: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
