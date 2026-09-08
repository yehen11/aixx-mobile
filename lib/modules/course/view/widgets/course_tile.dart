import 'package:flutter/material.dart';
import '../../../../themes/utils.dart';
import '../../model/course_model.dart';

/// Reusable course tile for the Hub's course grid.
/// Gradient is built from our OWN tokens (surfaceCards -> canvasBase,
/// with a subtle successColor tint) instead of the designer's unrelated
/// hex values — keeps this tile visually consistent with the rest of
/// the dashboard (page background = canvasBase, other cards = flat
/// surfaceCards) rather than looking like an inserted foreign element.
class CourseTile extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;

  const CourseTile({
    super.key,
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tintedTopLeft = Color.alphaBlend(
      successColor.withOpacity(0.12),
      surfaceCards,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(kCardRadius),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 140),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              tintedTopLeft,
              surfaceCards,
              canvasBase,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(kCardRadius),
          border: Border.all(color: successColor.withOpacity(0.2)),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kCardRadius),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.06),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: canvasBase.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: successColor.withOpacity(0.3)),
                  ),
                  child: Icon(course.icon, size: 20, color: successColor),
                ),
                const SizedBox(height: 12),
                Text(
                  course.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: onSurfaceColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  course.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: mutedTextColor,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}