import 'dart:convert';

import 'package:http/http.dart' as http;

class GeminiConfig {
  GeminiConfig._();

  static const String _keyUrl =
      'http://165.22.58.114/apps/lk/helafits/config/getPremiumkey.php';

  static String? _cachedApiKey;

  static Future<String> getApiKey() async {
    final cachedKey = _cachedApiKey;

    if (cachedKey != null && cachedKey.trim().isNotEmpty) {
      return cachedKey.trim();
    }

    try {
      final response = await http.get(
        Uri.parse(_keyUrl),
        headers: const {
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Key server returned HTTP ${response.statusCode}',
        );
      }

      final responseBody = response.body.trim();

      if (responseBody.isEmpty) {
        throw Exception('Key server returned an empty response');
      }

      final apiKey = _extractApiKey(responseBody);

      if (apiKey.isEmpty) {
        throw Exception(
          'Gemini API key was not found in the server response',
        );
      }

      _cachedApiKey = apiKey;
      return apiKey;
    } catch (error) {
      throw Exception(
        'Unable to load Gemini API key: $error',
      );
    }
  }

  static String _extractApiKey(String responseBody) {
    try {
      final dynamic decoded = jsonDecode(responseBody);

      if (decoded is Map) {
        return (decoded['apiKey'] ??
            decoded['api_key'] ??
            decoded['key'] ??
            decoded['premiumKey'] ??
            decoded['premium_key'] ??
            decoded['data']?['apiKey'] ??
            decoded['data']?['api_key'] ??
            decoded['data']?['key'] ??
            '')
            .toString()
            .trim();
      }

      if (decoded is String) {
        return decoded.trim();
      }
    } on FormatException {
      // Endpoint එක plain-text key එකක් return කරනවා නම්.
      return responseBody.trim();
    }

    return '';
  }

  static void clearCachedApiKey() {
    _cachedApiKey = null;
  }
}