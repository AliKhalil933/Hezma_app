import 'datum.dart';

class Payment {
  bool? status;
  String? message;
  List<Datumpymant>? data;

  Payment({this.status, this.message, this.data});

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        status: json['status'] as bool?,
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => Datumpymant.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
