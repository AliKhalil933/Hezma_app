import 'data.dart';

class Profile {
  bool? status;
  String? message;
  modelOfprofile? data;

  Profile({this.status, this.message, this.data});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        status: json['status'] as bool?,
        message: json['message'] as String?,
        data: json['data'] == null
            ? null
            : modelOfprofile.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}
