import 'package:flutter/material.dart';
import 'register_view.dart';
import '../home/home_view.dart';
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
  static const brandGreenDark = Color(0xFF059669);
  static const primaryBlue = Color(0xFF2563EB);
  static const textDark = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);

  LoginRole _selectedRole = LoginRole.patient;

  final TextEditingController _inputController = TextEditingController(text: 'patient@mediseba.org');
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
        case LoginRole.areaMgr:
          _inputController.text = 'areamanager@mediseba.com';
          break;
        case LoginRole.marketingMgr:
          _inputController.text = 'marketing@mediseba.com';
          break;
        case LoginRole.headOfSales:
          _inputController.text = 'headsales@mediseba.com';
          break;
        case LoginRole.salesDirector:
          _inputController.text = 'director@mediseba.com';
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

    if (_selectedRole != LoginRole.patient && _selectedRole != LoginRole.doctor) {
      String roleTitle = 'এডমিন';
      if (_selectedRole == LoginRole.hbp) roleTitle = 'HBP Field';
      if (_selectedRole == LoginRole.supervisor) roleTitle = 'Supervisor';
      if (_selectedRole == LoginRole.areaMgr) roleTitle = 'Area Manager';
      if (_selectedRole == LoginRole.marketingMgr) roleTitle = 'Marketing Manager';
      if (_selectedRole == LoginRole.headOfSales) roleTitle = 'Head of Sales';
      if (_selectedRole == LoginRole.salesDirector) roleTitle = 'Sales Director';
      if (_selectedRole == LoginRole.admin) roleTitle = 'System Admin';

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
    String roleNameUpper = 'PATIENT';
    switch (_selectedRole) {
      case LoginRole.patient:
        roleNameUpper = 'PATIENT';
        break;
      case LoginRole.doctor:
        roleNameUpper = 'DOCTOR';
        break;
      case LoginRole.hbp:
        roleNameUpper = 'HBP FIELD';
        break;
      case LoginRole.supervisor:
        roleNameUpper = 'SUPERVISOR';
        break;
      case LoginRole.areaMgr:
        roleNameUpper = 'AREA MGR';
        break;
      case LoginRole.marketingMgr:
        roleNameUpper = 'MARKETING MGR';
        break;
      case LoginRole.headOfSales:
        roleNameUpper = 'HEAD OF SALES';
        break;
      case LoginRole.salesDirector:
        roleNameUpper = 'SALES DIRECTOR';
        break;
      case LoginRole.admin:
        roleNameUpper = 'SYSTEM ADMIN';
        break;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double containerWidth = constraints.maxWidth > 580 ? 560 : constraints.maxWidth;
                final bool isSmallScreen = constraints.maxWidth < 420;

                return Container(
                  width: containerWidth,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 14.0 : 24.0,
                    vertical: isSmallScreen ? 18.0 : 26.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top Logo Image
                      Image.asset(
                        'assets/images/logo.png',
                        height: isSmallScreen ? 44 : 54,
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
                          fontSize: isSmallScreen ? 11 : 12.5,
                          fontWeight: FontWeight.w700,
                          color: brandGreenDark,
                          letterSpacing: 0.1,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Main Heading Title
                      Text(
                        'MediSeba ডেডিকেটেড একাউন্ট লগইন',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 17.5 : 21,
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
                          fontSize: isSmallScreen ? 11.5 : 13,
                          color: textMuted,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      // Adaptive Quick Auto-fill Credentials Card (Integrated 9 Roles Grid)
                      _buildAdaptiveCredentialsCard(isSmallScreen),

                      const SizedBox(height: 20),

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
                            icon: Icon(Icons.mail_outline_rounded, color: textMuted, size: 20),
                            hintText: 'ইমেইল বা মোবাইল নম্বর প্রদান করুন',
                            hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

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
                            icon: const Icon(Icons.lock_outline_rounded, color: textMuted, size: 20),
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

                      const SizedBox(height: 24),

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
                                          fontSize: isSmallScreen ? 12.5 : 14.5,
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

                      const SizedBox(height: 20),

                      // Light Horizontal Divider
                      const Divider(
                        color: Color(0xFFF1F5F9),
                        thickness: 1.2,
                      ),

                      const SizedBox(height: 12),

                      // Footer Row: Left Option (Back to Home) & Right Option (Sign Up)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Icon(Icons.arrow_back_rounded, size: 15, color: textMuted),
                                SizedBox(width: 4),
                                Text(
                                  'হোমপেজে ফিরে যান',
                                  style: TextStyle(
                                    fontSize: 12.5,
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
                                  fontSize: 12.5,
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

  // Adaptive Quick Auto-fill Credentials Box Card (Integrated 9 Roles Grid)
  Widget _buildAdaptiveCredentialsCard(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Expanded text to prevent overflow
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.vpn_key_outlined, size: 16, color: Color(0xFF00A859)),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'আপনার অ্যাকাউন্ট রোল বা ভূমিকা সিলেক্ট করুন (১-ক্লিকে ফিল):',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '১-ক্লিক অটো ফিল',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Responsive Wrap for 9 Credential Cards
          LayoutBuilder(
            builder: (context, cardConstraints) {
              final double availableWidth = cardConstraints.maxWidth;
              // On mobile (< 460px), 2 columns; on desktop/tablet (>= 460px), 3 columns
              final int columns = availableWidth < 460 ? 2 : 3;
              final double cardWidth = (availableWidth - (columns - 1) * 8) / columns;

              final List<Map<String, dynamic>> items = [
                {'role': LoginRole.patient, 'title': 'Patient', 'email': 'patient@mediseba.org', 'dot': const Color(0xFF10B981)},
                {'role': LoginRole.doctor, 'title': 'Doctor', 'email': 'doctor@mediseba.org', 'icon': Icons.medical_services_outlined, 'iconColor': const Color(0xFF2563EB)},
                {'role': LoginRole.hbp, 'title': 'HBP Field', 'email': 'rahim@mediseba.com', 'icon': Icons.build_outlined, 'iconColor': const Color(0xFFD97706)},
                {'role': LoginRole.supervisor, 'title': 'Supervisor', 'email': 'tanvir@mediseba.com', 'icon': Icons.shield_outlined, 'iconColor': const Color(0xFF2563EB)},
                {'role': LoginRole.areaMgr, 'title': 'Area Mgr', 'email': 'areamanager@mediseba.com', 'icon': Icons.business_outlined, 'iconColor': const Color(0xFF64748B)},
                {'role': LoginRole.marketingMgr, 'title': 'Marketing Mgr', 'email': 'marketing@mediseba.com', 'icon': Icons.edit_note_rounded, 'iconColor': const Color(0xFF64748B)},
                {'role': LoginRole.headOfSales, 'title': 'Head of Sales', 'email': 'headsales@mediseba.com', 'icon': Icons.bar_chart_rounded, 'iconColor': const Color(0xFF2563EB)},
                {'role': LoginRole.salesDirector, 'title': 'Sales Director', 'email': 'director@mediseba.com', 'icon': Icons.account_balance_outlined, 'iconColor': const Color(0xFF64748B)},
                {'role': LoginRole.admin, 'title': 'System Admin', 'email': 'admin@mediseba.org', 'icon': Icons.workspace_premium_rounded, 'iconColor': const Color(0xFFD97706)},
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFF0FDFA) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? brandGreen : const Color(0xFFE2E8F0),
                            width: isSelected ? 1.8 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? brandGreen.withValues(alpha: 0.12)
                                  : Colors.black.withValues(alpha: 0.02),
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
                                  Icon(icon, size: 13, color: isSelected ? brandGreen : (iconColor ?? primaryBlue)),
                                if (dotColor != null || icon != null) const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 10.5 : 11.5,
                                      fontWeight: FontWeight.w800,
                                      color: textDark,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle_outlined,
                                    size: 13,
                                    color: brandGreen,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              email,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 9 : 9.8,
                                color: isSelected ? const Color(0xFF0F172A) : textMuted,
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

          const SizedBox(height: 10),

          // Default Password Footnote
          const Center(
            child: Text.rich(
              TextSpan(
                text: 'ডিফল্ট পাসওয়ার্ড: ',
                style: TextStyle(fontSize: 11.5, color: textMuted),
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
