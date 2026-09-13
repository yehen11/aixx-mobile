/// Request payload for updating a profile.
///
/// TODO: Endpoint (PUT /api/auth/profile) and exact field names are
/// NOT confirmed yet — asked the backend dev, awaiting reply.
///
/// Sends a single `name` field for now, matching the real Alumni
/// table's current schema (no firstName/lastName split exists yet).
class UpdateProfileRequest {
  final String name;
  final String? avatarUrl;

  UpdateProfileRequest({
    required this.name,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
      };
}