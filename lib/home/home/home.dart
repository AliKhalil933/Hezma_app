import 'data.dart';
import 'extra_data.dart';

class Home {
  bool? status;
  String? message;
  Data? data;
  ExtraData? extraData;

  Home({this.status, this.message, this.data, this.extraData});

  factory Home.fromJson(Map<String, dynamic> json) => Home(
        status: json['status'] as bool?,
        message: json['message'] as String?,
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, dynamic>),
        extraData: json['extra_data'] == null
            ? null
            : ExtraData.fromJson(json['extra_data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
        'extra_data': extraData?.toJson(),
      };
}
