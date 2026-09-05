import 'package:flutter/material.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/custom_app_bar.dart';
import 'blood_request_success_view.dart';

class DonateBloodView extends StatefulWidget {
  final LanguageController? languageController;

  const DonateBloodView({super.key, this.languageController});

  @override
  State<DonateBloodView> createState() => _DonateBloodViewState();
}

class _DonateBloodViewState extends State<DonateBloodView> {
  late final LanguageController _langController;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedDivision;
  String? _selectedDistrict;
  String? _selectedBloodGroup;
  String? _selectedGender;

  DateTime? _lastDonationDate;
  bool _isDonateBloodActive = true;

  final List<String> _divisionsBn = [
    'ঢাকা',
    'চট্টগ্রাম',
    'রাজশাহী',
    'খুলনা',
    'বরিশাল',
    'সিলেট',
    'রংপুর',
    'ময়মনসিংহ',
  ];

  final List<String> _divisionsEn = [
    'Dhaka',
    'Chittagong',
    'Rajshahi',
    'Khulna',
    'Barisal',
    'Sylhet',
    'Rangpur',
    'Mymensingh',
  ];

  final Map<String, List<String>> _divisionDistrictsMapBn = const {
    'ঢাকা': [
      'ঢাকা',
      'গাজীপুর',
      'নারায়ণগঞ্জ',
      'টাঙ্গাইল',
      'ফরিদপুর',
      'মানিকগঞ্জ',
      'মুন্সীগঞ্জ',
      'নরসিংদী',
      'মাদারীপুর',
      'শরীয়তপুর',
      'রাজবাড়ী',
      'গোপালগঞ্জ',
      'কিশোরগঞ্জ',
    ],
    'চট্টগ্রাম': [
      'চট্টগ্রাম',
      'কক্সবাজার',
      'কুমিল্লা',
      'ফেনী',
      'ব্রাহ্মণবাড়িয়া',
      'নোয়াখালী',
      'চাঁদপুর',
      'লক্ষ্মীপুর',
      'রাঙ্গামাটি',
      'বান্দরবান',
      'খাগড়াছড়ি',
    ],
    'রাজশাহী': [
      'রাজশাহী',
      'বগুড়া',
      'পাবনা',
      'সিরাজগঞ্জ',
      'নাটোর',
      'নওগাঁ',
      'চাঁপাইনবাবগঞ্জ',
      'জয়পুরহাট',
    ],
    'খুলনা': [
      'খুলনা',
      'যশোর',
      'কুষ্টিয়া',
      'সাতক্ষীরা',
      'ঝিনাইদহ',
      'বাগেরহাট',
      'চুয়াডাঙ্গা',
      'মেহেরপুর',
      'নড়াইল',
      'মাগুরা',
    ],
    'বরিশাল': [
      'বরিশাল',
      'পটুয়াখালী',
      'ভোলা',
      'পিরোজপুর',
      'বরগুনা',
      'ঝালকাঠি',
    ],
    'সিলেট': [
      'সিলেট',
      'মৌলভীবাজার',
      'হবিগঞ্জ',
      'সুনামগঞ্জ',
    ],
    'রংপুর': [
      'রংপুর',
      'দিনাজপুর',
      'গাইবান্ধা',
      'কুড়িগ্রাম',
      'নীলফামারী',
      'পঞ্চগড়',
      'ঠাকুরগাঁও',
      'লালমনিরহাট',
    ],
    'ময়মনসিংহ': [
      'ময়মনসিংহ',
      'জামালপুর',
      'শেরপুর',
      'নেত্রকোণা',
    ],
  };

  final Map<String, List<String>> _divisionDistrictsMapEn = const {
    'Dhaka': [
      'Dhaka',
      'Gazipur',
      'Narayanganj',
      'Tangail',
      'Faridpur',
      'Manikganj',
      'Munshiganj',
      'Narsingdi',
      'Madaripur',
      'Shariatpur',
      'Rajbari',
      'Gopalgonj',
      'Kishoreganj',
    ],
    'Chittagong': [
      'Chittagong',
      'Cox\'s Bazar',
      'Comilla',
      'Feni',
      'Brahmanbaria',
      'Noakhali',
      'Chandpur',
      'Lakshmipur',
      'Rangamati',
      'Bandarban',
      'Khagrachhari',
    ],
    'Rajshahi': [
      'Rajshahi',
      'Bogra',
      'Pabna',
      'Sirajganj',
      'Natore',
      'Naogaon',
      'Chapainawabganj',
      'Joypurhat',
    ],
    'Khulna': [
      'Khulna',
      'Jessore',
      'Kushtia',
      'Satkhira',
      'Jhenaidah',
      'Bagerhat',
      'Chuadanga',
      'Meherpur',
      'Narail',
      'Magura',
    ],
    'Barisal': [
      'Barisal',
      'Patuakhali',
      'Bhola',
      'Pirojpur',
      'Barguna',
      'Jhalokati',
    ],
    'Sylhet': [
      'Sylhet',
      'Moulvibazar',
      'Habiganj',
      'Sunamganj',
    ],
    'Rangpur': [
      'Rangpur',
      'Dinajpur',
      'Gaibandha',
      'Kurigram',
      'Nilphamari',
      'Panchagarh',
      'Thakurgaon',
      'Lalmonirhat',
    ],
    'Mymensingh': [
      'Mymensingh',
      'Jamalpur',
      'Sherpur',
      'Netrokona',
    ],
  };

