import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/login_screen.dart';
import 'services/database_service.dart';
import 'services/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await HiveService.init();

  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  await DatabaseService.initSupabase(
    url: supabaseUrl,
    publishableKey: supabaseKey,
  );

  runApp(const SalviettiApp());
}

class SalviettiApp extends StatelessWidget {
  const SalviettiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salvietti Planta',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
