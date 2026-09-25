class RegisterResponse {
  final String message;
  final String email;
  final String registrationId;

  RegisterResponse({
    required this.message,
    required this.email,
    required this.registrationId,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'] ?? '',
      email: json['email'] ?? '',
      registrationId: json['registration_id'] ?? '',
    );
  }
}