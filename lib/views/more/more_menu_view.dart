import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../health_consultation/health_consultation_view.dart';
import '../about/about_us_view.dart';
import '../privacy_policy/privacy_policy_view.dart';
import '../social/social_media_view.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/share_app_dialog.dart';
import '../../widgets/helpline_bottom_sheet.dart';
import '../profile/profile_view.dart';

class MoreMenuView extends StatelessWidget {
  final AuthController authController;
  final HomeController homeController;
  final LanguageController? languageController;

  const MoreMenuView({
    super.key,
    required this.authController,
    required this.homeController,
    this.languageController,
  });

  static const brandGreen = Color(0xFF008536);
  static const brandRed = Color(0xFFED1B24);
  static const textDark = Color(0xFF1E293B);
  static const textMuted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'আরও মেনু ও সেবা',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Profile Card Header
              ListenableBuilder(
                listenable: authController,
                builder: (context, _) {
                  final user = authController.currentUser;
                  final userData = authController.currentUserData;
                  final name = userData?.name ?? user?.displayName ?? 'মেডি সেবা ইউজার';
                  final contact = userData?.phone ?? user?.email ?? '';
                  final profileImg = userData?.profileImageUrl ?? user?.photoURL;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileView(
                            authController: authController,
                            homeController: homeController,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF062316), Color(0xFF0B462A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: brandGreen.withValues(alpha: 0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.2),
                              border: Border.all(color: Colors.white, width: 2),
                              image: profileImg != null && profileImg.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(profileImg),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: profileImg == null || profileImg.isEmpty
                                ? const Icon(Icons.person_rounded, color: Colors.white, size: 30)
                                : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  contact,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 24),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Section: Additional Services
              const Text(
                'অন্যান্য সেবাসমূহ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              // Quick Grid Actions
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.3,
                children: [
                  _buildQuickTile(
                    context,
                    title: 'স্বাস্থ্য পরামর্শ',
                    icon: Icons.health_and_safety_rounded,
                    color: const Color(0xFF0F9D58),
                    bg: const Color(0xFFE8F5E9),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HealthConsultationView()),
                    ),
                  ),
                  _buildQuickTile(
                    context,
                    title: 'হেল্পলাইন সেবা',
                    icon: Icons.headset_mic_rounded,
                    color: const Color(0xFF1565C0),
                    bg: const Color(0xFFE3F2FD),
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const HelplineBottomSheet(),
                    ),
                  ),
                  _buildQuickTile(
                    context,
                    title: 'অ্যাম্বুলেন্স সেবা',
                    icon: Icons.airport_shuttle_rounded,
                    color: const Color(0xFFE53935),
                    bg: const Color(0xFFFFEBEE),
                    onTap: () {},
                  ),
                  _buildQuickTile(
                    context,
                    title: 'মাতৃসেবা',
                    icon: Icons.pregnant_woman_rounded,
                    color: const Color(0xFFAD1457),
                    bg: const Color(0xFFFCE4EC),
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Section: App Preferences & Support
              const Text(
                'অ্যাপ সেটিংস ও তথ্য',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                ),
                child: Column(
                  children: [
                    _buildListOption(
                      icon: Icons.share_rounded,
                      iconBg: const Color(0xFFEEF2FF),
                      iconColor: const Color(0xFF6366F1),
                      title: 'মেডি সেবা অ্যাপ শেয়ার করুন',
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => const ShareAppDialog(),
                      ),
                    ),
                    const Divider(height: 1, indent: 60, color: Color(0xFFF1F5F9)),
                    _buildListOption(
                      icon: Icons.public_rounded,
                      iconBg: const Color(0xFFE0F2FE),
                      iconColor: const Color(0xFF0EA5E9),
                      title: 'সোশ্যাল মিডিয়া পেজসমূহ',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SocialMediaView(languageController: languageController),
                        ),
                      ),
                    ),
                    const Divider(height: 1, indent: 60, color: Color(0xFFF1F5F9)),
                    _buildListOption(
                      icon: Icons.info_outline_rounded,
                      iconBg: const Color(0xFFFEF3C7),
                      iconColor: const Color(0xFFF59E0B),
                      title: 'আমাদের সম্পর্কে',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutUsView()),
                      ),
                    ),
                    const Divider(height: 1, indent: 60, color: Color(0xFFF1F5F9)),
                    _buildListOption(
                      icon: Icons.privacy_tip_outlined,
                      iconBg: const Color(0xFFE8F5E9),
                      iconColor: const Color(0xFF0F9D58),
                      title: 'প্রাইভেসি পলিসি (Privacy Policy)',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PrivacyPolicyView(languageController: languageController),
                        ),
                      ),
                    ),
                    const Divider(height: 1, indent: 60, color: Color(0xFFF1F5F9)),
                    _buildListOption(
                      icon: Icons.logout_rounded,
                      iconBg: const Color(0xFFFEE2E2),
                      iconColor: brandRed,
                      title: 'লগআউট করুন',
                      titleColor: brandRed,
                      onTap: () async {
                        await authController.logout();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListOption({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: titleColor ?? textDark,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: textMuted, size: 20),
    );
  }
}
