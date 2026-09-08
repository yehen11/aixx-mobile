import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/providers/course_provider.dart';
import '../../../../themes/utils.dart';
import '../../model/course_model.dart';
import '../../model/module_model.dart';

/// Course Contents — matches the designer's refined HTML.
/// NOTE: corner radius kept at kCardRadius (12px) per the "strict 12.0px"
/// rule in the guidelines doc — HTML's rounded-2xl (16px) not applied.
/// NOTE: "Course Track" badge omitted — no matching field exists on
/// CourseModel (not real backend data).
/// Module order uses list index (no sequence field on real backend);
/// per-module question counts will come from the Assessment API (Day 5).
class CourseContentsScreen extends ConsumerWidget {
  final CourseModel course;
  const CourseContentsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modulesAsync = ref.watch(moduleListProvider(course.id));

    return Scaffold(
      backgroundColor: canvasBase,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: _glowBlob(actionHighlight.withOpacity(0.08), 260),
          ),
          Positioned(
            top: 220,
            left: -100,
            child: _glowBlob(successColor.withOpacity(0.08), 220),
          ),
          Positioned(
            bottom: 60,
            left: -60,
            child: _glowBlob(actionHighlight.withOpacity(0.08), 220),
          ),

          SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: canvasBase.withOpacity(0.8),
                    border: Border(bottom: BorderSide(color: glossOutline)),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => context.pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            shape: BoxShape.circle,
                            border: Border.all(color: glossOutline),
                          ),
                          child: Icon(Icons.arrow_back, size: 20, color: onSurfaceColor),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Course Contents',
                        style: TextStyle(
                          color: onSurfaceColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: modulesAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(
                      child: Text('Failed to load modules: $err',
                          style: TextStyle(color: errorColor)),
                    ),
                    data: (modules) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: TextStyle(
                                color: onSurfaceColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ...List.generate(modules.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _ModuleTile(
                                  module: modules[index],
                                  displayNumber: index + 1,
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [canvasBase, canvasBase.withOpacity(0.0)],
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go(AppRoutes.quiz);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: actionHighlight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kCardRadius),
                          side: BorderSide(color: Colors.white.withOpacity(0.1)),
                        ),
                        elevation: 10,
                        shadowColor: actionHighlight.withOpacity(0.45),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Start Course',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                          SizedBox(width: 8),
                          Icon(Icons.play_arrow, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
      ),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  final ModuleModel module;
  final int displayNumber;
  const _ModuleTile({required this.module, required this.displayNumber});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(kCardRadius),
      onTap: () {
        // TODO: navigate into this specific module's questions (Day 5).
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceCards,
          borderRadius: BorderRadius.circular(kCardRadius),
          border: Border.all(color: glossOutline),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: successColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: successColor.withOpacity(0.3)),
              ),
              child: Center(
                child: Text(
                  '$displayNumber',
                  style: TextStyle(
                    color: successColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                module.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: onSurfaceColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: mutedTextColor, size: 20),
          ],
        ),
      ),
    );
  }
}