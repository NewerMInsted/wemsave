import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/wem_app_bar.dart';
import '../widgets/wem_drawer.dart';
import '../services/download_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  final DownloadService _downloadService = DownloadService();
  bool _isLoading = false;
  String? _videoTitle;
  String? _videoThumbnail;
  List<Map<String, String>> _availableQualities = [];
  String? _selectedQuality;

  final List<Map<String, dynamic>> _platforms = [
    {
      'name': 'ВКонтакте',
      'color': const Color(0xFF0077FF),
      'icon': Icons.people,
      'domain': 'vk.com'
    },
    {
      'name': 'YouTube',
      'color': const Color(0xFFFF0000),
      'icon': Icons.play_circle,
      'domain': 'youtube.com'
    },
    {
      'name': 'Pinterest',
      'color': const Color(0xFFE60023),
      'icon': Icons.image,
      'domain': 'pinterest.com'
    },
  ];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    if (data != null && data.text != null) {
      _urlController.text = data.text!;
      setState(() {});
      _analyzeUrl();
    }
  }

  void _analyzeUrl() {
    final url = _urlController.text.toLowerCase();
    for (var platform in _platforms) {
      if (url.contains(platform['domain'])) {
        setState(() {});
        return;
      }
    }
  }

  Future<void> _fetchVideoInfo() async {
    if (_urlController.text.isEmpty) {
      _showSnackBar('Вставь ссылку на видео', Colors.redAccent);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final videoInfo = await _downloadService.getVideoInfo(_urlController.text);
      setState(() {
        _videoTitle = videoInfo['title'];
        _videoThumbnail = videoInfo['thumbnail'];
        _availableQualities = videoInfo['qualities'] as List<Map<String, String>>;
        _selectedQuality = _availableQualities.isNotEmpty ? _availableQualities.first['value'] : null;
      });
    } catch (e) {
      _showSnackBar('Ошибка: $e', Colors.redAccent);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _downloadVideo() async {
    if (_selectedQuality == null) {
      _showSnackBar('Выбери качество', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _downloadService.downloadVideo(
        _urlController.text,
        _selectedQuality!,
        onProgress: (progress) {
          setState(() {});
        },
      );

      if (result['success']) {
        _showSnackBar('Видео сохранено в галерею!', Colors.green);
        _urlController.clear();
        setState(() {
          _videoTitle = null;
          _videoThumbnail = null;
          _availableQualities = [];
        });
      } else {
        _showSnackBar('Ошибка: ${result['error']}', Colors.redAccent);
      }
    } catch (e) {
      _showSnackBar('Ошибка загрузки: $e', Colors.redAccent);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WemAppBar(title: 'WemSave'),
      drawer: const WemDrawer(),
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Приветствие
              _buildHeader(),
              const SizedBox(height: 20),

              // Платформы
              _buildPlatformsList(),
              const SizedBox(height: 25),

              // Поле ввода
              _buildUrlInput(),
              const SizedBox(height: 15),

              // Кнопка анализа
              if (_videoTitle == null) _buildAnalyzeButton(),
              const SizedBox(height: 20),

              // Информация о видео
              if (_videoTitle != null) _buildVideoInfo(),
              const SizedBox(height: 20),

              // Кнопка скачивания
              if (_videoTitle != null && _availableQualities.isNotEmpty) _buildDownloadButton(),
              const SizedBox(height: 15),

              // Контакты
              _buildContactInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9D4EDD), Color(0xFF5A189A)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Wem',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Привет!',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformsList() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _platforms.map((platform) {
        final isActive = _urlController.text.toLowerCase().contains(platform['domain']);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: platform['color'].withOpacity(isActive ? 0.2 : 0.05),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: platform['color'].withOpacity(isActive ? 0.6 : 0.2),
              width: isActive ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(platform['icon'], color: platform['color'], size: 18),
              const SizedBox(width: 6),
              Text(
                platform['name'],
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: isActive ? platform['color'] : Colors.white60,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUrlInput() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9D4EDD).withOpacity(0.1),
            blurRadius: 20,
          ),
        ],
      ),
      child: TextField(
        controller: _urlController,
        style: GoogleFonts.poppins(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Вставь ссылку из VK, YouTube или Pinterest',
          hintStyle: GoogleFonts.poppins(color: Colors.white38),
          prefixIcon: const Icon(Icons.link, color: Color(0xFF9D4EDD)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.paste, color: Colors.white38),
            onPressed: _pasteFromClipboard,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _fetchVideoInfo,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9D4EDD),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search),
                  const SizedBox(width: 10),
                  Text(
                    'Найти видео',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.movie, color: Color(0xFF9D4EDD)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _videoTitle ?? 'Видео',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'Качество:',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white60),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableQualities.map((quality) {
              final isSelected = _selectedQuality == quality['value'];
              return ChoiceChip(
                label: Text(
                  quality['label']!,
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedQuality = quality['value'];
                  });
                },
                backgroundColor: Colors.transparent,
                selectedColor: const Color(0xFF9D4EDD),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF9D4EDD) : Colors.white24,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _downloadVideo,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Icon(Icons.download_rounded),
        label: Text(
          _isLoading ? 'Скачивание...' : 'Скачать видео',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9D4EDD),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF9D4EDD).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.discord, color: Color(0xFF5865F2)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Связь с разработчиком',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Discord: @Wemiann',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
