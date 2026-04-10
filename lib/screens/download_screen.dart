import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/wem_app_bar.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WemAppBar(title: 'Мои загрузки', showLogo: false),
      backgroundColor: const Color(0xFF0A0E21),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.download_done_rounded,
              size: 80,
              color: const Color(0xFF9D4EDD).withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            Text(
              'Скоро здесь будет история загрузок',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white60,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Все скачанные видео сохраняются\nв папку WemSave',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white38,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
