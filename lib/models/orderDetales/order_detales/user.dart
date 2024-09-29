import 'address.dart';

class User {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? image;
  List<Address>? address;
  int? status;
  String? fcm;
  int? otp;

  User({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.image,
    this.address,
    this.status,
    this.fcm,
    this.otp,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int?,
        name: json['name'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        image: json['image'] as String?,
        address: (json['address'] as List<dynamic>?)
            ?.map((e) => Address.fromJson(e as Map<String, dynamic>))
            .toList(),
        status: json['status'] as int?,
        fcm: json['fcm'] as String?,
        otp: json['otp'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'image': image,
        'address': address?.map((e) => e.toJson()).toList(),
        'status': status,
        'fcm': fcm,
        'otp': otp,
      };
}
