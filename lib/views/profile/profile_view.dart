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
    final String phone = _extractPhone(user?.email);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: textMuted,
                size: 28,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF1F5F9),
                  border: Border.all(color: brandGreen, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: brandGreen.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: brandGreen,
                  size: 60,
                ),
              ),
              const SizedBox(height: 16),
              
              // Name
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 4),
              
              // Phone
              Text(
                phone,
                style: const TextStyle(
                  fontSize: 16,
                  color: textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),

              // Profile Details Cards
              _buildProfileItem(
                icon: Icons.phone_android_rounded,
                title: 'Mobile Number',
                subtitle: phone,
              ),
              const SizedBox(height: 12),
              
              if (userData != null) ...[
                _buildProfileItem(
                  icon: Icons.location_on_outlined,
                  title: 'Address',
                  subtitle: '${userData.union}, ${userData.upazila}, ${userData.district}, ${userData.division}',
                ),
                const SizedBox(height: 12),
                
                if (userData.referId != null && userData.referId!.isNotEmpty) ...[
                  _buildProfileItem(
                    icon: Icons.group_add_outlined,
                    title: 'Refer ID',
                    subtitle: userData.referId!,
                  ),
                  const SizedBox(height: 12),
                ],
              ],
              
              _buildProfileItem(
                icon: Icons.verified_user_outlined,
                title: 'Account Status',
                subtitle: 'Active',
                subtitleColor: brandGreen,
              ),
              
              const SizedBox(height: 40),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () async {
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
                  icon: const Icon(Icons.logout_rounded, color: brandRed),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: brandRed,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEF2F2), // Light red background
                    foregroundColor: brandRed,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFFFCA5A5), width: 1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: brandGreen, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: subtitleColor ?? textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
