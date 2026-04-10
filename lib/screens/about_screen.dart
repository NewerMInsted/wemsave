import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/wem_app_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WemAppBar(title: 'О приложении', showLogo: false),
      backgroundColor: const Color(0xFF0A0E21),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Лого
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9D4EDD), Color(0xFF3C096C)],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9D4EDD).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'W',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'WemSave',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF9D4EDD).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF9D4EDD).withOpacity(0.3)),
              ),
              child: Text(
                'v1.0.0',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFFE0AAFF),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Карточка разработчика
            _buildInfoCard(
              title: 'Разработчик',
              icon: Icons.code,
              children: [
                _buildInfoRow('Имя', 'Wemiann'),
                _buildInfoRow('Discord', '@Wemiann'),
                _buildInfoRow('Роль', 'Full-stack Developer'),
              ],
            ),
            const SizedBox(height: 20),
            
            // Карточка контактов
            _buildInfoCard(
              title: 'Связь со мной',
              icon: Icons.chat,
              children: [
                InkWell(
                  onTap: () => _openDiscord(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5865F2).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.discord, color: Color(0xFF5865F2)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Discord',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '@Wemiann',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Кнопка поделиться
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _shareApp(context),
                icon: const Icon(Icons.share),
                label: Text(
                  'Поделиться с друзьями',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9D4EDD),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            Text(
              '© 2024 Wemiann. Все права защищены.',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white38),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Создано с ❤️ для сообщества',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white38),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF9D4EDD), size: 22),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 15, color: Colors.white60)),
          Text(value, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
        ],
      ),
    );
  }

  void _openDiscord() async {
    const url = 'https://discord.com/users/wemiann';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _shareApp(BuildContext context) {
    Share.share(
      'Попробуй WemSave! Приложение для скачивания видео из ВК, YouTube и Pinterest.\n'
      'Создано Wemiann (@Wemiann в Discord)',
      subject: 'WemSave - Скачивание видео',
    );
  }
}
