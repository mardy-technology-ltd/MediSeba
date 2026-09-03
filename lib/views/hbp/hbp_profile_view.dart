import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/language_controller.dart';
import '../customer_support/customer_support_view.dart';

class HbpProfileView extends StatefulWidget {
  final AuthController authController;
  final LanguageController? languageController;

  const HbpProfileView({
    super.key,
    required this.authController,
    this.languageController,
  });

  @override
  State<HbpProfileView> createState() => _HbpProfileViewState();
}

class _HbpProfileViewState extends State<HbpProfileView> {
  final String _referralCode = 'MSB-1101';
  final String _hbpId = 'MSB-HBP-0044';
  final String _supervisorName = 'মোঃ আরিফুল ইসলাম';
  final String _supervisorPhone = '01710000010';
  final String _joiningDate = '১২ জানুয়ারি, ২০২৪';
  final String _assignedRegion = 'রাজশাহী বিভাগ / বোয়ালিয়া অঞ্চল';

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text('$label "$text" ক্লিপবোর্ডে কপি করা হয়েছে!')),
          ],
        ),
        backgroundColor: const Color(0xFF0F9D58),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const userName = 'Sojib';
    const userPhone = '01798456879';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'এইচবিপি প্রোফাইল ও অ্যাকাউন্ট',
          style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
        },
        color: const Color(0xFF0F9D58),
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Header Profile Card
              _buildHeroProfileCard(userName, userPhone),

              const SizedBox(height: 16),

              // 2. HBP Wallet & Commission Card
              _buildWalletCard(),

              const SizedBox(height: 20),

              // 3. Official HBP Officer Info Card
              _buildSectionTitle('অফিসিয়াল এইচবিপি পরিচয় ও কর্মক্ষেত্র'),
              const SizedBox(height: 10),
              _buildOfficialInfoCard(),

              const SizedBox(height: 20),

              // 4. Sales & Target Performance Summary
              _buildSectionTitle('সেলস টার্গেট ও ইনসেন্টিভ পারফরম্যান্স'),
              const SizedBox(height: 10),
              _buildPerformanceCard(),

              const SizedBox(height: 20),

              // 4. Personal & Contact Details
              _buildSectionTitle('ব্যক্তিগত ও জরুরি পরিচিতি'),
              const SizedBox(height: 10),
              _buildPersonalInfoCard(userPhone),

              const SizedBox(height: 20),

              // 5. Payment & Payout Accounts
              _buildSectionTitle('কমিশন পে-আউট ওয়ালেট অ্যাকাউন্টস'),
              const SizedBox(height: 10),
              _buildPayoutAccountsCard(),

              const SizedBox(height: 24),

              // 6. Action Buttons
              _buildActionButtons(context),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Hero Header Profile Card
  Widget _buildHeroProfileCard(String userName, String userPhone) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF003822), Color(0xFF005A36)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003822).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: const Color(0xFF0F9D58),
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'S',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF00E676),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 14, color: Color(0xFF003822)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            userName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(height: 2),
          Text(
            userPhone,
            style: const TextStyle(fontSize: 13.5, color: Color(0xFFCBD5E1), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_user_rounded, color: Color(0xFF00E676), size: 15),
                  SizedBox(width: 6),
                  Text(
                    'অফিসিয়াল হেলথ প্রমোশন পার্টনার (Verified HBP)',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Referral Code Pill Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('রেফারেল কোড', style: TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8))),
                      Text(_referralCode, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFFFACC15))),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _copyToClipboard(_referralCode, 'রেফারেল কোড'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAB308),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.copy_rounded, size: 13, color: Color(0xFF0F172A)),
                        SizedBox(width: 4),
                        Text(
                          'কপি',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. HBP Wallet & Commission Card
  Widget _buildWalletCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF007A3E),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF007A3E).withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'এইচবিপি ওয়ালেট ও কমিশন',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'বর্তমান উপলব্ধ কমিশন ব্যালেন্স',
            style: TextStyle(fontSize: 12, color: Color(0xFFE2E8F0), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            '৳ ৩৫০',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'মোট সেলস কালেকশন: ৳ ১,৭৫০',
              style: TextStyle(fontSize: 11.5, color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'উইথড্র রিকোয়েস্ট সফলভাবে সাবমিট হয়েছে। অ্যাডমিন পর্যালোচনা করছেন।',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: const Color(0xFF0F9D58),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              icon: const Icon(Icons.send_to_mobile_rounded, size: 18),
              label: const Text(
                'কমিশন ক্যাশ-আউট করুন (bKash/Nagad)',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A859),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Official Info Card
  Widget _buildOfficialInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(Icons.badge_rounded, 'আইডি নম্বর (HBP ID)', _hbpId),
          const Divider(height: 18),
          _buildDetailRow(Icons.map_rounded, 'দায়িত্বপ্রাপ্ত এলাকা', _assignedRegion),
          const Divider(height: 18),
          _buildDetailRow(Icons.supervisor_account_rounded, 'রিপোর্টিং সুপারভাইজার', _supervisorName),
          const Divider(height: 18),
          _buildDetailRow(Icons.phone_in_talk_rounded, 'সুপারভাইজার ফোন', _supervisorPhone),
          const Divider(height: 18),
          _buildDetailRow(Icons.calendar_today_rounded, 'যোগদানের তারিখ', _joiningDate),
        ],
      ),
    );
  }

  // 3. Performance Card
  Widget _buildPerformanceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(Icons.track_changes_rounded, 'মাসিক সেলস টার্গেট', '২১৪ টি প্যাকেজ'),
          const Divider(height: 18),
          _buildDetailRow(Icons.military_tech_rounded, 'চলতি মাসের র‍্যাংক', 'সিলভার পার্টনার (Silver)'),
          const Divider(height: 18),
          _buildDetailRow(Icons.people_outline_rounded, 'মোট রেজিস্টার্ড কাস্টমার', '১৫ জন'),
          const Divider(height: 18),
          _buildDetailRow(Icons.monetization_on_rounded, 'মোট সেলস কালেকশন', '৳ ১,৭৫০'),
        ],
      ),
    );
  }

  // 4. Personal Info Card
  Widget _buildPersonalInfoCard(String phone) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(Icons.fingerprint_rounded, 'জাতীয় পরিচয়পত্র (NID)', '**********৬৭৮৯ (যাচাইকৃত)'),
          const Divider(height: 18),
          _buildDetailRow(Icons.email_rounded, 'অফিসিয়াল ইমেইল', 'sojib.hbp@mediseba.com'),
          const Divider(height: 18),
          _buildDetailRow(Icons.contact_phone_rounded, 'জরুরি যোগাযোগ নম্বর', phone),
          const Divider(height: 18),
          _buildDetailRow(Icons.location_on_rounded, 'স্থায়ী ঠিকানা', 'বোয়ালিয়া বাজার বিআরটিএ গলি, রাজশাহী'),
        ],
      ),
    );
  }

  // 5. Payout Accounts Card
  Widget _buildPayoutAccountsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(Icons.account_balance_wallet_rounded, 'বিকাশ ওয়ালেট নম্বর', '01798456879 (Primary)'),
          const Divider(height: 18),
          _buildDetailRow(Icons.account_balance_wallet_outlined, 'নগদ ওয়ালেট নম্বর', '01798456879'),
          const Divider(height: 18),
          _buildDetailRow(Icons.account_balance_rounded, 'ব্যাংক অ্যাকাউন্ট', 'ডাচ-বাংলা ব্যাংক লিমিটেড (DBBL)'),
        ],
      ),
    );
  }

  // Action Buttons
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CustomerSupportView()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F9D58),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.headset_mic_rounded, color: Colors.white, size: 18),
            label: const Text(
              'সুপারভাইজার ও হেল্পলাইনে যোগাযোগ করুন',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () async {
              await widget.authController.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
              side: const BorderSide(color: Color(0xFFEF4444), width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text(
              'লগআউট করুন (Sign Out)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF00A859)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
