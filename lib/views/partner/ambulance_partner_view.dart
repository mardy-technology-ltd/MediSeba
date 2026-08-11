import 'package:flutter/material.dart';
import '../../controllers/language_controller.dart';

class AmbulancePartnerView extends StatefulWidget {
  final LanguageController? languageController;

  const AmbulancePartnerView({super.key, this.languageController});

  @override
  State<AmbulancePartnerView> createState() => _AmbulancePartnerViewState();
}

class _AmbulancePartnerViewState extends State<AmbulancePartnerView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _metroNoController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();

  String _selectedAmbulanceTypeKey = 'standard_ac';

  static const List<Map<String, String>> _ambulanceTypeOptions = [
    {
      'key': 'standard_ac',
      'bn': 'Standard AC (স্ট্যান্ডার্ড এসি)',
      'en': 'Standard AC',
    },
    {
      'key': 'icu',
      'bn': 'ICU / Life Support (আইসিইউ / লাইফ সাপোর্ট)',
      'en': 'ICU / Life Support',
    },
    {
      'key': 'non_ac',
      'bn': 'Non-AC (নন-এসি)',
      'en': 'Non-AC',
    },
    {
      'key': 'freezing',
      'bn': 'Freezing Ambulance (ফ্রিজিং অ্যাম্বুলেন্স)',
      'en': 'Freezing Ambulance',
    },
  ];

  late final LanguageController _langController;

  static const brandBlue = Color(0xFF2563EB);
  static const textDark = Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
  }

  @override
  void dispose() {
    _ownerNameController.dispose();
    _metroNoController.dispose();
    _phoneController.dispose();
    _districtController.dispose();
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
              _langController.tr('অ্যাম্বুলেন্স পার্টনারশিপ', 'Ambulance Partnership'),
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

                  const SizedBox(height: 20),

                  // 2. AMBULANCE PARTNERSHIP FORM CARD
                  _buildRegistrationFormCard(),

                  const SizedBox(height: 24),
                ],
              ),
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
                  size: 16,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _langController.tr('অ্যাম্বুলেন্স পার্টনারশিপ (Ambulance Partner)', 'Ambulance Partner'),
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
              'আপনার অ্যাম্বুলেন্স যুক্ত করুন মেডিসেবা জরুরি নেটওয়ার্কে',
              'Connect Your Ambulance to MediSeba Emergency Network',
            ),
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),

          // Subtitle Description
          Text(
            _langController.tr(
              '২৪/৭ সরাসরি বুকিং কল ও টিপস সুবিধা পেতে আমাদের নিবন্ধিত অ্যাম্বুলেন্স ড্রাইভার ও ওনার নেটওয়ার্কে জয়েন করুন।',
              'Join our registered ambulance driver & owner network to get 24/7 direct booking calls & trip requests.',
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

  // 2. AMBULANCE PARTNERSHIP REGISTRATION FORM CARD
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
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.airport_shuttle_rounded, color: brandBlue, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _langController.tr('অ্যাম্বুলেন্স পার্টনার আবেদন ফর্ম', 'Ambulance Partner Application Form'),
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 1. Owner / Driver Name
          _buildFormFieldLabel(_langController.tr('মালিক / ড্রাইভারের নাম', 'Owner / Driver Name'), isRequired: true),
          _buildTextField(
            controller: _ownerNameController,
            hint: _langController.tr('যেমন: Md. Aslam Hossain', 'e.g. Md. Aslam Hossain'),
            validatorMsg: _langController.tr('অনুগ্রহ করে মালিক/ড্রাইভারের নাম লিখুন', 'Please enter owner/driver name'),
          ),

          const SizedBox(height: 14),

          // 2. Metro / Vehicle No
          _buildFormFieldLabel(_langController.tr('গাড়ির নম্বর (Metro No)', 'Vehicle / Metro No'), isRequired: true),
          _buildTextField(
            controller: _metroNoController,
            hint: _langController.tr('যেমন: ঢাকা মেট্রো-ছ-১ি১২২২৩', 'e.g. Dhaka Metro-CH-112233'),
            validatorMsg: _langController.tr('গাড়ির নম্বর আবশ্যক', 'Vehicle number required'),
          ),

          const SizedBox(height: 14),

          // 3. Ambulance Type Dropdown
          _buildFormFieldLabel(_langController.tr('অ্যাম্বুলেন্স ধরন', 'Ambulance Type'), isRequired: true),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedAmbulanceTypeKey,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: brandBlue),
                items: _ambulanceTypeOptions.map((option) {
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
                    setState(() => _selectedAmbulanceTypeKey = newValue);
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 14),

          // 4. Contact Mobile Number
          _buildFormFieldLabel(_langController.tr('যোগাযোগের মোবাইল নম্বর', 'Contact Mobile Number'), isRequired: true),
          _buildTextField(
            controller: _phoneController,
            hint: '01710000000',
            keyboardType: TextInputType.phone,
            validatorMsg: _langController.tr('মোবাইল নম্বর আবশ্যক', 'Mobile number required'),
          ),

          const SizedBox(height: 14),

          // 5. Operating District / Area
          _buildFormFieldLabel(_langController.tr('মূল কাজের এলাকা (জেলা)', 'Operating District / Area'), isRequired: true),
          _buildTextField(
            controller: _districtController,
            hint: _langController.tr('যেমন: Rajshahi / ঢাকা', 'e.g. Rajshahi / Dhaka'),
            validatorMsg: _langController.tr('কাজের এলাকা/জেলা আবশ্যক', 'Operating district required'),
          ),

          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: brandBlue,
                elevation: 3,
                shadowColor: brandBlue.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _submitForm,
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              label: Text(
                _langController.tr('আবেদন পাঠান', 'Submit Application'),
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
          borderSide: const BorderSide(color: brandBlue, width: 1.5),
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
