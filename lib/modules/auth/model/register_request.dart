class RegisterRequest {
  final String fullName;
  final String email;
  final String password;
  final String phone;
  final String country;
  final String? referralCode;

  RegisterRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.country,
    this.referralCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'password': password,
      'phone': phone,
      'country': country,
      if (referralCode != null && referralCode!.isNotEmpty)
        'referral_code': referralCode,
    };
  }
}