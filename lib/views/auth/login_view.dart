import 'package:flutter/material.dart';
import 'register_view.dart';
import '../home/home_view.dart';
import '../admin/admin_dashboard_view.dart';
import '../hbp/hbp_dashboard_view.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/language_controller.dart';

enum LoginRole {
  patient,
  doctor,
  hbp,
  supervisor,
  areaMgr,
  marketingMgr,
  headOfSales,
  salesDirector,
  admin
}

class LoginView extends StatefulWidget {
  final HomeController homeController;
  final AuthController authController;
  final LanguageController? languageController;

  const LoginView({
    super.key,
    required this.homeController,
    required this.authController,
    this.languageController,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  static const brandGreen = Color(0xFF00A859);
  static const textDark = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);

  LoginRole _selectedRole = LoginRole.patient;

  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoggingIn = false;

  LoginRole _detectRole(String input) {
    final cleanInput = input.trim().toLowerCase();
    if (cleanInput.contains('hbp') ||
        cleanInput.contains('sojib') ||
        cleanInput.contains('rahim') ||
        cleanInput.contains('01710000010') ||
        cleanInput.contains('01798456879')) {
      return LoginRole.hbp;
    }
    if (cleanInput.contains('doctor')) return LoginRole.doctor;
    if (cleanInput.contains('admin')) return LoginRole.admin;
    if (cleanInput.contains('tanvir')) return LoginRole.supervisor;
    if (cleanInput.contains('areamanager')) return LoginRole.areaMgr;
    if (cleanInput.contains('marketing')) return LoginRole.marketingMgr;
    if (cleanInput.contains('headsales')) return LoginRole.headOfSales;
    if (cleanInput.contains('director')) return LoginRole.salesDirector;
    return LoginRole.patient;
  }

  void _handleLogin() async {
    final input = _inputController.text.trim();
    final password = _passwordController.text;

    if (input.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('ইমেইল/মোবাইল নম্বর ও পাসওয়ার্ড প্রদান করুন'),
            ],
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    // Set selected role dynamically based on input for routing
    setState(() {
      _selectedRole = _detectRole(input);
    });

    _proceedNormalLogin();
  }

  void _proceedNormalLogin() async {
    setState(() {
      _isLoggingIn = true;
    });

    final success = await widget.authController.login(_inputController.text.trim(), _passwordController.text);

    if (mounted) {
      setState(() {
        _isLoggingIn = false;
      });

      if (success) {
        final uData = widget.authController.currentUserData;
        final uName = (uData?.name ?? '').toLowerCase();
        final uPhone = (uData?.phone ?? '').toLowerCase();
        final id = _inputController.text.trim().toLowerCase();

        final bool isHbpUser = _selectedRole == LoginRole.hbp ||
            id.contains('hbp') ||
            id.contains('sojib') ||
            id.contains('01798456879') ||
            uName.contains('sojib') ||
            uPhone.contains('01798456879');

        final bool isAdminUser = _selectedRole == LoginRole.admin ||
            id.contains('admin') ||
            uName.contains('admin');

        Widget targetView;
        if (isHbpUser) {
          targetView = HbpDashboardView(
            homeController: widget.homeController,
            authController: widget.authController,
            languageController: widget.languageController,
          );
        } else if (isAdminUser || (_selectedRole != LoginRole.patient && _selectedRole != LoginRole.hbp)) {
          targetView = AdminDashboardView(
            homeController: widget.homeController,
            authController: widget.authController,
            languageController: widget.languageController,
          );
        } else {
          targetView = HomeView(
            homeController: widget.homeController,
            authController: widget.authController,
            languageController: widget.languageController,
          );
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => targetView),
        );
      } else {
        // Show error snackbar
        final errorMsg = widget.authController.errorMessage ?? 'লগইন করতে ব্যর্থ হয়েছে। আবার চেষ্টা করুন।';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(errorMsg)),
              ],
            ),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _passwordController.dispose();
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
                final double containerWidth = constraints.maxWidth > 480 ? 440 : constraints.maxWidth;
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

                      // Secured Service Account Login Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F7F4), // Light teal background
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFB2DFDB), width: 1.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.gpp_good_outlined,
                              color: Color(0xFF009688), // Teal color
                              size: 18,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'সিকিউরড সার্ভিস অ্যাকাউন্ট লগইন',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF009688),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Main Heading Title
                      const Text(
                        'মেডিসেবা পোর্টালে সাইন-ইন করুন',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: textDark,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // Subtitle Description
                      const Text(
                        'আপনার নিবন্ধিত ইমেইল/মোবাইল নম্বর ও পাসওয়ার্ড প্রদান করুন',
                        style: TextStyle(
                          fontSize: 13.5,
                          color: textMuted,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // Section: Email/Mobile label
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'ইমেইল অথবা মোবাইল নম্বর *',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Email input field
                      TextField(
                        controller: _inputController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: textDark,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail_outline_rounded, color: Color(0xFF94A3B8), size: 22),
                          hintText: 'যেমন: patient@mediseba.org অথবা 01700000000',
                          hintStyle: const TextStyle(fontSize: 13.5, color: Color(0xFF94A3B8)),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: const BorderSide(color: Color(0xFF009688), width: 1.5),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Section: Password label row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'পাসওয়ার্ড *',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('পাসওয়ার্ড পুনরুদ্ধারের জন্য অ্যাডমিনের সাথে যোগাযোগ করুন।')),
                                );
                              },
                              child: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'পাসওয়ার্ড ভুলে গেছেন?',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF009688),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Password input field
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: textDark,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF94A3B8), size: 22),
                          hintText: '••••••••',
                          hintStyle: const TextStyle(fontSize: 13.5, color: Color(0xFF94A3B8)),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: const BorderSide(color: Color(0xFF009688), width: 1.5),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: const Color(0xFF94A3B8),
                              size: 22,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isLoggingIn ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF009688),
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: const Color(0xFF009688).withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: _isLoggingIn
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'পোর্টালে সাইন-ইন করুন',
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

                      // Under-button divider
                      const Divider(
                        color: Color(0xFFF1F5F9),
                        thickness: 1.2,
                      ),

                      const SizedBox(height: 16),

                      // Sign up Link
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterView(
                                homeController: widget.homeController,
                                authController: widget.authController,
                              ),
                            ),
                          );
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: 'নতুন অ্যাকাউন্ট খুলতে চান? ',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF334155),
                            ),
                            children: [
                              TextSpan(
                                text: 'এখানে নিবন্ধন করুন',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF009688),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Secure SSL Badge Footer
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.gpp_good_outlined,
                              color: Color(0xFF94A3B8),
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              '256-Bit SSL Encrypted Enterprise Portal',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF94A3B8),
                              ),
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
}
