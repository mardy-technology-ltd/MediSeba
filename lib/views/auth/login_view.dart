import 'package:flutter/material.dart';
import 'register_view.dart';
import 'forgot_password_view.dart';
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
    final isBangla = widget.languageController?.isBangla ?? true;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double containerWidth = constraints.maxWidth > 480 ? 420 : constraints.maxWidth;

                return SizedBox(
                  width: containerWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      // Top Logo Image (Clean without duplicate text)
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

                      const SizedBox(height: 32),

                      // Main Heading Title
                      Text(
                        isBangla ? 'সাইন-ইন করুন' : 'Sign In',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // Subtitle Description
                      Text(
                        isBangla
                            ? 'আপনার অ্যাকাউন্টে প্রবেশ করতে নিচের তথ্য প্রদান করুন'
                            : 'Enter your credentials to access your account',
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // Section: Email/Mobile label
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          isBangla ? 'ইমেইল অথবা মোবাইল নম্বর *' : 'Email or Mobile Number *',
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
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
                          color: Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF94A3B8), size: 22),
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

                      const SizedBox(height: 20),

                      // Section: Password label row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isBangla ? 'পাসওয়ার্ড *' : 'Password *',
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPasswordView(
                                    homeController: widget.homeController,
                                    authController: widget.authController,
                                    languageController: widget.languageController,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              isBangla ? 'পাসওয়ার্ড ভুলে গেছেন?' : 'Forgot Password?',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F9D58),
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
                          color: Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF94A3B8), size: 22),
                          hintText: '••••••••',
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

                      const SizedBox(height: 28),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoggingIn ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F9D58),
                            foregroundColor: Colors.white,
                            elevation: 3,
                            shadowColor: const Color(0xFF0F9D58).withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
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
                                  children: [
                                    Text(
                                      isBangla ? 'সাইন-ইন করুন' : 'Sign In',
                                      style: const TextStyle(
                                        fontSize: 16,
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

                      const SizedBox(height: 32),

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
                        child: Text.rich(
                          TextSpan(
                            text: isBangla ? 'নতুন অ্যাকাউন্ট খুলতে চান? ' : "Don't have an account? ",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF475569),
                            ),
                            children: [
                              TextSpan(
                                text: isBangla ? 'নিবন্ধন করুন' : 'Register Now',
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
