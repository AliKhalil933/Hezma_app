import 'package:equatable/equatable.dart';
import 'data.dart';

class ModelCoboun {
  final bool status;
  final String message;
  final copounOfModel? data;

  ModelCoboun({
    required this.status,
    required this.message,
    this.data,
  });

  factory ModelCoboun.fromJson(Map<String, dynamic> json) {
    return ModelCoboun(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? copounOfModel.fromJson(json['data']) : null,
    );
  }
}
