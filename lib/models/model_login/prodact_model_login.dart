class ProdactModelLoginAndRegister {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? image;
  List<dynamic>? address;
  int? status;
  String? fcm;
  int? otp;
  String? token;

  ProdactModelLoginAndRegister({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.image,
    this.address,
    this.status,
    this.fcm,
    this.otp,
    this.token,
  });
  factory ProdactModelLoginAndRegister.fromJson(Map<String, dynamic> json) =>
      ProdactModelLoginAndRegister(
        id: json['id'] as int?,
        name: json['name'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        image: json['image'] as String?,
        address: List<dynamic>.from(json['address'] ?? []),
        status: json['status'] as int?,
        fcm: json['fcm'] as String?,
        otp: json['otp'] as int?,
        token: json['token'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'image': image,
        'address': address,
        'status': status,
        'fcm': fcm,
        'otp': otp,
        'token': token,
      };
}
