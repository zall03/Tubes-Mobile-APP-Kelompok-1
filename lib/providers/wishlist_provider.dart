import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // [WAJIB] Pastikan import intl untuk format tanggal
import '../data/models/destination_model.dart';
import '../data/models/notification_model.dart';
import '../services/notification_service.dart';

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

  // --- 1. FETCH WISHLIST (DENGAN AUTO-DELETE & NOTIFIKASI KADALUARSA) ---
  Future<void> fetchWishlist() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    isLoading = true;
    notifyListeners();

    try {
      // Ambil data dari Supabase
      final List<dynamic> response = await _supabase
          .from('wishlist')
          .select('id, travel_date, destinations(*)')
          .eq('user_id', user.id)
          .order('travel_date', ascending: true);

      final List<WishlistItem> activeItems = [];

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      for (var data in response) {
        final scheduledDate = DateTime.parse(data['travel_date']);
        final scheduledDateOnly = DateTime(
            scheduledDate.year, scheduledDate.month, scheduledDate.day);

        // Ambil nama wisata untuk pesan notifikasi
        final String destName = data['destinations']['name'] ?? 'Wisata';
        final String dateStr = DateFormat('dd MMM yyyy').format(scheduledDate);

        // [LOGIKA AUTO DELETE]
        if (scheduledDateOnly.isBefore(today)) {
          // 1. Hapus dari Database Wishlist
          await _supabase.from('wishlist').delete().eq('id', data['id']);

          // 2. Batalkan alarm lokal
          await _notifService.cancelNotification(data['id']);

          // 3. [BARU] Simpan Pesan "Kadaluwarsa" ke Notifikasi Supabase
          await _supabase.from('notifications').insert({
            'user_id': user.id,
            'title': "Jadwal Kadaluwarsa ⏳",
            'body':
                "Jadwal ke $destName pada tanggal $dateStr otomatis dihapus karena sudah terlewat.",
            'is_read': false,
          });

          debugPrint(
              "Item ID ${data['id']} dihapus & dinotifikasi kadaluwarsa.");
        } else {
          // Jika masih aktif
          final destinationData = data['destinations'];
          activeItems.add(
            WishlistItem(
              id: data['id'].toString(),
              date: scheduledDate,
              destination: DestinationModel.fromJson(destinationData),
            ),
          );
        }
      }

      _wishlistItems = activeItems;
    } catch (e) {
      debugPrint("Error Fetch Wishlist: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // --- 2. FETCH NOTIFICATIONS ---
  Future<void> fetchNotifications() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final List<dynamic> response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      _notifications =
          response.map((json) => NotificationModel.fromJson(json)).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Error Fetch Notifications: $e");
    }
  }

  // --- 3. ADD WISHLIST ---
  Future<void> addToWishlist(
    DestinationModel destination,
    DateTime date,
  ) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _notifService.requestPermissions();

      // A. Insert Wishlist
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
      final String dateStr = DateFormat('dd MMM yyyy').format(date);

      // B. Notifikasi HP
      await _notifService.showInstantNotification(
        "Berhasil Ditambahkan!",
        "Jadwal ke ${destination.name} telah disimpan.",
      );

      // C. Alarm H-1
      await _notifService.scheduleNotification(
        newWishlistId,
        "Siap-siap Liburan Besok! ",
        "Besok jadwal ke ${destination.name}. Siapkan barang bawaanmu!",
        date,
      );

      // D. Simpan Riwayat Notifikasi (Success Add)
      await _supabase.from('notifications').insert({
        'user_id': user.id,
        'title': "Jadwal Dibuat ✅",
        'body':
            "Berhasil mengatur jadwal ke ${destination.name} untuk tanggal $dateStr.",
        'is_read': false,
      });

      await fetchWishlist();
      await fetchNotifications();
    } catch (e) {
      debugPrint("Error Add Wishlist: $e");
      rethrow;
    }
  }

  // --- 4. REMOVE WISHLIST (DENGAN NOTIFIKASI DIHAPUS) ---
  Future<void> removeFromWishlist(String wishlistId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      // 1. Cari dulu data itemnya (untuk ambil nama wisata) sebelum dihapus
      final itemToDelete = _wishlistItems.firstWhere(
        (item) => item.id == wishlistId,
        orElse: () => throw Exception("Item not found"),
      );

      final String destName = itemToDelete.destination.name;

      // 2. Hapus dari Supabase Wishlist
      await _supabase.from('wishlist').delete().eq('id', wishlistId);

      // 3. Hapus Alarm Lokal
      await _notifService.cancelNotification(int.parse(wishlistId));

      // 4. [BARU] Simpan Pesan "Dihapus" ke Notifikasi Supabase
      await _supabase.from('notifications').insert({
        'user_id': user.id,
        'title': "Jadwal Dihapus 🗑️",
        'body': "Anda telah menghapus jadwal kunjungan ke $destName.",
        'is_read': false,
      });

      // 5. Update UI
      _wishlistItems.removeWhere((item) => item.id == wishlistId);

      // Refresh notifikasi agar pesan penghapusan langsung muncul
      await fetchNotifications();

      notifyListeners();
    } catch (e) {
      debugPrint("Error Remove Wishlist: $e");
    }
  }
}
