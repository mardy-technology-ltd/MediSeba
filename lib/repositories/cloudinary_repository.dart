import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/api_logger.dart';

class CloudinaryRepository {
  static const String cloudName = 'wnxmse2e';
  static const String uploadPreset = 'mediseba_profile';
  static const String apiUrl = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  /// Uploads an image to Cloudinary and returns the secure URL
  Future<String> uploadImage(File imageFile) async {
    final stopwatch = Stopwatch()..start();
    final reqId = ApiLogger.logRequest(
      screen: 'Profile / Image Picker',
      trigger: 'Upload Image Button',
      functionName: 'uploadImage',
      isUserAction: true,
      method: 'POST (Multipart)',
      url: apiUrl,
      body: {'upload_preset': uploadPreset, 'file_path': imageFile.path},
    );

    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      
      request.fields['upload_preset'] = uploadPreset;
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String secureUrl = responseData['secure_url'];
        return secureUrl;
      } else {
        throw Exception('Failed to upload image. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Profile / Image Picker',
        trigger: 'Upload Image Button',
        functionName: 'uploadImage',
        method: 'POST (Multipart)',
        url: apiUrl,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
      throw Exception('Network error during upload: $e');
    }
  }
}
