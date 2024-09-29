import 'modelAdress.dart';

class Adress {
  bool? status;
  String? message;
  List<modelofAdress>? data;

  Adress({this.status, this.message, this.data});

  factory Adress.fromJson(Map<String, dynamic> json) => Adress(
        status: json['status'] as bool?,
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => modelofAdress.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
