import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/language_controller.dart';

class ContactUsView extends StatefulWidget {
  final LanguageController? languageController;

  const ContactUsView({super.key, this.languageController});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  late final LanguageController _langController;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  int _selectedMapIndex = 0; // 0 for Dhaka, 1 for Rajshahi

  static const brandGreen = Color(0xFF0F9D58);
  static const textDark = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();

    // Pre-cache real Satellite Map imagery into RAM so tab switching is 100% instant with 0ms delay!
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        precacheImage(
          const NetworkImage('https://static-maps.yandex.ru/1.x/?l=sat&ll=90.385123,23.874854&z=16&size=650,320'),
          context,
        );
        precacheImage(
          const NetworkImage('https://static-maps.yandex.ru/1.x/?l=sat&ll=88.6249481800218,24.360968474850758&z=16&size=650,320'),
          context,
        );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _submitMessage() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.construction_rounded, color: Color(0xFFFBBF24), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _langController.tr(
                  'মেসেজ সাবমিট ফিচারটি বর্তমানে ডেভেলপমেন্টাধীন রয়েছে (Under Development)।',
                  'Message submission is currently under development.',
                ),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _langController,
      builder: (context, _) {
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
              _langController.tr('যোগাযোগ', 'Contact Us'),
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
                _buildHeroCard(),

                const SizedBox(height: 16),

                // 2. QUICK CONTACT CARDS GRID (2x2 Grid)
                _buildQuickContactGrid(),

                const SizedBox(height: 20),

                // 3. SEND MESSAGE FORM CARD
                _buildSendMessageCard(),

                const SizedBox(height: 20),

                // 4. GOOGLE MAP OFFICE LOCATION CARD
                _buildMapLocationCard(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // 1. HERO BANNER CARD
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F9D58), Color(0xFF047857)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F9D58).withValues(alpha: 0.3),
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
                  Icons.call_rounded,
                  color: Colors.white,
                  size: 15,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _langController.tr('আমাদের সাথে যোগাযোগ (Contact Us)', 'Contact Us'),
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
              'সরাসরি আমাদের সাথে কথা বলুন',
              'Talk Directly to Our Team',
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
              'মেডিসেবা টিমের সাথে যেকোনো কোয়ারী, মতামত বা তথ্যের জন্য ঢাকা ও রাজশাহী অফিসে সরাসরি যোগাযোগ করুন।',
              'Contact Dhaka & Rajshahi offices directly for any query, feedback or info.',
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

  // 2. QUICK CONTACT CARDS (SINGLE COLUMN LIST)
  Widget _buildQuickContactGrid() {
    return Column(
      children: [
        _buildContactBox(
          icon: Icons.phone_in_talk_rounded,
          iconBgColor: const Color(0xFFDCFCE7),
          iconColor: const Color(0xFF16A34A),
          title: _langController.tr('জরুরি হটলাইন', 'Emergency Hotline'),
          mainText: '09647111666',
          subText: _langController.tr('অভিযোগ: 01330177522', 'Complain: 01330177522'),
          onTap: () => _makePhoneCall('09647111666'),
        ),
        const SizedBox(height: 12),
        _buildContactBox(
          icon: Icons.email_rounded,
          iconBgColor: const Color(0xFFDBEAFE),
          iconColor: const Color(0xFF2563EB),
          title: _langController.tr('ইমেইল ঠিকানা', 'Email Address'),
          mainText: 'info@mediseba.org',
          subText: _langController.tr('২৪ ঘণ্টার মধ্যে রেসপন্স', 'Response in 24h'),
          onTap: () => _sendEmail('info@mediseba.org'),
        ),
        const SizedBox(height: 12),
        _buildContactBox(
          icon: Icons.business_rounded,
          iconBgColor: const Color(0xFFCCFBF1),
          iconColor: const Color(0xFF0D9488),
          title: _langController.tr('ঢাকা হেড অফিস', 'Dhaka Head Office'),
          mainText: _langController.tr('উত্তরা, ঢাকা-১২৩০', 'Uttara, Dhaka-1230'),
          subText: _langController.tr('হোল্ডিং ৬৮, রোড ২০, সেক্টর ১১', 'Holding 68, Rd 20, Sec 11'),
        ),
        const SizedBox(height: 12),
        _buildContactBox(
          icon: Icons.location_on_rounded,
          iconBgColor: const Color(0xFFF3E8FF),
          iconColor: const Color(0xFF9333EA),
          title: _langController.tr('রাজশাহী অফিস', 'Rajshahi Office'),
          mainText: _langController.tr('তালাইমারী, বোয়ালিয়া, রাজশাহী', 'Talaimari, Boalia, Rajshahi'),
          subText: _langController.tr('বাজার মসজিদের বিপরীতে পাশে', 'Opposite Market Mosque'),
        ),
      ],
    );
  }

