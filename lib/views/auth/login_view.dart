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
  static const brandGreenDark = Color(0xFF059669);
  static const primaryBlue = Color(0xFF2563EB);
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

    if (_selectedRole == LoginRole.admin || _selectedRole == LoginRole.hbp || _selectedRole == LoginRole.supervisor) {
      String roleTitle = 'অ্যাডমিন';
      if (_selectedRole == LoginRole.hbp) roleTitle = 'HBP এজেন্ট';
      if (_selectedRole == LoginRole.supervisor) roleTitle = 'সুপারভাইজার';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 12,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD97706).withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.construction_rounded,
                      color: Color(0xFFD97706),
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'কাজটি ডেভেলপমেন্টে আছে (Step 7)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$roleTitle পোর্টালের এই সেকশনটি বর্তমানে ডেভেলপমেন্ট ফেজ Step 7-এ প্রস্তুত করা হচ্ছে। শীঘ্রই এটি ব্যবহারের জন্য উন্মুক্ত করা হবে।',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      height: 1.45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005C45),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'ঠিক আছে',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double containerWidth = constraints.maxWidth > 580 ? 560 : constraints.maxWidth;
                final bool isSmallScreen = constraints.maxWidth < 420;

                return SizedBox(
                  width: containerWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top Logo Image
                      Image.asset(
                        'assets/images/logo.png',
                        height: isSmallScreen ? 48 : 56,
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

                      const SizedBox(height: 6),

                      // Tagline under logo
                      Text(
                        '“সেবা নিন ঘরে বসে, সুস্থ থাকুন নির্বিঘ্নে”',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 11.5 : 12.5,
                          fontWeight: FontWeight.w700,
                          color: brandGreenDark,
                          letterSpacing: 0.1,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Main Heading Title
                      Text(
                        'MediSeba ডেডিকেটেড একাউন্ট লগইন',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : 21,
                          fontWeight: FontWeight.w900,
                          color: textDark,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 6),

                      // Subtitle Description
                      Text(
                        'আপনার নির্দিষ্ট পোটালে (রোগী, ডাক্তার, HBP, সুপারভাইজার বা এডমিন) প্রবেশ করুন।',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 13,
                          color: textMuted,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Section 1 Header
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '১. আপনার পোর্টাল ভূমিকা (Role) নির্বাচন করুন:',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: textDark,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Adaptive 5 Role Selector Pills Container
                      _buildAdaptiveRoleBar(isSmallScreen),

                      const SizedBox(height: 22),

                      // Adaptive Quick Auto-fill Credentials Box Card
                      _buildAdaptiveCredentialsCard(isSmallScreen),

                      const SizedBox(height: 22),

                      // Section 2 Header: ইমেইল বা মোবাইল নম্বর
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '২. ইমেইল বা মোবাইল নম্বর *',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: textDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Email Input Box (Rounded Pill Style)
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        child: TextField(
                          controller: _inputController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textDark,
                          ),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.mail_outline_rounded, color: primaryBlue, size: 20),
                            hintText: 'ইমেইল বা মোবাইল নম্বর প্রদান করুন',
                            hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Section 3 Header: পাসওয়ার্ড
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '৩. পাসওয়ার্ড *',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: textDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Password Input Box (Rounded Pill Style)
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textDark,
                            letterSpacing: 1.5,
                          ),
                          decoration: InputDecoration(
                            icon: const Icon(Icons.lock_outline_rounded, color: primaryBlue, size: 20),
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

                      const SizedBox(height: 26),

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
                            shadowColor: brandGreen.withValues(alpha: 0.4),
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
                                    Flexible(
                                      child: Text(
                                        '$roleNameUpper পোর্টালে ডাইরেক্ট লগইন করুন',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 13 : 14.5,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.2,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward_rounded, size: 20),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Light Horizontal Divider
                      const Divider(
                        color: Color(0xFFF1F5F9),
                        thickness: 1.2,
                      ),

                      const SizedBox(height: 14),

                      // Footer Row: Left Option (Back to Home) & Right Option (Sign Up)
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        runSpacing: 10,
                        children: [
                          // Left Option: ← হোমপেজে ফিরে যান
                          GestureDetector(
                            onTap: () {
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
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_back_rounded, size: 16, color: textMuted),
                                SizedBox(width: 4),
                                Text(
                                  'হোমপেজে ফিরে যান',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Right Option: অ্যাকাউন্ট নেই? সাইন-আপ করুন
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
                                text: 'অ্যাকাউন্ট নেই? ',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF334155),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'সাইন-আপ করুন',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: brandGreenDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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

  // Adaptive Role Selection Bar (Scrollable on small screens, expanded on wider screens)
  Widget _buildAdaptiveRoleBar(bool isSmallScreen) {
    final List<Map<String, dynamic>> roles = [
      {'role': LoginRole.patient, 'label': 'রোগী', 'icon': Icons.person_outline_rounded, 'color': const Color(0xFF2563EB)},
      {'role': LoginRole.doctor, 'label': 'ডাক্তার', 'icon': Icons.medical_services_outlined, 'color': const Color(0xFF2563EB)},
      {'role': LoginRole.hbp, 'label': 'HBP', 'icon': Icons.auto_awesome_rounded, 'color': const Color(0xFF0D9488)},
      {'role': LoginRole.supervisor, 'label': 'Sup.', 'icon': Icons.check_circle_outline_rounded, 'color': const Color(0xFF4F46E5)},
      {'role': LoginRole.admin, 'label': 'Admin', 'icon': Icons.shield_outlined, 'color': const Color(0xFFDC2626)},
    ];

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: roles.map((item) {
            final LoginRole role = item['role'];
            final String label = item['label'];
            final IconData icon = item['icon'];
            final Color activeColor = item['color'];
            final isSelected = _selectedRole == role;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: GestureDetector(
                onTap: () => _onRoleChanged(role),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected ? Border.all(color: activeColor, width: 1.6) : Border.all(color: Colors.transparent, width: 1.6),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: activeColor.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 16,
                        color: isSelected ? activeColor : textMuted,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? activeColor : textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Adaptive Quick Auto-fill Credentials Box Card
  Widget _buildAdaptiveCredentialsCard(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCCFBF1), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Wrap (Prevents text overflow on 320px screens)
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.vpn_key_outlined, size: 17, color: Color(0xFFD97706)),
                  SizedBox(width: 6),
                  Text(
                    'টেস্টিং ক্রেডেনশিয়াল (Auto-fill):',
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

          const SizedBox(height: 12),

          // Responsive Wrap for 5 Credential Cards (Adapts dynamically to mobile vs desktop)
          LayoutBuilder(
            builder: (context, cardConstraints) {
              final double availableWidth = cardConstraints.maxWidth;
              final int columns = availableWidth < 380 ? 2 : 3;
              final double cardWidth = (availableWidth - (columns - 1) * 8) / columns;

              final List<Map<String, dynamic>> items = [
                {'role': LoginRole.patient, 'title': 'রোগী (Patient)', 'email': 'patient@mediseba.org', 'dot': const Color(0xFF10B981)},
                {'role': LoginRole.doctor, 'title': 'ডাক্তার (Doctor)', 'email': 'doctor@mediseba.org', 'icon': Icons.medical_services_outlined, 'iconColor': const Color(0xFF4F46E5)},
                {'role': LoginRole.admin, 'title': 'অ্যাডমিন (Admin)', 'email': 'admin@mediseba.org', 'icon': Icons.workspace_premium_rounded, 'iconColor': const Color(0xFFD97706)},
                {'role': LoginRole.hbp, 'title': 'HBP এজেন্ট', 'email': 'rahim@mediseba.com', 'icon': Icons.auto_awesome_rounded, 'iconColor': const Color(0xFFD97706)},
                {'role': LoginRole.supervisor, 'title': 'সুপারভাইজার', 'email': 'tanvir@mediseba.com', 'icon': Icons.shield_rounded, 'iconColor': const Color(0xFF2563EB)},
              ];

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items.map((item) {
                  final LoginRole role = item['role'];
                  final String title = item['title'];
                  final String email = item['email'];
                  final Color? dotColor = item['dot'];
                  final IconData? icon = item['icon'];
                  final Color? iconColor = item['iconColor'];
                  final isSelected = _selectedRole == role;

                  return SizedBox(
                    width: cardWidth,
                    child: GestureDetector(
                      onTap: () => _onRoleChanged(role),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                            width: isSelected ? 1.8 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? const Color(0xFF2563EB).withValues(alpha: 0.12)
                                  : Colors.black.withValues(alpha: 0.03),
                              blurRadius: isSelected ? 8 : 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                if (dotColor != null)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: dotColor,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                else if (icon != null)
                                  Icon(icon, size: 14, color: iconColor ?? const Color(0xFF2563EB)),
                                if (dotColor != null || icon != null) const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 11 : 11.5,
                                      fontWeight: FontWeight.w800,
                                      color: textDark,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    size: 13,
                                    color: Color(0xFF2563EB),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              email,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 9.5 : 10,
                                color: isSelected ? const Color(0xFF1E293B) : textMuted,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
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
    );
  }
}
