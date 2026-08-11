import 'package:flutter/material.dart';
import '../../controllers/language_controller.dart';

class DealerPartnerView extends StatefulWidget {
  final LanguageController? languageController;

  const DealerPartnerView({super.key, this.languageController});

  @override
  State<DealerPartnerView> createState() => _DealerPartnerViewState();
}

class _DealerPartnerViewState extends State<DealerPartnerView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _tradeLicenseController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  late final LanguageController _langController;

  static const brandGreen = Color(0xFF0F9D58);
  static const textDark = Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _tradeLicenseController.dispose();
    _regionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
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
              _langController.tr('ডিলার পার্টনারশিপ', 'Dealer Partnership'),
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

                  // 2. DEALER PARTNERSHIP FORM CARD
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
          colors: [Color(0xFF0F9D58), Color(0xFF059669)],
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
                  Icons.storefront_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _langController.tr('রিজিওনাল ডিলার পার্টনারশিপ (Dealer Partner)', 'Regional Dealer Partner'),
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
              'আপনার এলাকায় মেডিসেবা পয়েন্ট ও ডিলারশিপ নিন',
              'Get MediSeba Point & Dealership in Your Area',
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
              'উপজেলা ও জেলা পর্যায়ে মেডিসেবা ই-ফার্মেসি এবং হেলথকার্ড ডিস্ট্রিবিউশন এজেন্ট হিসেবে আকর্ষণীয় আয়ের সুযোগ।',
              'Attractive earning opportunity as a MediSeba e-pharmacy & health card distribution agent at upazila & district levels.',
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

  // 2. DEALER PARTNERSHIP REGISTRATION FORM CARD
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
                child: const Icon(Icons.storefront_rounded, color: brandGreen, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _langController.tr('ডিলার পার্টনারশিপ ফর্ম', 'Dealer Partnership Form'),
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

          // 1. Business Name / Dealer Name
          _buildFormFieldLabel(_langController.tr('ব্যবসায়িক প্রতিষ্ঠানের নাম / ডিলারের নাম', 'Business Name / Dealer Name'), isRequired: true),
          _buildTextField(
            controller: _businessNameController,
            hint: _langController.tr('যেমন: এস এ ট্রেডার্স / Samiul Islam', 'e.g. S A Traders / Samiul Islam'),
            validatorMsg: _langController.tr('অনুগ্রহ করে প্রতিষ্ঠানের নাম/ডিলারের নাম লিখুন', 'Please enter business/dealer name'),
          ),

          const SizedBox(height: 14),

          // 2. Trade License No
          _buildFormFieldLabel(_langController.tr('ট্রেড লাইসেন্স নং', 'Trade License No'), isRequired: true),
          _buildTextField(
            controller: _tradeLicenseController,
            hint: 'TRAD-99120',
            validatorMsg: _langController.tr('ট্রেড লাইসেন্স নম্বর আবশ্যক', 'Trade license number required'),
          ),

          const SizedBox(height: 14),

          // 3. Desired Region / District
          _buildFormFieldLabel(_langController.tr('কাঙ্ক্ষিত এলাকা / জেলা', 'Desired Region / District'), isRequired: true),
          _buildTextField(
            controller: _regionController,
            hint: _langController.tr('যেমন: Dhaka / রাজশাহী', 'e.g. Dhaka / Rajshahi'),
            validatorMsg: _langController.tr('কাঙ্ক্ষিত এলাকা/জেলা আবশ্যক', 'Desired region/district required'),
          ),

          const SizedBox(height: 14),

          // 4. Mobile Number
          _buildFormFieldLabel(_langController.tr('মোবাইল নম্বর', 'Mobile Number'), isRequired: true),
          _buildTextField(
            controller: _phoneController,
            hint: '01710000000',
            keyboardType: TextInputType.phone,
            validatorMsg: _langController.tr('মোবাইল নম্বর আবশ্যক', 'Mobile number required'),
          ),

          const SizedBox(height: 14),

          // 5. Email Address
          _buildFormFieldLabel(_langController.tr('ইমেইল ঠিকানা', 'Email Address')),
          _buildTextField(
            controller: _emailController,
            hint: 'dealer@mediseba.org',
            keyboardType: TextInputType.emailAddress,
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