  Widget _buildContactBox({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String mainText,
    required String subText,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mainText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: brandGreen,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  // 3. SEND MESSAGE FORM CARD
  Widget _buildSendMessageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _langController.tr('বার্তা পাঠান', 'Send Message'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _langController.tr(
                'আপনার মেসেজ নিচে লিখুন, আমাদের টিম সরাসরি রিপ্লাই দেবে',
                'Write your message below, our team will reply directly',
              ),
              style: const TextStyle(
                fontSize: 12.5,
                color: textMuted,
              ),
            ),
            const SizedBox(height: 16),

            // Name & Phone Row / Column
            _buildLabel(_langController.tr('আপনার নাম', 'Your Name'), isRequired: true),
            _buildInput(_nameController, _langController.tr('আপনার নাম...', 'Your name...')),
            const SizedBox(height: 12),

            _buildLabel(_langController.tr('মোবাইল নম্বর (১১ ডিজিট)', 'Mobile Number (11 digits)'), isRequired: true),
            _buildInput(_phoneController, '017XXXXXXXX', keyboardType: TextInputType.phone),
            const SizedBox(height: 12),

            _buildLabel(_langController.tr('বিষয়', 'Subject'), isRequired: true),
            _buildInput(_subjectController, _langController.tr('যোগাযোগের বিষয়...', 'Subject of contact...')),
            const SizedBox(height: 12),

            _buildLabel(_langController.tr('বার্তা', 'Message'), isRequired: true),
            _buildInput(
              _messageController,
              _langController.tr('আপনার মেসেজ বিস্তারিত টাইপ করুন...', 'Type your message in detail...'),
              maxLines: 4,
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandGreen,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _submitMessage,
                icon: const Icon(Icons.send_rounded, size: 18),
                label: Text(
                  _langController.tr('মেসেজ সাবমিট করুন', 'Submit Message'),
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openGoogleMap(double lat, double lng) async {
    final Uri uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // 4. GOOGLE MAP OFFICE LOCATION CARD
  Widget _buildMapLocationCard() {
    final dhakaAddress = _langController.tr(
      'ঢাকা হেড অফিস: হোল্ডিং ৬৮, রোড ২০, সেক্টর ১১, উত্তরা, ঢাকা (২য় তলা)',
      'Dhaka Head Office: Holding 68, Rd 20, Sec 11, Uttara, Dhaka',
    );
    final rajshahiAddress = _langController.tr(
      'রাজশাহী অফিস: তালাইমারী বাজার মসজিদের বিপরীতে পাশে, বোয়ালিয়া, রাজশাহী',
      'Rajshahi Office: Opposite Talaimari Market Mosque, Boalia, Rajshahi',
    );

    final double lat = _selectedMapIndex == 0 ? 23.874854 : 24.360968474850758;
    final double lng = _selectedMapIndex == 0 ? 90.385123 : 88.6249481800218;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
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
          Row(
            children: [
              const Icon(Icons.near_me_rounded, color: brandGreen, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _langController.tr('গুগল ম্যাপ অফিস লোকেশন', 'Google Map Office Location'),
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _langController.tr('ম্যাপে আমাদের অফিসিয়াল অফিস লোকেশন দেখুন', 'See official office location on map'),
            style: const TextStyle(fontSize: 12.5, color: textMuted),
          ),
          const SizedBox(height: 14),

          // Tabs: Dhaka Head Office | Rajshahi Office
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMapIndex = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedMapIndex == 0 ? brandGreen : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        _langController.tr('ঢাকা হেড অফিস', 'Dhaka Head Office'),
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: _selectedMapIndex == 0 ? Colors.white : textDark,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMapIndex = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedMapIndex == 1 ? brandGreen : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        _langController.tr('রাজশাহী অফিস', 'Rajshahi Office'),
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: _selectedMapIndex == 1 ? Colors.white : textDark,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Address Pill
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFC8E6C9)),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_rounded, color: brandGreen, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedMapIndex == 0 ? dhakaAddress : rajshahiAddress,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Map Preview Container (Satellite Imagery Mode + Clickable to open Google Maps)
          InkWell(
            onTap: () => _openGoogleMap(lat, lng),
            borderRadius: BorderRadius.circular(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
                ),
                child: Stack(
                  children: [
                    // Real Pre-cached Satellite Map Image (Natural Green Uttara Lake & Park View)
                    Positioned.fill(
                      child: Image.network(
                        _selectedMapIndex == 0
                            ? 'https://static-maps.yandex.ru/1.x/?l=sat&ll=90.385123,23.874854&z=16&size=650,320'
                            : 'https://static-maps.yandex.ru/1.x/?l=sat&ll=88.6249481800218,24.360968474850758&z=16&size=650,320',
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                        errorBuilder: (context, error, stackTrace) {
                          return CustomPaint(
                            painter: _SatellitePainter(isRajshahi: _selectedMapIndex == 1),
                          );
                        },
                      ),
                    ),

                    // Map Overlay Dark Vignette
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.05),
                              Colors.black.withValues(alpha: 0.25),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                    // Centered Pin Drop (Compact & Clean)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.redAccent.withValues(alpha: 0.4),
                                  blurRadius: 14,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.location_on_rounded,
                              color: Color(0xFFEF4444),
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Text(
                              _selectedMapIndex == 0
                                  ? '📍 MediSeba Uttara Office'
                                  : '📍 MediSeba Rajshahi Office',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom Action Button Overlay (Overflow Safe with Flexible text)
                    Positioned(
                      bottom: 10,
                      left: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: brandGreen,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.directions_rounded, color: Colors.white, size: 16),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                _langController.tr(
                                  'গুগল ম্যাপে সরাসরি দেখুন',
                                  'Open in Google Maps',
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text.rich(
        TextSpan(
          text: label,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
          children: isRequired
              ? const [TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))]
              : null,
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0F9D58), width: 1.5),
        ),
      ),
    );
  }
}

class _SatellitePainter extends CustomPainter {
  final bool isRajshahi;
  _SatellitePainter({required this.isRajshahi});

  @override
  void paint(Canvas canvas, Size size) {
    if (isRajshahi) {
      _paintRajshahiSatellite(canvas, size);
    } else {
      _paintDhakaSatellite(canvas, size);
    }
  }

  void _paintRajshahiSatellite(Canvas canvas, Size size) {
    // 1. Base Dense Urban Satellite Aerial Background (Rooftops & Trees)
    final bgPaint = Paint()..color = const Color(0xFF333D4C);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Green Vegetation & Tree Canopies Patches
    final vegPaint = Paint()..color = const Color(0xFF1E3A29);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.45, 0, size.width * 0.25, size.height * 0.5), const Radius.circular(10)), vegPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 10, size.width * 0.2, size.height * 0.4), const Radius.circular(10)), vegPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.75, 40, size.width * 0.25, size.height * 0.4), const Radius.circular(10)), vegPaint);

    // 2. Padma River Sandbank & Water (Bottom Area)
    final sandPaint = Paint()..color = const Color(0xFFD4C8B8);
    final sandPath = Path()
      ..moveTo(0, size.height * 0.76)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.72, size.width, size.height * 0.78)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(sandPath, sandPaint);

    final waterLinePaint = Paint()
      ..color = const Color(0xFF818CF8).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final waterEdgePath = Path()
      ..moveTo(0, size.height * 0.76)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.72, size.width, size.height * 0.78);
    canvas.drawPath(waterEdgePath, waterLinePaint);

    // 3. Dense Residential Street Grid Lines (Gray Mesh)
    final streetPaint = Paint()
      ..color = const Color(0xFF64748B).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final gridPath = Path();
    // Horizontal curves
    for (double y = 30; y < size.height * 0.7; y += 22) {
      gridPath.moveTo(0, y);
      gridPath.quadraticBezierTo(size.width * 0.5, y + 8, size.width, y - 5);
    }
    // Vertical wavy lanes
    for (double x = 15; x < size.width; x += 26) {
      gridPath.moveTo(x, 0);
      gridPath.cubicTo(x + 10, size.height * 0.25, x - 10, size.height * 0.5, x + 5, size.height * 0.72);
    }
    canvas.drawPath(gridPath, streetPaint);

    // 4. Riverside Rd (Parallel to River)
    final riversideRdPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    final riverRdPath = Path()
      ..moveTo(0, size.height * 0.72)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.68, size.width, size.height * 0.74);
    canvas.drawPath(riverRdPath, riversideRdPaint);

    // 5. Yellow N6 Main Highway Curve (Golden Yellow Accent)
    final n6BorderPaint = Paint()
      ..color = const Color(0xFF475569)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13;
    final n6RoadPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final n6Path = Path()
      ..moveTo(0, size.height * 0.45)
      ..cubicTo(size.width * 0.35, size.height * 0.62, size.width * 0.65, size.height * 0.58, size.width, size.height * 0.22);

    canvas.drawPath(n6Path, n6BorderPaint);
    canvas.drawPath(n6Path, n6RoadPaint);

    // Highway Right Branch
    final branchPath = Path()
      ..moveTo(size.width * 0.82, size.height * 0.36)
      ..lineTo(size.width, 0);
    canvas.drawPath(branchPath, n6BorderPaint);
    canvas.drawPath(branchPath, n6RoadPaint);

    // 6. Landmark Badges & Labels (Matching User Screenshot)
    _drawLandmarkPill(canvas, Offset(size.width * 0.15, size.height * 0.38), 'Khademul Islam Jame Masjid', Icons.mosque_rounded);
    _drawLandmarkPill(canvas, Offset(size.width * 0.35, size.height * 0.18), 'Rajshahi City Hospital', Icons.local_hospital_rounded, isRed: true);
    _drawLandmarkPill(canvas, Offset(size.width * 0.68, size.height * 0.44), 'Talaimari Balur Ghat Masjid', Icons.mosque_rounded);

    // Padma River Text
    final TextPainter tp = TextPainter(
      text: const TextSpan(
        text: 'Padma River',
        style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(size.width * 0.4, size.height * 0.84));
  }

  void _paintDhakaSatellite(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF2C3545);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final vegPaint = Paint()..color = const Color(0xFF14532D);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(20, 20, size.width * 0.3, 60), const Radius.circular(8)), vegPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.6, 120, size.width * 0.35, 70), const Radius.circular(8)), vegPaint);

    final streetPaint = Paint()
      ..color = const Color(0xFF64748B).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final gridPath = Path();
    for (double x = 20; x < size.width; x += 30) {
      gridPath.moveTo(x, 0);
      gridPath.lineTo(x, size.height);
    }
    for (double y = 20; y < size.height; y += 28) {
      gridPath.moveTo(0, y);
      gridPath.lineTo(size.width, y);
    }
    canvas.drawPath(gridPath, streetPaint);

    // Sonargaon Janapath Avenue (Uttara Highway)
    final hwyPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11;
    final hwyPath = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width * 0.5, size.height);
    canvas.drawPath(hwyPath, hwyPaint);

    _drawLandmarkPill(canvas, Offset(size.width * 0.2, size.height * 0.3), 'Uttara Sector 11 Park', Icons.park_rounded);
    _drawLandmarkPill(canvas, Offset(size.width * 0.6, size.height * 0.6), 'Uttara Modern Hospital', Icons.local_hospital_rounded, isRed: true);
  }

  void _drawLandmarkPill(Canvas canvas, Offset offset, String title, IconData icon, {bool isRed = false}) {
    final bgPaint = Paint()..color = Colors.black87;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(offset.dx, offset.dy, 135, 20),
      const Radius.circular(10),
    );
    canvas.drawRRect(rect, bgPaint);

    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: title,
        style: TextStyle(
          color: isRed ? const Color(0xFFF87171) : Colors.white,
          fontSize: 8.5,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '...',
    )..layout(maxWidth: 120);
    tp.paint(canvas, Offset(offset.dx + 8, offset.dy + 4));
  }

  @override
  bool shouldRepaint(covariant _SatellitePainter oldDelegate) => oldDelegate.isRajshahi != isRajshahi;
}
