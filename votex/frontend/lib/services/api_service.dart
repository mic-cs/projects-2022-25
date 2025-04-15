import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:votex/config/remote_config_service.dart';

class ApiService {
  final String baseUrl = 'http://192.168.43.13:8000';

  // ApiService({required RemoteConfigService remoteConfigService})
  // : baseUrl = remoteConfigService.apiBaseUrl;

  // test
  Future<String> hello() async {
    final response = await http.get(Uri.parse('$baseUrl/hello-world'));
    return response.body;
  }

  // Send otp to the user wih `verificationId` retrieved from qr code.
  Future<bool> sendOtp({required String verificationId}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'verification_id': verificationId,
      }),
    );
    return response.statusCode == 200;
  }

  // Get user phone
  Future<String> getPhone({required String verificationId}) async {
    final response =
        await http.get(Uri.parse('$baseUrl/users/$verificationId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final phone = data['phone'];
      return phone;
    } else {
      return 'phone';
    }
  }

  // Verify the otp
  Future<bool> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verfy-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'verification_id': verificationId,
        'otp': otp,
      }),
    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>> getUser({
    required String verificationId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/$verificationId'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return {};
  }

  // Face verification
  Future<Map<String, dynamic>> faceVerify({
    required String verificationId,
    required File image,
  }) async {
    final uri = Uri.parse('$baseUrl/auth/face_verification');
    final request = http.MultipartRequest('POST', uri);

    request.fields['verification_id'] = verificationId;

    // Prepare the image
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
    final fileStream = http.ByteStream(image.openRead());
    final fileLength = await image.length();

    final multipartFile = http.MultipartFile(
      'image',
      fileStream,
      fileLength,
      filename: image.path.split('/').last,
      contentType: mimeTypeData != null
          ? MediaType(mimeTypeData[0], mimeTypeData[1])
          : null,
    );
    request.files.add(multipartFile);

    final response = await request.send();
    final responseData = await http.Response.fromStream(response);

    if (response.statusCode != 200) {
      throw Exception("Filed to verify face: ${responseData.body}");
    }

    return jsonDecode(responseData.body) as Map<String, dynamic>;
  }
}
