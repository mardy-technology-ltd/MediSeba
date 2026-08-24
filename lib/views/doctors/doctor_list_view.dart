import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';
import '../../controllers/doctor_controller.dart';
import '../../controllers/language_controller.dart';
import '../appointments/book_appointment_view.dart';
import '../payment/payment_view.dart';
import 'widgets/doctor_card.dart';

class DoctorListView extends StatefulWidget {
  final bool showAppBar;
  final LanguageController? languageController;
  final String? initialSearchQuery;

  const DoctorListView({
    super.key,
    this.showAppBar = true,
    this.languageController,
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
      backgroundColor: AppColors.background,
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: AppColors.surface,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Text(_langController.tr('ডাক্তার খুঁজুন', 'Find Doctors'), style: AppTextStyles.heading2),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      body: Column(
        children: [
          // Search & Filter Box
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Column(
              children: [
                // Search TextField
                TextField(
                  controller: _searchController,
                  onChanged: (val) => _doctorController.searchDoctors(val),
                  decoration: InputDecoration(
                    hintText: 'ডাক্তারের নাম, বিশেষজ্ঞ বা হাসপাতাল...',
                    hintStyle: AppTextStyles.bodyMedium,
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
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
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: AppColors.primary,
                              backgroundColor: AppColors.background,
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

          // Doctor List Results
          Expanded(
            child: ListenableBuilder(
              listenable: _doctorController,
              builder: (context, child) {
                if (_doctorController.isLoading) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                if (_doctorController.errorMessage != null && _doctorController.doctors.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wifi_off_rounded, size: 50, color: AppColors.primary),
                          const SizedBox(height: 12),
                          Text(
                            _doctorController.errorMessage!,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            onPressed: () => _doctorController.fetchDoctors(),
                            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                            label: const Text('পুনরায় চেষ্টা করুন', style: TextStyle(color: Colors.white)),
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
                        const Icon(Icons.search_off_rounded, size: 60, color: AppColors.textLight),
                        const SizedBox(height: 12),
                        Text('কোনো ডাক্তার পাওয়া যায়নি', style: AppTextStyles.heading3),
                        const SizedBox(height: 4),
                        Text('অন্য কোনো নাম বা স্পেশাল্টি দিয়ে সার্চ করার চেষ্টা করুন', style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => _doctorController.fetchDoctors(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
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
        ],
      ),
    );
  }
}
