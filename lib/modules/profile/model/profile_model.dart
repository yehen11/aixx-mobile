/// AI knowledge score. The backend sends `aiks: null` until the student
/// has a score.
class AiksModel {
  final num score;
  final String level;
  final DateTime? createdAt;

  const AiksModel({
    required this.score,
    required this.level,
    required this.createdAt,
  });

  factory AiksModel.fromJson(Map<String, dynamic> json) {
    return AiksModel(
      score: json['score'] as num? ?? 0,
      level: json['level'] as String? ?? '',
      createdAt:
          DateTime.tryParse((json['created_at'] ?? '') as String)?.toLocal(),
    );
  }
}

/// Matches GET /me: { profile{...}, entitlements{...}, aiks{...}|null }.
class ProfileModel {
  final int id;
  final String uuid; // also sent as X-Student-Token until Bearer is supported
  final String registrationId;
  final String fullName;
  final String email;
  final String? phone;
  final String? country;
  final String? avatarUrl; // null until avatar upload is built
  final DateTime? lastLoginAt;
  final bool isAmbassador;
  final AiksModel? aiks;

  const ProfileModel({
    required this.id,
    required this.uuid,
    required this.registrationId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.country,
    required this.avatarUrl,
    required this.lastLoginAt,
    required this.isAmbassador,
    required this.aiks,
  });

  /// The screen still reads `profile.name`.
  String get name => fullName;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] as Map<String, dynamic>;
    final entitlements = json['entitlements'] as Map<String, dynamic>?;
    final aiks = json['aiks'];

    return ProfileModel(
      id: (profile['id'] as num).toInt(),
      uuid: (profile['uuid'] ?? '') as String,
      registrationId: (profile['registration_id'] ?? '') as String,
      fullName: (profile['full_name'] ?? '') as String,
      email: (profile['email'] ?? '') as String,
      phone: profile['phone'] as String?,
      country: profile['country'] as String?,
      // "avatar_url on GET /me" could sit in profile{} or at the top level.
      avatarUrl: (profile['avatar_url'] ?? json['avatar_url']) as String?,
      lastLoginAt: DateTime.tryParse((profile['last_login_at'] ?? '') as String)
          ?.toLocal(),
      isAmbassador: entitlements?['is_ambassador'] as bool? ?? false,
      aiks: aiks is Map<String, dynamic> ? AiksModel.fromJson(aiks) : null,
    );
  }
}