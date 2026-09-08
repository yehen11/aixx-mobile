/*
@Author - yehenSamarasinghe
@Date - 2026/09/01
*/

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../modules/auth/data/repositories/auth_repository.dart';
import '../../modules/auth/model/sign_up_model.dart';
import '../core/token_storage.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());

/// PLACEHOLDER field name — ask the backend developer for the real key
/// in the register/login response (token / accessToken / jwt / etc.)
/// and update the single line marked below once she replies. Nothing
/// else in the app needs to change when that happens.
const String kTokenResponseField = 'token';

/// Handles the sign-up call and saves the returned JWT token.
/// Per Backend_API_Documentation.docx: POST /api/auth/register
/// "Signs & returns a 24h JWT token" — we must save it so future
/// requests (like fetching courses) can attach it automatically.
//final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());

final signUpUserProvider =
    FutureProvider.family<bool, SignUpModel>((ref, model) async {
  final repo = ref.read(authRepositoryProvider);
  final response = await repo.signUp(model);

  final success = response.statusCode == 200 || response.statusCode == 201;
  if (!success) return false;

  // TODO: update kTokenResponseField above once the backend developer
  // confirms the real field name — this is the only line that changes.
  final token = response.data[kTokenResponseField] as String?;
  if (token != null) {
    await TokenStorage.saveToken(token);
  }

  return token != null;
});