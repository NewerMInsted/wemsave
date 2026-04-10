import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/download_screen.dart';
import 'screens/about_screen.dart';

void main() {
  runApp(const WemSaveApp());
}

class WemSaveApp extends StatelessWidget {
  const WemSaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WemSave',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.poppinsTextTheme(),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1F3A),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/downloads': (context) => const DownloadScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}
