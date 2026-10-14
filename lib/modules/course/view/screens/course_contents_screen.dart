import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/app_routes.dart';
import '../../../../services/providers/course_provider.dart';
import '../../../../themes/utils.dart';
import '../../../quiz/view/screens/quiz_session_screen.dart';
import '../../model/course_model.dart';
import '../../model/module_model.dart';
import '../../../quiz/view/screens/final_assessment_screen.dart';

class CourseContentsScreen extends ConsumerWidget {
  final CourseModel course;

  const CourseContentsScreen({super.key, required this.course});

    void _startModule(BuildContext context, ModuleModel module) {
    context.push(
      AppRoutes.studyMaterial,
      extra: QuizSessionArgs(
        courseSlug: course.slug,
        moduleIndex: module.moduleIndex,
        moduleTitle: module.title,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentsAsync = ref.watch(moduleListProvider(course.slug));

    return Scaffold(
      backgroundColor: canvasBase,
      body: Stack(
        children: [
          Positioned(top: -100, right: -100, child: _glowBlob(actionHighlight.withOpacity(0.08), 260)),
          Positioned(top: 220, left: -100, child: _glowBlob(successColor.withOpacity(0.08), 220)),
          Positioned(bottom: 60, left: -60, child: _glowBlob(actionHighlight.withOpacity(0.08), 220)),

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
                      Text('Course Contents', style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.w600, fontSize: 16)),
                    ],
                  ),
                ),

                Expanded(
                  child: contentsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => Center(
                      child: Text('Failed to load modules: $error', style: TextStyle(color: errorColor)),
                    ),
                    data: (contents) {
                      final modules = contents.modules;
                      final progress = contents.progress;

                      if (modules.isEmpty) {
                        return Center(child: Text('No modules available.', style: TextStyle(color: mutedTextColor)));
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(course.title, style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.w700, fontSize: 22)),
                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: LinearProgressIndicator(
                                      value: progress.progressPercentage / 100,
                                      minHeight: 5,
                                      backgroundColor: surfaceCards,
                                      valueColor: AlwaysStoppedAnimation(successColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(progress.progressCounter, style: TextStyle(color: mutedTextColor, fontSize: 12)),
                              ],
                            ),

                            const SizedBox(height: 20),

                            ...modules.map((module) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _ModuleTile(
                                    module: module,
                                    onTap: () => _startModule(context, module),
                                  ),
                                )),
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
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () async {
            final contents = await ref.read(moduleListProvider(course.slug).future);

            if (contents.modules.isNotEmpty && context.mounted) {
              _startModule(context, contents.modules.first);
            }
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
              Text('Start Course', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              SizedBox(width: 8),
              Icon(Icons.play_arrow, size: 18),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: () {
            context.push(
              AppRoutes.finalAssessment,
              extra: FinalAssessmentArgs(
                courseId: course.id,
                courseSlug: course.slug,
                courseTitle: course.title,
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: glossOutline),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.workspace_premium_outlined, size: 18, color: onSurfaceColor),
              const SizedBox(width: 8),
              Text('Take Final Assessment', style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    ],
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
  final VoidCallback onTap;

  const _ModuleTile({required this.module, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(kCardRadius),
      onTap: onTap,
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
                child: module.isCompleted
                    ? Icon(Icons.check, size: 16, color: successColor)
                    : Text(
                        '${module.moduleIndex}',
                        style: TextStyle(color: successColor, fontWeight: FontWeight.w700, fontSize: 12),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                module.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            Icon(Icons.chevron_right, color: mutedTextColor, size: 20),
          ],
        ),
      ),
    );
  }
}