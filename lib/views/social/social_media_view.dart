import 'package:flutter/material.dart';
import '../../controllers/language_controller.dart';
import '../../services/social_media_launcher.dart';
import '../../widgets/helpline_bottom_sheet.dart';

class SocialMediaView extends StatelessWidget {
  final LanguageController? languageController;

  const SocialMediaView({
    super.key,
    this.languageController,
  });

  static const brandGreen = Color(0xFF008536);
  static const textDark = Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    final lang = languageController ?? LanguageController();
    final isBangla = lang.isBangla;

    // Social Media Extra Metadata for Rich Cards
    final Map<String, Map<String, String>> socialMeta = {
      'facebook': {
        'handle': '@mediseba.org',
        'bnSub': 'অফিসিয়াল পেজ ও কমিউনিটিতে যুক্ত থাকুন',
        'enSub': 'Join our official page & community',
        'btnBn': 'ফলো করুন ➔',
        'btnEn': 'Follow ➔',
      },
      'youtube': {
        'handle': '@mediseba00',
        'bnSub': 'ডাক্তারদের ভিডিও পরামর্শ ও স্বাস্থ্য টিপস',
        'enSub': 'Watch doctor video tips & health guides',
        'btnBn': 'সাবস্ক্রাইব ➔',
        'btnEn': 'Subscribe ➔',
      },
      'instagram': {
        'handle': '@mediseba00',
        'bnSub': 'দৈনন্দিন লাইফস্টাইল টিপস ও ইনফোগ্রাফিক্স',
        'enSub': 'Daily lifestyle tips & infographics',
        'btnBn': 'ফলো করুন ➔',
        'btnEn': 'Follow ➔',
      },
      'twitter': {
        'handle': '@mediseba00',
        'bnSub': 'সর্বশেষ হেলথ আপডেট ও এনাউন্সমেন্ট',
        'enSub': 'Latest health news & announcements',
        'btnBn': 'ফলো করুন ➔',
        'btnEn': 'Follow ➔',
      },
      'pinterest': {
        'handle': '@mediseba00',
        'bnSub': 'স্বাস্থ্যকর ডায়েট চার্ট ও লাইফস্টাইল গাইড',
        'enSub': 'Healthy diet charts & lifestyle guides',
        'btnBn': 'ভিজিট করুন ➔',
        'btnEn': 'Visit ➔',
      },
      'linkedin': {
        'handle': 'MediSeba Official',
        'bnSub': 'কর্পোরেট আপডেট, ক্যারিয়ার ও পার্টনারশিপ',
        'enSub': 'Corporate updates, career & partnership',
        'btnBn': 'কানেক্ট হন ➔',
        'btnEn': 'Connect ➔',
      },
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: textDark),
        title: Text(
          lang.tr('সোশ্যাল মিডিয়া সংযোগ', 'Social Media'),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_in_talk_rounded, color: brandGreen),
            onPressed: () => showHelplineBottomSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Header Banner
              _buildHeroCard(lang),

              const SizedBox(height: 20),

              // 2. Section Title
              Text(
                lang.tr('আমাদের অফিসিয়াল সোশ্যাল চ্যানেলসমূহ', 'Our Official Social Channels'),
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w900,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 12),

              // 3. Social Media Cards List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: SocialMediaLauncher.items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = SocialMediaLauncher.items[index];
                  final meta = socialMeta[item.id] ?? {
                    'handle': '@mediseba',
                    'bnSub': 'মেডিসেবার সাথে যুক্ত থাকুন',
                    'enSub': 'Connect with MediSeba',
                    'btnBn': 'ভিজিট করুন ➔',
                    'btnEn': 'Visit ➔',
                  };

                  return _buildRichSocialCard(item, meta, isBangla);
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Hero Header Banner
  Widget _buildHeroCard(LanguageController lang) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF008536)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.share_rounded, color: Colors.white, size: 14),
                const SizedBox(width: 6),
                Text(
                  lang.tr('সোশ্যাল মিডিয়া সংযোগ (Social Connect)', 'Social Connect'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Text(
            lang.tr('মেডিসেবার সাথে সোশ্যাল মিডিয়ায় যুক্ত থাকুন', 'Stay Connected with MediSeba'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              height: 1.25,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            lang.tr(
              'নিয়মিত স্বাস্থ্য টিপস, নতুন ডাক্তারের তথ্য ও হেলথ ডিসকাউন্ট অফারের আপডেট পেতে আমাদের সোশ্যাল মিডিয়া চ্যানেলগুলো ফলো করুন।',
              'Follow our social media channels for daily health tips, doctor updates, and discount offers.',
            ),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  // 2. Rich Social Card Item (Overflow-Proof & Clean UI)
  Widget _buildRichSocialCard(
    SocialMediaItem item,
    Map<String, String> meta,
    bool isBangla,
  ) {
    final subtitle = isBangla ? meta['bnSub']! : meta['enSub']!;
    final btnText = isBangla ? meta['btnBn']! : meta['btnEn']!;

    return GestureDetector(
      onTap: () => SocialMediaLauncher.open(item),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: item.brandColor.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Official Icon Container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.brandColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: item.brandColor.withValues(alpha: 0.2), width: 1),
              ),
              child: Icon(
                item.iconData,
                color: item.brandColor,
                size: 24,
              ),
            ),

            const SizedBox(width: 12),

            // Middle Title & Subtitle (Fully Constrained to Prevent Overflow)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Right Compact Action Pill Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: item.brandColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: item.brandColor.withValues(alpha: 0.25), width: 1),
              ),
              child: Text(
                btnText,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: item.brandColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
