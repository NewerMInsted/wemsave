import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'video_extractor.dart';

class DownloadService {
  final Dio _dio = Dio();
  final VideoExtractor _extractor = VideoExtractor();

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
      final videoUrl = await _extractor.extractVideoUrl(url, quality);
      
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

      await _dio.download(
        videoUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            onProgress(received / total);
          }
        },
      );

      await ImageGallerySaver.saveFile(filePath, name: 'WemSave');

      return {'success': true, 'path': filePath};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
