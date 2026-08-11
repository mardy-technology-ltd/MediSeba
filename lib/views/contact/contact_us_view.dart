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
            _buildInput(_phoneController, '01700000000', keyboardType: TextInputType.phone),
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

          // Map Preview Container
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(14),
              image: const DecorationImage(
                image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=23.8759,90.3795&zoom=15&size=600x300&sensor=false'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                        ),
                        child: const Icon(Icons.pin_drop_rounded, color: Colors.redAccent, size: 28),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _selectedMapIndex == 0 ? 'MediSeba Dhaka Office' : 'MediSeba Rajshahi Office',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
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
