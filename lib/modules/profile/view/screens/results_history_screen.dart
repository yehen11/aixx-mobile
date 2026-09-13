import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../services/providers/profile_provider.dart';
import '../../../../themes/utils.dart';
import '../../model/result_history_item_model.dart';

/// Results History — lists every past module attempt.
/// Matches GET /api/assessment/results: "Orders results chronologically
/// descending" — mock data below is already in that order.
class ResultsHistoryScreen extends ConsumerWidget {
  const ResultsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(resultHistoryProvider);

    return Scaffold(
      backgroundColor: canvasBase,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: glossOutline),
                ),
              ),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => context.pop(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: onSurfaceColor,
                    ),
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
            ),
            Expanded(
              child: resultsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (err, _) => Center(
                  child: Text(
                    'Failed to load results: $err',
                    style: TextStyle(color: errorColor),
                  ),
                ),
                data: (results) {
                  if (results.isEmpty) {
                    return Center(
                      child: Text(
                        'No completed modules yet',
                        style: TextStyle(color: mutedTextColor),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: results.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _ResultTile(item: results[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final ResultHistoryItemModel item;

  const _ResultTile({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final passed = (item.score / 6) >= 0.8;

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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (passed ? successColor : errorColor)
                  .withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${item.score}',
                style: TextStyle(
                  color: passed ? successColor : errorColor,
                  fontWeight: FontWeight.w700,
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
                  item.moduleTitle,
                  style: TextStyle(
                    color: onSurfaceColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.courseTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: mutedTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${item.createdAt.day}/${item.createdAt.month}',
            style: TextStyle(
              color: mutedTextColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}