import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/custom_app_bar.dart';
import 'login_view.dart';

class ForgotPasswordView extends StatefulWidget {
  final HomeController homeController;
  final AuthController authController;
  final LanguageController? languageController;

  const ForgotPasswordView({
    super.key,
    required this.homeController,
    required this.authController,
    this.languageController,
  });

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _inputController = TextEditingController();
  bool _isSubmitting = false;
  bool _isSubmittedSuccess = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _handleResetRequest() async {
    final input = _inputController.text.trim();
    final isBangla = widget.languageController?.isBangla ?? true;

    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isBangla
                ? 'অনুগ্রহ করে আপনার মোবাইল নম্বর অথবা ইমেইল প্রদান করুন।'
                : 'Please enter your mobile number or email address.',
          ),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate OTP / Reset request processing
    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _isSubmittedSuccess = true;
      });
    }
  }

  void _callHelpline() async {
    final Uri phoneUri = Uri.parse('tel:09647111666');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = widget.languageController?.isBangla ?? true;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: '',
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double containerWidth = constraints.maxWidth > 480 ? 420 : constraints.maxWidth;

                return SizedBox(
                  width: containerWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top Logo Image
                      Image.asset(
                        'assets/images/logo.png',
                        height: 65,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.local_hospital_rounded, size: 36, color: Color(0xFF0F9D58)),
                            SizedBox(width: 8),
                            Text(
                              'মেডিসেবা',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFED1C24),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Heading Title
                      Text(
                        isBangla ? 'পাসওয়ার্ড পুনরুদ্ধার' : 'Reset Password',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        isBangla
                            ? 'আপনার নিবন্ধিত মোবাইল নম্বর অথবা ইমেইল লিখে পাসওয়ার্ড রিসেট করুন'
                            : 'Enter your registered phone or email to recover your account',
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      if (_isSubmittedSuccess) ...[
                        // Success Feedback Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F4EA),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFA7F3D0), width: 1.2),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.check_circle_rounded, color: Color(0xFF0F9D58), size: 48),
                              const SizedBox(height: 12),
                              Text(
                                isBangla ? 'অনুরোধ পাঠানো হয়েছে!' : 'Request Sent Successfully!',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF065F46),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isBangla
                                    ? '${_inputController.text.trim()} নম্বরে/ইমেইলে রিসেট ইন্সট্রাকশন অথবা ওটিপি পাঠানো হয়েছে। যেকোনো সহায়তায় আমাদের হটলাইনে কল করুন।'
                                    : 'Reset instructions sent to ${_inputController.text.trim()}. Call our helpline for immediate assistance.',
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: Color(0xFF047857),
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Call Hotline Button (Fully Responsive)
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: _callHelpline,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF0F9D58), width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.phone_in_talk_rounded, color: Color(0xFF0F9D58), size: 20),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      isBangla ? 'হেল্পলাইনে কল দিন (09647111666)' : 'Call Helpline (09647111666)',
                                      style: const TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F9D58),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else ...[
                        // Form Input Field
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            isBangla ? 'মোবাইল নম্বর অথবা ইমেইল *' : 'Mobile Number or Email *',
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        TextField(
                          controller: _inputController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0F172A),
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.phone_iphone_rounded, color: Color(0xFF94A3B8), size: 22),
                            hintText: isBangla ? '017XXXXXXXX অথবা ইমেইল' : '017XXXXXXXX or email',
                            hintStyle: const TextStyle(fontSize: 13.5, color: Color(0xFF94A3B8)),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Color(0xFF0F9D58), width: 1.6),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Submit Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _handleResetRequest,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F9D58),
                              foregroundColor: Colors.white,
                              elevation: 3,
                              shadowColor: const Color(0xFF0F9D58).withValues(alpha: 0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        isBangla ? 'ওটিপি/রিসেট রিকোয়েস্ট পাঠান' : 'Send Reset Code',
                                        style: const TextStyle(
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward_rounded, size: 20),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Call Hotline Button Alternative (Fully Responsive)
                        InkWell(
                          onTap: _callHelpline,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.headset_mic_rounded, color: Color(0xFF0284C7), size: 20),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      isBangla ? 'সরাসরি হেল্পলাইনে কল করুন: 09647111666' : 'Call Helpline Support: 09647111666',
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0284C7),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),

                      // Return to Login Link
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginView(
                                homeController: widget.homeController,
                                authController: widget.authController,
                                languageController: widget.languageController,
                              ),
                            ),
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            text: isBangla ? 'পাসওয়ার্ড মনে পড়েছে? ' : 'Remembered your password? ',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF475569),
                            ),
                            children: [
                              TextSpan(
                                text: isBangla ? 'সাইন-ইন করুন' : 'Sign In',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F9D58),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
