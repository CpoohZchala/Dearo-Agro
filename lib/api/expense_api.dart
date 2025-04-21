import 'package:dio/dio.dart';
import '../models/expense_model.dart';

class ExpenseApi {
  final Dio _dio = Dio();

  final String _submitUrl = "http://192.168.8.125:5000/api/esubmit";
  final String _updateUrl = "http://192.168.8.125:5000/api/eupdate";

  Future<String> submitExpense(Expense expense) async {
    final response = await _dio.post(_submitUrl, data: expense.toJson());
    return response.data["message"];
  }

  Future<String> updateExpense(Expense expense) async {
    final response = await _dio.put(_updateUrl, data: expense.toJson());
    return response.data["message"];
  }
}
