import 'package:flutter/material.dart';
import '../../controllers/doctor_controller.dart';
import '../../controllers/language_controller.dart';
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
  static const textDark = Color(0xFF222222);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
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
        title: Text(
          _langController.tr('ডাক্তার ঘর', 'Doctor Bari'),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => _doctorController.searchDoctors(val),
                  decoration: const InputDecoration(
                    hintText: 'ডাক্তারের নাম, বিশেষজ্ঞ বা হাসপাতাল...',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF0F9D58)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
            
            // Categories Row
            ListenableBuilder(
              listenable: _doctorController,
              builder: (context, child) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = _doctorController.selectedSpecialty == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () => _doctorController.filterBySpecialty(cat),
                          child: _buildCategoryChip(cat, isSelected: isSelected),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Doctors List
            Expanded(
              child: Container(
                color: const Color(0xFFF8FAFC),
                child: ListenableBuilder(
                  listenable: _doctorController,
                  builder: (context, child) {
                    if (_doctorController.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Color(0xFF0F9D58)),
                      );
                    }

                    if (_doctorController.errorMessage != null && _doctorController.doctors.isEmpty) {
                      return Center(
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
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F9D58),
                              ),
                              onPressed: () => _doctorController.fetchDoctors(),
                              child: const Text('পুনরায় চেষ্টা করুন', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    }

                    if (_doctorController.doctors.isEmpty) {
                      return const Center(
                        child: Text(
                          'কোনো ডাক্তার পাওয়া যায়নি',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 15),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: const Color(0xFF0F9D58),
                      onRefresh: () => _doctorController.fetchDoctors(),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0F9D58) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? const Color(0xFF0F9D58) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected) ...[
            const Icon(Icons.check, color: Colors.white, size: 16),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}
