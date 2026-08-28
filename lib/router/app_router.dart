/*
@Author - yehenSamarasinghe
@Date - 2026/08/27
*/
import 'package:go_router/go_router.dart';
import '../layout/main_shell.dart';
import '../modules/auth/view/screens/auth_screen.dart';
import '../modules/dashboard/view/screens/dashboard_screen.dart';
import '../modules/quiz/view/screens/quiz_screen.dart';
import '../modules/profile/view/screens/profile_screen.dart';
import '../modules/certificate/view/screens/certificate_screen.dart';
import '../routes/app_routes.dart';

GoRouter getRouter(String initialRoute) {
  return GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              builder: (context, state) => const DashboardScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.quiz,
              builder: (context, state) => const QuizScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.certificates,
              builder: (context, state) => const CertificateScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
}