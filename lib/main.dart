// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:smart_grocery_app/providers/grocery_provider.dart';
import 'package:smart_grocery_app/screens/home_screen.dart';

void main() {
  // Initialize sqflite ffi for desktop (Windows, macOS, Linux)
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroceryProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Grocery App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 4,
            centerTitle: true,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),

          // <-- REPLACE: use CardThemeData (type expected by this Flutter version)
          cardTheme: const CardThemeData(
            margin: EdgeInsets.all(8),
            elevation: 3,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
