import 'package:flutter/material.dart';
import 'package:notes_app/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromARGB(255, 144, 100, 221),
        scaffoldBackgroundColor: Colors.grey.shade100,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: const Color.fromARGB(255, 159, 129, 209),
          secondary: Colors.amber,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 63, 119, 192),
          foregroundColor: Colors.white,
          elevation: 3,
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 91, 5, 239),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
