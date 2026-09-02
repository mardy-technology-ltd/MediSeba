import 'package:flutter/material.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/language_controller.dart';
import '../../auth/login_view.dart';
import '../../customer_support/customer_support_view.dart';
import '../../offers/offer_list_view.dart';

class HbpDrawer extends StatelessWidget {
  final AuthController authController;
  final HomeController homeController;
  final LanguageController? languageController;
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onRegisterCustomerTap;

  const HbpDrawer({
    super.key,
    required this.authController,
    required this.homeController,
    this.languageController,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onRegisterCustomerTap,
  });

  @override
  Widget build(BuildContext context) {
    final userName = authController.currentUserData?.name ?? authController.currentUser?.displayName ?? 'Sojib (HBP Agent)';
    final userPhone = authController.currentUserData?.phone ?? authController.currentUser?.email ?? '01710000010';

    return Drawer(
      backgroundColor: const Color(0xFF0F172A),
      child: SafeArea(
        child: Column(
          children: [
            // Top HBP Agent Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF1E293B), width: 1.5),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00A859), Color(0xFF005A36)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00A859).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'S',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          userPhone,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00A859).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF00A859).withValues(alpha: 0.4),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_rounded, size: 12, color: Color(0xFF00A859)),
                              SizedBox(width: 4),
                              Text(
                                'HBP Field Agent',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF00A859),
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
            ),

            // Navigation Links
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                children: [
                  _buildDrawerItem(
                    icon: Icons.dashboard_rounded,
                    title: 'এইচবিপি ড্যাশবোর্ড',
                    subtitle: 'সেলস ও প্রমোশন ট্র্যাকার',
                    isSelected: selectedIndex == 0,
                    onTap: () {
                      Navigator.pop(context);
                      onItemSelected(0);
                    },
                  ),
                  const SizedBox(height: 4),
                  _buildDrawerItem(
                    icon: Icons.person_add_alt_1_rounded,
                    title: 'নতুন কাস্টমার রেজিস্ট্রেশন',
                    subtitle: 'তাত্ক্ষণিক অনবোর্ডিং',
                    isSelected: false,
                    accentColor: const Color(0xFF00A859),
                    onTap: () {
                      Navigator.pop(context);
                      onRegisterCustomerTap();
                    },
                  ),
                  const SizedBox(height: 4),
                  _buildDrawerItem(
                    icon: Icons.people_alt_rounded,
                    title: 'কাস্টমার ও প্যাকেজ তালিকা',
                    subtitle: 'মাঠ পর্যায়ের তালিকা',
                    isSelected: selectedIndex == 1,
                    onTap: () {
                      Navigator.pop(context);
                      onItemSelected(1);
                    },
                  ),
                  const SizedBox(height: 4),
                  _buildDrawerItem(
                    icon: Icons.account_balance_wallet_rounded,
                    title: 'ওয়ালেট ও ক্যাশ-আউট',
                    subtitle: 'কমিশন ও পে-আউট হিস্ট্রি',
                    isSelected: selectedIndex == 2,
                    onTap: () {
                      Navigator.pop(context);
                      onItemSelected(2);
                    },
                  ),
                  const SizedBox(height: 4),
                  _buildDrawerItem(
                    icon: Icons.card_giftcard_rounded,
                    title: 'হেলথ প্যাকেজ ক্যাটালগ',
                    subtitle: 'মেডিসেবা প্রিমিয়াম প্যাকেজ',
                    isSelected: false,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OfferListView(
                            showAppBar: true,
                            languageController: languageController,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  _buildDrawerItem(
                    icon: Icons.headset_mic_rounded,
                    title: 'সুপারভাইজার ও সাপোর্ট',
                    subtitle: '২৪/৭ ফিল্ড এজেন্ট হেল্পলাইন',
                    isSelected: false,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CustomerSupportView()),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Bottom Logout & Referral Tag
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF1E293B), width: 1.2),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.qr_code_rounded, color: Color(0xFF00A859), size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'রেফারেল কোড: MSB-1101',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFCBD5E1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await authController.logout();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginView(
                                homeController: homeController,
                                authController: authController,
                                languageController: languageController,
                              ),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text(
                        'লগআউট (Sign Out)',
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444).withValues(alpha: 0.12),
                        foregroundColor: const Color(0xFFEF4444),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    Color? accentColor,
  }) {
    final activeColor = accentColor ?? const Color(0xFF00A859);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: isSelected
                ? Border.all(color: activeColor.withValues(alpha: 0.4), width: 1.2)
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? activeColor : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected ? Colors.white : (accentColor ?? const Color(0xFF94A3B8)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFFE2E8F0),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: activeColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
