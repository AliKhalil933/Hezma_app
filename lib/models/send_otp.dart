class OtpResponse {
  final bool status;
  final String message;
  final String otp;

  OtpResponse({
    required this.status,
    required this.message,
    required this.otp,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      status:
          json['status'] ?? true, // استخدام false كقيمة افتراضية إذا كانت null
      message: json['message'] ?? '', // استخدام '' كقيمة افتراضية إذا كانت null
      otp: json['otp'] ?? '', // استخدام '' كقيمة افتراضية إذا كانت null
    );
  }
}
