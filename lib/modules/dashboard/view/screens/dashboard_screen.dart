/*
@Author - yehenSamarasinghe
@Date - 2026/08/29
*/
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/providers/course_provider.dart';
import '../../../../themes/utils.dart';
import '../../../course/view/widgets/course_tile.dart';
import '../widgets/ai_news_card.dart';

/// Hub — matches the approved dashboard HTML design.
/// No premium/locked courses, no progress bars, hardcoded AI Hot News
/// (per current MVP scope). Mobile-only — no desktop sidebar.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(courseListProvider);

    return Scaffold(
      backgroundColor: canvasBase,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top app bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: surfaceCards,
                          child: Icon(Icons.person, size: 18, color: mutedTextColor),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'AIXX',
                          style: TextStyle(
                            color: onSurfaceColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: surfaceCards,
                        shape: BoxShape.circle,
                        border: Border.all(color: glossOutline),
                      ),
                      child: Icon(Icons.notifications_outlined,
                          color: mutedTextColor, size: 18),
                    ),
                  ],
                ),
              ),
            ),

            // Welcome section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back.',
                            style: TextStyle(
                              color: onSurfaceColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Your AI learning cockpit is ready.',
                            style: TextStyle(color: mutedTextColor, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: surfaceCards,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: glossOutline),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6, height: 6,
                            decoration: BoxDecoration(
                              color: successColor, shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text('Online',
                              style: TextStyle(color: onSurfaceColor, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // AI Hot News — hardcoded for now
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('AI Hot News',
                        style: TextStyle(
                            color: onSurfaceColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    Text('View All',
                        style: TextStyle(color: actionHighlight, fontSize: 12)),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 190,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: kHardcodedNews.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) =>
                      AiNewsCard(data: kHardcodedNews[index]),
                ),
              ),
            ),

            // Course Modules
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text('Course Modules',
                    style: TextStyle(
                        color: onSurfaceColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            coursesAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (err, _) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Failed to load courses: $err',
                      style: TextStyle(color: errorColor)),
                ),
              ),
              data: (courses) {
                if (courses.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('No courses available yet',
                          style: TextStyle(color: mutedTextColor)),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.95,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final course = courses[index];
                        return CourseTile(
                          course: course,
                          onTap: () => context.push(
                            AppRoutes.courseDetail,
                            extra: course,
                          ),
                        );
                      },
                      childCount: courses.length,
                    ),
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}