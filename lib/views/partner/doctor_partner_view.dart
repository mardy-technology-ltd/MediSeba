import 'package:flutter/material.dart';
import '../../controllers/language_controller.dart';

class DoctorPartnerView extends StatefulWidget {
  final LanguageController? languageController;

  const DoctorPartnerView({super.key, this.languageController});

  @override
  State<DoctorPartnerView> createState() => _DoctorPartnerViewState();
}

class _DoctorPartnerViewState extends State<DoctorPartnerView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bmdcController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _chamberController = TextEditingController();

  String _selectedServiceModeKey = 'both';

  static const List<Map<String, String>> _serviceModeOptions = [
    {
      'key': 'both',
      'bn': 'উভয় সেবা (ডাক্তার ঘর + চেম্বার সিরিয়াল)',
      'en': 'Both Services (Doctor Ghor + Chamber Serial)',
    },
    {
      'key': 'doctor_ghor',
      'bn': 'শুধুমাত্র ডাক্তার ঘর (ভিডিও কল)',
      'en': 'Doctor Ghor Only (Video Call)',
    },
    {
      'key': 'chamber_serial',
      'bn': 'শুধুমাত্র চেম্বার সিরিয়াল',
      'en': 'Chamber Serial Only',
    },
  ];

  late final LanguageController _langController;

  static const brandGreen = Color(0xFF008536);
  static const textDark = Color(0xFF1E293B);
  static const textMuted = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bmdcController.dispose();
    _specialityController.dispose();
    _degreeController.dispose();
    _designationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _chamberController.dispose();
    super.dispose();
  }

  void _submitForm() {
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
                  'এই ফিচারটি বর্তমানে ডেভেলপমেন্টাধীন রয়েছে (Under Development)।',
                  'This feature is currently under development.',
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
          _langController.tr('ডাক্তার পার্টনারশিপ', 'Doctor Partnership'),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HERO BANNER CARD
              _buildHeroCard(),

              const SizedBox(height: 16),

              // 2. FEATURE HIGHLIGHTS CARDS
              _buildFeatureCards(),

              const SizedBox(height: 24),

              // 3. DOCTOR PARTNERSHIP REGISTRATION FORM CARD
              _buildRegistrationFormCard(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // 1. HERO BANNER CARD
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
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
                  Icons.medical_services_rounded,
                  color: Colors.white,
                  size: 15,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _langController.tr('চিকিৎসক পার্টনারশিপ পোর্টাল (Doctor Registration)', 'Doctor Registration Portal'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
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
              'মেডিসেবা প্ল্যাটফর্মে যোগ দিন আপনার চেম্বার ও অনলাইন প্র্যাকটিস বাড়াতে',
              'Join MediSeba Platform to Expand Your Chamber & Online Practice',
            ),
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),

          // Sub-description
          Text(
            _langController.tr(
              'হাজারো রোগীর ডিজিটাল কনসালটেশন ও অনলাইন চেম্বার অ্যাপয়েন্টমেন্ট ম্যানেজমেন্টের নির্ভরযোগ্য সমাধান।',
              'Reliable solution for digital consultation of thousands of patients and online chamber appointment management.',
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

  // 2. FEATURE HIGHLIGHTS CARDS
  Widget _buildFeatureCards() {
    return Column(
      children: [
        _buildFeatureItem(
          icon: Icons.video_camera_front_rounded,
          iconBg: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF0F9D58),
          title: _langController.tr('HD ভিডিও কনসালটেশন', 'HD Video Consultation'),
          description: _langController.tr(
            'মেডিসেবা ডিজিটাল চেম্বারের মাধ্যমে ঘরে বসেই দেশ-বিদেশের রোগীদের অনলাইন সেবা দিন।',
            'Provide online services to patients home & abroad through MediSeba digital chamber.',
          ),
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          icon: Icons.calendar_month_rounded,
          iconBg: const Color(0xFFE0F2FE),
          iconColor: const Color(0xFF0EA5E9),
          title: _langController.tr('স্মার্ট চেম্বার বুকিং', 'Smart Chamber Booking'),
          description: _langController.tr(
            'আপনার হাসপাতালের শারীরিক চেম্বার সিরিয়াল অনলাইন এক ক্লিকে ম্যানেজ করুন।',
            'Manage your physical hospital chamber serials online in one click.',
          ),
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          icon: Icons.verified_user_rounded,
          iconBg: const Color(0xFFFEF3C7),
          iconColor: const Color(0xFFD97706),
          title: _langController.tr('বিএমডিসি রেজিস্টার্ড ডাক্তার ভেরিফিকেশন', 'BMDC Registered Doctor Verification'),
          description: _langController.tr(
            'ভেরিফাইড ব্যাজ সহ সরাসরি ডিজিটাল প্রেসক্রিপশন ও অটোমেটিক ফি রিফান্ড সুবিধা।',
            'Verified badge with direct digital prescription and automatic fee refund benefits.',
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
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

  // 3. DOCTOR PARTNERSHIP REGISTRATION FORM CARD
  Widget _buildRegistrationFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form Title Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.app_registration_rounded, color: brandGreen, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _langController.tr('ডাক্তার পার্টনারশিপ রেজিস্ট্রেশন ফর্ম', 'Doctor Partnership Registration Form'),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 1. Doctor Full Name Field
          _buildFormFieldLabel(_langController.tr('ডাক্তারের পূর্ণ নাম', 'Doctor Full Name'), isRequired: true),
          _buildTextField(
            controller: _nameController,
            hint: _langController.tr('যেমন: Dr. Md. Imran Kabir', 'e.g. Dr. Md. Imran Kabir'),
            validatorMsg: _langController.tr('অনুগ্রহ করে ডাক্তারের পূর্ণ নাম লিখুন', 'Please enter full name'),
          ),

          const SizedBox(height: 14),

          // 2. BMDC Reg. No Field
          _buildFormFieldLabel(_langController.tr('BMDC রেজিস্ট্রেশন নম্বর', 'BMDC Reg. No'), isRequired: true),
          _buildTextField(
            controller: _bmdcController,
            hint: 'A-10294',
            validatorMsg: _langController.tr('BMDC নম্বর আবশ্যক', 'BMDC required'),
          ),

          const SizedBox(height: 14),

          // 3. Speciality Field
          _buildFormFieldLabel(_langController.tr('বিশেষজ্ঞতা (Speciality)', 'Speciality'), isRequired: true),
          _buildTextField(
            controller: _specialityController,
            hint: 'Medicine',
            validatorMsg: _langController.tr('বিশেষজ্ঞতা আবশ্যক', 'Speciality required'),
          ),

          const SizedBox(height: 14),

          // 4. Degree Field
          _buildFormFieldLabel(_langController.tr('ডিগ্রি / যোগ্যতা (Degree)', 'Degree')),
          _buildTextField(
            controller: _degreeController,
            hint: 'MBBS, FCPS',
          ),

          const SizedBox(height: 14),

          // 5. Designation Field
          _buildFormFieldLabel(_langController.tr('বর্তমান পদবী (Designation)', 'Designation')),
          _buildTextField(
            controller: _designationController,
            hint: 'Consultant',
          ),

          const SizedBox(height: 14),

          // 6. Mobile Number Field
          _buildFormFieldLabel(_langController.tr('মোবাইল নম্বর', 'Mobile Number'), isRequired: true),
          _buildTextField(
            controller: _phoneController,
            hint: '01710000000',
            keyboardType: TextInputType.phone,
            validatorMsg: _langController.tr('মোবাইল নম্বর আবশ্যক', 'Mobile required'),
          ),

          const SizedBox(height: 14),

          // 7. Email Address Field
          _buildFormFieldLabel(_langController.tr('ইমেইল', 'Email Address')),
          _buildTextField(
            controller: _emailController,
            hint: 'doctor@mediseba.org',
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 14),

          // 8. Chamber / Hospital Name
          _buildFormFieldLabel(_langController.tr('চেম্বার / হাসপাতালের নাম', 'Chamber / Hospital Name')),
          _buildTextField(
            controller: _chamberController,
            hint: _langController.tr('যেমন: পপুলার ডায়াগনস্টিক, রাজশাহী', 'e.g. Popular Diagnostic, Rajshahi'),
          ),

          const SizedBox(height: 14),

          // 6. Service Mode Dropdown
          _buildFormFieldLabel(_langController.tr('কাজের পছন্দের ধরন (Service Mode)', 'Service Mode Preference'), isRequired: true),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedServiceModeKey,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: brandGreen),
                items: _serviceModeOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option['key']!,
                    child: Text(
                      _langController.tr(option['bn']!, option['en']!),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textDark),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _selectedServiceModeKey = newValue);
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: brandGreen,
                elevation: 3,
                shadowColor: brandGreen.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _submitForm,
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              label: Text(
                _langController.tr('আবেদন জমা দিন', 'Submit Application'),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFieldLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text.rich(
        TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
          children: isRequired
              ? const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ]
              : null,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? validatorMsg,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 13.5, color: textDark, fontWeight: FontWeight.w500),
      validator: (val) {
        if (validatorMsg != null && (val == null || val.trim().isEmpty)) {
          return validatorMsg;
        }
        return null;
      },
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
          borderSide: const BorderSide(color: brandGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
