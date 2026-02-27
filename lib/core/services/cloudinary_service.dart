import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService {
  static String get _cloudName =>
      dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  static String get _uploadPreset =>
      dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';
  static String get _uploadUrl =>
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

  /// Загрузить фото и вернуть secure_url
  /// [imageFile] — файл, выбранный через image_picker
  /// [folder] — папка в Cloudinary (например 'avatars')
  Future<String?> uploadImage(File imageFile, {String folder = 'avatars'}) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
      request.fields['upload_preset'] = _uploadPreset;
      request.fields['folder'] = folder;

      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return json['secure_url'] as String?;
      } else {
        final error = jsonDecode(response.body);
        throw Exception('Cloudinary error: ${error['error']?['message'] ?? response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Удалить фото по public_id (нужен API Secret — используется только на сервере)
  /// Для клиентского приложения просто перезаписываем через upload
  static String getOptimizedUrl(String originalUrl, {int width = 400, int height = 400}) {
    if (originalUrl.isEmpty) return '';
    // Вставляем трансформацию в URL Cloudinary
    // Пример: .../upload/c_fill,h_400,w_400/...
    return originalUrl.replaceFirst(
      '/upload/',
      '/upload/c_fill,h_${height},w_${width},q_auto,f_auto/',
    );
  }
}
