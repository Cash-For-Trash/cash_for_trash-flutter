import 'package:cash_for_trash/core/services/remote/endpoints.dart';

class ErrorModel {
  final String message;
  final List<dynamic>? errors;

  ErrorModel({required this.message, this.errors});

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    return ErrorModel(
      message: jsonData[ApiKey.message] ?? 'Unknown error',
      errors: jsonData[ApiKey.errors],
    );
  }
}
