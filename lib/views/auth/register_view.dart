import 'package:flutter/material.dart';
import 'login_view.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../repositories/geo_repository.dart';
import '../../models/geo_models.dart';
import '../../widgets/searchable_dropdown.dart';

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
  final TextEditingController _referIdController = TextEditingController();
  
  final GeoRepository _geoRepo = GeoRepository();

  // Selected Values
  GeoDivision? _selectedDivision;
  GeoDistrict? _selectedDistrict;
  GeoUpazila? _selectedUpazila;
  GeoUnion? _selectedUnion;

  // Data Lists
  List<GeoDivision> _divisions = [];
  List<GeoDistrict> _districts = [];
  List<GeoUpazila> _upazilas = [];
  List<GeoUnion> _unions = [];

  // Loading States
  bool _isLoadingDivisions = false;
  bool _isLoadingDistricts = false;
  bool _isLoadingUpazilas = false;
  bool _isLoadingUnions = false;

  // Error States
  String? _divisionError;
  String? _districtError;
  String? _upazilaError;
  String? _unionError;
  
  bool _isPasswordVisible = false;
  bool _isSigningUp = false;

  @override
  void initState() {
    super.initState();
    _fetchDivisions();
  }

  Future<void> _fetchDivisions() async {
    setState(() {
      _isLoadingDivisions = true;
      _divisionError = null;
    });
    try {
      final divs = await _geoRepo.getDivisions();
      setState(() => _divisions = divs);
    } catch (e) {
      setState(() => _divisionError = e.toString());
    } finally {
      setState(() => _isLoadingDivisions = false);
    }
  }

  Future<void> _fetchDistricts(int divisionId) async {
    setState(() {
      _isLoadingDistricts = true;
      _districtError = null;
      _districts = [];
      _selectedDistrict = null;
      _upazilas = [];
      _selectedUpazila = null;
      _unions = [];
      _selectedUnion = null;
    });
    try {
      final dists = await _geoRepo.getDistricts(divisionId);
      setState(() => _districts = dists);
    } catch (e) {
      setState(() => _districtError = e.toString());
    } finally {
      setState(() => _isLoadingDistricts = false);
    }
  }

  Future<void> _fetchUpazilas(int districtId) async {
    setState(() {
      _isLoadingUpazilas = true;
      _upazilaError = null;
      _upazilas = [];
      _selectedUpazila = null;
      _unions = [];
      _selectedUnion = null;
    });
    try {
      final upazilas = await _geoRepo.getUpazilas(districtId);
      setState(() => _upazilas = upazilas);
    } catch (e) {
      setState(() => _upazilaError = e.toString());
    } finally {
      setState(() => _isLoadingUpazilas = false);
    }
  }

  Future<void> _fetchUnions(int upazilaId) async {
    setState(() {
      _isLoadingUnions = true;
      _unionError = null;
      _unions = [];
      _selectedUnion = null;
    });
    try {
      final unions = await _geoRepo.getUnions(upazilaId);
      setState(() => _unions = unions);
    } catch (e) {
      setState(() => _unionError = e.toString());
    } finally {
      setState(() => _isLoadingUnions = false);
    }
  }
  
  void _handleSignUp() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final referId = _referIdController.text.trim();
    
    if (name.isEmpty || phone.isEmpty || password.isEmpty || 
        _selectedDivision == null || _selectedDistrict == null || 
        _selectedUpazila == null || _selectedUnion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the required fields')),
      );
      return;
    }
    
    setState(() {
      _isSigningUp = true;
    });
    
    final success = await widget.authController.signUp(
      name: name,
      phone: phone,
      password: password,
      division: _selectedDivision!.name,
      district: _selectedDistrict!.name,
      upazila: _selectedUpazila!.name,
      union: _selectedUnion!.name,
      referId: referId.isEmpty ? null : referId,
    );
    
    if (mounted) {
      setState(() {
        _isSigningUp = false;
      });
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please login.'),
            backgroundColor: brandGreen,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginView(
              homeController: widget.homeController,
              authController: widget.authController,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.authController.errorMessage ?? 'Signup failed'),
            backgroundColor: brandRed,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
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
                  'Welcome to MediSeba!',
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
                  'Sign Up To MediSeba',
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

                SearchableDropdown<GeoDivision>(
                  label: 'Select Division',
                  hintText: 'Select your division',
                  prefixIcon: Icons.map_outlined,
                  items: _divisions,
                  selectedValue: _selectedDivision,
                  itemAsString: (div) => div.name,
                  isLoading: _isLoadingDivisions,
                  errorMessage: _divisionError,
                  onRetry: _fetchDivisions,
                  onChanged: (val) {
                    setState(() {
                      _selectedDivision = val;
                      _fetchDistricts(val.id);
                    });
                  },
                ),
                const SizedBox(height: 16),

                SearchableDropdown<GeoDistrict>(
                  label: 'Select District',
                  hintText: 'Select your district',
                  prefixIcon: Icons.location_city_outlined,
                  items: _districts,
                  selectedValue: _selectedDistrict,
                  itemAsString: (dist) => dist.name,
                  isEnabled: _selectedDivision != null,
                  isLoading: _isLoadingDistricts,
                  errorMessage: _districtError,
                  onRetry: () {
                    if (_selectedDivision != null) _fetchDistricts(_selectedDivision!.id);
                  },
                  onChanged: (val) {
                    setState(() {
                      _selectedDistrict = val;
                      _fetchUpazilas(val.id);
                    });
                  },
                ),
                const SizedBox(height: 16),

                SearchableDropdown<GeoUpazila>(
                  label: 'Select Upazila',
                  hintText: 'Select your upazila',
                  prefixIcon: Icons.location_on_outlined,
                  items: _upazilas,
                  selectedValue: _selectedUpazila,
                  itemAsString: (upz) => upz.name,
                  isEnabled: _selectedDistrict != null,
                  isLoading: _isLoadingUpazilas,
                  errorMessage: _upazilaError,
                  onRetry: () {
                    if (_selectedDistrict != null) _fetchUpazilas(_selectedDistrict!.id);
                  },
                  onChanged: (val) {
                    setState(() {
                      _selectedUpazila = val;
                      _fetchUnions(val.id);
                    });
                  },
                ),
                const SizedBox(height: 16),

                SearchableDropdown<GeoUnion>(
                  label: 'Select Union/Area',
                  hintText: 'Select your union or area',
                  prefixIcon: Icons.home_outlined,
                  items: _unions,
                  selectedValue: _selectedUnion,
                  itemAsString: (un) => un.name,
                  isEnabled: _selectedUpazila != null,
                  isLoading: _isLoadingUnions,
                  errorMessage: _unionError,
                  onRetry: () {
                    if (_selectedUpazila != null) _fetchUnions(_selectedUpazila!.id);
                  },
                  onChanged: (val) {
                    setState(() {
                      _selectedUnion = val;
                    });
                  },
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
                    onPressed: _isSigningUp ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandGreen,
                      disabledBackgroundColor: brandGreen.withValues(alpha: 0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isSigningUp
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                        )
                      : const Text(
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
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(prefixIcon, color: Colors.grey.shade400, size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: brandGreen, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
