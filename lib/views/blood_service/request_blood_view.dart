import 'package:flutter/material.dart';
import '../../models/geo_models.dart';
import '../../repositories/geo_repository.dart';
import '../../widgets/custom_app_bar.dart';
import 'blood_request_success_view.dart';

class RequestBloodView extends StatefulWidget {
  const RequestBloodView({super.key});

  @override
  State<RequestBloodView> createState() => _RequestBloodViewState();
}

class _RequestBloodViewState extends State<RequestBloodView> {
  static const Color brandRed = Color(0xFFE11D48);
  static const Color brandRedDark = Color(0xFFBE123C);
  static const Color bgCanvas = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
  static const Color inputBg = Color(0xFFF8FAFC);
  static const Color inputBorder = Color(0xFFE2E8F0);

  final GeoRepository _geoRepository = GeoRepository();

  List<GeoDivision> _divisions = [];
  List<GeoDistrict> _districts = [];
  List<GeoUpazila> _thanas = [];

  GeoDivision? _selectedDivision;
  GeoDistrict? _selectedDistrict;
  GeoUpazila? _selectedThana;
  String? _selectedBloodGroup;

  bool _isLoadingDivisions = false;
  bool _isLoadingDistricts = false;
  bool _isLoadingThanas = false;

  String? _divisionError;
  String? _districtError;
  String? _thanaError;

  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  late DateTime _selectedDate;
  late DateTime _currentMonth;
  late TimeOfDay _selectedTime;

  bool _isEmergency = false;
  bool _isExchange = false;

  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _currentMonth = DateTime(now.year, now.month, 1);
    _selectedTime = TimeOfDay.fromDateTime(now);

