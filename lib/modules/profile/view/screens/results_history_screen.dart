import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../services/providers/profile_provider.dart';
import '../../../../themes/utils.dart';
import '../../model/module_result_item_model.dart';
import '../../model/result_history_item_model.dart';

/// Past Results: final assessment attempts (GET /assessment/results) and
/// module quiz results (GET /me/module-results).
class ResultsHistoryScreen extends ConsumerWidget {
  const ResultsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assessmentsAsync = ref.watch(resultHistoryProvider);
    final modulesAsync = ref.watch(moduleResultsProvider);

    return Scaffold(
      backgroundColor: canvasBase,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _sectionTitle('Final Assessments'),
                  ..._section<ResultHistoryItemModel>(
                    assessmentsAsync,
                    emptyText: 'No assessments taken yet',
                    tile: (item) => _ResultCard(
                      scoreLabel: item.scoreLabel,
                      accent: item.passed ? successColor : errorColor,
                      title: item.courseTitle,
                      subtitle: 'Final assessment',
                      statusLabel: item.passed ? 'Passed' : 'Not passed',
                      dateLabel: item.dateLabel,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _sectionTitle('Module Quizzes'),
                  ..._section<ModuleResultItemModel>(
                    modulesAsync,
                    emptyText: 'No modules attempted yet',
                    tile: (item) => _ResultCard(
                      scoreLabel: item.bestScoreLabel,
                      accent: item.passed ? successColor : errorColor,
                      title: item.course,
                      subtitle: '${item.moduleName} · ${item.attemptsLabel}',
                      statusLabel: item.passed ? 'Passed' : 'Not passed yet',
                      dateLabel: item.dateLabel,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: glossOutline)),
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context.pop(),
            child: Icon(Icons.arrow_back, size: 20, color: onSurfaceColor),
          ),
          const SizedBox(width: 14),
          Text(
            'Past Results',
            style: TextStyle(
              color: onSurfaceColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: TextStyle(
          color: onSurfaceColor,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /// One section of the list, with its own loading, error and empty states.
  List<Widget> _section<T>(
    AsyncValue<List<T>> async, {
    required String emptyText,
    required Widget Function(T item) tile,
  }) {
    return async.when<List<Widget>>(
      loading: () => const [
        Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
      error: (err, _) => [
        Text('Failed to load results: $err',
            style: TextStyle(color: errorColor)),
      ],
      data: (items) {
        if (items.isEmpty) {
          return [Text(emptyText, style: TextStyle(color: mutedTextColor))];
        }
        return [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: tile(item),
            ),
        ];
      },
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String scoreLabel;
  final Color accent;
  final String title;
  final String subtitle;
  final String statusLabel;
  final String dateLabel;

  const _ResultCard({
    required this.scoreLabel,
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.statusLabel,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceCards,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: glossOutline),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                scoreLabel,
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: onSurfaceColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: mutedTextColor, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                statusLabel,
                style: TextStyle(
                  color: accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateLabel,
                style: TextStyle(color: mutedTextColor, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}