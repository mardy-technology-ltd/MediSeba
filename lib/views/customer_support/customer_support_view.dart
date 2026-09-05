import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/language_controller.dart';

class CustomerSupportView extends StatefulWidget {
  final LanguageController? languageController;

  const CustomerSupportView({
    super.key,
    this.languageController,
  });

  @override
  State<CustomerSupportView> createState() => _CustomerSupportViewState();
}

class _CustomerSupportViewState extends State<CustomerSupportView> {
  late final LanguageController _langController;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;

  static const brandPurple = Color(0xFF6366F1);
  static const textDark = Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() => _isSubmitting = false);

        _nameController.clear();
        _phoneController.clear();
        _messageController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _langController.tr(
                'আপনার বার্তা সফলভাবে জমা হয়েছে। আমাদের টিম খুব শীঘ্রই যোগাযোগ করবে।',
                'Your message has been submitted successfully. Our team will contact you soon.',
              ),
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: textDark),
        title: Text(
          _langController.tr('কাস্টমার সাপোর্ট (২৪/৭)', 'Customer Support (24/7)'),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Purple Gradient Banner Card
              _buildHeroCard(),

              const SizedBox(height: 20),

              // 2. Responsive 3 Contact Info Cards
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 750) {
                    return Row(
                      children: [
                        Expanded(child: _buildHotlineCard()),
                        const SizedBox(width: 12),
                        Expanded(child: _buildEmailCard()),
                        const SizedBox(width: 12),
                        Expanded(child: _buildAddressCard()),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _buildHotlineCard(),
                      const SizedBox(height: 12),
                      _buildEmailCard(),
                      const SizedBox(height: 12),
                      _buildAddressCard(),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // 3. Direct Message Submission Form Card
              _buildMessageFormCard(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Hero Purple Gradient Banner Card
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF6366F1), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: brandPurple.withValues(alpha: 0.35),
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
                const Icon(Icons.headset_mic_rounded, color: Colors.white, size: 15),
                const SizedBox(width: 6),
                Text(
                  _langController.tr('২৪/৭ কাস্টমার হেল্পডেস্ক (24/7 Support Desk)', '24/7 Support Desk'),
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
            _langController.tr('আমরা কীভাবে আপনাকে সাহায্য করতে পারি?', 'How Can We Help You?'),
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
              'মেডিসেবা প্ল্যাটফর্মের যেকোনো সেবা, অ্যাপয়েন্টমেন্ট বা অভিযোগের জন্য আমাদের কাস্টমার কেয়ার টিম সবসময় আপনার পাশে আছে।',
              'Our customer care team is always by your side for any service, appointment, or feedback on the MediSeba platform.',
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

  // 2. Hotline Info Card
  Widget _buildHotlineCard() {
    return GestureDetector(
      onTap: () => _makePhoneCall('09647111666'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.phone_in_talk_rounded, color: brandPurple, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _langController.tr('২৪/৭ জরুরি হটলাইন', '24/7 Emergency Hotline'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '09647111666',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                      color: brandPurple,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _langController.tr('অভিযোগ/সরাসরি: 01330177522', 'Direct/Complaint: 01330177522'),
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF64748B),
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

  // 3. Email Info Card
  Widget _buildEmailCard() {
    return GestureDetector(
      onTap: () => _sendEmail('info@mediseba.org'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.email_rounded, color: Color(0xFF10B981), size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _langController.tr('ইমেইল হেল্পডেস্ক', 'Email Helpdesk'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'info@mediseba.org',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _langController.tr('সরাসরি প্রশ্ন বা ফিডব্যাক মেইল করুন', 'Email your queries or feedback'),
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF64748B),
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

  // 4. Head Office Address Card
  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.location_on_rounded, color: Color(0xFF9333EA), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _langController.tr('হেড অফিস ঠিকানা', 'Head Office Address'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _langController.tr('তালোড়মারী, বোয়ালিয়া / মতিহার', 'Talaimari, Boalia / Motihar'),
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _langController.tr('রাজশাহী, বাংলাদেশ', 'Rajshahi, Bangladesh'),
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 5. Direct Message Form Card
  Widget _buildMessageFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _langController.tr('সরাসরি বার্তা পাঠাতেন', 'Send Direct Message'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              _langController.tr(
                'আপনার সমস্যা বা জিজ্ঞাসা সাবমিট করুন, আমাদের টিম ৮ ঘণ্টার মধ্যে কল করবে',
                'Submit your issue or inquiry, our team will call back within 8 hours',
              ),
              style: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Field 1: Name
            _buildFormFieldLabel(_langController.tr('আপনার নাম', 'Your Name')),
            const SizedBox(height: 6),
            TextFormField(
              controller: _nameController,
              decoration: _buildInputDecoration(
                _langController.tr('আপনার নাম টাইপ করুন...', 'Type your name...'),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return _langController.tr('অনুগ্রহ করে নাম লিখুন', 'Please enter your name');
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Field 2: Mobile Number
            _buildFormFieldLabel(_langController.tr('মোবাইল নম্বর', 'Mobile Number')),
            const SizedBox(height: 6),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: _buildInputDecoration('017XXXXXXXX'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return _langController.tr('অনুগ্রহ করে মোবাইল নম্বর লিখুন', 'Please enter mobile number');
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Field 3: Message / Issue
            _buildFormFieldLabel(_langController.tr('বার্তার বিষয়/সমস্যা', 'Message Subject / Issue')),
            const SizedBox(height: 6),
            TextFormField(
              controller: _messageController,
              maxLines: 4,
              decoration: _buildInputDecoration(
                _langController.tr('আপনার জিজ্ঞাসা বা সমস্যা বিস্তারিত লিখুন...', 'Write your query or issue in detail...'),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return _langController.tr('অনুগ্রহ করে আপনার সমস্যাটি লিখুন', 'Please write your issue');
                }
                return null;
              },
            ),

            const SizedBox(height: 22),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandPurple,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                label: Text(
                  _langController.tr('মেসেজ সাবমিট করুন', 'Submit Message'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFieldLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFF94A3B8),
      ),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: brandPurple, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
      ),
    );
  }
}
