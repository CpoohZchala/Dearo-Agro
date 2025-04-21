import 'dart:convert';
import 'package:farmeragriapp/models/technical_inquiry_model.dart';
import 'package:http/http.dart' as http;

class TechnicalInquiryApi {
  final String baseUrl;

  TechnicalInquiryApi(this.baseUrl);

  Future<List<TechnicalInquiry>> getInquiries() async {
    final response = await http.get(Uri.parse('$baseUrl/tinquiries'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => TechnicalInquiry.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load inquiries');
    }
  }

  Future<void> deleteInquiry(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tinquiry/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete inquiry');
    }
  }

  Future<void> updateInquiry(TechnicalInquiry inquiry) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tinquiry/${inquiry.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(inquiry.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update inquiry');
    }
  }
}