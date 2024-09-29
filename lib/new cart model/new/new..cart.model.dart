import 'datum..cart.model.dart';

class New {
  bool? status;
  String? message;
  List<NewCartModel>? data;

  New({this.status, this.message, this.data});

  factory New.fromJson(Map<String, dynamic> json) => New(
        status: json['status'] as bool?,
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => NewCartModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
