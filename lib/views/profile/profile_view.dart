import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../auth/login_view.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/language_controller.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatelessWidget {
  final AuthController authController;
  final HomeController homeController;
  final bool showAppBarLeading;
  final LanguageController? languageController;

  const ProfileView({
    super.key,
    required this.authController,
    required this.homeController,
    this.showAppBarLeading = true,
    this.languageController,
  });

  static const brandGreen = Color(0xFF008536);
  static const brandGreenDark = Color(0xFF006428);
  static const brandGreenLight = Color(0xFF02A946);
  static const brandRed = Color(0xFFED1B24);
  static const textDark = Color(0xFF1E293B);
  static const textMuted = Color(0xFF64748B);

  String _extractPhone(String? email) {
    if (email == null) return 'N/A';
    return email.split('@').first;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authController,
      builder: (context, _) {
        final user = authController.currentUser;
        final userData = authController.currentUserData;
        final String name = userData?.name ?? user?.displayName ?? 'User';

        final String userEmail = user?.email ?? '';
        final bool isGoogleUser = userEmail.isNotEmpty && !userEmail.endsWith('@mediseba.com');

        // Determine phone
        String rawPhone = userData?.phone ?? '';
        if (rawPhone.contains('@')) rawPhone = '';
        final bool hasValidPhone = rawPhone.isNotEmpty && !rawPhone.contains('@');

        final String displayContact = isGoogleUser 
            ? userEmail 
            : (hasValidPhone ? rawPhone : _extractPhone(user?.email));
        final String contactLabel = isGoogleUser ? 'Gmail' : 'Mobile Number';
        final IconData contactIcon = isGoogleUser ? Icons.email_rounded : Icons.phone_android_rounded;

        final double completionPct = authController.profileCompletionPercentage;

        // Address string
        String addressText = 'Not set (Tap edit to add)';
        if (userData != null &&
            userData.division.isNotEmpty &&
            userData.district.isNotEmpty) {
          final parts = [
            if (userData.union.isNotEmpty) userData.union,
            if (userData.upazila.isNotEmpty) userData.upazila,
            userData.district,
            userData.division,
          ];
          addressText = parts.join(', ');
        }

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
                automaticallyImplyLeading: showAppBarLeading,
                leading: showAppBarLeading
                    ? Padding(
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
                      )
                    : null,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileView(authController: authController),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.edit_rounded, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
                      // ─── Profile Completion Card ────────────────
                      _buildCompletionCard(context, completionPct),
                      const SizedBox(height: 20),

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

                      // Additional phone card for Google users if phone added
                      if (isGoogleUser && hasValidPhone) ...[
                        _buildInfoCard(
                          icon: Icons.phone_android_rounded,
                          iconColor: const Color(0xFF10B981),
                          iconBg: const Color(0xFFD1FAE5),
                          title: 'Mobile Number',
                          subtitle: rawPhone,
                        ),
                        const SizedBox(height: 10),
                      ],

                      _buildInfoCard(
                        icon: Icons.location_on_rounded,
                        iconColor: const Color(0xFF0EA5E9),
                        iconBg: const Color(0xFFE0F2FE),
                        title: 'Address',
                        subtitle: addressText,
                        subtitleColor: addressText.startsWith('Not set') ? textMuted : textDark,
                      ),
                      const SizedBox(height: 10),

                      if (userData?.referId != null &&
                          userData!.referId!.isNotEmpty) ...[
                        _buildInfoCard(
                          icon: Icons.group_add_rounded,
                          iconColor: const Color(0xFFF59E0B),
                          iconBg: const Color(0xFFFEF3C7),
                          title: 'Refer ID',
                          subtitle: userData.referId!,
                        ),
                        const SizedBox(height: 10),
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
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                                child: const Icon(
                                  Icons.logout_rounded,
                                  color: brandRed,
                                  size: 22,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: brandRed,
                                  ),
                                ),
                              ),
                              Icon(
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
      },
    );
  }

  Widget _buildCompletionCard(BuildContext context, double completionPct) {
    final int pct = completionPct.round();
    final bool is100Val = pct >= 100;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: is100Val ? brandGreen.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: is100Val ? const Color(0xFFBBF7D0) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    is100Val ? Icons.check_circle_rounded : Icons.pie_chart_rounded,
                    color: is100Val ? brandGreen : const Color(0xFF6366F1),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Profile Completion',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: is100Val ? const Color(0xFFDCFCE7) : const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$pct%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: is100Val ? brandGreen : const Color(0xFF6366F1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: completionPct / 100.0,
              minHeight: 8,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                is100Val ? brandGreen : const Color(0xFF6366F1),
              ),
            ),
          ),

          if (!is100Val) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Complete your profile to reach 100%',
                    style: TextStyle(
                      fontSize: 12,
                      color: textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileView(authController: authController),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: brandGreen,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: brandGreen,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
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
