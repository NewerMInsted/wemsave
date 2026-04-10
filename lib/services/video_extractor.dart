import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoExtractor {
  
  Future<Map<String, dynamic>> extractInfo(String url) async {
    // Определяем платформу
    if (url.contains('youtube.com') || url.contains('youtu.be')) {
      return _extractYouTube(url);
    } else if (url.contains('vk.com')) {
      return _extractVK(url);
    } else if (url.contains('pinterest.com')) {
      return _extractPinterest(url);
    } else {
      throw Exception('Неподдерживаемая платформа');
    }
  }

  Future<String> extractVideoUrl(String url, String quality) async {
    if (url.contains('youtube.com') || url.contains('youtu.be')) {
      return _getYouTubeDirectUrl(url, quality);
    } else if (url.contains('vk.com')) {
      return _getVKDirectUrl(url, quality);
    } else if (url.contains('pinterest.com')) {
      return _getPinterestDirectUrl(url, quality);
    } else {
      throw Exception('Неподдерживаемая платформа');
    }
  }

  // YouTube
  Future<Map<String, dynamic>> _extractYouTube(String url) async {
    try {
      // Извлекаем ID видео
      String videoId;
      if (url.contains('youtu.be')) {
        videoId = url.split('/').last.split('?').first;
      } else if (url.contains('v=')) {
        videoId = url.split('v=').last.split('&').first;
      } else {
        videoId = url.split('/').last;
      }

      // Используем oEmbed API для получения информации
      final oEmbedUrl = 'https://www.youtube.com/oembed?url=https://youtube.com/watch?v=$videoId&format=json';
      final response = await http.get(Uri.parse(oEmbedUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        return {
          'title': data['title'] ?? 'YouTube Video',
          'thumbnail': data['thumbnail_url'] ?? '',
          'qualities': [
            {'label': 'Высокое (720p)', 'value': '720p'},
            {'label': 'Среднее (480p)', 'value': '480p'},
            {'label': 'Низкое (360p)', 'value': '360p'},
            {'label': 'Только аудио (MP3)', 'value': 'audio'},
          ],
        };
      }
      
      throw Exception('Не удалось получить информацию');
    } catch (e) {
      return {
        'title': 'Видео YouTube',
        'thumbnail': '',
        'qualities': [
          {'label': 'Стандартное', 'value': '720p'},
        ],
      };
    }
  }

  Future<String> _getYouTubeDirectUrl(String url, String quality) async {
    // Заглушка - в реальности нужно использовать youtube_explode_dart
    // или API сервис для получения прямой ссылки
    throw Exception('Для YouTube требуется дополнительная настройка');
  }

  // VK
  Future<Map<String, dynamic>> _extractVK(String url) async {
    try {
      return {
        'title': 'Видео ВКонтакте',
        'thumbnail': '',
        'qualities': [
          {'label': 'HD (720p)', 'value': '720p'},
          {'label': 'SD (480p)', 'value': '480p'},
          {'label': 'Низкое (360p)', 'value': '360p'},
        ],
      };
    } catch (e) {
      throw Exception('Не удалось получить информацию о видео ВК');
    }
  }

  Future<String> _getVKDirectUrl(String url, String quality) async {
    // Заглушка для VK
    throw Exception('Для ВК требуется дополнительная настройка');
  }

  // Pinterest
  Future<Map<String, dynamic>> _extractPinterest(String url) async {
    try {
      return {
        'title': 'Видео Pinterest',
        'thumbnail': '',
        'qualities': [
          {'label': 'Оригинал', 'value': 'original'},
          {'label': 'Среднее', 'value': 'medium'},
        ],
      };
    } catch (e) {
      throw Exception('Не удалось получить информацию о видео Pinterest');
    }
  }

  Future<String> _getPinterestDirectUrl(String url, String quality) async {
    // Заглушка для Pinterest
    throw Exception('Для Pinterest требуется дополнительная настройка');
  }
}
