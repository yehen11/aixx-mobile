/*
@Author - yehenSamarasinghe
@Date - 2026/08/27
*/
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../layout/main_shell.dart';
import '../modules/auth/view/screens/auth_screen.dart';
import '../modules/auth/view/screens/forgot_password_screen.dart';
import '../modules/auth/view/screens/login_screen.dart';
import '../modules/auth/view/screens/reset_password_screen.dart';
import '../modules/dashboard/view/screens/dashboard_screen.dart';
import '../modules/quiz/view/screens/quiz_screen.dart';
import '../modules/profile/view/screens/profile_screen.dart';
import '../modules/certificate/view/screens/certificate_screen.dart';
import '../routes/app_routes.dart';
import '../modules/course/view/screens/course_detail_screen.dart';
import '../modules/course/view/screens/course_contents_screen.dart';
import '../modules/course/model/course_model.dart';
import '../modules/quiz/view/screens/quiz_session_screen.dart';
import '../modules/quiz/view/screens/module_results_screen.dart';
import '../modules/quiz/model/submit_result_model.dart';
import '../modules/profile/view/screens/results_history_screen.dart';
import '../modules/auth/view/screens/otp_screen.dart';

GoRouter getRouter(String initialRoute) {
  return GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.courseDetail,
        builder: (context, state) {
          final course = state.extra as CourseModel;
          return CourseDetailScreen(course: course);
        },
      ),
      GoRoute(
        path: AppRoutes.courseContents,
        builder: (context, state) {
          final course = state.extra as CourseModel;
          return CourseContentsScreen(course: course);
        },
      ),
      GoRoute(
        path: AppRoutes.quizSession,
        builder: (context, state) {
          final args = state.extra as QuizSessionArgs;

          return QuizSessionScreen(
            args: args,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.moduleResults,
        builder: (context, state) {
          final result = state.extra as SubmitResultModel;

          return ModuleResultsScreen(
            result: result,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.resultsHistory,
        builder: (context, state) => const ResultsHistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) {
          final email = state.extra as String;

          return OtpScreen(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) {
          return const ForgotPasswordScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) {
          final email = state.extra as String;
          return ResetPasswordScreen(email: email);
        },
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