    _fetchDivisions();
  }

  Future<void> _fetchDivisions() async {
    setState(() {
      _isLoadingDivisions = true;
      _divisionError = null;
    });

    try {
      final divisions = await _geoRepository.getDivisions();
      if (mounted) {
        setState(() {
          _divisions = divisions;
          _isLoadingDivisions = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingDivisions = false;
          _divisionError = 'বিভাগ লোড করা যায়নি। ক্লিক করে পুনরায় চেষ্টা করুন।';
        });
      }
    }
  }

  Future<void> _fetchDistricts(int divisionId) async {
    setState(() {
      _isLoadingDistricts = true;
      _districtError = null;
      _districts = [];
      _thanas = [];
      _selectedDistrict = null;
      _selectedThana = null;
    });

    try {
      final districts = await _geoRepository.getDistricts(divisionId);
      if (mounted) {
        setState(() {
          _districts = districts;
          _isLoadingDistricts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingDistricts = false;
          _districtError = 'জেলা লোড করা যায়নি। ক্লিক করে পুনরায় চেষ্টা করুন।';
        });
      }
    }
  }

  Future<void> _fetchThanas(int districtId) async {
    setState(() {
      _isLoadingThanas = true;
      _thanaError = null;
      _thanas = [];
      _selectedThana = null;
    });

    try {
      final thanas = await _geoRepository.getUpazilas(districtId);
      if (mounted) {
        setState(() {
          _thanas = thanas;
          _isLoadingThanas = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingThanas = false;
          _thanaError = 'থানা/উপজেলা লোড করা যায়নি। ক্লিক করে পুনরায় চেষ্টা করুন।';
        });
      }
    }
  }

  @override
  void dispose() {
    _contactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: const CustomAppBar(
        title: 'রক্ত চাই',
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notice / Info Card
              _buildInfoBanner(),
              const SizedBox(height: 16),

              // Form Section Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title: Location
                    _buildSectionHeader(
                      icon: Icons.location_on_rounded,
                      title: 'লোকেশন নির্বাচন (Location)',
                    ),
                    const SizedBox(height: 12),

                    // Select Division
                    _buildLabel('Select Division'),
                    _buildDivisionDropdown(),

                    // Select District
                    _buildLabel('Select District'),
                    _buildDistrictDropdown(),

                    // Select Thana
                    _buildLabel('Select Thana'),
                    _buildThanaDropdown(),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(color: Color(0xFFF1F5F9), height: 1),
                    ),

                    // Section Title: Contact
                    _buildSectionHeader(
                      icon: Icons.contact_phone_rounded,
                      title: 'যোগাযোগ ও ঠিকানা (Contact Details)',
                    ),
                    const SizedBox(height: 12),

                    // Contact Number
                    _buildLabel('Contact Number'),
                    _buildTextField(
                      controller: _contactController,
                      hint: 'Enter Contact Number',
                      icon: Icons.phone_android_rounded,
                      keyboardType: TextInputType.phone,
                    ),

                    // Address
                    _buildLabel('Address'),
                    _buildTextField(
                      controller: _addressController,
                      hint: 'Enter Full Address / Hospital Name',
                      icon: Icons.local_hospital_outlined,
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(color: Color(0xFFF1F5F9), height: 1),
                    ),

                    // Section Title: Blood Group
                    _buildSectionHeader(
                      icon: Icons.water_drop_rounded,
                      title: 'রক্তের গ্রুপ (Blood Group)',
                    ),
                    const SizedBox(height: 12),

                    // Blood Group Quick Selector Chips
                    _buildBloodGroupChips(),
                    const SizedBox(height: 10),

                    // Explicit Dropdown
                    _buildBloodGroupDropdown(),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(color: Color(0xFFF1F5F9), height: 1),
                    ),

                    // Section Title: Schedule
                    _buildSectionHeader(
                      icon: Icons.event_available_rounded,
                      title: 'প্রয়োজনের তারিখ ও সময় (Date & Time)',
                    ),
                    const SizedBox(height: 12),

                    // Select Date Calendar
                    _buildLabel('Select Date'),
                    _buildCalendarCard(),

                    // Time Selection
                    _buildLabel('Time'),
                    _buildTimePicker(),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(color: Color(0xFFF1F5F9), height: 1),
                    ),

                    // Section Title: Priority Options
                    _buildSectionHeader(
                      icon: Icons.tune_rounded,
                      title: 'জরুরি অপশন (Priority Settings)',
                    ),
                    const SizedBox(height: 10),

                    // Emergency Switch
                    _buildSwitchRow(
                      label: 'Emergency Requirement',
                      sublabel: 'জরুরি রক্তের প্রয়োজন হলে অন করুন',
                      icon: Icons.warning_amber_rounded,
                      value: _isEmergency,
                      onChanged: (val) => setState(() => _isEmergency = val),
                    ),

                    // Exchange Switch
                    _buildSwitchRow(
                      label: 'Exchange Available',
                      sublabel: 'ব্লাড এক্সচেঞ্জে রক্তদাতাকে দিতে রাজি',
                      icon: Icons.published_with_changes_rounded,
                      value: _isExchange,
                      onChanged: (val) => setState(() => _isExchange = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Submit Button
              _buildSubmitButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFF1F2),
            Color(0xFFFFE4E6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFECDD3), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: brandRed.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bloodtype_rounded,
              color: brandRed,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'জরুরি রক্তের আবেদন ফর্ম',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: brandRedDark,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'ফর্মটি সঠিক তথ্যে পূরণ করুন। আপনার অনুরোধটি নিকটস্থ ভেরিফাইড রক্তদাতাদের নিকট পৌঁছে দেওয়া হবে।',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF475569),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, color: brandRed, size: 19),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, top: 10.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textMuted,
        ),
      ),
    );
  }

  Widget _buildDivisionDropdown() {
    if (_isLoadingDivisions) {
      return _buildLoadingDropdown('বিভাগ লোড হচ্ছে...');
    }
    if (_divisionError != null) {
      return _buildErrorDropdown(_divisionError!, _fetchDivisions);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedDivision != null ? brandRed.withValues(alpha: 0.5) : inputBorder,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.map_outlined, color: _selectedDivision != null ? brandRed : const Color(0xFF94A3B8), size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<GeoDivision>(
                value: _selectedDivision,
                hint: const Text('Select Division', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5)),
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF94A3B8)),
                items: _divisions.map((GeoDivision d) {
                  final name = d.bnName.isNotEmpty ? d.bnName : d.name;
                  return DropdownMenuItem<GeoDivision>(
                    value: d,
                    child: Text(name, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500, color: textDark)),
                  );
                }).toList(),
                onChanged: (GeoDivision? val) {
                  if (val != null) {
                    setState(() {
                      _selectedDivision = val;
                    });
                    _fetchDistricts(val.id);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistrictDropdown() {
    if (_selectedDivision == null) {
      return _buildDisabledDropdown('প্রথমে বিভাগ নির্বাচন করুন');
    }
    if (_isLoadingDistricts) {
      return _buildLoadingDropdown('জেলা লোড হচ্ছে...');
    }
    if (_districtError != null) {
      return _buildErrorDropdown(_districtError!, () => _fetchDistricts(_selectedDivision!.id));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedDistrict != null ? brandRed.withValues(alpha: 0.5) : inputBorder,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.location_city_outlined, color: _selectedDistrict != null ? brandRed : const Color(0xFF94A3B8), size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<GeoDistrict>(
                value: _selectedDistrict,
                hint: const Text('Select District', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5)),
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF94A3B8)),
                items: _districts.map((GeoDistrict d) {
                  final name = d.bnName.isNotEmpty ? d.bnName : d.name;
                  return DropdownMenuItem<GeoDistrict>(
                    value: d,
                    child: Text(name, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500, color: textDark)),
                  );
                }).toList(),
                onChanged: (GeoDistrict? val) {
                  if (val != null) {
                    setState(() {
                      _selectedDistrict = val;
                    });
                    _fetchThanas(val.id);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThanaDropdown() {
    if (_selectedDistrict == null) {
      return _buildDisabledDropdown('প্রথমে জেলা নির্বাচন করুন');
    }
    if (_isLoadingThanas) {
      return _buildLoadingDropdown('থানা/উপজেলা লোড হচ্ছে...');
    }
    if (_thanaError != null) {
      return _buildErrorDropdown(_thanaError!, () => _fetchThanas(_selectedDistrict!.id));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedThana != null ? brandRed.withValues(alpha: 0.5) : inputBorder,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.my_location_rounded, color: _selectedThana != null ? brandRed : const Color(0xFF94A3B8), size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<GeoUpazila>(
                value: _selectedThana,
                hint: const Text('Select Thana', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5)),
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF94A3B8)),
                items: _thanas.map((GeoUpazila t) {
                  final name = t.bnName.isNotEmpty ? t.bnName : t.name;
                  return DropdownMenuItem<GeoUpazila>(
                    value: t,
                    child: Text(name, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500, color: textDark)),
                  );
                }).toList(),
                onChanged: (GeoUpazila? val) {
                  if (val != null) {
                    setState(() {
                      _selectedThana = val;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingDropdown(String text) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: inputBorder, width: 1.2),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: brandRed),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 13.5, color: textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledDropdown(String hint) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: inputBorder, width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline_rounded, color: Color(0xFFCBD5E1), size: 18),
          const SizedBox(width: 8),
          Text(
            hint,
            style: const TextStyle(fontSize: 13.5, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorDropdown(String message, VoidCallback onRetry) {
    return GestureDetector(
      onTap: onRetry,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFECDD3), width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: brandRed, size: 18),
                const SizedBox(width: 8),
                Text(
                  message,
                  style: const TextStyle(fontSize: 12.5, color: brandRedDark, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Icon(Icons.refresh_rounded, color: brandRed, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildBloodGroupDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedBloodGroup != null ? brandRed.withValues(alpha: 0.5) : inputBorder,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.bloodtype_outlined, color: _selectedBloodGroup != null ? brandRed : const Color(0xFF94A3B8), size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBloodGroup,
                hint: const Text('Select Blood Group', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5)),
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF94A3B8)),
                items: _bloodGroups.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500, color: textDark)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedBloodGroup = val),
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: inputBorder, width: 1.2),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF94A3B8), size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500, color: textDark),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodGroupChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _bloodGroups.map((group) {
          final isSelected = _selectedBloodGroup == group;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedBloodGroup = group;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? brandRed : const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? brandRed : const Color(0xFFFECDD3),
                    width: 1.2,
                  ),
                ),
                child: Text(
                  group,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : brandRedDark,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarCard() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final monthName = monthNames[_currentMonth.month - 1];
    final daysInMonth = DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final firstDayOffset = (DateTime(_currentMonth.year, _currentMonth.month, 1).weekday - 1) % 7;

    final isPrevMonthDisabled = _currentMonth.year < now.year ||
        (_currentMonth.year == now.year && _currentMonth.month <= now.month);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: inputBorder, width: 1.2),
      ),
      child: Column(
        children: [
          // Month Navigation Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: isPrevMonthDisabled ? const Color(0xFFCBD5E1) : brandRed,
                  size: 24,
                ),
                onPressed: isPrevMonthDisabled
                    ? null
                    : () {
                        setState(() {
                          _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
                        });
                      },
              ),
              Text(
                '$monthName ${_currentMonth.year}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.chevron_right_rounded, color: brandRed, size: 24),
                onPressed: () {
                  setState(() {
                    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Day Headers (Mon - Sun) fully responsive
          Row(
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
              return Expanded(
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: textMuted,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 6),

          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: daysInMonth + firstDayOffset,
            itemBuilder: (context, index) {
              if (index < firstDayOffset) {
                return const SizedBox();
              }
              final dayNumber = index - firstDayOffset + 1;
              final cellDate = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
              final isPast = cellDate.isBefore(today);
              final isSelected = cellDate.year == _selectedDate.year &&
                  cellDate.month == _selectedDate.month &&
                  cellDate.day == _selectedDate.day;

              return GestureDetector(
                onTap: isPast
                    ? null
                    : () {
                        setState(() {
                          _selectedDate = cellDate;
                        });
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? brandRed : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$dayNumber',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isPast
                          ? const Color(0xFFCBD5E1)
                          : isSelected
                              ? Colors.white
                              : textDark,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    final period = _selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
    final hour = _selectedTime.hourOfPeriod == 0 ? 12 : _selectedTime.hourOfPeriod;
    final minute = _selectedTime.minute.toString().padLeft(2, '0');
    final formattedTime = '${hour.toString().padLeft(2, '0')}:$minute $period';

    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: _selectedTime,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: brandRed,
                  onPrimary: Colors.white,
                  onSurface: textDark,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            _selectedTime = picked;
          });
        }
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: inputBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: inputBorder, width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time_rounded, color: brandRed, size: 20),
                const SizedBox(width: 10),
                Text(
                  formattedTime,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: brandRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Text(
                    'সময় নির্বাচন করুন',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: brandRedDark,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.edit_calendar_rounded, size: 14, color: brandRed),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String label,
    required String sublabel,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? brandRed.withValues(alpha: 0.4) : inputBorder,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: value ? brandRed : const Color(0xFF94A3B8),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                ),
                Text(
                  sublabel,
                  style: const TextStyle(
                    fontSize: 11,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: brandRed,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [brandRed, brandRedDark],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: brandRed.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: _handleSubmit,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send_rounded, color: Colors.white, size: 19),
            SizedBox(width: 8),
            Text(
              'রক্তের অনুরোধ পাঠান',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    showBloodRequestSuccessDialog(context);
  }
}
