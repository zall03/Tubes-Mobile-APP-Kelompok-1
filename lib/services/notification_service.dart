import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 1. Inisialisasi (Dipanggil di main.dart)
  Future<void> init() async {
    tz.initializeTimeZones(); // Setup Timezone

    // Android Settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS Settings (Opsional, buat jaga-jaga)
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // 2. Request Izin (Khusus Android 13+)
  Future<void> requestPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // 3. Tampilkan Notifikasi Langsung (Saat Sukses Add)
  Future<void> showInstantNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'wiskuyy_channel',
      'Wiskuyy Notifications',
      channelDescription: 'Notifikasi aplikasi wisata',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    // ID 0 untuk notifikasi umum (selalu ditimpa)
    await flutterLocalNotificationsPlugin.show(0, title, body, details);
  }

  // 4. Jadwalkan Notifikasi (H-1 Jam 19:00)
  Future<void> scheduleNotification(
      int id, String title, String body, DateTime travelDate) async {
    
    // Hitung H-1
    final DateTime dDayMinus1 = travelDate.subtract(const Duration(days: 1));
    
    // Set Jam 19:00
    final DateTime scheduledTime = DateTime(
      dDayMinus1.year,
      dDayMinus1.month,
      dDayMinus1.day,
      19, // Jam 19
      00, // Menit 00
    );

    // Cek apakah jadwal sudah lewat? (Misal user add mepet)
    if (scheduledTime.isBefore(DateTime.now())) {
      // Jika sudah lewat jam 19:00 H-1, tidak perlu dijadwalkan
      return;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id, // ID unik dari Database agar bisa di-cancel
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'wiskuyy_schedule',
          'Travel Reminder',
          channelDescription: 'Pengingat jadwal wisata',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // 5. Hapus Jadwal Notifikasi (Saat Wishlist Dihapus)
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}