/*
@Author - yehenSamarasinghe
@Date - 2026/08/27
*/
import 'package:aixx/themes/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/aixx_bottom_nav_bar.dart';

class MainShell extends StatelessWidget {
  const MainShell({required this.navigationShell, Key? key})
      : super(key: key ?? const ValueKey<String>('MainShell'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor:canvasBase,
      body: SafeArea(
        top: true,
        bottom: false,
        child: navigationShell,
      ),
      bottomNavigationBar: AixxBottomNavBar(navigationShell: navigationShell),
    );
  }
}
