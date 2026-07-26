import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../home/home_view.dart';

class RegisterView extends StatefulWidget {
  final AuthController authController;
  final HomeController homeController;

  const RegisterView({
    super.key,
    required this.authController,
    required this.homeController,
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  final _userNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _villageController = TextEditingController();
  final _birthYearController = TextEditingController();
  final _referIdController = TextEditingController();

  String? _selectedDivision;
  String? _selectedDistrict;
  String? _selectedThana;

  final List<String> _divisions = [
    'Dhaka',
    'Chattogram',
    'Rajshahi',
    'Khulna',
    'Barishal',
    'Sylhet',
    'Rangpur',
    'Mymensingh',
  ];

  final Map<String, List<String>> _districts = {
    'Dhaka': ['Dhaka', 'Gazipur', 'Narayanganj', 'Tangail'],
    'Chattogram': ['Chattogram', 'Cox\'s Bazar', 'Cumilla', 'Noakhali'],
    'Rajshahi': ['Rajshahi', 'Bogra', 'Pabna'],
    'Khulna': ['Khulna', 'Jashore', 'Kushtia'],
    'Barishal': ['Barishal', 'Bhola', 'Patuakhali'],
    'Sylhet': ['Sylhet', 'Moulvibazar', 'Habiganj'],
    'Rangpur': ['Rangpur', 'Dinajpur', 'Bogura'],
    'Mymensingh': ['Mymensingh', 'Jamalpur', 'Netrokona'],
  };

  final Map<String, List<String>> _thanas = {
    'Dhaka': ['Dhanmondi', 'Gulshan', 'Mirpur', 'Uttara', 'Mohammadpur'],
    'Gazipur': ['Sadar', 'Tongii', 'Kaliakair'],
    'Chattogram': ['Kotwali', 'Panchlaish', 'Halishahar'],
    'Rajshahi': ['Boalia', 'Rajpara', 'Motihar'],
  };

  @override
  void dispose() {
    _userNameController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _villageController.dispose();
    _birthYearController.dispose();
    _referIdController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      final success = await widget.authController.login(
        _contactController.text,
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => HomeView(
              homeController: widget.homeController,
              authController: widget.authController,
            ),
          ),
          (route) => false,
        );
      }
    }
  }

  Widget _buildLabel(String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        labelText,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF4A4A4A),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String? hint) {
    const brandGreen = Color(0xFF009245);
    const inputBg = Color(0xFFF7F8FA);

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFA0A0A0)),
      filled: true,
      fillColor: inputBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: brandGreen, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const brandGreen = Color(0xFF009245);
    const textDark = Color(0xFF333333);
    const textMuted = Color(0xFF666666);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Section
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 65,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Welcome to MediSheba App!',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Get your health update on a single click',
                        style: TextStyle(fontSize: 12.5, color: textMuted),
                      ),
                      const SizedBox(height: 18),

                      // Sign Up Heading
                      const Text(
                        'Sign Up To MediSheba',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: brandGreen,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // 1. User Name
                _buildLabel('User Name'),
                TextFormField(
                  controller: _userNameController,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter user name' : null,
                  decoration: _inputDecoration(null),
                ),
                const SizedBox(height: 16),

                // 2. Contact number
                _buildLabel('Contact number'),
                TextFormField(
                  controller: _contactController,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter contact number' : null,
                  decoration: _inputDecoration(null),
                ),
                const SizedBox(height: 16),

                // 3. Password
                _buildLabel('Password'),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter password' : null,
                  decoration: _inputDecoration(null),
                ),
                const SizedBox(height: 16),

                // 4. Select Division
                _buildLabel('Select Division'),
                DropdownButtonFormField<String>(
                  initialValue: _selectedDivision,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7A869A)),
                  decoration: _inputDecoration(null),
                  items: _divisions.map((div) {
                    return DropdownMenuItem(
                      value: div,
                      child: Text(div, style: const TextStyle(fontSize: 14, color: textDark)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedDivision = val;
                      _selectedDistrict = null;
                      _selectedThana = null;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // 5. Select District
                _buildLabel('Select District'),
                DropdownButtonFormField<String>(
                  initialValue: _selectedDistrict,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7A869A)),
                  decoration: _inputDecoration(null),
                  items: (_selectedDivision != null && _districts.containsKey(_selectedDivision))
                      ? _districts[_selectedDivision]!.map((dist) {
                          return DropdownMenuItem(
                            value: dist,
                            child: Text(dist, style: const TextStyle(fontSize: 14, color: textDark)),
                          );
                        }).toList()
                      : [],
                  onChanged: (val) {
                    setState(() {
                      _selectedDistrict = val;
                      _selectedThana = null;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // 6. Select Thana
                _buildLabel('Select Thana'),
                DropdownButtonFormField<String>(
                  initialValue: _selectedThana,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7A869A)),
                  decoration: _inputDecoration(null),
                  items: (_selectedDistrict != null && _thanas.containsKey(_selectedDistrict))
                      ? _thanas[_selectedDistrict]!.map((thana) {
                          return DropdownMenuItem(
                            value: thana,
                            child: Text(thana, style: const TextStyle(fontSize: 14, color: textDark)),
                          );
                        }).toList()
                      : [],
                  onChanged: (val) {
                    setState(() => _selectedThana = val);
                  },
                ),
                const SizedBox(height: 16),

                // 7. Village or Area
                _buildLabel('Village or Area'),
                TextFormField(
                  controller: _villageController,
                  decoration: _inputDecoration(null),
                ),
                const SizedBox(height: 16),

                // 8. Birth Year
                _buildLabel('Birth Year'),
                TextFormField(
                  controller: _birthYearController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(null),
                ),
                const SizedBox(height: 16),

                // 9. Refer ID
                _buildLabel('Refer ID'),
                TextFormField(
                  controller: _referIdController,
                  decoration: _inputDecoration(null),
                ),

                const SizedBox(height: 28),

                // Sign Up Button
                ListenableBuilder(
                  listenable: widget.authController,
                  builder: (context, child) {
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandGreen,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: widget.authController.isLoading ? null : _handleSignUp,
                        child: widget.authController.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Bottom Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF888888),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
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
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
