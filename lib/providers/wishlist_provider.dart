import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/destination_model.dart';

// Model khusus untuk item Wishlist
class WishlistItem {
  final String id;
  final DestinationModel destination;
  final DateTime date;

  WishlistItem({
    required this.id,
    required this.destination,
    required this.date,
  });
}

class WishlistProvider extends ChangeNotifier {
  List<WishlistItem> _wishlistItems = [];
  bool isLoading = false;
  List<WishlistItem> get wishlistItems => _wishlistItems;

  // Instance Supabase
  final _supabase = Supabase.instance.client;

  // 1. FUNGSI AMBIL DATA (FETCH)
  Future<void> fetchWishlist() async {
    // [UPDATE] Ambil user dari Supabase
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> response = await _supabase
          .from('wishlist')
          .select('id, travel_date, destinations(*)')
          .eq('user_id', user.id) // [UPDATE] Gunakan user.id Supabase
          .order('id', ascending: false);

      _wishlistItems = response.map((data) {
        final destinationData = data['destinations'];
        return WishlistItem(
          id: data['id'].toString(),
          date: DateTime.parse(data['travel_date']),
          destination: DestinationModel.fromJson(destinationData),
        );
      }).toList();
    } catch (e) {
      debugPrint("Error Fetch Wishlist: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // 2. FUNGSI TAMBAH DATA (ADD)
  Future<void> addToWishlist(
    DestinationModel destination,
    DateTime date,
  ) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('wishlist').insert({
        'user_id': user.id, // [UPDATE]
        'destination_id': int.parse(destination.id),
        'travel_date': date.toIso8601String(),
      });
      await fetchWishlist();
    } catch (e) {
      debugPrint("Error Add Wishlist: $e");
      rethrow;
    }
  }

  // 3. FUNGSI HAPUS DATA (REMOVE)
  Future<void> removeFromWishlist(String wishlistId) async {
    try {
      await _supabase.from('wishlist').delete().eq('id', wishlistId);
      _wishlistItems.removeWhere((item) => item.id == wishlistId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error Remove Wishlist: $e");
    }
  }
}
