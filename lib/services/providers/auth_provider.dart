/*
@Author - yehenSamarasinghe
@Date - 2026/09/01
*/

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../modules/auth/data/repositories/auth_repository.dart';
import '../../modules/auth/model/sign_up_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());

final signUpUserProvider =
    FutureProvider.family<bool, SignUpModel>((ref, model) async {
  final repo = ref.read(authRepositoryProvider);
  final response = await repo.signUp(model);

  return response.statusCode == 200 || response.statusCode == 201;
});