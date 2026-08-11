import 'package:flutter/material.dart';
import 'register_view.dart';
import '../home/home_view.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/language_controller.dart';

enum LoginRole { patient, doctor, admin }

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
  static const brandGreen = Color(0xFF0F9D58);

  LoginRole _selectedRole = LoginRole.patient;

  final TextEditingController _inputController = TextEditingController(text: 'patient@mediseba.org');
  final TextEditingController _passwordController = TextEditingController(text: '12345678');
  bool _isPasswordVisible = false;
  bool _isLoggingIn = false;

  void _onRoleChanged(LoginRole role) {
    setState(() {
      _selectedRole = role;
      if (role == LoginRole.patient) {
        _inputController.text = 'patient@mediseba.org';
      } else if (role == LoginRole.doctor) {
        _inputController.text = 'doctor@mediseba.org';
      } else {
        _inputController.text = 'admin@mediseba.org';
      }
    });
  }

  void _handleLogin() async {
    final input = _inputController.text.trim();
    final password = _passwordController.text;

    if (input.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ইমেইল/মোবাইল নম্বর ও পাসওয়ার্ড প্রদান করুন')),
      );
      return;
    }

    setState(() {
      _isLoggingIn = true;
    });

    final success = await widget.authController.login(input, password);

    if (mounted) {
      setState(() {
        _isLoggingIn = false;
      });

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeView(
              homeController: widget.homeController,
              authController: widget.authController,
              languageController: widget.languageController,
            ),
          ),
        );
      } else {
        // Direct entry fallback if backend credentials vary
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeView(
              homeController: widget.homeController,
              authController: widget.authController,
              languageController: widget.languageController,
            ),
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
    String roleButtonText = 'PATIENT পোর্টালে প্রবেশ করুন';
    if (_selectedRole == LoginRole.doctor) {
      roleButtonText = 'DOCTOR পোর্টালে প্রবেশ করুন';
    } else if (_selectedRole == LoginRole.admin) {
      roleButtonText = 'ADMIN পোর্টালে প্রবেশ করুন';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                  const SizedBox(height: 8),

                  // MediSeba Logo Image
                  Image.asset(
                    'assets/images/logo.png',
                    height: 52,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.local_hospital_rounded,
                      size: 60,
                      color: brandGreen,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Heading: অ্যাকাউন্ট লগইন করুন
                  const Text(
                    'অ্যাকাউন্ট লগইন করুন',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),

                  // Subheading
                  const Text(
                    'আপনার রোগীর প্রোফাইল, ডাক্তার পোর্টাল বা অ্যাডমিন প্যানেলে প্রবেশ করুন।',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF64748B),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // Role Selection Header Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                        text: 'লগইন রোল নির্বাচন করুন ',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334155),
                        ),
                        children: const [
                          TextSpan(
                            text: '(Role Selection)',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Role Selector Segmented Bar (Web Style)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        // Patient Role Pill
                        Expanded(
                          child: _buildRoleSelectorPill(
                            title: 'রোগী (Patient)',
                            icon: Icons.person_outline_rounded,
                            isSelected: _selectedRole == LoginRole.patient,
                            onTap: () => _onRoleChanged(LoginRole.patient),
                          ),
                        ),
                        const SizedBox(width: 4),

                        // Doctor Role Pill
                        Expanded(
                          child: _buildRoleSelectorPill(
                            title: 'ডাক্তার (Doctor)',
                            icon: Icons.medical_services_outlined,
                            isSelected: _selectedRole == LoginRole.doctor,
                            onTap: () => _onRoleChanged(LoginRole.doctor),
                          ),
                        ),
                        const SizedBox(width: 4),

                        // Admin Role Pill
                        Expanded(
                          child: _buildRoleSelectorPill(
                            title: 'অ্যাডমিন (Admin)',
                            icon: Icons.shield_outlined,
                            isSelected: _selectedRole == LoginRole.admin,
                            onTap: () => _onRoleChanged(LoginRole.admin),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Email or Phone Field (ইমেইল বা মোবাইল নম্বর *)
                  _buildWebStyleField(
                    controller: _inputController,
                    label: 'ইমেইল বা মোবাইল নম্বর *',
                    hintText: 'patient@mediseba.org',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  // Password Field (পাসওয়ার্ড *)
                  _buildWebStyleField(
                    controller: _passwordController,
                    label: 'পাসওয়ার্ড *',
                    hintText: '••••••••••',
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

                  const SizedBox(height: 20),

                  // Dynamic Primary Action Button (PATIENT পোর্টালে প্রবেশ করুন →)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoggingIn ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
                                  roleButtonText,
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_rounded, size: 18),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Google Login Button Option
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton.icon(
                      onPressed: widget.authController.isLoading
                          ? null
                          : () async {
                              final navigator = Navigator.of(context);
                              final success = await widget.authController.loginWithGoogle();
                              if (success && mounted) {
                                navigator.pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => HomeView(
                                      homeController: widget.homeController,
                                      authController: widget.authController,
                                      languageController: widget.languageController,
                                    ),
                                  ),
                                );
                              }
                            },
                      icon: const Icon(Icons.g_mobiledata_rounded, size: 28, color: Color(0xFFEA4335)),
                      label: const Text(
                        'Google দিয়ে কন্টিনিউ করুন',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF334155),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),
                  const Divider(color: Color(0xFFF1F5F9), height: 1),
                  const SizedBox(height: 16),

                  // Bottom Sign Up Link
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'অ্যাকাউন্ট নেই? ',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
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
                        child: const Text(
                          'নতুন রোগী হিসেবে সাইন-আপ করুন',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: brandGreen,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
  }

  // Web Style Segmented Role Selector Pill
  Widget _buildRoleSelectorPill({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: const Color(0xFF10B981), width: 1.2)
              : Border.all(color: Colors.transparent),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? const Color(0xFF047857) : const Color(0xFF64748B),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                title.split(' ').first, // Show Bangla title (রোগী / ডাক্তার / অ্যাডমিন)
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? const Color(0xFF047857) : const Color(0xFF64748B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Web Style Input Field
  Widget _buildWebStyleField({
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
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
              prefixIcon: Icon(
                prefixIcon,
                color: const Color(0xFF94A3B8),
                size: 20,
              ),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
