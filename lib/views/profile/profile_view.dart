import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/language_controller.dart';
import '../../models/user_model.dart';
import '../auth/login_view.dart';
import '../customer_support/customer_support_view.dart';
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

  static const Color primaryGreen = Color(0xFF0F9D58);
  static const Color darkGreen = Color(0xFF064E3B);
  static const Color bgCanvas = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);

  String _formatAddress(UserModel? userData) {
    if (userData == null) return 'ঠিকানা নির্ধারণ করা হয়নি';

    final rawParts = [
      userData.union.trim(),
      userData.upazila.trim(),
      userData.district.trim(),
      userData.division.trim(),
    ].where((p) => p.isNotEmpty).toList();

    if (rawParts.isEmpty) return 'ঠিকানা নির্ধারণ করা হয়নি';

    final List<String> cleanParts = [];
    for (var part in rawParts) {
      if (cleanParts.isEmpty || cleanParts.last.toLowerCase() != part.toLowerCase()) {
        cleanParts.add(part);
      }
    }

    return cleanParts.join(', ');
  }

  String _extractPhone(String? email) {
    if (email == null || email.isEmpty) return 'N/A';
    return email.split('@').first;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authController,
      builder: (context, _) {
        final user = authController.currentUser;
        final userData = authController.currentUserData;
        final String name = (userData?.name != null && userData!.name.trim().isNotEmpty)
            ? userData.name
            : (user?.displayName ?? 'ব্যবহারকারী');

        final String userEmail = user?.email ?? '';
        final bool isGoogleUser = userEmail.isNotEmpty && !userEmail.endsWith('@mediseba.com');

        String rawPhone = userData?.phone ?? '';
        if (rawPhone.contains('@')) rawPhone = '';
        final bool hasValidPhone = rawPhone.isNotEmpty && !rawPhone.contains('@');

        final String displayContact = isGoogleUser
            ? userEmail
            : (hasValidPhone ? rawPhone : _extractPhone(user?.email));
        final String contactLabel = isGoogleUser ? 'ইমেইল ঠিকানা' : 'মোবাইল নম্বর';
        final IconData contactIcon = isGoogleUser ? Icons.email_outlined : Icons.phone_iphone_rounded;

        final double completionPct = authController.profileCompletionPercentage;
        final String addressText = _formatAddress(userData);

        return Scaffold(
          backgroundColor: bgCanvas,
          appBar: AppBar(
            backgroundColor: bgCanvas,
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 16,
            leading: showAppBarLeading
                ? Padding(
                    padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: textDark,
                          size: 18,
                        ),
                      ),
                    ),
                  )
                : null,
            title: const Text(
              'আমার প্রোফাইল',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: textDark,
                letterSpacing: -0.2,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileView(authController: authController),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: primaryGreen.withValues(alpha: 0.2)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.edit_outlined, color: primaryGreen, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'সম্পাদনা',
                          style: TextStyle(
                            color: primaryGreen,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Header Profile Card ──────────────────────────────
                  _buildHeaderCard(context, userData, name, displayContact, isGoogleUser),

                  const SizedBox(height: 20),

                  // ─── Profile Completion Card ──────────────────────────
                  _buildCompletionCard(context, completionPct),

                  const SizedBox(height: 24),

                  // ─── Personal Info Section ────────────────────────────
                  _buildSectionHeader('ব্যক্তিগত তথ্য'),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: contactIcon,
                    iconColor: const Color(0xFF6366F1),
                    iconBg: const Color(0xFFEEF2FF),
                    title: contactLabel,
                    subtitle: displayContact,
                  ),
                  const SizedBox(height: 10),

                  if (isGoogleUser && hasValidPhone) ...[
                    _buildInfoCard(
                      icon: Icons.phone_iphone_rounded,
                      iconColor: const Color(0xFF10B981),
                      iconBg: const Color(0xFFD1FAE5),
                      title: 'মোবাইল নম্বর',
                      subtitle: rawPhone,
                    ),
                    const SizedBox(height: 10),
                  ],

                  _buildInfoCard(
                    icon: Icons.location_on_rounded,
                    iconColor: const Color(0xFF0EA5E9),
                    iconBg: const Color(0xFFE0F2FE),
                    title: 'ঠিকানা',
                    subtitle: addressText,
                    subtitleColor: addressText == 'ঠিকানা নির্ধারণ করা হয়নি' ? textMuted : textDark,
                  ),
                  const SizedBox(height: 10),

                  if (userData?.referId != null && userData!.referId!.isNotEmpty) ...[
                    _buildInfoCard(
                      icon: Icons.card_giftcard_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      iconBg: const Color(0xFFFEF3C7),
                      title: 'রেফারেল আইডি',
                      subtitle: userData.referId!,
                      trailing: IconButton(
                        icon: const Icon(Icons.copy_rounded, size: 18, color: textMuted),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: userData.referId!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('রেফারেল কোড কপি করা হয়েছে!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  const SizedBox(height: 20),

                  // ─── Support & Services Section ───────────────────────
                  _buildSectionHeader('সহায়তা ও অন্যান্য'),
                  const SizedBox(height: 12),

                  _buildMenuCard(
                    icon: Icons.headset_mic_rounded,
                    iconColor: const Color(0xFF0F9D58),
                    iconBg: const Color(0xFFE6F4EA),
                    title: 'কাস্টমার সাপোর্ট ও হেল্পলাইন',
                    subtitle: 'যেকোনো প্রয়োজনে আমাদের সাথে যোগাযোগ করুন',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CustomerSupportView(
                            languageController: languageController,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // ─── Account Settings Section ────────────────────────
                  _buildSectionHeader('অ্যাকাউন্ট'),
                  const SizedBox(height: 12),

                  _buildMenuCard(
                    icon: Icons.edit_rounded,
                    iconColor: const Color(0xFF3B82F6),
                    iconBg: const Color(0xFFEFF6FF),
                    title: 'প্রোফাইল তথ্য আপডেট',
                    subtitle: 'আপনার নাম, ঠিকানা ও অন্যান্য তথ্য সংশোধন করুন',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileView(authController: authController),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Logout Card
                  InkWell(
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
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFFEE2E2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withValues(alpha: 0.03),
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
                              color: Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: const Icon(
                              Icons.logout_rounded,
                              color: Color(0xFFEF4444),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'লগআউট',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFEF4444),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'আপনার অ্যাকাউন্ট থেকে সাইন-আউট করুন',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: Color(0xFFEF4444),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Header Card ───────────────────────────────────────────────────
  Widget _buildHeaderCard(
    BuildContext context,
    UserModel? userData,
    String name,
    String displayContact,
    bool isGoogleUser,
  ) {
    final bool hasImage = userData?.profileImageUrl != null && userData!.profileImageUrl!.isNotEmpty;
    final bool isLoading = authController.isLoading;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F9D58), Color(0xFF064E3B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background subtle circles decor
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),

          // Main Header Content
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar Stack
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    child: Container(
                      height: 76,
                      width: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                        border: Border.all(color: Colors.white, width: 2),
                        image: hasImage
                            ? DecorationImage(
                                image: NetworkImage(userData.profileImageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: !hasImage
                          ? const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 44,
                            )
                          : null,
                    ),
                  ),
                  if (isLoading)
                    Container(
                      height: 82,
                      width: 82,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.45),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      ),
                    ),
                  if (!isLoading)
                    GestureDetector(
                      onTap: () => authController.updateProfilePicture(context),
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: primaryGreen,
                          size: 15,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 16),

              // Info Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayContact,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_rounded, size: 13, color: Color(0xFF86EFAC)),
                          SizedBox(width: 4),
                          Text(
                            'সক্রিয় ব্যবহারকারী',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }

  // ─── Profile Completion Card ───────────────────────────────────────
  Widget _buildCompletionCard(BuildContext context, double completionPct) {
    final int pct = completionPct.round();
    final bool is100Val = pct >= 100;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: is100Val ? const Color(0xFFBBF7D0) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: is100Val ? primaryGreen.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
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
                    color: is100Val ? primaryGreen : const Color(0xFF6366F1),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'প্রোফাইল সম্পূর্ণতা',
                    style: TextStyle(
                      fontSize: 14.5,
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
                  '%$pct',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: is100Val ? primaryGreen : const Color(0xFF6366F1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: completionPct / 100.0,
              minHeight: 8,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(
                is100Val ? primaryGreen : const Color(0xFF6366F1),
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
                    'সম্পূর্ণ সুবিধা পেতে প্রোফাইল ১০০% সম্পন্ন করুন',
                    style: TextStyle(
                      fontSize: 12,
                      color: textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileView(authController: authController),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'সম্পাদনা ›',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                        ),
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

  // ─── Section Header ────────────────────────────────────────────────
  Widget _buildSectionHeader(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: textMuted,
        letterSpacing: 0.4,
      ),
    );
  }

  // ─── Information Card Widget ───────────────────────────────────────
  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    Color? subtitleColor,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
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
            child: Icon(icon, color: iconColor, size: 20),
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
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14.5,
                    color: subtitleColor ?? textDark,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }

  // ─── Menu Navigation Card Widget ───────────────────────────────────
  Widget _buildMenuCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
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
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
