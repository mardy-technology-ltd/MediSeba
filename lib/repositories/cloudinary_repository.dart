import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryRepository {
  static const String cloudName = 'wnxmse2e';
  static const String uploadPreset = 'mediseba_profile';
  static const String apiUrl = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  /// Uploads an image to Cloudinary and returns the secure URL
  Future<String> uploadImage(File imageFile) async {
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

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String secureUrl = responseData['secure_url'];
        return secureUrl;
      } else {
        throw Exception('Failed to upload image. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error during upload: $e');
    }
  }
}
