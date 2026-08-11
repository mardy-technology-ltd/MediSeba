import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/language_controller.dart';

class AmbulanceSebaView extends StatefulWidget {
  final LanguageController? languageController;

  const AmbulanceSebaView({super.key, this.languageController});

  @override
  State<AmbulanceSebaView> createState() => _AmbulanceSebaViewState();
}

class _AmbulanceSebaViewState extends State<AmbulanceSebaView> {
  late final LanguageController _langController;

  static const hotlinePhone = '+88009647111666';
  static const hotlinePhoneDisplay = '09647111666';

  static const brandBlue = Color(0xFF2563EB);
  static const textDark = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
  }

  Future<void> _makePhoneCall() async {
    final Uri uri = Uri.parse('tel:$hotlinePhone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_langController.tr('কল করা সম্ভব হচ্ছে না: $hotlinePhoneDisplay', 'Could not initiate call: $hotlinePhoneDisplay'))),
          );
        }
      }
    } catch (e) {
      debugPrint('Error making phone call: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _langController,
      builder: (context, _) {
        final isBangla = _langController.isBangla;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              _langController.tr('অ্যাম্বুলেন্স সেবা', 'Ambulance Service'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HERO BANNER CARD
                _buildHeroCard(isBangla),

                const SizedBox(height: 16),

                // 2. RED EMERGENCY HOTLINE CALL CARD
                _buildEmergencyHotlineCard(isBangla),

                const SizedBox(height: 24),

                // SECTION TITLE
                Text(
                  _langController.tr('আমাদের অ্যাম্বুলেন্স টাইপসমূহ', 'Our Ambulance Types'),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 12),

                // 3. AMBULANCE CATEGORY CARDS (GRID/LIST)
                _buildAmbulanceCard(
                  badgeText: _langController.tr('সবচেয়ে জনপ্রিয়', 'Most Popular'),
                  badgeBgColor: const Color(0xFFEFF6FF),
                  badgeTextColor: const Color(0xFF2563EB),
                  startingPrice: _langController.tr('৳ ২,০০০ থেকে শুরু', 'From ৳ 2,000'),
                  title: _langController.tr('AC অ্যাম্বুলেন্স (Standard AC)', 'AC Ambulance (Standard AC)'),
                  description: _langController.tr(
                    'রোগী বহনের জন্য শীতাতপ নিয়ন্ত্রিত আধুনিক ও আরামদায়ক অ্যাম্বুলেন্স।',
                    'Air conditioned modern & comfortable ambulance for patient transport.',
                  ),
                  features: [
                    _langController.tr('শীতাতপ নিয়ন্ত্রিত (AC)', 'Air Conditioned (AC)'),
                    _langController.tr('অভিজ্ঞ ড্রাইভার', 'Experienced Driver'),
                    _langController.tr('অক্সিজেন সিলিন্ডার সুবিধা', 'Oxygen Cylinder Facility'),
                    _langController.tr('২৪/৭ উপলব্ধ', 'Available 24/7'),
                  ],
                ),

                const SizedBox(height: 14),

                _buildAmbulanceCard(
                  badgeText: _langController.tr('জরুরি সেবা', 'Critical Care'),
                  badgeBgColor: const Color(0xFFE0F2FE),
                  badgeTextColor: const Color(0xFF0284C7),
                  startingPrice: _langController.tr('৳ ৫,০০০ থেকে শুরু', 'From ৳ 5,000'),
                  title: _langController.tr('ICU / লাইফ সাপোর্ট অ্যাম্বুলেন্স', 'ICU / Life Support Ambulance'),
                  description: _langController.tr(
                    'মুমূর্ষু রোগীদের স্থানান্তর করার জন্য সম্পূর্ণ ICU সুবিধাসম্পন্ন অ্যাম্বুলেন্স।',
                    'Full ICU equipped ambulance for transporting critical emergency patients.',
                  ),
                  features: [
                    _langController.tr('ভেন্টিলেটর ও কার্ডিয়াক মনিটর', 'Ventilator & Cardiac Monitor'),
                    _langController.tr('প্যারামেডিক / মেডিকেল অ্যাটেনডেন্ট', 'Paramedic / Medical Attendant'),
                    _langController.tr('জরুরি ওষুধ ও সিরিঞ্জ পাম্প', 'Emergency Meds & Syringe Pump'),
                    _langController.tr('লাইফ সাপোর্ট সিস্টেম', 'Life Support System'),
                  ],
                ),

                const SizedBox(height: 14),

                _buildAmbulanceCard(
                  badgeText: _langController.tr('সাশ্রয়ী', 'Affordable'),
                  badgeBgColor: const Color(0xFFF1F5F9),
                  badgeTextColor: const Color(0xFF475569),
                  startingPrice: _langController.tr('৳ ১,২০০ থেকে শুরু', 'From ৳ 1,200'),
                  title: _langController.tr('নন-এসি অ্যাম্বুলেন্স (Non-AC)', 'Non-AC Ambulance (Non-AC)'),
                  description: _langController.tr(
                    'স্বল্প খরচে দ্রুত রোগী স্থানান্তরের জন্য সাধারণ অ্যাম্বুলেন্স।',
                    'Standard ambulance for low-cost fast patient transport.',
                  ),
                  features: [
                    _langController.tr('সাশ্রয়ী খরচ', 'Cost Effective'),
                    _langController.tr('জরুরি ফার্স্ট এইড কিট', 'Emergency First Aid Kit'),
                    _langController.tr('অভিজ্ঞ ড্রাইভার', 'Experienced Driver'),
                    _langController.tr('সারা দেশ স্ট্রেচার সুবিধা', 'Countrywide Stretcher Facility'),
                  ],
                ),

                const SizedBox(height: 14),

                _buildAmbulanceCard(
                  badgeText: _langController.tr('বিশেষায়িত', 'Specialized'),
                  badgeBgColor: const Color(0xFFF3E8FF),
                  badgeTextColor: const Color(0xFF7E22CE),
                  startingPrice: _langController.tr('৳ ৪,০০০ থেকে শুরু', 'From ৳ 4,000'),
                  title: _langController.tr('ফ্রিজিং অ্যাম্বুলেন্স (Freezing Body Care)', 'Freezing Ambulance (Body Care)'),
                  description: _langController.tr(
                    'মৃতদেহ নিরাপদে দীর্ঘ দূরত্বে পরিবহনের জন্য ফ্রিজিং প্রযুক্তিযুক্ত অ্যাম্বুলেন্স।',
                    'Freezer technology ambulance for safe long distance deceased transport.',
                  ),
                  features: [
                    _langController.tr('মাইナス সেলসিয়াস কুলিং', 'Minus Degree Celsius Cooling'),
                    _langController.tr('দীর্ঘ দূরত্বের জন্য উপযুক্ত', 'Suitable for Long Distance'),
                    _langController.tr('সুরক্ষিত পরিবহন ব্যবস্থা', 'Secure Transportation'),
                    _langController.tr('২৪/৭ সাপোর্ট', '24/7 Support'),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // 1. HERO BANNER CARD
  Widget _buildHeroCard(bool isBangla) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
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
                  Icons.airport_shuttle_rounded,
                  color: Colors.white,
                  size: 15,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _langController.tr('২৪/৭ জরুরি অ্যাম্বুলেন্স সেবা (24/7 Ambulance)', '24/7 Emergency Ambulance'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Main Heading
          Text(
            _langController.tr(
              'এক কলেই মিলবে জরুরি অ্যাম্বুলেন্স',
              'Emergency Ambulance Available in One Call',
            ),
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),

          // Subtitle Description
          Text(
            _langController.tr(
              'সারা দেশের যেকোনো প্রান্ত থেকে যেকোনো সময় দ্রুত অ্যাম্বুলেন্স পেতে এখনই কল করুন।',
              'Call right now to get a fast ambulance anytime from anywhere across the country.',
            ),
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // 2. RED EMERGENCY HOTLINE CARD
  Widget _buildEmergencyHotlineCard(bool isBangla) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE11D48), Color(0xFFBE123C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE11D48).withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone_in_talk_rounded,
                  color: Color(0xFFE11D48),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _langController.tr('জরুরি অ্যাম্বুলেন্স হটলাইন', 'Emergency Ambulance Hotline'),
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _langController.tr(
                        'যে কোনো মুহূর্তে কল করুন, আমাদের গাড়ি দ্রুত রওনা হবে',
                        'Call at any moment, our ambulance will dispatch immediately',
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Call Button Pill
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFBE123C),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _makePhoneCall,
              icon: const Icon(Icons.call_rounded, size: 18, color: Color(0xFFBE123C)),
              label: Text(
                _langController.tr('কল করুন: $hotlinePhoneDisplay', 'Call Now: $hotlinePhoneDisplay'),
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. AMBULANCE CATEGORY CARD
  Widget _buildAmbulanceCard({
    required String badgeText,
    required Color badgeBgColor,
    required Color badgeTextColor,
    required String startingPrice,
    required String title,
    required String description,
    required List<String> features,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
          // Top Row: Badge + Starting Price Tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: badgeTextColor,
                  ),
                ),
              ),
              Text(
                startingPrice,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: brandBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: textDark,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),

          // Description
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: textMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),

          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 14),

          // Feature Checklist
          Column(
            children: features.map((feature) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCFCE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Color(0xFF16A34A),
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Call Action Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: brandBlue,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: brandBlue.withValues(alpha: 0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _makePhoneCall,
              icon: const Icon(Icons.phone_rounded, size: 18),
              label: Text(
                _langController.tr('অ্যাম্বুলেন্স বুক করতে কল করুন', 'Call to Book Ambulance'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
