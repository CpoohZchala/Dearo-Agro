import 'dart:convert';
import 'package:farmeragriapp/models/general_inquiry_model';
import 'package:http/http.dart' as http;

class GeneralInquiryApi {
  final String baseUrl;

  GeneralInquiryApi(this.baseUrl);

  Future<List<GeneralInquiry>> getInquiries() async {
    final response = await http.get(Uri.parse('$baseUrl/inquiries'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => GeneralInquiry.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load inquiries');
    }
  }

  Future<void> deleteInquiry(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/inquiry/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete inquiry');
    }
  }

  Future<void> updateInquiry(GeneralInquiry inquiry) async {
    final response = await http.put(
      Uri.parse('$baseUrl/inquiry/${inquiry.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(inquiry.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update inquiry');
    }
  }
}