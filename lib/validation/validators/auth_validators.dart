/*
@Author - yehenSamarasinghe
@Date - 2026/09/01
*/

class AuthValidators {
  static String? validateFullName(String value) {
    if (value.trim().isEmpty) return 'Please enter your full name';
    return null;
  }

  static String? validateEmail(String value) {
    if (value.trim().isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email address';
    return null;
  }

  static String? validateMobile(String value) {
    if (value.trim().isEmpty) return 'Please enter your mobile number';
    if (value.trim().length < 7) return 'Enter a valid mobile number';
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) return 'Please enter a password';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? validateConfirmPassword(String password, String confirm) {
    if (confirm.isEmpty) return 'Please confirm your password';
    if (password != confirm) return 'Passwords do not match';
    return null;
  }
}