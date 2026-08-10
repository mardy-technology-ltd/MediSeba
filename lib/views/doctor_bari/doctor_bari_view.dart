import 'package:flutter/material.dart';
import '../../controllers/doctor_controller.dart';
import '../../models/doctor_model.dart';
import '../../controllers/language_controller.dart';
import 'doctor_details_view.dart';

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
                          return _buildDoctorCard(doctor);
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

  Widget _buildDoctorCard(DoctorModel doctor) {
    final bool isPremium = doctor.rating >= 4.8;
    final bool isMediSeba = doctor.isAvailableToday;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailsView(
              name: doctor.name,
              specialty: doctor.degree.isNotEmpty ? '${doctor.degree} • ${doctor.specialty}' : doctor.specialty,
              hospital: doctor.hospital,
              rating: doctor.rating.toString(),
              reviews: '(${doctor.totalReviews})',
              price: '৳${doctor.consultationFee.toInt()}',
              imageUrl: doctor.imageUrl,
              isPremium: isPremium,
              isMediSeba: isMediSeba,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Image with Active Status Indicator
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    doctor.imageUrl,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 90,
                        height: 90,
                        color: const Color(0xFFE2E8F0),
                        child: const Icon(Icons.person, color: Color(0xFF94A3B8), size: 45),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: doctor.isAvailableToday ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: (doctor.isAvailableToday ? const Color(0xFF10B981) : Colors.black)
                              .withValues(alpha: 0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            
            // Doctor Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          doctor.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isPremium || isMediSeba) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isPremium ? const Color(0xFFFEF3C7) : const Color(0xFFD1FAE5),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isPremium ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
                            ),
                          ),
                          child: Text(
                            isPremium ? 'Premium' : 'MediSeba',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isPremium ? const Color(0xFFD97706) : const Color(0xFF047857),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.degree.isNotEmpty ? '${doctor.degree} • ${doctor.specialty}' : doctor.specialty,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.hospital,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18),
                          const SizedBox(width: 4),
                          Text(
                            doctor.rating.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${doctor.totalReviews})',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '৳${doctor.consultationFee.toInt()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F9D58),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
