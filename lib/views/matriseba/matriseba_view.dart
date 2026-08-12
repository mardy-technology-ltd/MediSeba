import 'package:flutter/material.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/helpline_bottom_sheet.dart';
import '../doctors/doctor_list_view.dart';

class MatriSebaView extends StatefulWidget {
  final LanguageController? languageController;

  const MatriSebaView({
    super.key,
    this.languageController,
  });

  @override
  State<MatriSebaView> createState() => _MatriSebaViewState();
}

class _MatriSebaViewState extends State<MatriSebaView> {
  late final LanguageController _langController;

  static const brandPink = Color(0xFFE11D48);
  static const brandPurple = Color(0xFF6366F1);
  static const textDark = Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = _langController.isBangla;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: textDark),
        title: Text(
          _langController.tr('মাতৃসেবা (মা ও শিশু স্বাস্থ্য)', 'Maternal & Child Care'),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_in_talk_rounded, color: brandPink),
            onPressed: () => showHelplineBottomSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Pink Gradient Banner Card
            _buildHeroCard(isBangla),

            const SizedBox(height: 24),

            // 2. Section Header: Care Packages
            Text(
              _langController.tr('মা ও শিশু বিশেষ স্বাস্থ্য প্যাকেজ', 'Maternal & Child Special Packages'),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: textDark,
              ),
            ),
            const SizedBox(height: 14),

            // 3. Side-by-Side / Responsive Package Cards
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 650) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildPrenatalPackageCard(isBangla)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildNewbornPackageCard(isBangla)),
                    ],
                  );
                }
                return Column(
                  children: [
                    _buildPrenatalPackageCard(isBangla),
                    const SizedBox(height: 16),
                    _buildNewbornPackageCard(isBangla),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 1. Hero Pink Gradient Banner Card
  Widget _buildHeroCard(bool isBangla) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF43F5E), Color(0xFFE11D48), Color(0xFFBE123C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: brandPink.withValues(alpha: 0.3),
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
                const Icon(Icons.child_care_rounded, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  _langController.tr('মা ও শিশু স্বাস্থ্যসেবা (Mother & Child Care)', 'Mother & Child Care'),
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
            _langController.tr('গর্ভবতী মা ও শিশুর নিরাপদ ও সুরক্ষিত যত্ন', 'Safe & Secure Care for Pregnant Mother & Child'),
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
            _langController.tr(
              'দেশের সেরা গাইনোকোলজিস্ট ও শিশু বিশেষজ্ঞ ডাক্তারদের কাছ থেকে ঘরের বসেই নিবেন সঠিক স্বাস্থ্য পরামর্শ ও সেবা।',
              'Get proper health advice and service at home from the best gynecologists and child specialists in the country.',
            ),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          // Search Doctor Button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorListView(
                    showAppBar: true,
                    languageController: _langController,
                    initialSearchQuery: 'গাইনোকোলজিস্ট',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: brandPink,
              elevation: 4,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: const Icon(Icons.search_rounded, size: 18, color: brandPink),
            label: Text(
              _langController.tr('গাইনোকোলজিস্ট ডাক্তার খুঁজুন', 'Find Gynecologist Doctor'),
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w900,
                color: brandPink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Prenatal Care Package Card (গর্ভকালীন যত্ন)
  Widget _buildPrenatalPackageCard(bool isBangla) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: brandPink.withValues(alpha: 0.05),
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
            // Top Header: Badge & Price
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
                    _langController.tr('সবচেয়ে জনপ্রিয়', 'Most Popular'),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: brandPink,
                    ),
                  ),
                ),
                Text(
                  _langController.tr('৳ ১,৫০০ (৩ মাস মেয়াদী)', '৳ 1,500 (3 Months)'),
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              _langController.tr('গর্ভকালীন যত্ন (Prenatal Care Package)', 'Prenatal Care Package'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: textDark,
              ),
            ),

            const SizedBox(height: 14),

            // Feature Checklist
            _buildFeatureRow(_langController.tr('অভিজ্ঞ গাইনোকোলজিস্টের ৩টি কনসালটেশন', '3 Consultations by Experienced Gynecologist')),
            _buildFeatureRow(_langController.tr('গর্ভকালীন ডায়েট ও পুষ্টি গাইড', 'Prenatal Diet & Nutrition Guide')),
            _buildFeatureRow(_langController.tr('জরুরি যেকোনো পরামর্শে হটলাইন সাপোর্ট', 'Hotline Support for Emergency Advice')),
            _buildFeatureRow(_langController.tr('ফ্রি ব্লাড প্রেশার ও সুগার ট্র্যাকিং', 'Free Blood Pressure & Sugar Tracking')),

            const SizedBox(height: 18),

            // Action Subscribe Button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => showHelplineBottomSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandPink,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 18),
                label: Text(
                  _langController.tr('প্যাকেজটি সাবস্ক্রাইব করুন (09647111666)', 'Subscribe Package (09647111666)'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
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

  // 3. Newborn & Child Care Package Card (নবজাতক যত্ন)
  Widget _buildNewbornPackageCard(bool isBangla) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: brandPurple.withValues(alpha: 0.05),
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
            // Top Header: Badge & Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _langController.tr('বিশেষায়িত', 'Specialized'),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: brandPurple,
                    ),
                  ),
                ),
                Text(
                  _langController.tr('৳ ২,০০০ (৬ মাস মেয়াদী)', '৳ 2,000 (6 Months)'),
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              _langController.tr('নবজাতক যত্ন (Newborn & Child Care)', 'Newborn & Child Care'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: textDark,
              ),
            ),

            const SizedBox(height: 14),

            // Feature Checklist
            _buildFeatureRow(_langController.tr('শিশু বিশেষজ্ঞের বিশেষ পরামর্শ', 'Special Advice from Child Specialist')),
            _buildFeatureRow(_langController.tr('টিকা ও ভ্যাকসিন রিমাইন্ডার চার্ট', 'Vaccine & Immunization Reminder Chart')),
            _buildFeatureRow(_langController.tr('শিশুর শারীরিক বৃদ্ধি মনিটরিং', 'Child Growth & Development Monitoring')),
            _buildFeatureRow(_langController.tr('২৪/৭ শিশুর জরুরি হেল্পডেস্ক', '24/7 Child Emergency Helpdesk')),

            const SizedBox(height: 18),

            // Action Subscribe Button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => showHelplineBottomSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandPurple,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 18),
                label: Text(
                  _langController.tr('প্যাকেজটি সাবস্ক্রাইব করুন (09647111666)', 'Subscribe Package (09647111666)'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
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
