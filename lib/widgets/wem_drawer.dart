import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class WemDrawer extends StatelessWidget {
  const WemDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1A1F3A),
      child: Column(
        children: [
          // Шапка
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF9D4EDD).withOpacity(0.8),
                  const Color(0xFF3C096C).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE0AAFF), Color(0xFF9D4EDD)],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'W',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Wemiann',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Разработчик WemSave',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => _openDiscord(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5865F2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          '@Wemiann',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Меню
          ListTile(
            leading: const Icon(Icons.home, color: Color(0xFF9D4EDD)),
            title: Text('Главная', style: GoogleFonts.poppins(color: Colors.white)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.download, color: Color(0xFF9D4EDD)),
            title: Text('Мои загрузки', style: GoogleFonts.poppins(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/downloads');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Color(0xFF9D4EDD)),
            title: Text('О приложении', style: GoogleFonts.poppins(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/about');
            },
          ),
          
          const Spacer(),
          
          // Футер
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Divider(color: Colors.white24),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSocialButton(
                      icon: Icons.share,
                      label: 'Поделиться',
                      onTap: () => _shareApp(),
                    ),
                    _buildSocialButton(
                      icon: Icons.discord,
                      label: 'Discord',
                      onTap: () => _openDiscord(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'WemSave v1.0.0',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white38),
                ),
                const SizedBox(height: 4),
                Text(
                  'Made with ❤️ by Wemiann',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white38),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF9D4EDD), size: 18),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  void _openDiscord() async {
    const url = 'https://discord.com/users/wemiann';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _shareApp() {
    Share.share(
      'Попробуй WemSave! Приложение для скачивания видео из ВК, YouTube и Pinterest.\n'
      'Создано Wemiann (@Wemiann в Discord)',
      subject: 'WemSave - Скачивание видео',
    );
  }
}
