import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../auth/login_view.dart';
import '../../controllers/home_controller.dart';

class ProfileView extends StatelessWidget {
  final AuthController authController;
  final HomeController homeController;

  const ProfileView({
    super.key,
    required this.authController,
    required this.homeController,
  });

  static const brandGreen = Color(0xFF0F9D58);
  static const brandGreenDark = Color(0xFF0A7D44);
  static const brandGreenLight = Color(0xFF34C97A);
  static const brandRed = Color(0xFFE53935);
  static const textDark = Color(0xFF1E293B);
  static const textMuted = Color(0xFF64748B);

  String _extractPhone(String? email) {
    if (email == null) return 'N/A';
    return email.split('@').first;
  }

  @override
  Widget build(BuildContext context) {
    final user = authController.currentUser;
    final userData = authController.currentUserData;
    final String name = user?.displayName ?? 'User';

    final String userEmail = user?.email ?? '';
    final bool isGoogleUser = userEmail.isNotEmpty && !userEmail.endsWith('@mediseba.com');

    final String displayContact = isGoogleUser ? userEmail : _extractPhone(user?.email);
    final String contactLabel = isGoogleUser ? 'Gmail' : 'Mobile Number';
    final IconData contactIcon = isGoogleUser ? Icons.email_rounded : Icons.phone_android_rounded;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: CustomScrollView(
        slivers: [
          // ─── Modern Gradient Header ───────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            elevation: 0,
            backgroundColor: brandGreen,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(context, name, displayContact, isGoogleUser),
            ),
            title: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          // ─── Content ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Section: Personal Info
                  _buildSectionLabel('Personal Info'),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: contactIcon,
                    iconColor: const Color(0xFF6366F1),
                    iconBg: const Color(0xFFEEF2FF),
                    title: contactLabel,
                    subtitle: displayContact,
                  ),
                  const SizedBox(height: 10),

                  if (userData != null) ...[
                    _buildInfoCard(
                      icon: Icons.location_on_rounded,
                      iconColor: const Color(0xFF0EA5E9),
                      iconBg: const Color(0xFFE0F2FE),
                      title: 'Address',
                      subtitle:
                          '${userData.union}, ${userData.upazila},\n${userData.district}, ${userData.division}',
                    ),
                    const SizedBox(height: 10),

                    if (userData.referId != null &&
                        userData.referId!.isNotEmpty) ...[
                      _buildInfoCard(
                        icon: Icons.group_add_rounded,
                        iconColor: const Color(0xFFF59E0B),
                        iconBg: const Color(0xFFFEF3C7),
                        title: 'Refer ID',
                        subtitle: userData.referId!,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],

                  _buildInfoCard(
                    icon: Icons.verified_rounded,
                    iconColor: brandGreen,
                    iconBg: const Color(0xFFDCFCE7),
                    title: 'Account Status',
                    subtitle: 'Active',
                    subtitleColor: brandGreen,
                    badge: true,
                  ),

                  const SizedBox(height: 28),

                  // Section: Account
                  _buildSectionLabel('Account'),
                  const SizedBox(height: 12),

                  // Logout
                  GestureDetector(
                    onTap: () async {
                      await authController.logout();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginView(
                              authController: authController,
                              homeController: homeController,
                            ),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.logout_rounded,
                              color: brandRed,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: brandRed,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: brandRed,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name, String displayContact, bool isGoogleUser) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [brandGreenDark, brandGreen, brandGreenLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Avatar with upload button
                  ListenableBuilder(
                    listenable: authController,
                    builder: (context, _) {
                      final uData = authController.currentUserData;
                      final bool hasImage = uData?.profileImageUrl != null &&
                          uData!.profileImageUrl!.isNotEmpty;
                      final bool isLoading = authController.isLoading;

                      return Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          // Avatar ring
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.2),
                                border: Border.all(
                                    color: Colors.white, width: 2.5),
                                image: hasImage
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            uData.profileImageUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: !hasImage
                                  ? const Icon(
                                      Icons.person_rounded,
                                      color: Colors.white,
                                      size: 56,
                                    )
                                  : null,
                            ),
                          ),

                          // Loading overlay
                          if (isLoading)
                            Container(
                              height: 106,
                              width: 106,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withValues(alpha: 0.45),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              ),
                            ),

                          // Camera button
                          if (!isLoading)
                            GestureDetector(
                              onTap: () =>
                                  authController.updateProfilePicture(context),
                              child: Container(
                                height: 34,
                                width: 34,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: brandGreen,
                                  size: 18,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 14),

                  // Name
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Contact (Phone or Gmail)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isGoogleUser ? Icons.email_rounded : Icons.phone_rounded,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        displayContact,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: textMuted,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    Color? subtitleColor,
    bool badge = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: textMuted,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 15,
                    color: subtitleColor ?? textDark,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (badge)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '● Active',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: brandGreen,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
