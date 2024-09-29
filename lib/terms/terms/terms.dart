import 'datum.dart';

class prodectModelTerms {
  bool? status;
  String? message;
  List<Datum>? data;

  prodectModelTerms({this.status, this.message, this.data});

  factory prodectModelTerms.fromJson(Map<String, dynamic> json) =>
      prodectModelTerms(
        status: json['status'] as bool?,
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
