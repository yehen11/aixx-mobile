import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../themes/utils.dart';
import '../../model/course_model.dart';

/// Course Detail — matches the designer's refined HTML.
/// NOTE: corner radius kept at kCardRadius (12px) per the "strict 12.0px"
/// rule in the Core UI Design Guidelines — the HTML's 16px hero radius
/// was not applied; confirm with designer if 16px is meant to override
/// that rule for hero elements specifically.
/// NOTE: "Deep Learning Track" badge omitted — no matching field exists
/// on CourseModel (category/level were removed; not real backend data).
class CourseDetailScreen extends StatelessWidget {
  final CourseModel course;
  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: canvasBase,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: canvasBase.withOpacity(0.85),
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
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Icon(Icons.arrow_back, size: 20, color: mutedTextColor),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      course.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: onSurfaceColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 208,
                      width: double.infinity,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF0E1927),
                            Color(0xFF081320),
                            Color(0xFF020617),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(kCardRadius),
                        border: Border.all(color: glossOutline),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: -40,
                            left: -20,
                            child: _glowBlob(successColor.withOpacity(0.1), 200),
                          ),
                          Positioned(
                            bottom: -20,
                            right: -20,
                            child: _glowBlob(actionHighlight.withOpacity(0.15), 170),
                          ),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0E172A).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(kCardRadius),
                              border: Border.all(color: successColor.withOpacity(0.3)),
                              boxShadow: [
                                BoxShadow(
                                  color: successColor.withOpacity(0.22),
                                  blurRadius: 28,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(course.icon, size: 42, color: successColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      course.title,
                      style: TextStyle(
                        color: onSurfaceColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: successColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: successColor.withOpacity(0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.layers_outlined, size: 16, color: successColor),
                          const SizedBox(width: 6),
                          Text(
                            '${course.moduleCount} MODULES',
                            style: TextStyle(
                              color: successColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      course.description,
                      style: TextStyle(
                        color: mutedTextColor,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push(
                    AppRoutes.courseContents,
                    extra: course,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: actionHighlight,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kCardRadius),
                      side: BorderSide(color: actionHighlight.withOpacity(0.4)),
                    ),
                    elevation: 8,
                    shadowColor: actionHighlight.withOpacity(0.4),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Start Course',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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