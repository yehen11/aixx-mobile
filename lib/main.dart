import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'routes/app_routes.dart';
import 'themes/theme.dart';

void main() {
  runApp(const ProviderScope(child: AixxAcademyApp()));
}

class AixxAcademyApp extends StatelessWidget {
  const AixxAcademyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

     final router = getRouter(AppRoutes.auth);
     
    return MaterialApp.router(
      title: 'AIXX Academy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
