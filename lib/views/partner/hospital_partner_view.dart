import 'package:flutter/material.dart';
import '../../controllers/language_controller.dart';

class HospitalPartnerView extends StatefulWidget {
  final LanguageController? languageController;

  const HospitalPartnerView({super.key, this.languageController});

  @override
  State<HospitalPartnerView> createState() => _HospitalPartnerViewState();
}

class _HospitalPartnerViewState extends State<HospitalPartnerView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _licenseNoController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  late final LanguageController _langController;

  static const brandPurple = Color(0xFF7C3AED);
  static const textDark = Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
  }

  @override
  void dispose() {
    _hospitalNameController.dispose();
    _licenseNoController.dispose();
    _contactPersonController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
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
              _langController.tr('হাসপাতাল পার্টনারশিপ', 'Hospital Partnership'),
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

                  // 2. HOSPITAL PARTNERSHIP FORM CARD
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
          colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
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
                  Icons.local_hospital_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _langController.tr('হাসপাতাল ও ডায়াগনস্টিক পার্টনার (Hospital Network)', 'Hospital & Diagnostic Partner'),
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
              'আপনার হাসপাতাল বা ক্লিনিক যুক্ত করুন মেডিসেবা নেটওয়ার্কে',
              'Connect Your Hospital or Clinic to MediSeba Network',
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
              'অনলাইন ডায়াগনস্টিক টেস্ট বুকিং, প্যাথলজি টেস্ট রিপোর্ট ডেলিভারি ও হাসপাতাল বেড বুকিংয়ে বিশেষ নেটওয়ার্ক পার্টনার হোন।',
              'Become a network partner for online diagnostic test bookings, pathology report delivery & hospital bed bookings.',
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

  // 2. HOSPITAL PARTNERSHIP REGISTRATION FORM CARD
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
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_hospital_rounded, color: brandPurple, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _langController.tr('হাসপাতাল পার্টনারশিপ রেজিস্ট্রেশন', 'Hospital Partnership Registration'),
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

          // 1. Hospital / Diagnostic Center Name
          _buildFormFieldLabel(_langController.tr('হাসপাতাল / ডায়াগনস্টিকের নাম', 'Hospital / Diagnostic Name'), isRequired: true),
          _buildTextField(
            controller: _hospitalNameController,
            hint: _langController.tr('যেমন: পপুলার ডায়াগনস্টিক সেন্টার, রাজশাহী', 'e.g. Popular Diagnostic Center, Rajshahi'),
            validatorMsg: _langController.tr('অনুগ্রহ করে হাসপাতাল/ডায়াগনস্টিকের নাম লিখুন', 'Please enter hospital/diagnostic name'),
          ),

          const SizedBox(height: 14),

          // 2. DGHS License No
          _buildFormFieldLabel(_langController.tr('স্বাস্থ্য অধিদপ্তরের লাইসেন্স নং', 'DGHS License No'), isRequired: true),
          _buildTextField(
            controller: _licenseNoController,
            hint: 'DGHS-REG-9912',
            validatorMsg: _langController.tr('লাইসেন্স নম্বর আবশ্যক', 'License number required'),
          ),

          const SizedBox(height: 14),

          // 3. Contact Person / Manager Name
          _buildFormFieldLabel(_langController.tr('দায়িত্বপ্রাপ্ত ব্যক্তির নাম', 'Contact Person / Manager Name'), isRequired: true),
          _buildTextField(
            controller: _contactPersonController,
            hint: _langController.tr('যেমন: Md. Rafiqul Islam (Manager)', 'e.g. Md. Rafiqul Islam (Manager)'),
            validatorMsg: _langController.tr('দায়িত্বপ্রাপ্ত ব্যক্তির নাম আবশ্যক', 'Contact person name required'),
          ),

          const SizedBox(height: 14),

          // 4. Official Mobile Number
          _buildFormFieldLabel(_langController.tr('অফিসিয়াল মোবাইল নম্বর', 'Official Mobile Number'), isRequired: true),
          _buildTextField(
            controller: _phoneController,
            hint: '01710000000',
            keyboardType: TextInputType.phone,
            validatorMsg: _langController.tr('মোবাইল নম্বর আবশ্যক', 'Mobile number required'),
          ),

          const SizedBox(height: 14),

          // 5. Full Address
          _buildFormFieldLabel(_langController.tr('পূর্ণ ঠিকানা', 'Full Address'), isRequired: true),
          _buildTextField(
            controller: _addressController,
            hint: _langController.tr('যেমন: বোয়ালিয়া, রাজশাহী', 'e.g. Boalia, Rajshahi'),
            validatorMsg: _langController.tr('পূর্ণ ঠিকানা আবশ্যক', 'Full address required'),
          ),

          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: brandPurple,
                elevation: 3,
                shadowColor: brandPurple.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _submitForm,
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              label: Text(
                _langController.tr('সাবমিট করুন', 'Submit Application'),
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
          borderSide: const BorderSide(color: brandPurple, width: 1.5),
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
