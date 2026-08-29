import 'package:flutter/material.dart';
import 'login_view.dart';
import '../home/home_view.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';

class RegisterView extends StatefulWidget {
  final HomeController homeController;
  final AuthController authController;

  const RegisterView({
    super.key,
    required this.homeController,
    required this.authController,
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  static const brandGreen = Color(0xFF009688);
  static const textDark = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isRegistering = false;

  void _handleRegister() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('অনুগ্রহ করে সকল আবশ্যকীয় তথ্য (নাম, ফোন, পাসওয়ার্ড) প্রদান করুন')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('পাসওয়ার্ড এবং পাসওয়ার্ড নিশ্চিতকরণ মিলছে না!')),
      );
      return;
    }

    setState(() {
      _isRegistering = true;
    });

    final success = await widget.authController.signUp(
      name: name,
      phone: phone,
      password: password,
      division: 'Dhaka',
      district: 'Dhaka',
      upazila: 'Dhanmondi',
      union: 'Dhanmondi',
    );

    if (mounted) {
      setState(() {
        _isRegistering = false;
      });

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeView(
              homeController: widget.homeController,
              authController: widget.authController,
            ),
          ),
        );
      } else {
        // Fallback navigate to Home View
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeView(
              homeController: widget.homeController,
              authController: widget.authController,
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double containerWidth = constraints.maxWidth > 580 ? 540 : constraints.maxWidth;
                final bool isSmallScreen = constraints.maxWidth < 420;

                return SizedBox(
                  width: containerWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      // Top Logo Image
                      Image.asset(
                        'assets/images/logo.png',
                        height: isSmallScreen ? 50 : 60,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.local_hospital_rounded, size: 36, color: brandGreen),
                            const SizedBox(width: 8),
                            Text(
                              'মেডিসেবা',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 22 : 26,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFFED1C24),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Tagline under logo
                      Text(
                        '“সেবা নিন ঘরে বসে, সুস্থ থাকুন নির্বিশেষে”',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 11 : 12.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFED1C24),
                          letterSpacing: 0.1,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Heading Title
                      Text(
                        'নতুন রোগী রেজিস্ট্রেশন (Register Account)',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 17.5 : 21,
                          fontWeight: FontWeight.w900,
                          color: textDark,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // Subtitle
                      const Text(
                        'আজই মেডিসেবা ডিজিটাল অ্যাকাউন্ট খুলুন ও পয়েন্ট রিডিম করুন',
                        style: TextStyle(
                          fontSize: 13,
                          color: textMuted,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 28),

                      // 1. Full Name Field (রোগীর পূর্ণ নাম *)
                      _buildFormField(
                        controller: _nameController,
                        label: 'রোগীর পূর্ণ নাম *',
                        hintText: 'যেমন: Mohammad Samiul',
                        prefixIcon: Icons.person_outline_rounded,
                      ),

                      const SizedBox(height: 18),

                      // 2. Phone & Email in split row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildFormField(
                              controller: _phoneController,
                              label: 'ফোন নম্বর *',
                              hintText: '01700000000',
                              prefixIcon: Icons.phone_iphone_rounded,
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildFormField(
                              controller: _emailController,
                              label: 'ইমেইল ঠিকানা',
                              hintText: 'patient@example.com',
                              prefixIcon: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // 3. Password & Confirm Password in split row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildFormField(
                              controller: _passwordController,
                              label: 'পাসওয়ার্ড *',
                              hintText: '••••••••',
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: !_isPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: const Color(0xFF94A3B8),
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildFormField(
                              controller: _confirmPasswordController,
                              label: 'পাসওয়ার্ড নিশ্চিত করুন *',
                              hintText: '••••••••',
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: !_isConfirmPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: const Color(0xFF94A3B8),
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isRegistering ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF009688),
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: const Color(0xFF009688).withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: _isRegistering
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'রেজিস্ট্রেশন সম্পন্ন করুন',
                                      style: TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded, size: 20),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Divider(color: Color(0xFFF1F5F9), thickness: 1.2),
                      const SizedBox(height: 16),

                      // Footer Wrap
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 12,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginView(
                                      homeController: widget.homeController,
                                      authController: widget.authController,
                                    ),
                                  ),
                                );
                              },
                              child: const Text.rich(
                                TextSpan(
                                  text: 'পূর্বেই অ্যাকাউন্ট তৈরি করা আছে? ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF334155),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'লগইন করুন',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF009688),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.gpp_good_outlined,
                                  color: Color(0xFF009688),
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '100% Data Encrypted',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF009688),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
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

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: textDark,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(prefixIcon, color: const Color(0xFF94A3B8), size: 20),
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 13.5, color: Color(0xFF94A3B8)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Color(0xFF009688), width: 1.5),
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
