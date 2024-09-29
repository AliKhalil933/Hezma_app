class ForgetPasswordResponse {
  final bool status;
  final String message;
  final String otp;
  final String token;

  ForgetPasswordResponse({
    required this.status,
    required this.message,
    required this.otp,
    required this.token,
  });

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordResponse(
      status: json['status'],
      message: json['message'],
      otp: json['otp'],
      token: json['Token'],
    );
  }
}
