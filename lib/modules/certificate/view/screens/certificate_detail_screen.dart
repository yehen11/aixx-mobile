import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../services/providers/certificate_provider.dart';
import '../../../../themes/utils.dart';
import '../../model/certificate_model.dart';

/// One certificate. Reached from the list and from both
/// "View Certificate" buttons, which only have the id.
class CertificateDetailScreen extends ConsumerWidget {
  final int certificateId;

  const CertificateDetailScreen({super.key, required this.certificateId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final certAsync = ref.watch(certificateDetailProvider(certificateId));

    return Scaffold(
      backgroundColor: canvasBase,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
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
                    'Certificate',
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
              child: certAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => _buildError(context, ref, err),
                data: (cert) => _buildContent(context, cert),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, CertificateModel cert) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: surfaceCards,
            borderRadius: BorderRadius.circular(kCardRadius),
            border: Border.all(color: glossOutline),
          ),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: successColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.workspace_premium_outlined,
                  size: 34,
                  color: successColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'CERTIFICATE OF COMPLETION',
                style: TextStyle(
                  color: mutedTextColor,
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                cert.course,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: onSurfaceColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 20),
              Divider(color: glossOutline, height: 1),
              const SizedBox(height: 16),
              _row('Final score', cert.scoreLabel, valueColor: successColor),
              if (cert.issuedLabel.isNotEmpty) _row('Issued', cert.issuedLabel),
              _row('Certificate ID', '${cert.id}'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Verification link',
          style: TextStyle(
            color: onSurfaceColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: surfaceCards,
            borderRadius: BorderRadius.circular(kCardRadius),
            border: Border.all(color: glossOutline),
          ),
          child: SelectableText(
            cert.fullVerifyUrl,
            style: TextStyle(color: mutedTextColor, fontSize: 12, height: 1.4),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: cert.fullVerifyUrl));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Verification link copied')),
              );
            },
            icon: const Icon(Icons.copy, size: 18),
            label: const Text(
              'Copy verification link',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: actionHighlight,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kCardRadius),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: mutedTextColor, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? onSurfaceColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object err) {
    final notFound = err is DioException && err.response?.statusCode == 404;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              notFound ? Icons.search_off : Icons.error_outline,
              size: 44,
              color: notFound ? mutedTextColor : errorColor,
            ),
            const SizedBox(height: 12),
            Text(
              notFound ? 'Certificate not found' : 'Couldn\'t load this certificate',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onSurfaceColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (notFound) ...[
              const SizedBox(height: 8),
              Text(
                'It doesn\'t exist or isn\'t on your account.',
                textAlign: TextAlign.center,
                style: TextStyle(color: mutedTextColor, fontSize: 14),
              ),
            ],
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: notFound
                  ? () => context.pop()
                  : () => ref.invalidate(certificateDetailProvider(certificateId)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: glossOutline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kCardRadius),
                ),
              ),
              child: Text(
                notFound ? 'Go back' : 'Retry',
                style: TextStyle(color: onSurfaceColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}