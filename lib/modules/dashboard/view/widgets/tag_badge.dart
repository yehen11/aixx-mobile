import 'package:aixx/modules/dashboard/view/widgets/ai_news_card.dart';
import 'package:aixx/themes/utils.dart';
import 'package:flutter/material.dart';

class TagBadge extends StatelessWidget {
  final NewsTag tag;

  const TagBadge({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    late Color color;
    late String label;
    late IconData? icon;

    switch (tag) {
      case NewsTag.breaking:
        color = errorColor;
        label = 'BREAKING';
        icon = null;
        break;
      case NewsTag.trending:
        color = successColor;
        label = 'TRENDING';
        icon = Icons.trending_up;
        break;
      case NewsTag.update:
        color = mutedTextColor;
        label = 'UPDATE';
        icon = null;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}