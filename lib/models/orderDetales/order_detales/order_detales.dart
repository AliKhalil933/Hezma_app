import 'ModelOfCartDedails.dart';

class OrderDetails {
  bool? status;
  String? message;
  ModelcartDetails? data;

  OrderDetails({this.status, this.message, this.data});

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
        status: json['status'] as bool?,
        message: json['message'] as String?,
        data: json['data'] == null
            ? null
            : ModelcartDetails.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}
