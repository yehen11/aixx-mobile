/*
@Author - yehenSamarasinghe
@Date - 2026/08/29
*/
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('AIXX Academy', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 8),
            const Text('Auth screen — coming Day 2'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.dashboard),
              child: const Text('Continue (temporary skip)'),
            ),
          ],
        ),
      ),
    );
  }
}
