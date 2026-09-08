import 'package:flutter/material.dart';
import '../../../../themes/utils.dart';
import 'tag_badge.dart';

enum NewsTag { breaking, trending, update }

/// Hardcoded news item data.
/// TODO: replace with real data from an API once AI Hot News content
/// is available — hardcoded per project lead's instruction for now.
class NewsItemData {
  final NewsTag tag;
  final String title;
  final String summary;
  final String timeAgo;

  const NewsItemData({
    required this.tag,
    required this.title,
    required this.summary,
    required this.timeAgo,
  });
}

const List<NewsItemData> kHardcodedNews = [
  NewsItemData(
    tag: NewsTag.breaking,
    title: 'OpenAI Announces New Enterprise Integration Models',
    summary:
        'The latest release promises a 40% reduction in latency for enterprise-scale API calls.',
    timeAgo: '2 hrs ago',
  ),
  NewsItemData(
    tag: NewsTag.trending,
    title: 'Optimizing LLMs for Edge Devices: A New Approach',
    summary:
        'Researchers have discovered a breakthrough method for running large models on mobile hardware.',
    timeAgo: '5 hrs ago',
  ),
  NewsItemData(
    tag: NewsTag.update,
    title: 'AIXX Platform v2.4 Release Notes Available',
    summary:
        'Explore the new features including advanced skill assessments and improved dashboard metrics.',
    timeAgo: '1 day ago',
  ),
];


class AiNewsCard extends StatelessWidget {
  final NewsItemData data;
  const AiNewsCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceCards,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: glossOutline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder — replace with real thumbnail later.
          Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: canvasBase,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.image_outlined, color: mutedTextColor, size: 28),
          ),
          Row(
            children: [
              TagBadge(tag: data.tag),
              const SizedBox(width: 8),
              Text(data.timeAgo,
                  style: TextStyle(color: mutedTextColor, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: onSurfaceColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.summary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: mutedTextColor, fontSize: 11, height: 1.3),
          ),
        ],
      ),
    );
  }

  
}