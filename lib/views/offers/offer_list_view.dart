import 'dart:ui';
import 'package:flutter/material.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/helpline_bottom_sheet.dart';
import 'widgets/eps_payment_gateway_dialog.dart';

class OfferListView extends StatelessWidget {
  final bool showAppBar;
  final LanguageController? languageController;

  const OfferListView({
    super.key,
    this.showAppBar = false,
    this.languageController,
  });

  static const brandOrange = Color(0xFFEA580C);
  static const textDark = Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    final langController = languageController ?? LanguageController();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: showAppBar
          ? CustomAppBar(
              title: langController.tr('ডিসকাউন্ট অফার ও হেলথ প্যাকেজ', 'Discount Offers & Health Packages'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.phone_in_talk_rounded, color: brandOrange, size: 22),
                  onPressed: () => showHelplineBottomSheet(context),
                ),
              ],
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            // Ambient Glow Orbs in background consistent with the home screen
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: brandOrange.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0D9488).withValues(alpha: 0.06), // Teal Glow Orb
                ),
              ),
            ),

            if (!showAppBar && Navigator.canPop(context))
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: textDark),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

            RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 600));
              },
              color: const Color(0xFF0F9D58),
              backgroundColor: Colors.white,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Hero Orange Banner Card
                  _buildHeroCard(langController),

                  const SizedBox(height: 24),

                  // 2. Section Header Title
                  Text(
                    langController.tr('বিশেষ ছাড়ের হেলথ চেকআপ প্যাকেজসমূহ', 'Special Discount Health Checkup Packages'),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: textDark,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 3. Official MediSeba 5 Health Packages List
                  Column(
                    children: [
                      _buildHealthPackageCard(
                        context: context,
                        name: 'প্রথমা প্যাকেজ',
                        subtitle: 'স্বাস্থ্যের প্রথম পদক্ষেপ',
                        price: '99',
                        points: '999',
                        validity: '৩ মাস',
                        primaryColor: const Color(0xFF0F9D58),
                        lightBg: const Color(0xFFE8F5E9),
                        benefits: [
                          '৩ মাসে ২ বার MBBS ডাক্তারের পরামর্শ',
                          'অনলাইন অথবা Health Point এ সেবা',
                          '৳ ৯৯৯ হেলথ ক্রেডিট',
                          'টেস্টে সর্বোচ্চ ৩০% পর্যন্ত Cash Back সুবিধা',
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildHealthPackageCard(
                        context: context,
                        name: 'আস্থা প্যাকেজ',
                        subtitle: 'নিয়মিত স্বাস্থ্য, আপনার ভরসা',
                        price: '199',
                        points: '1,499',
                        validity: '৬ মাস',
                        isBestSeller: true,
                        primaryColor: const Color(0xFF00796B),
                        lightBg: const Color(0xFFE0F2F1),
                        benefits: [
                          '৬ মাসে ২ বার MBBS ডাক্তারের পরামর্শ',
                          'অনলাইন অথবা Health Point এ সেবা',
                          '৳ ১,৪৯৯ হেলথ ক্রেডিট',
                          'টেস্টে সর্বোচ্চ ৩০% পর্যন্ত Cash Back সুবিধা',
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildHealthPackageCard(
                        context: context,
                        name: 'সহযাত্রী প্যাকেজ',
                        subtitle: 'দুজনের যত্ন, একসাথে সুস্থ পথচলা',
                        price: '299',
                        points: '2,000',
                        validity: '৬ মাস',
                        primaryColor: const Color(0xFFE11D48),
                        lightBg: const Color(0xFFFFE4E6),
                        benefits: [
                          '৬ মাসে সর্বোচ্চ ৩ বার MBBS ডাক্তারের পরামর্শ',
                          'অনলাইন অথবা Health Point এ সেবা',
                          '৳ ২,০০০ হেলথ ক্রেডিট',
                          'টেস্ট ক্রেডিট ব্যবহারের সুবিধা',
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildHealthPackageCard(
                        context: context,
                        name: 'মাতৃমমতা প্যাকেজ',
                        subtitle: 'মায়ের যত্ন, আগামী সুরক্ষায়',
                        price: '499',
                        points: '2,500',
                        validity: 'সিঙ্গেল/প্রসবকালীন পর্যায়',
                        primaryColor: const Color(0xFFC026D3),
                        lightBg: const Color(0xFFFAE8FF),
                        benefits: [
                          'প্রতি ৩ মাসে ১ বার MBBS ডাক্তারের পরামর্শ',
                          'গর্ভকালীন জরুরি ডাক্তারি পরামর্শ',
                          '৳ ২,৫০০ হেলথ ক্রেডিট',
                          'হাসপাতালে ২৫% ছাড় সুবিধা',
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildHealthPackageCard(
                        context: context,
                        name: 'আপনজন প্যাকেজ',
                        subtitle: 'পুরো পরিবারের সুরক্ষা, একটি কার্ডেই',
                        price: '999',
                        points: '5,500',
                        validity: '১ বছর',
                        primaryColor: const Color(0xFF7C3AED),
                        lightBg: const Color(0xFFF5F3FF),
                        benefits: [
                          'পরিবারের ৪ জনের জন্য সুবিধা',
                          'প্রতি ৩ মাস পর পর প্রতি ব্যক্তি ২ বার করে ডাক্তারের পরামর্শ (সর্বমোট ৮ বার)',
                          '৳ ৫,৫০০ হেলথ ক্রেডিট',
                          'টেস্ট ক্রেডিট ব্যবহারের সুবিধা',
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  // 1. Hero Orange Banner Card
  Widget _buildHeroCard(LanguageController lang) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF97316), Color(0xFFEA580C), Color(0xFFC2410C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: brandOrange.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Custom tech background grid
            Positioned.fill(
              child: CustomPaint(
                painter: OfferTechGridPainter(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Pill Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_rounded, color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          lang.tr('ডায়াগনস্টিক ও স্বাস্থ্য প্যাকেজে বিশেষ ছাড়', 'Special Discount on Diagnostics & Packages'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Main Title
                  Text(
                    lang.tr('সাশ্রয়ী মূল্যে হেলথ চেকআপ ও ডিসকাউন্ট অফার', 'Affordable Health Checkups & Discount Offers'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Subtitle
                  Text(
                    lang.tr(
                      'দেশের স্বনামধন্য ডায়াগনস্টিক ও ল্যাবে মেডিসেবা গ্রাহকদের জন্য ৪০% পর্যন্ত বিশেষ ছাড়ের সুবিধা।',
                      'Up to 40% special discount for MediSeba users at renowned diagnostic labs across the country.',
                    ),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
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

  // 2. Full Body Health Check Package Card (ফুল বডি চেকআপ)
  Widget _buildFullBodyPackageCard(BuildContext context, LanguageController lang) {
    const tealColor = Color(0xFF0D9488);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.55), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: tealColor.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Badges: Most Popular + Discount Tag
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: tealColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: tealColor.withValues(alpha: 0.2), width: 0.8),
                      ),
                      child: Text(
                        lang.tr('সর্বাধিক জনপ্রিয়', 'Most Popular'),
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: tealColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFF59E0B), width: 1),
                      ),
                      child: Text(
                        lang.tr('৪০% ছাড়', '40% OFF'),
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFB45309),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Title
                Text(
                  lang.tr('ফুল বডি চেকআপ প্যাকেজ (Full Body Health Check)', 'Full Body Health Check Package'),
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                  ),
                ),

                const SizedBox(height: 8),

                // Price Row
                Row(
                  children: [
                    Text(
                      lang.tr('৳ ২,৯৯৯', '৳ 2,999'),
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: tealColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      lang.tr('৳ ৫,০০০', '৳ 5,000'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF94A3B8),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Features List
                _buildFeatureRow(lang.tr('কমপ্লিট ব্লাড কাউন্ট (CBC)', 'Complete Blood Count (CBC)')),
                _buildFeatureRow(lang.tr('ফাস্টিং ব্লাড সুগার (FBS)', 'Fasting Blood Sugar (FBS)')),
                _buildFeatureRow(lang.tr('লিপিড প্রোফাইল (Lipid Profile)', 'Lipid Profile')),
                _buildFeatureRow(lang.tr('লিভার ফাংশন টেস্ট (SGPT, SGOT)', 'Liver Function Test (SGPT, SGOT)')),
                _buildFeatureRow(lang.tr('কিডনি ফাংশন টেস্ট (Serum Creatinine)', 'Kidney Function Test (Creatinine)')),
                _buildFeatureRow(lang.tr('অভিজ্ঞ ডাক্তারের ফ্রি কনসালটেশন', 'Free Consultation by Doctor')),

                const SizedBox(height: 18),

                // Subscribe Button
                Container(
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [tealColor, Color(0xFF0F766E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: tealColor.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => showHelplineBottomSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 18),
                    label: Text(
                      lang.tr('অফারটি গ্রহণ করুন (09647111666)', 'Get Offer (09647111666)'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 3. Cardiac Care Package Card (কার্ডিয়াক হার্ট চেকআপ)
  Widget _buildCardiacPackageCard(BuildContext context, LanguageController lang) {
    const redColor = Color(0xFFDC2626);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.55), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: redColor.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Badges: Specialized + Discount Tag
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: redColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: redColor.withValues(alpha: 0.2), width: 0.8),
                      ),
                      child: Text(
                        lang.tr('বিশেষায়িত', 'Specialized'),
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: redColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFF59E0B), width: 1),
                      ),
                      child: Text(
                        lang.tr('৩৯% ছাড়', '39% OFF'),
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFB45309),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Title
                Text(
                  lang.tr('কার্ডিয়াক হার্ট চেকআপ (Cardiac Care Package)', 'Cardiac Care Package'),
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                  ),
                ),

                const SizedBox(height: 8),

                // Price Row
                Row(
                  children: [
                    Text(
                      lang.tr('৳ ৩,৯৯৯', '৳ 3,999'),
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: redColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      lang.tr('৳ ৬,৫০০', '৳ 6,500'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF94A3B8),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Features List
                _buildFeatureRow(lang.tr('ইসিজি (ECG Report)', 'ECG Report')),
                _buildFeatureRow(lang.tr('ইকোকারডিওগ্রাম (Echo Test)', 'Echocardiogram (Echo Test)')),
                _buildFeatureRow(lang.tr('লিপিড প্রোফাইল ও কোলেস্টেরল', 'Lipid Profile & Cholesterol')),
                _buildFeatureRow(lang.tr('ব্লাড প্রেশার মনিটরিং', 'Blood Pressure Monitoring')),
                _buildFeatureRow(lang.tr('সিনিয়র কার্ডিওলোজিস্ট ডাক্তারের রিভিউ', 'Review by Senior Cardiologist')),

                const SizedBox(height: 18),

                // Subscribe Button
                Container(
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [redColor, Color(0xFF991B1B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: redColor.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => showHelplineBottomSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 18),
                    label: Text(
                      lang.tr('অফারটি গ্রহণ করুন (09647111666)', 'Get Offer (09647111666)'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 4. Diabetes Care Package Card (ডায়াবেটিস কন্ট্রোল প্যাকেজ)
  Widget _buildDiabetesPackageCard(BuildContext context, LanguageController lang) {
    const blueColor = Color(0xFF2563EB);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.55), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: blueColor.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Badges: Affordable + Discount Tag
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: blueColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: blueColor.withValues(alpha: 0.2), width: 0.8),
                      ),
                      child: Text(
                        lang.tr('সাশ্রয়ী', 'Affordable'),
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: blueColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFF59E0B), width: 1),
                      ),
                      child: Text(
                        lang.tr('৪০% ছাড়', '40% OFF'),
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFB45309),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Title
                Text(
                  lang.tr('ডায়াবেটিস কন্ট্রোল প্যাকেজ (Diabetes Care)', 'Diabetes Care Package'),
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                  ),
                ),

                const SizedBox(height: 8),

                // Price Row
                Row(
                  children: [
                    Text(
                      lang.tr('৳ ১,৭৯৯', '৳ 1,799'),
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: blueColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      lang.tr('৳ ৩,০০০', '৳ 3,000'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF94A3B8),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Features List
                _buildFeatureRow(lang.tr('HbA1c টেস্ট', 'HbA1c Test')),
                _buildFeatureRow(lang.tr('ফাস্টিং ও ২ ঘণ্টা পরের সুগার টেস্ট', 'Fasting & 2 Hours Post-Sugar Test')),
                _buildFeatureRow(lang.tr('ইউরিন মাইক্রো-আলবুমিন', 'Urine Micro-Albumin Test')),
                _buildFeatureRow(lang.tr('ডায়াবেটিক ডায়েট চার্ট পরামর্শ', 'Diabetic Diet Chart Advice')),

                const SizedBox(height: 18),

                // Subscribe Button
                Container(
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [blueColor, Color(0xFF1D4ED8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: blueColor.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => showHelplineBottomSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 18),
                    label: Text(
                      lang.tr('অফারটি গ্রহণ করুন (09647111666)', 'Get Offer (09647111666)'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Feature Row with Green Check Icon
  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 14,
              color: Color(0xFF16A34A),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Health Package Card matching Web UI
  Widget _buildHealthPackageCard({
    required BuildContext context,
    required String name,
    required String subtitle,
    required String price,
    required String points,
    required String validity,
    required Color primaryColor,
    required Color lightBg,
    required List<String> benefits,
    bool isBestSeller = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isBestSeller ? primaryColor : const Color(0xFFE2E8F0), width: isBestSeller ? 2 : 1),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: lightBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.stars_rounded, color: primaryColor, size: 20),
              ),
              Row(
                children: [
                  if (isBestSeller) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF97316),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '🔥 বেস্ট সেলার',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: lightBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'মেয়াদ: $validity',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('প্যাকেজ মূল্য', style: TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8))),
                    Text('৳ $price', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: primaryColor)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('হেলথ ক্রেডিট', style: TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8))),
                    Text('+$points Pts', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0F9D58))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...benefits.map((benefit) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF0F9D58)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      benefit,
                      style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155), height: 1.3),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final cleanPrice = int.tryParse(price.replaceAll(',', '')) ?? 99;
                final cleanPoints = int.tryParse(points.replaceAll(',', '')) ?? 999;
                EpsPaymentGatewayDialog.show(
                  context: context,
                  packageName: name,
                  price: cleanPrice,
                  points: cleanPoints,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'প্যাকেজটি কিনুন (৳ $price)',
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OfferTechGridPainter extends CustomPainter {
  final Color color;
  OfferTechGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const double step = 20.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double j = 0; j < size.height; j += step) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), paint);
    }

    // Draw tech diagnostic circles
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.2), 35, paint);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.2), 45, paint..strokeWidth = 0.3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
