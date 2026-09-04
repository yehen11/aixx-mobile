/*
@Author - yehenSamarasinghe
@Date - 2026/09/01
*/

class SignUpModel {
  final String fullName;
  final String email;
  final String countryCode;
  final String mobileNumber;
  final String preferredLanguage;
  final String password;

  SignUpModel({
    required this.fullName,
    required this.email,
    required this.countryCode,
    required this.mobileNumber,
    required this.preferredLanguage,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'country_code': countryCode,
      'mobile_number': mobileNumber,
      'preferred_language': preferredLanguage,
      'password': password,
    };
  }
}