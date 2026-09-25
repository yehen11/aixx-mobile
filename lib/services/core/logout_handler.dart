import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';
import '../../services/core/token_storage.dart';
import '../../services/providers/auth_provider.dart';
import '../../services/providers/profile_provider.dart';

Future<void> performLogout(WidgetRef ref, BuildContext context) async {
  await TokenStorage.clearToken();

  // Fire-and-forget: don't block navigation on this
  ref.read(authRepositoryProvider).logout().catchError((_) {
    // Backend logout failure is non-blocking; token is already cleared locally
  });

  // Clear cached per-user state so the next login doesn't show stale data
  ref.invalidate(profileProvider);
  ref.invalidate(resultHistoryProvider);

  if (!context.mounted) return;
  context.go(AppRoutes.login);
}