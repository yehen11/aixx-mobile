/// Payload for PUT /me. The backend accepts full_name, phone and country.
/// avatar_url is read-only for now, since avatar upload isn't built.
class UpdateProfileRequest {
  final String fullName;
  final String? phone;
  final String? country;

  UpdateProfileRequest({
    required this.fullName,
    this.phone,
    this.country,
  });

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        if (phone != null) 'phone': phone,
        if (country != null) 'country': country,
      };
}