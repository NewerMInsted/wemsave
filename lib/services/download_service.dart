import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'video_extractor.dart';

class DownloadService {
  final Dio _dio = Dio();
  final VideoExtractor _extractor = VideoExtractor();
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  DownloadService() {
    _initNotifications();
  }

  void _initNotifications() {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    _notifications.initialize(settings);
  }

  Future<Map<String, dynamic>> getVideoInfo(String url) async {
    try {
      return await _extractor.extractInfo(url);
    } catch (e) {
      throw Exception('Не удалось получить информацию о видео: $e');
    }
  }

  Future<Map<String, dynamic>> downloadVideo(
    String url,
    String quality, {
    Function(double)? onProgress,
  }) async {
    try {
      // Получаем прямую ссылку на видео
      final videoUrl = await _extractor.extractVideoUrl(url, quality);
      
      // Путь для сохранения
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download/WemSave');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final fileName = 'WemSave_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final filePath = '${directory.path}/$fileName';

      // Показываем уведомление о начале загрузки
      await _showNotification('Начало загрузки', 'Скачивание видео...');

      // Скачиваем файл
      await _dio.download(
        videoUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            onProgress(received / total);
          }
        },
      );

      // Сохраняем в галерею
      await GallerySaver.saveVideo(filePath, albumName: 'WemSave');

      // Уведомление об успехе
      await _showNotification('Загрузка завершена', 'Видео сохранено в WemSave');

      return {'success': true, 'path': filePath};
    } catch (e) {
      await _showNotification('Ошибка загрузки', e.toString());
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<void> _showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'download_channel',
      'Загрузки WemSave',
      channelDescription: 'Уведомления о загрузке видео',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const details = NotificationDetails(android: androidDetails);
    
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }
}
