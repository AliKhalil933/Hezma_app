class UpdateResponse {
  final bool status;
  final String message;

  UpdateResponse({required this.status, required this.message});

  factory UpdateResponse.fromJson(Map<String, dynamic> json) {
    return UpdateResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? 'Unknown error',
    );
  }
}
