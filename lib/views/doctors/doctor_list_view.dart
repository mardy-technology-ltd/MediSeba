import 'dart:ui';
import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../controllers/doctor_controller.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../appointments/book_appointment_view.dart';
import '../offers/widgets/eps_payment_gateway_dialog.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/auth_guard.dart';
import 'widgets/doctor_card.dart';

class DoctorListView extends StatefulWidget {
  final bool showAppBar;
  final LanguageController? languageController;
  final AuthController? authController;
  final HomeController? homeController;
  final String? initialSearchQuery;

  const DoctorListView({
    super.key,
    this.showAppBar = true,
    this.languageController,
    this.authController,
    this.homeController,
    this.initialSearchQuery,
  });

  @override
  State<DoctorListView> createState() => _DoctorListViewState();
}

class _DoctorListViewState extends State<DoctorListView> {
  final DoctorController _doctorController = DoctorController();
  final TextEditingController _searchController = TextEditingController();
  late final LanguageController _langController;

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
    if (widget.initialSearchQuery != null && widget.initialSearchQuery!.isNotEmpty) {
      _searchController.text = widget.initialSearchQuery!;
      _doctorController.searchDoctors(widget.initialSearchQuery!);
    }
  }

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
      appBar: widget.showAppBar
          ? CustomAppBar(
              title: _langController.tr('ডাক্তার খুঁজুন', 'Find Doctors'),
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            // Ambient Glow Orbs in background matching home view
            Positioned(
              top: -60,
              left: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF008536).withValues(alpha: 0.08), // brandGreen
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              right: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.06), // Sky Blue Accent
                ),
              ),
            ),

            Column(
              children: [
                // Search & Filter Box (Glassmorphic)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF008536).withValues(alpha: 0.03),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Search TextField Container
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (val) => _doctorController.searchDoctors(val),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                                decoration: InputDecoration(
                                  hintText: _langController.tr('ডাক্তারের নাম, বিশেষজ্ঞ বা হাসপাতাল...', 'Doctor name, specialty or hospital...'),
                                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF008536), size: 22),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear_rounded, color: Colors.grey, size: 18),
                                          onPressed: () {
                                            setState(() {
                                              _searchController.clear();
                                              _doctorController.searchDoctors('');
                                            });
                                          },
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Specialty Chips Carousel
                            ListenableBuilder(
                              listenable: _doctorController,
                              builder: (context, child) {
                                return SizedBox(
                                  height: 38,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: AppConstants.doctorSpecialties.length,
                                    itemBuilder: (context, index) {
                                      final specialty = AppConstants.doctorSpecialties[index];
                                      final isSelected = _doctorController.selectedSpecialty == specialty;
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: ChoiceChip(
                                          label: Text(
                                            specialty,
                                            style: TextStyle(
                                              color: isSelected ? Colors.white : const Color(0xFF1E293B),
                                              fontSize: 12,
                                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                            ),
                                          ),
                                          selected: isSelected,
                                          selectedColor: const Color(0xFF008536),
                                          backgroundColor: Colors.white.withValues(alpha: 0.6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: BorderSide(
                                              color: isSelected ? Colors.transparent : Colors.white.withValues(alpha: 0.5),
                                              width: 1,
                                            ),
                                          ),
                                          elevation: isSelected ? 2 : 0,
                                          onSelected: (selected) {
                                            if (selected) {
                                              _doctorController.filterBySpecialty(specialty);
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Doctor List Results
                Expanded(
                  child: ListenableBuilder(
                    listenable: _doctorController,
                    builder: (context, child) {
                      if (_doctorController.isLoading) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFF008536)));
                      }

                      if (_doctorController.errorMessage != null && _doctorController.doctors.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF2F2),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFFFCA5A5), width: 1.2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withValues(alpha: 0.1),
                                        blurRadius: 16,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.wifi_off_rounded,
                                    size: 44,
                                    color: Color(0xFFDC2626),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'ইন্টারনেট সংযোগ নেই!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'আপনার ইন্টারনেট কানেকশনটি বিচ্ছিন্ন রয়েছে। অনুগ্রহ করে ওয়াইফাই বা মোবাইল ডাটা চালু করে আবার চেষ্টা করুন।',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                    height: 1.45,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  height: 44,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF008536),
                                      elevation: 3,
                                      shadowColor: const Color(0xFF008536).withValues(alpha: 0.35),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                    ),
                                    onPressed: () => _doctorController.fetchDoctors(forceRefresh: true),
                                    icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
                                    label: const Text(
                                      'পুনরায় চেষ্টা করুন',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (_doctorController.doctors.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off_rounded, size: 60, color: Color(0xFF94A3B8)),
                              const SizedBox(height: 12),
                              const Text(
                                'কোনো ডাক্তার পাওয়া যায়নি',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'অন্য কোনো নাম বা স্পেশাল্টি দিয়ে সার্চ করার চেষ্টা করুন',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        color: const Color(0xFF008536),
                        onRefresh: () => _doctorController.fetchDoctors(),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                          itemCount: _doctorController.doctors.length,
                          itemBuilder: (context, index) {
                            final doctor = _doctorController.doctors[index];
                            return DoctorCard(
                              doctor: doctor,
                              onTap: () {
                                final authCtrl = widget.authController ?? AuthController();
                                final homeCtrl = widget.homeController ?? HomeController();
                                AuthGuard.check(
                                  context: context,
                                  authController: authCtrl,
                                  homeController: homeCtrl,
                                  languageController: _langController,
                                  title: 'অ্যাপয়েন্টমেন্ট বুকিং করতে লগইন করুন',
                                  message: 'ডাক্তারের কনসালটেশন বা চেম্বার অ্যাপয়েন্টমেন্ট সম্পন্ন করতে লগইন করুন।',
                                  onAuthenticated: () {
                                    if (doctor.isAvailableToday) {
                                      EpsPaymentGatewayDialog.show(
                                        context: context,
                                        packageName: doctor.name.isEmpty ? 'Instant Medicine Doctor Consultation' : doctor.name,
                                        price: doctor.consultationFee.toInt() > 0 ? doctor.consultationFee.toInt() : 800,
                                        points: 999,
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
