import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/geo_models.dart';
import '../../repositories/geo_repository.dart';
import '../../widgets/searchable_dropdown.dart';
import '../../widgets/custom_app_bar.dart';

class EditProfileView extends StatefulWidget {
  final AuthController authController;

  const EditProfileView({
    super.key,
    required this.authController,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final GeoRepository _geoRepository = GeoRepository();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _referIdController;

  bool _isPhoneLocked = false;
  bool _isReferIdLocked = false;
  bool _isGoogleUser = false;

  // Address state
  List<GeoDivision> _divisions = [];
  List<GeoDistrict> _districts = [];
  List<GeoUpazila> _upazilas = [];
  List<GeoUnion> _unions = [];

  GeoDivision? _selectedDivision;
  GeoDistrict? _selectedDistrict;
  GeoUpazila? _selectedUpazila;
  GeoUnion? _selectedUnion;

  bool _isLoadingDivisions = false;
  bool _isLoadingDistricts = false;
  bool _isLoadingUpazilas = false;
  bool _isLoadingUnions = false;

  String? _divisionError;
  String? _districtError;
  String? _upazilaError;
  String? _unionError;

  static const brandGreen = Color(0xFF008536);
  static const textDark = Color(0xFF1E293B);
  static const textMuted = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    final user = widget.authController.currentUser;
    final userData = widget.authController.currentUserData;

    final email = user?.email ?? '';
    _isGoogleUser = email.isNotEmpty && !email.endsWith('@mediseba.com');

    String phone = userData?.phone ?? '';
    if (phone.contains('@')) phone = ''; // Reset dummy phone if any

    // Determine if phone is locked (if user already has a valid saved phone)
    final bool hasValidPhone = phone.isNotEmpty &&
        (RegExp(r'^01[3-9]\d{8}$').hasMatch(phone.replaceAll(RegExp(r'\s+'), '')) || phone.length >= 10);
    _isPhoneLocked = hasValidPhone || !_isGoogleUser;

    final String existingReferId = userData?.referId ?? '';
    _isReferIdLocked = existingReferId.trim().isNotEmpty;

    _nameController = TextEditingController(text: userData?.name ?? user?.displayName ?? '');
    _phoneController = TextEditingController(text: hasValidPhone ? phone : '');
    _emailController = TextEditingController(text: _isGoogleUser ? email : '');
    _referIdController = TextEditingController(text: existingReferId);

    _fetchDivisions(initialDivisionName: userData?.division,
                    initialDistrictName: userData?.district,
                    initialUpazilaName: userData?.upazila,
                    initialUnionName: userData?.union);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _referIdController.dispose();
    super.dispose();
  }

  Future<void> _fetchDivisions({
    String? initialDivisionName,
    String? initialDistrictName,
    String? initialUpazilaName,
    String? initialUnionName,
  }) async {
    setState(() {
      _isLoadingDivisions = true;
      _divisionError = null;
    });

    try {
      final divisions = await _geoRepository.getDivisions();
      setState(() {
        _divisions = divisions;
        _isLoadingDivisions = false;

        if (initialDivisionName != null && initialDivisionName.isNotEmpty) {
          try {
            _selectedDivision = divisions.firstWhere(
              (d) => d.name.toLowerCase() == initialDivisionName.toLowerCase() ||
                     d.bnName == initialDivisionName,
            );
            _fetchDistricts(_selectedDivision!.id,
                initialDistrictName: initialDistrictName,
                initialUpazilaName: initialUpazilaName,
                initialUnionName: initialUnionName);
          } catch (_) {}
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingDivisions = false;
        _divisionError = 'Failed to load divisions. Tap to retry.';
      });
    }
  }

  Future<void> _fetchDistricts(int divisionId, {
    String? initialDistrictName,
    String? initialUpazilaName,
    String? initialUnionName,
  }) async {
    setState(() {
      _isLoadingDistricts = true;
      _districtError = null;
      _districts = [];
      _upazilas = [];
      _unions = [];
      if (initialDistrictName == null) {
        _selectedDistrict = null;
        _selectedUpazila = null;
        _selectedUnion = null;
      }
    });

    try {
      final districts = await _geoRepository.getDistricts(divisionId);
      setState(() {
        _districts = districts;
        _isLoadingDistricts = false;

        if (initialDistrictName != null && initialDistrictName.isNotEmpty) {
          try {
            _selectedDistrict = districts.firstWhere(
              (d) => d.name.toLowerCase() == initialDistrictName.toLowerCase() ||
                     d.bnName == initialDistrictName,
            );
            _fetchUpazilas(_selectedDistrict!.id,
                initialUpazilaName: initialUpazilaName,
                initialUnionName: initialUnionName);
          } catch (_) {}
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingDistricts = false;
        _districtError = 'Failed to load districts. Tap to retry.';
      });
    }
  }

  Future<void> _fetchUpazilas(int districtId, {
    String? initialUpazilaName,
    String? initialUnionName,
  }) async {
    setState(() {
      _isLoadingUpazilas = true;
      _upazilaError = null;
      _upazilas = [];
      _unions = [];
      if (initialUpazilaName == null) {
        _selectedUpazila = null;
        _selectedUnion = null;
      }
    });

    try {
      final upazilas = await _geoRepository.getUpazilas(districtId);
      setState(() {
        _upazilas = upazilas;
        _isLoadingUpazilas = false;

        if (initialUpazilaName != null && initialUpazilaName.isNotEmpty) {
          try {
            _selectedUpazila = upazilas.firstWhere(
              (u) => u.name.toLowerCase() == initialUpazilaName.toLowerCase() ||
                     u.bnName == initialUpazilaName,
            );
            _fetchUnions(_selectedUpazila!.id, initialUnionName: initialUnionName);
          } catch (_) {}
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingUpazilas = false;
        _upazilaError = 'Failed to load upazilas. Tap to retry.';
      });
    }
  }

  Future<void> _fetchUnions(int upazilaId, {String? initialUnionName}) async {
    setState(() {
      _isLoadingUnions = true;
      _unionError = null;
      _unions = [];
      if (initialUnionName == null) {
        _selectedUnion = null;
      }
    });

    try {
      final unions = await _geoRepository.getUnions(upazilaId);
      setState(() {
        _unions = unions;
        _isLoadingUnions = false;

        if (initialUnionName != null && initialUnionName.isNotEmpty) {
          try {
            _selectedUnion = unions.firstWhere(
              (u) => u.name.toLowerCase() == initialUnionName.toLowerCase() ||
                     u.bnName == initialUnionName,
            );
          } catch (_) {}
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingUnions = false;
        _unionError = 'Failed to load unions. Tap to retry.';
      });
    }
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final String name = _nameController.text.trim();
    final String phone = _phoneController.text.trim();
    final String division = _selectedDivision?.name ?? widget.authController.currentUserData?.division ?? '';
    final String district = _selectedDistrict?.name ?? widget.authController.currentUserData?.district ?? '';
    final String upazila = _selectedUpazila?.name ?? widget.authController.currentUserData?.upazila ?? '';
    final String union = _selectedUnion?.name ?? widget.authController.currentUserData?.union ?? '';
    final String referId = _isReferIdLocked
        ? (widget.authController.currentUserData?.referId ?? '')
        : _referIdController.text.trim();

    final success = await widget.authController.updateProfileDetails(
      name: name,
      phone: phone,
      division: division,
      district: district,
      upazila: upazila,
      union: union,
      referId: referId,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('প্রোফাইল তথ্য সফলভাবে আপডেট হয়েছে! 🎉'),
          backgroundColor: brandGreen,
        ),
      );
      Navigator.pop(context);
    } else if (mounted && widget.authController.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.authController.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'প্রোফাইল সম্পাদনা',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Title: Basic Info
                const Text(
                  'মূল তথ্য',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textMuted,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 16),

                // Name
                _buildInputField(
                  controller: _nameController,
                  label: 'পূর্ণ নাম *',
                  hintText: 'আপনার পূর্ণ নাম লিখুন',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'অনুগ্রহ করে আপনার নাম দিন';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email (If Google user, show & disabled)
                if (_isGoogleUser) ...[
                  _buildInputField(
                    controller: _emailController,
                    label: 'জিিমেইল ঠিকানা',
                    hintText: 'আপনার রেজিস্টার্ড জিমেইল',
                    prefixIcon: Icons.email_outlined,
                    isReadOnly: true,
                    suffixIcon: const Icon(Icons.lock_outline_rounded, color: textMuted, size: 20),
                    helperText: 'জিমেইল ঠিকানাটি পরিবর্তনযোগ্য নয়।',
                  ),
                  const SizedBox(height: 16),
                ],

                // Mobile Number (Locked if phone registered, Editable if Google user without phone)
                _buildInputField(
                  controller: _phoneController,
                  label: 'মোবাইল নম্বর',
                  hintText: _isPhoneLocked ? 'রেজিস্টার্ড ফোন নম্বর' : '১১ ডিজিটের ফোন নম্বর দিন',
                  prefixIcon: Icons.phone_android_outlined,
                  isReadOnly: _isPhoneLocked,
                  keyboardType: TextInputType.phone,
                  suffixIcon: _isPhoneLocked
                      ? const Icon(Icons.lock_outline_rounded, color: textMuted, size: 20)
                      : null,
                  helperText: _isPhoneLocked
                      ? 'মোবাইল নম্বর পরিবর্তন করা সম্ভব নয়।'
                      : 'প্রোফাইল ১০০% সম্পন্ন করতে ফোন নম্বর যোগ করুন।',
                  validator: (val) {
                    if (!_isPhoneLocked) {
                      if (val == null || val.trim().isEmpty) {
                        return 'অনুগ্রহ করে ফোন নম্বরটি দিন';
                      }
                      final clean = val.trim().replaceAll(RegExp(r'\s+'), '');
                      if (!RegExp(r'^01[3-9]\d{8}$').hasMatch(clean)) {
                        return 'সঠিক ১১ ডিজিটের মোবাইল নম্বর দিন';
                      }
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 28),

                // Section Title: Address
                const Text(
                  'ঠিকানা সংক্রান্ত তথ্য',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textMuted,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 16),

                // Division
                SearchableDropdown<GeoDivision>(
                  label: 'বিভাগ নির্বাচন করুন',
                  hintText: 'আপনার বিভাগ নির্বাচন করুন',
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

                // District
                SearchableDropdown<GeoDistrict>(
                  label: 'জেলা নির্বাচন করুন',
                  hintText: 'আপনার জেলা নির্বাচন করুন',
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

                // Upazila
                SearchableDropdown<GeoUpazila>(
                  label: 'উপজেলা নির্বাচন করুন',
                  hintText: 'আপনার উপজেলা নির্বাচন করুন',
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

                // Union
                SearchableDropdown<GeoUnion>(
                  label: 'ইউনিয়ন নির্বাচন করুন',
                  hintText: 'আপনার ইউনিয়ন নির্বাচন করুন',
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

                const SizedBox(height: 28),

                // Refer ID
                _buildInputField(
                  controller: _referIdController,
                  label: 'রেফারেল আইডি (ঐচ্ছিক)',
                  hintText: _isReferIdLocked ? 'রেজিস্টার্ড রেফারেল আইডি' : 'যেমন: REF12345',
                  prefixIcon: Icons.card_giftcard_outlined,
                  isReadOnly: _isReferIdLocked,
                  suffixIcon: _isReferIdLocked
                      ? const Icon(Icons.lock_outline_rounded, color: textMuted, size: 20)
                      : null,
                  helperText: _isReferIdLocked
                      ? 'রেফারেল আইডি একবার প্রদান করা হলে তা পরিবর্তনযোগ্য নয়।'
                      : null,
                ),

                const SizedBox(height: 36),

                // Save Button
                ListenableBuilder(
                  listenable: widget.authController,
                  builder: (context, _) {
                    final isLoading = widget.authController.isLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                              )
                            : const Text(
                                'সংরক্ষণ করুন',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    bool isReadOnly = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? helperText,
    String? Function(String?)? validator,
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
        TextFormField(
          controller: controller,
          readOnly: isReadOnly,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isReadOnly ? textMuted : textDark,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
            prefixIcon: Icon(prefixIcon, color: isReadOnly ? textMuted : brandGreen, size: 22),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: isReadOnly ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: brandGreen, width: 1.5),
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            helperText,
            style: TextStyle(
              fontSize: 12,
              color: isReadOnly ? textMuted : brandGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
