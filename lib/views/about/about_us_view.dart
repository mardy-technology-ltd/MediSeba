import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../doctors/doctor_list_view.dart';

class AboutUsView extends StatelessWidget {
  final LanguageController? languageController;

  const AboutUsView({super.key, this.languageController});

  static const brandGreen = Color(0xFF008536);
  static const brandGreenDark = Color(0xFF00682B);
  static const brandGreenLight = Color(0xFFE8F5E9);
  static const textDark = Color(0xFF1E293B);
  static const textMuted = Color(0xFF64748B);

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = languageController ?? LanguageController();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        title: lang.tr('আমাদের সম্পর্কে', 'About Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HERO BANNER CARD (Green Card from Web Concept)
            _buildHeroSection(context, lang),

            const SizedBox(height: 16),

            // 2. STATS COUNTER GRID (4 Stats Cards)
            _buildStatsGrid(lang),

            const SizedBox(height: 24),

            // 3. MISSION & VALUES SECTION (আমাদের লক্ষ্য ও মূল্যবোধ)
            _buildMissionAndValuesSection(lang),

            const SizedBox(height: 24),

            // 4. CONTACT & OFFICES SECTION (যোগাযোগ ও অফিসসমূহ)
            _buildContactAndOfficesSection(lang),

            const SizedBox(height: 24),

            // 5. FOOTER COPYRIGHT
            Center(
              child: Text(
                '© 2026 MediSeba (মেডিসেবা)। সর্বস্বত্ব সংরক্ষিত।',
                style: TextStyle(
                  fontSize: 12,
                  color: textMuted.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // 1. HERO SECTION CARD
  Widget _buildHeroSection(BuildContext context, LanguageController lang) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF007530), Color(0xFF005221)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: brandGreen.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_user_rounded,
                  color: Colors.white,
                  size: 15,
                ),
                const SizedBox(width: 6),
                Text(
                  lang.tr('মেডিসেবা পরিচিতি (About MediSeba)', 'About MediSeba'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Main Title
          Text(
            lang.tr(
              'বাংলাদেশের আধুনিক ডিজিটাল স্বাস্থ্যসেবা প্ল্যাটফর্ম',
              'Bangladesh\'s Modern Digital Healthcare Platform',
            ),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),

          // Description
          Text(
            lang.tr(
              'মেডিসেবা দেশের স্বনামধন্য হাসপাতাল ও ডাক্তারদের একই ছাদের নিচে নিয়ে এসে সবার কাছে ডিজিটাল চিকিৎসা সহজলভ্য করছে।',
              'MediSeba brings renowned hospitals and doctors under one roof, making digital healthcare accessible to everyone.',
            ),
            style: TextStyle(
              fontSize: 13.5,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 18),

          // Action Button
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DoctorListView(languageController: languageController),
                ),
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    lang.tr('আমাদের ডক্টরবৃন্দ দেখুন', 'View Our Doctors'),
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: brandGreenDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: brandGreenDark,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. STATS COUNTER GRID (4 Stats Cards in 2x2 Grid)
  Widget _buildStatsGrid(LanguageController lang) {
    final stats = [
      {
        'number': '৫০+',
        'numberEn': '50+',
        'label': lang.tr('অভিজ্ঞ বিশেষজ্ঞ ডাক্তার', 'Experienced Specialists'),
      },
      {
        'number': '১০,০০০+',
        'numberEn': '10,000+',
        'label': lang.tr('সন্তুষ্ট রোগী সেবাগ্রহীতা', 'Satisfied Patients Served'),
      },
      {
        'number': '১২,০০০+',
        'numberEn': '12,000+',
        'label': lang.tr('ডাটাবেসে অরিজিনাল ওষুধ', 'Medicines in Database'),
      },
      {
        'number': '১০০%',
        'numberEn': '100%',
        'label': lang.tr('২৪/৭ জরুরি সাপোর্ট', '24/7 Emergency Support'),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.7,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        final numberStr = lang.isBangla ? stat['number']! : stat['numberEn']!;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                numberStr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: brandGreen,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                stat['label']!,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  // 3. MISSION & VALUES SECTION (আমাদের লক্ষ্য ও মূল্যবোধ)
  Widget _buildMissionAndValuesSection(LanguageController lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title & Subtitle
        Text(
          lang.tr('আমাদের লক্ষ্য ও মূল্যবোধ', 'Our Mission & Values'),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          lang.tr(
            'কেন মেডিসেবা দেশের মানুষের প্রথম পছন্দ',
            'Why MediSeba is the first choice of the nation',
          ),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: textMuted,
          ),
        ),
        const SizedBox(height: 14),

        // Value Card 1
        _buildValueCard(
          icon: Icons.verified_user_outlined,
          iconBg: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF0F9D58),
          title: lang.tr(
            'নির্ভরযোগ্যতা ও মানসম্পন্ন চিকিৎসা',
            'Reliability & Quality Healthcare',
          ),
          description: lang.tr(
            'আমরা শুধুমাত্র ভেরিফাইড বিএমডিসি রেজিস্টার্ড ডাক্তার ও অরিজিনাল ফার্মাসিউটিক্যাল ওষুধ সরবরাহ করি।',
            'We only provide verified BMDC registered doctors and 100% original pharmaceutical medicines.',
          ),
        ),
        const SizedBox(height: 12),

        // Value Card 2
        _buildValueCard(
          icon: Icons.touch_app_outlined,
          iconBg: const Color(0xFFE0F2FE),
          iconColor: const Color(0xFF0EA5E9),
          title: lang.tr(
            'ঝামেলাহীন ডিজিটাল অভিজ্ঞতা',
            'Seamless Digital Experience',
          ),
          description: lang.tr(
            'সহজ ইন্টারফেসের মাধ্যমে ঘরে বসেই ১ ক্লিকে ডাক্তারের অ্যাপয়েন্টমেন্ট ও ভিডিও কল গ্রহণ করতে পারবেন।',
            'Get doctor appointments and live video consultation at home in 1 click through an easy interface.',
          ),
        ),
        const SizedBox(height: 12),

        // Value Card 3
        _buildValueCard(
          icon: Icons.savings_outlined,
          iconBg: const Color(0xFFFEF3C7),
          iconColor: const Color(0xFFD97706),
          title: lang.tr(
            'সাশ্রয়ী স্বাস্থ্যসেবা',
            'Affordable Healthcare',
          ),
          description: lang.tr(
            'আমরা দেশের প্রতিটি মানুষের জন্য সাশ্রয়ী মূল্যে এবং বিশেষ ডিসকাউন্টে সেবা পৌঁছে দিতে প্রতিশ্রুতবদ্ধ।',
            'We are committed to delivering healthcare services at affordable prices & special discounts for everyone.',
          ),
        ),
      ],
    );
  }

  Widget _buildValueCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 4. CONTACT & OFFICES SECTION (যোগাযোগ ও অফিসসমূহ)
  Widget _buildContactAndOfficesSection(LanguageController lang) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: brandGreenLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.location_on_outlined, color: brandGreen, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                lang.tr('যোগাযোগ ও অফিসসমূহ', 'Contact & Offices'),
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Hotline 24/7 (Clickable)
          _buildContactTile(
            icon: Icons.phone_in_talk_rounded,
            iconColor: const Color(0xFF0F9D58),
            iconBg: const Color(0xFFE8F5E9),
            title: lang.tr('২৪/৭ জরুরি হটলাইন', '24/7 Emergency Hotline'),
            subtitle: '09647111666',
            onTap: () => _makePhoneCall('09647111666'),
            isActionable: true,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),

          // Email (Clickable)
          _buildContactTile(
            icon: Icons.email_outlined,
            iconColor: const Color(0xFF1565C0),
            iconBg: const Color(0xFFE3F2FD),
            title: lang.tr('অফিসিয়াল ইমেইল', 'Official Email'),
            subtitle: 'info@mediseba.org',
            onTap: () => _sendEmail('info@mediseba.org'),
            isActionable: true,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),

          // Dhaka Office
          _buildContactTile(
            icon: Icons.business_rounded,
            iconColor: const Color(0xFF8E24AA),
            iconBg: const Color(0xFFF3E5F5),
            title: lang.tr('ঢাকা হেড অফিস', 'Dhaka Head Office'),
            subtitle: lang.tr(
              'লেভেল ১৮, রোড ১০, সেক্টর ১১, উত্তরা, ঢাকা (১২৩০)।',
              'Level 18, Road 10, Sector 11, Uttara, Dhaka (1230).',
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),

          // Rajshahi Office
          _buildContactTile(
            icon: Icons.store_rounded,
            iconColor: const Color(0xFFD97706),
            iconBg: const Color(0xFFFEF3C7),
            title: lang.tr('রাজশাহী অফিস', 'Rajshahi Office'),
            subtitle: lang.tr(
              'তালাইমারী বাজার মসজিদের বিপরীত পাশে, বোয়ালিয়া, রাজশাহী।',
              'Opposite of Talaimari Bazar Mosque, Boalia, Rajshahi.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isActionable = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: isActionable ? brandGreenDark : textDark,
                      decoration: isActionable ? TextDecoration.underline : TextDecoration.none,
                      decorationColor: brandGreenDark,
                    ),
                  ),
                ],
              ),
            ),
            if (isActionable)
              const Icon(
                Icons.call_made_rounded,
                size: 16,
                color: brandGreenDark,
              ),
          ],
        ),
      ),
    );
  }
}

