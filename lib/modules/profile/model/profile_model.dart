/// Profile model — matches GET /api/auth/profile.
///
/// NOTE: Real Alumni table has a single `name` field, not split
/// first/last — the Profile screen splits it for editing UI purposes
/// only, then rejoins before sending to the update endpoint.
///
/// `avatarUrl` is optional and parsed defensively because it is not
/// confirmed to exist in the current backend response.
class ProfileModel {
  final int id;
  final String email;
  final String? name;
  final String state;
  final DateTime createdAt;
  final String? avatarUrl;

  ProfileModel({
    required this.id,
    required this.email,
    required this.name,
    required this.state,
    required this.createdAt,
    this.avatarUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String?,
      state: json['state'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}