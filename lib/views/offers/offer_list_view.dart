import 'package:flutter/material.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/helpline_bottom_sheet.dart';

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
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              iconTheme: const IconThemeData(color: textDark),
              title: Text(
                langController.tr('ডিসকাউন্ট অফার ও হেলথ প্যাকেজ', 'Discount Offers & Health Packages'),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.phone_in_talk_rounded, color: brandOrange),
                  onPressed: () => showHelplineBottomSheet(context),
                ),
              ],
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
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

              // 3. Responsive 3-Column / Column Package Cards
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 900) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildFullBodyPackageCard(context, langController)),
                        const SizedBox(width: 14),
                        Expanded(child: _buildCardiacPackageCard(context, langController)),
                        const SizedBox(width: 14),
                        Expanded(child: _buildDiabetesPackageCard(context, langController)),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _buildFullBodyPackageCard(context, langController),
                      const SizedBox(height: 16),
                      _buildCardiacPackageCard(context, langController),
                      const SizedBox(height: 16),
                      _buildDiabetesPackageCard(context, langController),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Hero Orange Banner Card
  Widget _buildHeroCard(LanguageController lang) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF97316), Color(0xFFEA580C), Color(0xFFC2410C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: brandOrange.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Pill Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white30, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_rounded, color: Colors.white, size: 15),
                const SizedBox(width: 6),
                Text(
                  lang.tr('ডায়াগনস্টিক ও স্বাস্থ্য প্যাকেজে বিশেষ ছাড়', 'Special Discount on Diagnostics & Packages'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
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
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // 2. Full Body Health Check Package Card (ফুল বডি চেকআপ)
  Widget _buildFullBodyPackageCard(BuildContext context, LanguageController lang) {
    const tealColor = Color(0xFF0D9488);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: tealColor.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    color: const Color(0xFFCCFBF1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    lang.tr('সর্বাধিক জনপ্রিয়', 'Most Popular'),
                    style: const TextStyle(
                      fontSize: 11,
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
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFB45309),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

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
                    fontSize: 18,
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

            const SizedBox(height: 14),

            // Features List
            _buildFeatureRow(lang.tr('কমপ্লিট ব্লাড কাউন্ট (CBC)', 'Complete Blood Count (CBC)')),
            _buildFeatureRow(lang.tr('ফাস্টিং ব্লাড সুগার (FBS)', 'Fasting Blood Sugar (FBS)')),
            _buildFeatureRow(lang.tr('লিপিড প্রোফাইল (Lipid Profile)', 'Lipid Profile')),
            _buildFeatureRow(lang.tr('লিভার ফাংশন টেস্ট (SGPT, SGOT)', 'Liver Function Test (SGPT, SGOT)')),
            _buildFeatureRow(lang.tr('কিডনি ফাংশন টেস্ট (Serum Creatinine)', 'Kidney Function Test (Creatinine)')),
            _buildFeatureRow(lang.tr('অভিজ্ঞ ডাক্তারের ফ্রি কনসালটেশন', 'Free Consultation by Doctor')),

            const SizedBox(height: 18),

            // Subscribe Button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => showHelplineBottomSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tealColor,
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
    );
  }

  // 3. Cardiac Care Package Card (কার্ডিয়াক হার্ট চেকআপ)
  Widget _buildCardiacPackageCard(BuildContext context, LanguageController lang) {
    const redColor = Color(0xFFDC2626);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: redColor.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    color: const Color(0xFFFFE4E6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    lang.tr('বিশেষায়িত', 'Specialized'),
                    style: const TextStyle(
                      fontSize: 11,
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
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFB45309),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

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
                    fontSize: 18,
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

            const SizedBox(height: 14),

            // Features List
            _buildFeatureRow(lang.tr('ইসিজি (ECG Report)', 'ECG Report')),
            _buildFeatureRow(lang.tr('ইকোকারডিওগ্রাম (Echo Test)', 'Echocardiogram (Echo Test)')),
            _buildFeatureRow(lang.tr('লিপিড প্রোফাইল ও কোলেস্টেরল', 'Lipid Profile & Cholesterol')),
            _buildFeatureRow(lang.tr('ব্লাড প্রেশার মনিটরিং', 'Blood Pressure Monitoring')),
            _buildFeatureRow(lang.tr('সিনিয়র কার্ডিওলোজিস্ট ডাক্তারের রিভিউ', 'Review by Senior Cardiologist')),

            const SizedBox(height: 18),

            // Subscribe Button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => showHelplineBottomSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: redColor,
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
    );
  }

  // 4. Diabetes Care Package Card (ডায়াবেটিস কন্ট্রোল প্যাকেজ)
  Widget _buildDiabetesPackageCard(BuildContext context, LanguageController lang) {
    const blueColor = Color(0xFF2563EB);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: blueColor.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    color: const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    lang.tr('সাশ্রয়ী', 'Affordable'),
                    style: const TextStyle(
                      fontSize: 11,
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
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFB45309),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

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
                    fontSize: 18,
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

            const SizedBox(height: 14),

            // Features List
            _buildFeatureRow(lang.tr('HbA1c টেস্ট', 'HbA1c Test')),
            _buildFeatureRow(lang.tr('ফাস্টিং ও ২ ঘণ্টা পরের সুগার টেস্ট', 'Fasting & 2 Hours Post-Sugar Test')),
            _buildFeatureRow(lang.tr('ইউরিন মাইক্রো-আলবুমিন', 'Urine Micro-Albumin Test')),
            _buildFeatureRow(lang.tr('ডায়াবেটিক ডায়েট চার্ট পরামর্শ', 'Diabetic Diet Chart Advice')),

            const SizedBox(height: 18),

            // Subscribe Button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => showHelplineBottomSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
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
}
