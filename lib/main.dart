import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/home_provider.dart';
import 'providers/explore_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/theme_provider.dart'; // [BARU] Import Theme Provider
import 'ui/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://xfqladronqbapnaagvgr.supabase.co', // URL Supabase Anda
    anonKey: 'sb_publishable_Z2BVYV74vH4KFEWWljxUVA_Pb_5z0U2', // Key Anda
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ExploreProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ), // [BARU] Daftar disini
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // [BARU] Ambil state theme dari Provider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wiskuyy',

      // [PENTING] Konfigurasi Tema
      themeMode: themeProvider.themeMode,

      // 1. TEMA TERANG (Light)
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0074D9),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // Warna Teks/Icon AppBar
        ),
      ),

      // 2. TEMA GELAP (Dark)
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(
          0xFF121212,
        ), // Warna Background Gelap
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0074D9),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Colors.white,
        ),
      ),

      home: const SplashScreen(),
    );
  }
}
