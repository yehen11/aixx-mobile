import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';
import '../../services/core/token_storage.dart';
import '../../services/providers/auth_provider.dart';
import '../../services/providers/profile_provider.dart';

Future<void> performLogout(WidgetRef ref, BuildContext context) async {
  // Revoke the token on the server first, while it is still stored.
  // Offline or already revoked? Log out locally anyway.
  try {
    await ref
        .read(authRepositoryProvider)
        .logout()
        .timeout(const Duration(seconds: 3));
  } catch (_) {}

  await TokenStorage.clearToken();

  if (!context.mounted) return;

  // Clear cached per-user state so the next login doesn't show stale data
  ref.invalidate(profileProvider);
  ref.invalidate(resultHistoryProvider);

  context.go(AppRoutes.login);
}