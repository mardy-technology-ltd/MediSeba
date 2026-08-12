import 'package:flutter/material.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/helpline_bottom_sheet.dart';

class PrivacyPolicyView extends StatelessWidget {
  final LanguageController? languageController;

  const PrivacyPolicyView({
    super.key,
    this.languageController,
  });

  static const brandGreen = Color(0xFF008536);
  static const darkForest = Color(0xFF064E3B);
  static const textDark = Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    final lang = languageController ?? LanguageController();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: textDark),
        title: Text(
          lang.tr('প্রাইভেসি পলিসি', 'Privacy Policy'),
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
              // 1. Top Hero Emerald Banner Card
              _buildHeroCard(lang),

              const SizedBox(height: 20),

              // 2. Main Privacy Policy Card matching reference design
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row with Shield Icon
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.verified_user_rounded,
                            color: brandGreen,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            lang.tr('প্রাইভেসি পলিসি (Privacy Policy)', 'Privacy Policy'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: textDark,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Intro Paragraph
                    Text(
                      lang.tr(
                        'মেডিসেবা আপনার গোপনীয়তা রক্ষা করতে প্রতিশ্রুতিবদ্ধ। এই পলিসিতে উল্লেখ করা হয়েছে যে কীভাবে আমরা আপনার ব্যক্তিগত তথ্য সংগ্রহ, ব্যবহার এবং সুরক্ষিত রাখি।',
                        'MediSeba is committed to protecting your privacy. This policy outlines how we collect, use, and safeguard your personal information.',
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF475569),
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Section 1: Data Collection
                    _buildPolicySection(
                      title: lang.tr('১. তথ্য সংগ্রহ:', '1. Information Collection:'),
                      content: lang.tr(
                        'আমরা রোগী ও ব্যবহারকারীদের নাম, মোবাইল নম্বর, ইমেইল এবং প্রয়োজনীয় মেডিকেল তথ্য শুধুমাত্র সঠিক চিকিৎসাসেবা ও ডক্টর অ্যাপয়েন্টমেন্ট নিশ্চিত করার জন্য সংগ্রহ করি।',
                        'We collect user names, mobile numbers, email, and necessary medical details solely to ensure proper medical healthcare & doctor appointments.',
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Section 2: Data Protection
                    _buildPolicySection(
                      title: lang.tr('২. তথ্যের সুরক্ষা:', '2. Data Protection & Security:'),
                      content: lang.tr(
                        'আপনার ব্যক্তিগত স্বাস্থ্য তথ্য সম্পূর্ণ এনক্রিপ্টেড ও সুরক্ষিত ডাটাবেসে রাখা হয়। আপনার সম্মতি ছাড়া কোনো তৃতীয় পক্ষের কাছে তথ্য শেয়ার করা হয় না।',
                        'Your personal health data is stored in fully encrypted and secure databases. Information is never shared with third parties without consent.',
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Section 3: Data Usage Purpose
                    _buildPolicySection(
                      title: lang.tr('৩. তথ্যের সঠিক ব্যবহার:', '3. Usage of Information:'),
                      content: lang.tr(
                        'সংগৃহীত তথ্য শুধুমাত্র ডক্টর ভিডিও কনসালটেশন, টেস্ট রিপোর্ট ডেলিভারি, এবং কাস্টমার সাপোর্ট সার্ভিসেস সুনিশ্চিত করার উদ্দেশ্যে ব্যবহৃত হয়।',
                        'Collected data is strictly used for doctor video consultation, test report delivery, and customer support service excellence.',
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Section 4: User Rights
                    _buildPolicySection(
                      title: lang.tr('৪. ব্যবহারকারীর অধিকার:', '4. User Rights:'),
                      content: lang.tr(
                        'আপনি যেকোনো সময় আপনার ব্যক্তিগত তথ্য পরিবর্তন, আপডেট বা আমাদের ডাটাবেস থেকে মুছে ফেলার জন্য অনুরোধ করতে পারেন।',
                        'You may request to update, alter, or remove your personal information from our database at any time.',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Contact Support Note
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFA7F3D0), width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: brandGreen, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        lang.tr(
                          'প্রাইভেসি সংক্রান্ত প্রশ্নের জন্য মেইল করুন: info@mediseba.org',
                          'For privacy queries, email us at: info@mediseba.org',
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: darkForest,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Top Hero Emerald Banner Card
  Widget _buildHeroCard(LanguageController lang) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF064E3B), Color(0xFF008536), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: brandGreen.withValues(alpha: 0.3),
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
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white30, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shield_rounded, color: Colors.white, size: 14),
                const SizedBox(width: 6),
                Text(
                  lang.tr('গোপনীয়তা ও তথ্যের সুরক্ষা (Privacy & Security)', 'Privacy & Security'),
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
            lang.tr('মেডিসেবা প্রাইভেসি পলিসি', 'MediSeba Privacy Policy'),
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
              'আপনার ব্যক্তিগত ও স্বাস্থ্য তথ্যের সুরক্ষার নিশ্চয়তা দিয়ে আমরা সেবা প্রদান করি। যেকোনো তথ্য এনক্রিপ্ট করে নিরাপদ ডাটাবেসে সংরক্ষণ করা হয়।',
              'We ensure 100% privacy and encryption for all user & medical health information.',
            ),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: const TextStyle(
            fontSize: 12.5,
            color: Color(0xFF64748B),
            height: 1.45,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
