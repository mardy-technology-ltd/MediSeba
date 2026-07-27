import 'package:flutter/material.dart';
import 'login_view.dart';
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
  static const brandGreen = Color(0xFF0F9D58);
  static const brandRed = Color(0xFFE53935);
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _birthYearController = TextEditingController();
  final TextEditingController _referIdController = TextEditingController();
  
  bool _isPasswordVisible = false;
  String? _selectedDivision;
  String? _selectedDistrict;
  String? _selectedThana;

  final List<String> _divisions = ['Dhaka', 'Chittagong', 'Rajshahi', 'Khulna', 'Barishal', 'Sylhet', 'Rangpur', 'Mymensingh'];
  final List<String> _districts = ['Dhaka', 'Faridpur', 'Gazipur', 'Gopalganj', 'Kishoreganj'];
  final List<String> _thanas = ['Mirpur', 'Dhanmondi', 'Gulshan', 'Uttara', 'Mohammadpur'];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _villageController.dispose();
    _birthYearController.dispose();
    _referIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Color(0xFF64748B),
                size: 28,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  height: 80,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.local_hospital_rounded,
                    size: 60,
                    color: brandRed,
                  ),
                ),
                const SizedBox(height: 16),
                // Welcome Text
                const Text(
                  'Welcome to MediSheba App!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Get your health update on a single click',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Sign Up To MediSheba',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: brandGreen,
                  ),
                ),
                const SizedBox(height: 32),

                // Form Fields
                _buildTextField(
                  controller: _nameController,
                  label: 'User Name',
                  hintText: 'Enter your full name',
                  prefixIcon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _phoneController,
                  label: 'Contact number',
                  hintText: 'Enter your phone number',
                  prefixIcon: Icons.phone_android_rounded,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: const Color(0xFF94A3B8),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

                _buildDropdown(
                  label: 'Select Division',
                  hintText: 'Select your division',
                  value: _selectedDivision,
                  items: _divisions,
                  onChanged: (val) => setState(() => _selectedDivision = val),
                  prefixIcon: Icons.map_outlined,
                ),
                const SizedBox(height: 16),

                _buildDropdown(
                  label: 'Select District',
                  hintText: 'Select your district',
                  value: _selectedDistrict,
                  items: _districts,
                  onChanged: (val) => setState(() => _selectedDistrict = val),
                  prefixIcon: Icons.location_city_outlined,
                ),
                const SizedBox(height: 16),

                _buildDropdown(
                  label: 'Select Thana',
                  hintText: 'Select your thana',
                  value: _selectedThana,
                  items: _thanas,
                  onChanged: (val) => setState(() => _selectedThana = val),
                  prefixIcon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _villageController,
                  label: 'Village or Area',
                  hintText: 'Enter your village or area',
                  prefixIcon: Icons.home_outlined,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _birthYearController,
                  label: 'Birth Year',
                  hintText: 'e.g. 1995',
                  prefixIcon: Icons.calendar_today_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _referIdController,
                  label: 'Refer ID',
                  hintText: 'Enter refer ID (optional)',
                  prefixIcon: Icons.group_add_outlined,
                ),
                const SizedBox(height: 40),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Implementation logic goes here later
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
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
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: brandGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
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
            fontWeight: 
            FontWeight.w700,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 8),
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
              fontSize: 15,
              color: Color(0xFF1E293B),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 14,
              ),
              prefixIcon: Icon(
                prefixIcon,
                color: const Color(0xFF94A3B8),
                size: 22,
              ),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hintText,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                prefixIcon,
                color: const Color(0xFF94A3B8),
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    hint: Text(
                      hintText,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                    ),
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF94A3B8)),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1E293B),
                    ),
                    onChanged: onChanged,
                    items: items.map<DropdownMenuItem<String>>((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
