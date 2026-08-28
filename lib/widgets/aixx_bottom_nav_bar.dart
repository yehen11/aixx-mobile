
/*
@Author - yehenSamarasinghe
@Date - 2026/08/29
*/
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../themes/utils.dart';

/// Bottom navigation bar — matches the approved HTML design:
/// translucent blurred background, pill-shaped highlight on the active tab.
class AixxBottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AixxBottomNavBar({super.key, required this.navigationShell});

  static const _tabs = [
    (Icons.grid_view_rounded, 'Hub'),
    (Icons.quiz_outlined, 'Quiz'),
    (Icons.workspace_premium_outlined, 'Certificates'),
    (Icons.person_outline, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: surfaceCards.withOpacity(0.8),
            border: Border(top: BorderSide(color: glossOutline, width: 0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_tabs.length, (index) {
              final isActive = navigationShell.currentIndex == index;
              final (icon, label) = _tabs[index];

              return GestureDetector(
                onTap: () => navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                ),
                child: AnimatedScale(
                  scale: isActive ? 1.0 : 0.95,
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? actionHighlight.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          color: isActive ? actionHighlight : mutedTextColor,
                          size: 22,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isActive ? actionHighlight : mutedTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}