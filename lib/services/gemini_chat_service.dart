import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/gemini_config.dart';

class GeminiChatReply {
  final String text;
  final String interactionId;

  GeminiChatReply({
    required this.text,
    required this.interactionId,
  });
}

class GeminiChatException implements Exception {
  final String message;

  GeminiChatException(this.message);

  @override
  String toString() => message;
}

class GeminiChatService {
  static const String _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/interactions';

  Future<GeminiChatReply> askQuestion({
    required String question,
    String? previousInteractionId,
  }) async {
    final trimmedQuestion = question.trim();

    if (trimmedQuestion.isEmpty) {
      throw GeminiChatException(
        'Please enter a question.',
      );
    }

    try {
      // Gemini key එක PHP server එකෙන් load කරනවා.
      final apiKey = await GeminiConfig.getApiKey();

      if (apiKey.trim().isEmpty) {
        throw GeminiChatException(
          'Gemini API key could not be loaded.',
        );
      }

      final farmerPrompt = '''
You are AgriChatbot, a helpful agriculture assistant for Sri Lankan farmers.

Answer in a clean, short, farmer-friendly format.

Rules:
- Help with paddy, vegetables, fruits, soil, compost, irrigation, pests, diseases, and harvesting.
- Always answer in BOTH Sinhala and English.
- Use simple words.
- Keep each language section short.
- Give a maximum of 3 practical steps.
- Do not give dangerous pesticide mixing instructions.
- For serious disease or chemical problems, tell the farmer to contact a local agricultural officer.

Return ONLY this Markdown format:

## සිංහල

**හේතුව:**  
Write one short explanation.

**කළ යුතු දේ:**  
- Step 1
- Step 2
- Step 3

**අවවාදය:**  
Write one short safety note.

---

## English

**Reason:**  
Write one short explanation.

**What to do:**  
- Step 1
- Step 2
- Step 3

**Advice:**  
Write one short safety note.

Farmer question:
$trimmedQuestion
''';

      final response = await http
          .post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': apiKey.trim(),
        },
        body: jsonEncode({
          'model': 'gemini-2.5-flash',
          'input': farmerPrompt,
          if (previousInteractionId != null &&
              previousInteractionId.trim().isNotEmpty)
            'previous_interaction_id':
            previousInteractionId.trim(),
        }),
      )
          .timeout(
        const Duration(seconds: 40),
      );

      Map<String, dynamic> data = <String, dynamic>{};

      try {
        final dynamic decodedBody = jsonDecode(response.body);

        if (decodedBody is Map<String, dynamic>) {
          data = decodedBody;
        } else if (decodedBody is Map) {
          data = Map<String, dynamic>.from(decodedBody);
        }
      } on FormatException {
        if (response.statusCode < 200 ||
            response.statusCode >= 300) {
          throw GeminiChatException(
            'Gemini server returned an invalid response.',
          );
        }
      }

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        final dynamic error = data['error'];

        if (response.statusCode == 429) {
          throw GeminiChatException(
            'Too many requests. Please try again in a few minutes.',
          );
        }

        if (response.statusCode == 401 ||
            response.statusCode == 403) {
          // Server එකේ key එක වෙනස් වූ විට cached key එක ඉවත් කරනවා.
          GeminiConfig.clearCachedApiKey();

          throw GeminiChatException(
            'AgriChatbot authentication failed. Please try again later.',
          );
        }

        if (error is Map && error['message'] != null) {
          throw GeminiChatException(
            error['message'].toString(),
          );
        }

        throw GeminiChatException(
          'Unable to get a response from AgriChatbot.',
        );
      }

      final reply = _extractReply(data);
      final interactionId = data['id']?.toString() ?? '';

      if (reply.isEmpty) {
        throw GeminiChatException(
          'AgriChatbot did not return a response. Please try again.',
        );
      }

      return GeminiChatReply(
        text: reply,
        interactionId: interactionId,
      );
    } on GeminiChatException {
      rethrow;
    } catch (_) {
      throw GeminiChatException(
        'Internet connection failed. Please try again.',
      );
    }
  }

  String _extractReply(Map<String, dynamic> responseData) {
    final dynamic steps = responseData['steps'];

    if (steps is! List) {
      return '';
    }

    final texts = <String>[];

    for (final dynamic step in steps) {
      if (step is! Map) {
        continue;
      }

      if (step['type'] != 'model_output') {
        continue;
      }

      final dynamic content = step['content'];

      if (content is! List) {
        continue;
      }

      for (final dynamic item in content) {
        if (item is Map &&
            item['type'] == 'text' &&
            item['text'] != null) {
          texts.add(item['text'].toString());
        }
      }
    }

    return texts.join('\n').trim();
  }
}