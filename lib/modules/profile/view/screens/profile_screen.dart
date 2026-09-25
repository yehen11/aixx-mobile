import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/app_routes.dart';
import '../../../../services/providers/profile_provider.dart';
import '../../../../themes/utils.dart';
import '../../model/update_profile_request.dart';
import '../../../../services/core/logout_handler.dart';

/// Profile screen.
///
/// Features:
/// - Editable first and last name
/// - Avatar selection placeholder
/// - Free membership badge
/// - Progress summary
/// - Past results navigation
/// - Profile update with Riverpod refresh
///
/// NOTE:
/// Profile editing currently uses the placeholder
/// PUT /api/auth/profile endpoint. Confirm the endpoint
/// with the backend before production integration.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _initialized = false;
  bool _saving = false;

  int _selectedAvatarIndex = 0;

  static const _avatarIcons = [
    Icons.person,
    Icons.face,
    Icons.emoji_people,
    Icons.school,
    Icons.psychology,
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _prefillFromName(String? fullName) {
    if (_initialized) return;

    final parts = (fullName ?? '').trim().split(' ');

    _firstNameController.text =
        parts.isNotEmpty ? parts.first : '';

    _lastNameController.text =
        parts.length > 1 ? parts.sublist(1).join(' ') : '';

    _initialized = true;
  }

  Future<void> _save() async {
    final fullName =
        '${_firstNameController.text.trim()} '
                '${_lastNameController.text.trim()}'
            .trim();

    if (fullName.isEmpty) return;

    setState(() {
      _saving = true;
    });

    try {
      await updateProfile(
        ref,
        UpdateProfileRequest(
          name: fullName,
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save: $e'),
          backgroundColor: errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

    Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: surfaceCards,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kCardRadius),
          ),
          title: Text(
            'Log out?',
            style: TextStyle(
              color: onSurfaceColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'You\'ll need to sign in again to access your account.',
            style: TextStyle(
              color: mutedTextColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: TextStyle(color: mutedTextColor),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Log Out',
                style: TextStyle(
                  color: errorColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (!mounted) return;
      await performLogout(ref, context);
    }
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceCards,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(kCardRadius),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose an avatar',
                style: TextStyle(
                  color: onSurfaceColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),

              Wrap(
                spacing: 12,
                children: List.generate(
                  _avatarIcons.length,
                  (i) {
                    final selected =
                        i == _selectedAvatarIndex;

                    return InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        setState(() {
                          _selectedAvatarIndex = i;
                        });

                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: selected
                            ? actionHighlight.withOpacity(0.15)
                            : canvasBase,
                        child: Icon(
                          _avatarIcons[i],
                          color: selected
                              ? actionHighlight
                              : mutedTextColor,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Photo upload isn\'t available yet — pick a placeholder for now.',
                style: TextStyle(
                  color: mutedTextColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final resultsAsync = ref.watch(resultHistoryProvider);

    return Scaffold(
      backgroundColor: canvasBase,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: TextStyle(
                  color: onSurfaceColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 20),

              profileAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (err, _) => Text(
                  'Failed to load profile: $err',
                  style: TextStyle(
                    color: errorColor,
                  ),
                ),
                data: (profile) {
                  _prefillFromName(profile.name);

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: surfaceCards,
                      borderRadius:
                          BorderRadius.circular(kCardRadius),
                      border: Border.all(
                        color: glossOutline,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: _showAvatarPicker,
                              borderRadius:
                                  BorderRadius.circular(32),
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundColor: canvasBase,
                                    child: Icon(
                                      _avatarIcons[
                                          _selectedAvatarIndex],
                                      size: 30,
                                      color: mutedTextColor,
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding:
                                          const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: actionHighlight,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: surfaceCards,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.photo_camera,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile.email,
                                    style: TextStyle(
                                      color: mutedTextColor,
                                      fontSize: 12,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: actionHighlight
                                          .withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                      border: Border.all(
                                        color: actionHighlight
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize:
                                          MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.shield_outlined,
                                          size: 13,
                                          color: actionHighlight,
                                        ),

                                        const SizedBox(width: 5),

                                        Text(
                                          'Free',
                                          style: TextStyle(
                                            color:
                                                actionHighlight,
                                            fontWeight:
                                                FontWeight.w600,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: _editField(
                                'First Name',
                                _firstNameController,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: _editField(
                                'Last Name',
                                _lastNameController,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                _saving ? null : _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  actionHighlight,
                              foregroundColor:
                                  Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  kCardRadius,
                                ),
                              ),
                            ),
                            child: _saving
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.save_outlined,
                                        size: 16,
                                        color: Colors.white,
                                      ),

                                      SizedBox(width: 8),

                                      Text(
                                        'Save Changes',
                                        style: TextStyle(
                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              Text(
                'Your Progress',
                style: TextStyle(
                  color: onSurfaceColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              resultsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (err, _) => Text(
                  'Failed to load progress: $err',
                  style: TextStyle(
                    color: errorColor,
                  ),
                ),
                data: (results) {
                  final completedModules = results.length;

                  final avgScore = results.isEmpty
                      ? 0
                      : (results
                                  .map((r) => r.score)
                                  .reduce(
                                    (a, b) => a + b,
                                  ) /
                              results.length)
                          .round();

                  return Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          icon:
                              Icons.check_circle_outline,
                          label: 'Modules Completed',
                          value: '$completedModules',
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _statCard(
                          icon: Icons.bar_chart,
                          label: 'Avg. Score',
                          value: '$avgScore / 6',
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.push(
                    AppRoutes.resultsHistory,
                  ),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    side: BorderSide(
                      color: glossOutline,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        kCardRadius,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 18,
                        color: onSurfaceColor,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        'View Past Results',
                        style: TextStyle(
                          color: onSurfaceColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _confirmLogout(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: errorColor.withOpacity(0.4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kCardRadius),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 18, color: errorColor),
                      const SizedBox(width: 8),
                      Text(
                        'Log Out',
                        style: TextStyle(
                          color: errorColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _editField(
    String label,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: mutedTextColor,
            fontSize: 11,
          ),
        ),

        const SizedBox(height: 6),

        Container(
          height: 44,
          padding:
              const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: canvasBase,
            borderRadius:
                BorderRadius.circular(kCardRadius),
            border: Border.all(
              color: glossOutline,
            ),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(
              color: onSurfaceColor,
              fontSize: 14,
            ),
            decoration:
                const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceCards,
        borderRadius:
            BorderRadius.circular(kCardRadius),
        border: Border.all(
          color: glossOutline,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: successColor,
            size: 20,
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: TextStyle(
              color: onSurfaceColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,
            style: TextStyle(
              color: mutedTextColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}