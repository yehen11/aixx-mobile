/*
@Author - yehenSamarasinghe
@Date - 2026/08/29
*/
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/app_routes.dart';
import '../../../../services/providers/certificate_provider.dart';
import '../../../../themes/utils.dart';
import '../../model/certificate_model.dart';

/// Certificates tab: every certificate the student has earned.
class CertificateScreen extends ConsumerWidget {
  const CertificateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final certsAsync = ref.watch(certificateListProvider);

    return Scaffold(
      backgroundColor: canvasBase,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: glossOutline)),
            ),
            child: Text(
              'Certificates',
              style: TextStyle(
                color: onSurfaceColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(certificateListProvider.future),
              child: certsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => _ErrorView(
                  onRetry: () => ref.invalidate(certificateListProvider),
                ),
                data: (certs) {
                  if (certs.isEmpty) return const _EmptyView();

                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    itemCount: certs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) =>
                        _CertificateCard(certificate: certs[i]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final CertificateModel certificate;

  const _CertificateCard({required this.certificate});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(kCardRadius),
      onTap: () => context.push(
        AppRoutes.certificateDetail,
        extra: certificate.id,
      ),
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
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: successColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.workspace_premium_outlined,
                color: successColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    certificate.course,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: onSurfaceColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (certificate.issuedLabel.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Issued ${certificate.issuedLabel}',
                      style: TextStyle(color: mutedTextColor, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              certificate.scoreLabel,
              style: TextStyle(
                color: successColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: mutedTextColor, size: 20),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    // A ListView so pull-to-refresh still works on the empty state.
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(32),
      children: [
        const SizedBox(height: 80),
        Icon(Icons.workspace_premium_outlined, size: 56, color: mutedTextColor),
        const SizedBox(height: 16),
        Text(
          'No certificates yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: onSurfaceColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pass a course final assessment to earn your certificate.',
          textAlign: TextAlign.center,
          style: TextStyle(color: mutedTextColor, fontSize: 14, height: 1.4),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40, color: errorColor),
            const SizedBox(height: 12),
            Text(
              'Couldn\'t load your certificates.',
              style: TextStyle(color: onSurfaceColor, fontSize: 15),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: glossOutline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kCardRadius),
                ),
              ),
              child: Text('Retry', style: TextStyle(color: onSurfaceColor)),
            ),
          ],
        ),
      ),
    );
  }
}