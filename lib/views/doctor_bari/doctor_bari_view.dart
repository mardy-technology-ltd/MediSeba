import 'package:flutter/material.dart';
import '../../controllers/doctor_controller.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../appointments/book_appointment_view.dart';
import '../payment/payment_view.dart';
import '../doctors/widgets/doctor_card.dart';

class DoctorBariView extends StatefulWidget {
  final LanguageController? languageController;

  const DoctorBariView({super.key, this.languageController});

  @override
  State<DoctorBariView> createState() => _DoctorBariViewState();
}

class _DoctorBariViewState extends State<DoctorBariView> {
  static const brandGreen = Color(0xFF0F9D58);
  static const darkGreen = Color(0xFF006B4A);
  
  final DoctorController _doctorController = DoctorController();
  final TextEditingController _searchController = TextEditingController();
  late final LanguageController _langController;

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
  }

  final List<String> _categories = [
    'সকল (All)',
    'মেডিসিন (Medicine)',
    'হৃদরোগ (Cardiology)',
    'শিশু রোগ (Pediatrics)',
    'গাইনি ও স্ত্রী রোগ (Gynecology)',
    'চর্ম ও যৌন (Dermatology)',
    'নিউরোমেডিসিন (Neurology)',
    'অর্থোপেডিক্স (Orthopedics)',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _doctorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        title: _langController.tr('ডাক্তার ঘর', 'Doctor Ghar Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF475569)),
            onPressed: () => _doctorController.fetchDoctors(forceRefresh: true),
            tooltip: 'রিফ্রেশ করুন',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: brandGreen,
                onRefresh: () => _doctorController.fetchDoctors(forceRefresh: true),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Hero Gradient Banner (Matching Web Portal)
                      _buildHeroBanner(),

                      // 2. Search Box
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => _doctorController.searchDoctors(val),
                            decoration: InputDecoration(
                              hintText: 'ডাক্তারের নাম, বিশেষজ্ঞ বা হাসপাতাল দিয়ে খুঁজুন...',
                              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
                              prefixIcon: const Icon(Icons.search_rounded, color: brandGreen, size: 22),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded, color: Color(0xFF94A3B8), size: 18),
                                      onPressed: () {
                                        _searchController.clear();
                                        _doctorController.searchDoctors('');
                                        setState(() {});
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ),

                      // 3. Specialty Categories Chips Carousel
                      ListenableBuilder(
                        listenable: _doctorController,
                        builder: (context, child) {
                          return SizedBox(
                            height: 42,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              itemCount: _categories.length,
                              itemBuilder: (context, index) {
                                final cat = _categories[index];
                                final isSelected = _doctorController.selectedSpecialty == cat;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: () => _doctorController.filterBySpecialty(cat),
                                    child: _buildCategoryChip(cat, isSelected: isSelected),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 14),

                      // 4. Results Stats & Sort Header Bar
                      ListenableBuilder(
                        listenable: _doctorController,
                        builder: (context, child) {
                          final count = _doctorController.doctors.length;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Count Pill Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCFCE7),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFFBBF7D0)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: const BoxDecoration(
                                          color: brandGreen,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '$count জন বিশেষজ্ঞ ডাক্তার',
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF15803D),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Sort Indicator
                                Row(
                                  children: [
                                    const Icon(Icons.tune_rounded, size: 16, color: Color(0xFF64748B)),
                                    const SizedBox(width: 4),
                                    Text(
                                      'প্রাসঙ্গিকতা',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      // 5. Doctors List
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListenableBuilder(
                          listenable: _doctorController,
                          builder: (context, child) {
                            if (_doctorController.isLoading) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.0),
                                child: Center(
                                  child: CircularProgressIndicator(color: brandGreen),
                                ),
                              );
                            }

                            if (_doctorController.errorMessage != null && _doctorController.doctors.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 40.0),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.wifi_off_rounded, size: 50, color: Colors.grey),
                                      const SizedBox(height: 12),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                        child: Text(
                                          _doctorController.errorMessage!,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: brandGreen,
                                        ),
                                        onPressed: () => _doctorController.fetchDoctors(),
                                        icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
                                        label: const Text('পুনরায় চেষ্টা করুন', style: TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            if (_doctorController.doctors.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 50.0),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.search_off_rounded, size: 54, color: Color(0xFFCBD5E1)),
                                      SizedBox(height: 10),
                                      Text(
                                        'কোনো ডাক্তার পাওয়া যায়নি',
                                        style: TextStyle(color: Color(0xFF475569), fontSize: 15, fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'অন্য কোনো ফিল্টার বা সার্চ দিয়ে চেষ্টা করুন',
                                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _doctorController.doctors.length,
                              itemBuilder: (context, index) {
                                final doctor = _doctorController.doctors[index];
                                return DoctorCard(
                                  doctor: doctor,
                                  onTap: () {
                                    if (doctor.isAvailableToday) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PaymentView(doctor: doctor),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BookAppointmentView(doctor: doctor),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build Hero Gradient Banner matching Web Portal
  Widget _buildHeroBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [darkGreen, Color(0xFF008536), Color(0xFF05583D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Pill Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.health_and_safety_rounded, color: Colors.white, size: 15),
                SizedBox(width: 6),
                Text(
                  'ডাক্তার ঘর (Doctor Ghar Portal)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Banner Title
          const Text(
            'অনলাইন ভিডিও কনসালটেশন ও খ্যাতনামা ডাক্তারের সিরিয়াল বুকিং',
            style: TextStyle(
              fontSize: 18.5,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),

          // Banner Subtitle
          Text(
            'মেডি সেবা প্ল্যাটফর্মে অনলাইন বিএমডিসি রেজিস্টার্ড ডাক্তার দেখান অথবা দেশের খ্যাতনামা প্রফেসরের চেম্বার সিরিয়াল নেওয়ার দায়িত্ব মেগিসেবা কে দিন।',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.92),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons Row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Button 1: Instant Doctor
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: darkGreen,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // Filter by available online doctors
                  _doctorController.filterBySpecialty('সকল (All)');
                },
                icon: const Icon(Icons.videocam_rounded, size: 16, color: darkGreen),
                label: const Text(
                  'অনলাইন ডাক্তার ইনস্ট্যান্ট',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                ),
              ),

              // Button 2: Chamber Serial Request
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.6), width: 1.2),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('চেম্বার সিরিয়াল রিকোয়েস্ট করতে ডাক্তার নির্বাচন করুন'),
                      backgroundColor: darkGreen,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_month_rounded, size: 16, color: Colors.white),
                label: const Text(
                  'চেম্বার সিরিয়াল রিকোয়েস্ট',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build Specialty Filter Chip
  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? brandGreen : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? brandGreen : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: brandGreen.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected) ...[
            const Icon(Icons.check_rounded, color: Colors.white, size: 15),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}

