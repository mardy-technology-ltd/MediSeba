import 'package:flutter/material.dart';
import 'register_view.dart';
import '../home/home_view.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/language_controller.dart';

enum LoginRole { patient, doctor, hbp, supervisor, admin }

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

  LoginRole _selectedRole = LoginRole.doctor;

  final TextEditingController _inputController = TextEditingController(text: 'doctor@mediseba.org');
  final TextEditingController _passwordController = TextEditingController(text: 'password123');
  bool _isPasswordVisible = false;
  bool _isLoggingIn = false;

  void _onRoleChanged(LoginRole role) {
    setState(() {
      _selectedRole = role;
      _passwordController.text = 'password123';
      switch (role) {
        case LoginRole.patient:
          _inputController.text = 'patient@mediseba.org';
          break;
        case LoginRole.doctor:
          _inputController.text = 'doctor@mediseba.org';
          break;
        case LoginRole.hbp:
          _inputController.text = 'rahim@mediseba.com';
          break;
        case LoginRole.supervisor:
          _inputController.text = 'tanvir@mediseba.com';
          break;
        case LoginRole.admin:
          _inputController.text = 'admin@mediseba.org';
          break;
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

    if (_selectedRole == LoginRole.admin || _selectedRole == LoginRole.hbp || _selectedRole == LoginRole.supervisor) {
      String roleTitle = 'অ্যাডমিন';
      if (_selectedRole == LoginRole.hbp) roleTitle = 'HBP এজেন্ট';
      if (_selectedRole == LoginRole.supervisor) roleTitle = 'সুপারভাইজার';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 10,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEF3C7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.construction_rounded,
                      color: Color(0xFFD97706),
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'কাজটি ডেভেলপমেন্টে আছে (Step 7)',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$roleTitle পোর্টালের এই সেকশনটি বর্তমানে ডেভেলপমেন্ট ফেজ Step 7-এ প্রস্তুত করা হচ্ছে। শীঘ্রই এটি ব্যবহারের জন্য উন্মুক্ত করা হবে।',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF64748B),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005C45),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'ঠিক আছে',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
      return;
    }

    _proceedNormalLogin();
  }

  void _proceedNormalLogin() async {
    setState(() {
      _isLoggingIn = true;
    });

    await widget.authController.login(_inputController.text.trim(), _passwordController.text);

    if (mounted) {
      setState(() {
        _isLoggingIn = false;
      });

      Navigator.push(
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

  @override
  void dispose() {
    _inputController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String roleNameUpper = 'DOCTOR';
    switch (_selectedRole) {
      case LoginRole.patient:
        roleNameUpper = 'PATIENT';
        break;
      case LoginRole.doctor:
        roleNameUpper = 'DOCTOR';
        break;
      case LoginRole.hbp:
        roleNameUpper = 'HBP';
        break;
      case LoginRole.supervisor:
        roleNameUpper = 'SUPERVISOR';
        break;
      case LoginRole.admin:
        roleNameUpper = 'ADMIN';
        break;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Logo Image
                  Image.asset(
                    'assets/images/logo.png',
                    height: 54,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_hospital_rounded, size: 36, color: brandGreen),
                        SizedBox(width: 8),
                        Text(
                          'মেডিসেবা',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFED1C24),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Tagline under logo
                  Text(
                    '“সেবা নিন ঘরে বসে, সুস্থ থাকুন নির্বিঘ্নে”',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: brandGreen.withValues(alpha: 0.9),
                      letterSpacing: 0.2,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Main Heading Title
                  const Text(
                    'MediSeba ডেডিকেটেড একাউন্ট লগইন',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: textDark,
                      letterSpacing: -0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Subtitle Description
                  const Text(
                    'আপনার নির্দিষ্ট পোটালে (রোগী, ডাক্তার, HBP, সুপারভাইজার বা এডমিন) প্রবেশ করুন।',
                    style: TextStyle(
                      fontSize: 13,
                      color: textMuted,
                      height: 1.35,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 28),

                  // Section 1 Header: ১. আপনার পোর্টাল ভূমিকা (Role) নির্বাচন করুন:
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '১. আপনার পোর্টাল ভূমিকা (Role) নির্বাচন করুন:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 5 Role Selector Pills Container
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildRolePill(
                            role: LoginRole.patient,
                            label: 'রোগী',
                            icon: Icons.person_outline_rounded,
                            activeColor: const Color(0xFF2563EB),
                          ),
                        ),
                        Expanded(
                          child: _buildRolePill(
                            role: LoginRole.doctor,
                            label: 'ডাক্তার',
                            icon: Icons.medical_services_outlined,
                            activeColor: const Color(0xFF2563EB),
                          ),
                        ),
                        Expanded(
                          child: _buildRolePill(
                            role: LoginRole.hbp,
                            label: 'HBP',
                            icon: Icons.auto_awesome_rounded,
                            activeColor: const Color(0xFF0D9488),
                          ),
                        ),
                        Expanded(
                          child: _buildRolePill(
                            role: LoginRole.supervisor,
                            label: 'Sup.',
                            icon: Icons.check_circle_outline_rounded,
                            activeColor: const Color(0xFF4F46E5),
                          ),
                        ),
                        Expanded(
                          child: _buildRolePill(
                            role: LoginRole.admin,
                            label: 'Admin',
                            icon: Icons.shield_outlined,
                            activeColor: const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Quick Auto-fill Credentials Box Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDFA),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFCCFBF1), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Box Header Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.vpn_key_outlined, size: 18, color: Color(0xFFD97706)),
                                SizedBox(width: 6),
                                Text(
                                  'টেস্টিং ক্রেডেনশিয়াল (Quick Auto-fill Credentials):',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                    color: textDark,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD1FAE5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '১-ক্লিকে পূরণ',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF059669),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Row 1: Patient, Doctor, Admin (3 Columns)
                        Row(
                          children: [
                            Expanded(
                              child: _buildCredentialCard(
                                role: LoginRole.patient,
                                title: 'রোগী (Patient)',
                                email: 'patient@mediseba.org',
                                dotColor: const Color(0xFF10B981),
                                icon: null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildCredentialCard(
                                role: LoginRole.doctor,
                                title: 'ডাক্তার (Doctor)',
                                email: 'doctor@mediseba.org',
                                dotColor: null,
                                icon: Icons.medical_services_outlined,
                                iconColor: const Color(0xFF4F46E5),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildCredentialCard(
                                role: LoginRole.admin,
                                title: 'অ্যাডমিন (Admin)',
                                email: 'admin@mediseba.org',
                                dotColor: null,
                                icon: Icons.workspace_premium_rounded,
                                iconColor: const Color(0xFFD97706),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Row 2: HBP Agent, Supervisor (2 Columns)
                        Row(
                          children: [
                            Expanded(
                              child: _buildCredentialCard(
                                role: LoginRole.hbp,
                                title: 'HBP এজেন্ট',
                                email: 'rahim@mediseba.com',
                                dotColor: null,
                                icon: Icons.auto_awesome_rounded,
                                iconColor: const Color(0xFFD97706),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildCredentialCard(
                                role: LoginRole.supervisor,
                                title: 'সুপারভাইজার',
                                email: 'tanvir@mediseba.com',
                                dotColor: null,
                                icon: Icons.shield_rounded,
                                iconColor: const Color(0xFF2563EB),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(child: SizedBox()), // Placeholder for grid alignment
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Default Password Footnote
                        const Center(
                          child: Text.rich(
                            TextSpan(
                              text: 'ডিফল্ট পাসওয়ার্ড: ',
                              style: TextStyle(fontSize: 12, color: textMuted),
                              children: [
                                TextSpan(
                                  text: 'password123',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Section 2 Header: ২. ইমেইল বা মোবাইল নম্বর *
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '২. ইমেইল বা মোবাইল নম্বর *',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Email Input Box (Rounded Pill Style)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: TextField(
                      controller: _inputController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.mail_outline_rounded, color: textMuted, size: 22),
                        hintText: 'ইমেইল বা মোবাইল নম্বর প্রদান করুন',
                        hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Section 3 Header: ৩. পাসওয়ার্ড *
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '৩. পাসওয়ার্ড *',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Password Input Box (Rounded Pill Style)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                        letterSpacing: 2,
                      ),
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock_outline_rounded, color: textMuted, size: 22),
                        hintText: '••••••••••',
                        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8), letterSpacing: 0),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: textMuted,
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
                  ),

                  const SizedBox(height: 28),

                  // Submit Direct Login Button (Full Green Pill Button)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoggingIn ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandGreen,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: brandGreen.withValues(alpha: 0.35),
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
                              children: [
                                const Icon(Icons.login_rounded, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  '$roleNameUpper পোর্টালে ডাইরেক্ট লগইন করুন',
                                  style: const TextStyle(
                                    fontSize: 14.5,
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

                  const SizedBox(height: 24),

                  // Sign Up Link Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "একাউন্ট নেই? ",
                        style: TextStyle(
                          fontSize: 14,
                          color: textMuted,
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
                          "নতুন অ্যাকাউন্ট তৈরি করুন",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: brandGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget Builder for Role Selector Segmented Pill
  Widget _buildRolePill({
    required LoginRole role,
    required String label,
    required IconData icon,
    required Color activeColor,
  }) {
    final isSelected = _selectedRole == role;

    return GestureDetector(
      onTap: () => _onRoleChanged(role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: activeColor.withValues(alpha: 0.6), width: 1.5) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.12),
                    blurRadius: 8,
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
              size: 16,
              color: isSelected ? activeColor : textMuted,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? activeColor : textMuted,
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

  // Widget Builder for Quick Auto-fill Credential Card
  Widget _buildCredentialCard({
    required LoginRole role,
    required String title,
    required String email,
    Color? dotColor,
    IconData? icon,
    Color? iconColor,
  }) {
    final isSelected = _selectedRole == role;

    return GestureDetector(
      onTap: () => _onRoleChanged(role),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (dotColor != null)
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  )
                else if (icon != null)
                  Icon(icon, size: 14, color: iconColor ?? const Color(0xFF2563EB)),
                if (dotColor != null || icon != null) const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              email,
              style: const TextStyle(
                fontSize: 10,
                color: textMuted,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
