import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/destination_model.dart';
import '../data/models/notification_model.dart'; // Import Model Notif
import '../services/notification_service.dart'; // Import Service

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
  // State Wishlist
  List<WishlistItem> _wishlistItems = [];
  bool isLoading = false;
  List<WishlistItem> get wishlistItems => _wishlistItems;

  // State Notifications
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  final _supabase = Supabase.instance.client;
  final _notifService = NotificationService();

  // 1. Fetch Wishlist
  Future<void> fetchWishlist() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> response = await _supabase
          .from('wishlist')
          .select('id, travel_date, destinations(*)')
          .eq('user_id', user.id)
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

  // 2. Fetch Notifications
  Future<void> fetchNotifications() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final List<dynamic> response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      _notifications = response
          .map((json) => NotificationModel.fromJson(json))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Error Fetch Notifications: $e");
    }
  }

  // 3. Add Wishlist (Lengkap dengan Notifikasi & History)
  Future<void> addToWishlist(
    DestinationModel destination,
    DateTime date,
  ) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _notifService.requestPermissions();

      // A. Simpan ke Wishlist Supabase
      final response = await _supabase
          .from('wishlist')
          .insert({
            'user_id': user.id,
            'destination_id': int.parse(destination.id),
            'travel_date': date.toIso8601String(),
          })
          .select()
          .single();

      final int newWishlistId = response['id'];

      // B. Munculkan Notifikasi HP (Langsung)
      await _notifService.showInstantNotification(
        "Berhasil Ditambahkan!",
        "Jadwal ke ${destination.name} telah disimpan.",
      );

      // C. Pasang Alarm H-1 Jam 19:00
      await _notifService.scheduleNotification(
        newWishlistId,
        "Siap-siap Liburan Besok! 🎒",
        "Besok jadwal ke ${destination.name}. Siapkan barang bawaanmu!",
        date,
      );

      // D. Simpan Riwayat Notifikasi ke Supabase
      await _supabase.from('notifications').insert({
        'user_id': user.id,
        'title': "Berhasil Ditambahkan!",
        'body': "Jadwal ke ${destination.name} telah disimpan.",
        'is_read': false,
      });

      // Refresh Data UI
      await fetchWishlist();
      await fetchNotifications();
    } catch (e) {
      debugPrint("Error Add Wishlist: $e");
      rethrow;
    }
  }

  // 4. Remove Wishlist
  Future<void> removeFromWishlist(String wishlistId) async {
    try {
      await _supabase.from('wishlist').delete().eq('id', wishlistId);

      // Batalkan alarm notifikasi
      await _notifService.cancelNotification(int.parse(wishlistId));

      _wishlistItems.removeWhere((item) => item.id == wishlistId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error Remove Wishlist: $e");
    }
  }
}