  final List<String> _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'
  ];

  final List<String> _gendersBn = [
    'পুরুষ',
    'নারী',
    'অন্যান্য',
  ];

  final List<String> _gendersEn = [
    'Male',
    'Female',
    'Other',
  ];

  List<String> get _availableDistricts {
    if (_selectedDivision == null) return [];
    return _divisionDistrictsMapBn[_selectedDivision] ??
        _divisionDistrictsMapEn[_selectedDivision] ??
        [];
  }

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = _langController.isBangla;

    final divisionsList = isBangla ? _divisionsBn : _divisionsEn;
    final gendersList = isBangla ? _gendersBn : _gendersEn;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        title: isBangla ? 'রক্ত দিতে চাই' : 'Donate Blood',
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Hero Header Banner Card
                  _buildHeroHeaderCard(isBangla),

                  const SizedBox(height: 16),

                  // 2. Form Container Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full Name
                        _buildLabel(
                          icon: Icons.person_outline_rounded,
                          label: isBangla ? 'আপনার পূর্ণ নাম' : 'Full Name',
                        ),
                        _buildTextField(
                          controller: _nameController,
                          hint: isBangla ? 'যেমন: মোঃ আরিফ হোসেন' : 'Enter Full Name',
                          icon: Icons.person_outline_rounded,
                        ),

                        const SizedBox(height: 16),

                        // Division & District Responsive Layout
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isNarrow = constraints.maxWidth < 360;

                            final divisionWidget = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel(
                                  icon: Icons.map_outlined,
                                  label: isBangla ? 'বিভাগ' : 'Division',
                                ),
                                _buildDropdownField(
                                  value: _selectedDivision,
                                  hint: isBangla ? 'বিভাগ নির্বাচন' : 'Select Division',
                                  items: divisionsList,
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedDivision = val;
                                      _selectedDistrict = null; // Reset district when division changes
                                    });
                                  },
                                ),
                              ],
                            );

                            final districtWidget = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel(
                                  icon: Icons.location_city_outlined,
                                  label: isBangla ? 'জেলা' : 'District',
                                ),
                                _buildDropdownField(
                                  value: _selectedDistrict,
                                  hint: _selectedDivision == null
                                      ? (isBangla ? 'আগে বিভাগ নির্বাচন করুন' : 'Select Division First')
                                      : (isBangla ? 'জেলা নির্বাচন' : 'Select District'),
                                  items: _availableDistricts,
                                  onChanged: _selectedDivision == null
                                      ? null
                                      : (val) => setState(() => _selectedDistrict = val),
                                ),
                              ],
                            );

                            if (isNarrow) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  divisionWidget,
                                  const SizedBox(height: 16),
                                  districtWidget,
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Expanded(child: divisionWidget),
                                const SizedBox(width: 12),
                                Expanded(child: districtWidget),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        // Contact Number
                        _buildLabel(
                          icon: Icons.phone_outlined,
                          label: isBangla ? 'যোগাযোগের নম্বর' : 'Contact Number',
                        ),
                        _buildTextField(
                          controller: _contactController,
                          hint: '017XXXXXXXX',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: 16),

                        // Address / Present Location
                        _buildLabel(
                          icon: Icons.location_on_outlined,
                          label: isBangla ? 'ঠিকানা / বর্তমান অবস্থান' : 'Address',
                        ),
                        _buildTextField(
                          controller: _addressController,
                          hint: isBangla ? 'যেমন: বাসা ১০, রোড ৫, উত্তরা, ঢাকা' : 'Enter Address / Present Location',
                          icon: Icons.location_on_outlined,
                        ),

                        const SizedBox(height: 16),

                        // Blood Group Selector Chips
                        _buildLabel(
                          icon: Icons.water_drop_outlined,
                          label: isBangla ? 'রক্তের গ্রুপ' : 'Blood Group',
                        ),
                        _buildBloodGroupChips(),

                        const SizedBox(height: 16),

                        // Gender Selector
                        _buildLabel(
                          icon: Icons.wc_outlined,
                          label: isBangla ? 'লিঙ্গ' : 'Gender',
                        ),
                        _buildDropdownField(
                          value: _selectedGender,
                          hint: isBangla ? 'লিঙ্গ নির্বাচন করুন' : 'Select Gender',
                          items: gendersList,
                          onChanged: (val) => setState(() => _selectedGender = val),
                        ),

                        const SizedBox(height: 16),

                        // Last Blood Donation Date
                        _buildLabel(
                          icon: Icons.calendar_month_outlined,
                          label: isBangla ? 'সর্বশেষ রক্তদানের তারিখ' : 'Last Donation Date',
                        ),
                        _buildDateField(isBangla),

                        const SizedBox(height: 18),

                        // Donate Blood Availability Switch
                        _buildSwitchRow(isBangla),

                        const SizedBox(height: 24),

                        // Submit Registration Button
                        _buildSubmitButton(isBangla),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Hero Banner Header Card
  Widget _buildHeroHeaderCard(bool isBangla) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE11D48), Color(0xFFBE123C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE11D48).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBangla ? 'রক্তদান মহৎ দান ❤️' : 'Blood Donation Saves Lives ❤️',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isBangla
                      ? 'আপনার রক্তদানে বাঁচতে পারে একটি নতুন জীবন। রক্তদাতা হিসেবে নিজের সঠিক তথ্য দিন।'
                      : 'Your blood donation can save a life. Register your donor details accurately.',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFFFFE4E6),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel({required IconData icon, required String label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFFE11D48)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodGroupChips() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 340;
        final horizontalPadding = isSmallScreen ? 10.0 : 14.0;
        final fontSize = isSmallScreen ? 12.0 : 13.0;

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _bloodGroups.map((group) {
            final isSelected = _selectedBloodGroup == group;
            return InkWell(
              onTap: () => setState(() => _selectedBloodGroup = group),
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE11D48) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFE11D48) : const Color(0xFFE2E8F0),
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFE11D48).withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  group,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                    color: isSelected ? Colors.white : const Color(0xFF334155),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    final isDisabled = onChanged == null || items.isEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: isDisabled ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : null,
          hint: Text(
            hint,
            style: TextStyle(
              color: isDisabled ? const Color(0xFFCBD5E1) : const Color(0xFF94A3B8),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isDisabled ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13.5, color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDateField(bool isBangla) {
    final dateStr = _lastDonationDate != null
        ? '${_lastDonationDate!.day.toString().padLeft(2, '0')}/${_lastDonationDate!.month.toString().padLeft(2, '0')}/${_lastDonationDate!.year}'
        : (isBangla ? 'তারিখ নির্বাচন করুন' : 'Select Date');

    return InkWell(
      onTap: _selectLastDonationDate,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateStr,
              style: TextStyle(
                fontSize: 13,
                fontWeight: _lastDonationDate != null ? FontWeight.bold : FontWeight.w500,
                color: _lastDonationDate != null ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
              ),
            ),
            const Icon(Icons.calendar_today_rounded, color: Color(0xFFE11D48), size: 18),
          ],
        ),
      ),
    );
  }

  Future<void> _selectLastDonationDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 90)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE11D48),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _lastDonationDate = picked);
    }
  }

  Widget _buildSwitchRow(bool isBangla) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _isDonateBloodActive ? const Color(0xFFFFF1F2) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isDonateBloodActive ? const Color(0xFFFECDD3) : const Color(0xFFE2E8F0),
          width: 1.1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBangla ? 'রক্তদানে সদা প্রস্তুত?' : 'Available to Donate Blood?',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  _isDonateBloodActive
                      ? (isBangla ? 'হ্যাঁ, রক্ত দেওয়ার জন্য প্রস্তুত আছি' : 'Yes, ready for blood donation')
                      : (isBangla ? 'না, সাময়িকভাবে প্রস্তুত নই' : 'Currently unavailable'),
                  style: TextStyle(
                    fontSize: 11,
                    color: _isDonateBloodActive ? const Color(0xFFE11D48) : const Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isDonateBloodActive,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFFE11D48),
            onChanged: (val) => setState(() => _isDonateBloodActive = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(bool isBangla) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE11D48),
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: const Color(0xFFE11D48).withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: _handleSubmit,
        icon: const Icon(Icons.volunteer_activism_rounded, size: 18),
        label: Text(
          isBangla ? 'রক্তদাতা হিসেবে নিবন্ধন করুন' : 'Submit Registration',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    showBloodRequestSuccessDialog(context);
  }
}
