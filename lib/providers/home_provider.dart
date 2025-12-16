import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Ganti http dengan ini
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
      // 1. Request Data ke Table 'destinations'
      // Ini setara dengan GET request di REST API
      final List<dynamic> response = await _supabase
          .from('destinations')
          .select()
          .order('id', ascending: true); // Urutkan data

      // 2. Konversi ke Model
      // Supabase langsung mengembalikan List<Map>, jadi tidak perlu jsonDecode
      List<DestinationModel> allData = response
          .map((json) => DestinationModel.fromJson(json))
          .toList();

      // 3. Bagi Data untuk UI
      newDestinations = allData.take(3).toList();
      trendingDestinations = allData.length > 3 ? allData.sublist(3) : allData;
    } catch (e) {
      debugPrint("Error fetching Supabase data: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
