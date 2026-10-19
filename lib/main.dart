import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'router/app_router.dart';
import 'routes/app_routes.dart';
import 'services/core/api_client.dart';
import 'services/core/token_storage.dart';
import 'services/providers/profile_provider.dart';
import 'themes/theme.dart';

Future<void> main() async {
  // Needed before touching secure storage ahead of runApp.
  WidgetsFlutterBinding.ensureInitialized();

  final router = getRouter(await _resolveInitialRoute());
  final container = ProviderContainer();

  // The API rejected the stored token (401). api_client.dart has already
  // cleared it, so drop per-user cached data and send the user to Login.
  ApiClient.onUnauthorized = () {
    container.invalidate(profileProvider);
    container.invalidate(resultHistoryProvider);
    router.go(AppRoutes.login);
  };

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: AixxAcademyApp(router: router),
    ),
  );
}

/// Stay logged in: go straight to the Dashboard when a token is stored,
/// otherwise start at Login.
Future<String> _resolveInitialRoute() async {
  try {
    if (await TokenStorage.hasToken()) {
      return AppRoutes.dashboard;
    }
  } catch (_) {
    // Secure storage can fail to read (for example after a device restore).
    // Treat that as logged out instead of crashing on startup.
  }

  return AppRoutes.login;
}

class AixxAcademyApp extends StatelessWidget {
  final GoRouter router;

  const AixxAcademyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AIXX Academy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}