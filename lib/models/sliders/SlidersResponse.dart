import 'package:hezmaa/home/home/slider.dart';

class SlidersResponse {
  final bool status;
  final String message;
  final List<SliderModel> data;

  SlidersResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SlidersResponse.fromJson(Map<String, dynamic> json) {
    return SlidersResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List<dynamic>)
          .map((item) => SliderModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((slider) => slider.toJson()).toList(),
    };
  }
}
