class CertificateModel {
  final int id; // equals the final assessment attempt_id
  final String certificateToken;
  final String course;
  final String courseSlug;
  final double score; // percentage, e.g. 85
  final DateTime? issuedAt;
  final String verifyUrl; // relative, e.g. /api/certificate/verify/abc123

  const CertificateModel({
    required this.id,
    required this.certificateToken,
    required this.course,
    required this.courseSlug,
    required this.score,
    required this.issuedAt,
    required this.verifyUrl,
  });

  static const String _host = 'https://api.aixx.com.sg';

  /// verify_url arrives relative, so prefix the host.
  String get fullVerifyUrl {
    if (verifyUrl.startsWith('http')) return verifyUrl;
    final path = verifyUrl.startsWith('/') ? verifyUrl : '/$verifyUrl';
    return '$_host$path';
  }

  String get scoreLabel => '${score.round()}%';

    /// e.g. "10 Oct 2026". Empty when the backend sent no date.
  String get issuedLabel {
    final d = issuedAt;
    if (d == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  /// Works for a list item and for the unwrapped `data` object of
  /// GET /certificate/{id}, since both have the same shape.
  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: (json['id'] as num).toInt(),
      certificateToken: (json['certificate_token'] ?? '') as String,
      course: (json['course'] ?? '') as String,
      courseSlug: (json['course_slug'] ?? '') as String,
      score: (json['score'] as num?)?.toDouble() ?? 0,
      issuedAt: DateTime.tryParse((json['issued_at'] ?? '') as String)?.toLocal(),
      verifyUrl: (json['verify_url'] ?? '') as String,
    );
  }
}