import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import 'package:provider/provider.dart';
import 'providers/home_provider.dart';
import 'providers/explore_provider.dart';
import 'ui/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Init Firebase (Untuk Login Auth jika masih pakai Firebase)
  await Firebase.initializeApp();

  // 2. Init Supabase (Untuk Data Wisata)
  await Supabase.initialize(
    url: 'https://xfqladronqbapnaagvgr.supabase.co',
    anonKey: 'sb_publishable_Z2BVYV74vH4KFEWWljxUVA_Pb_5z0U2',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ExploreProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
// ... sisa kode MyApp tetap sama

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wiskuyy',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0074D9)),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}
