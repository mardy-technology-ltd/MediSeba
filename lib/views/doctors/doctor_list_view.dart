import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';
import '../../controllers/doctor_controller.dart';
import 'widgets/doctor_card.dart';
import 'doctor_detail_view.dart';

class DoctorListView extends StatefulWidget {
  final bool showAppBar;
  const DoctorListView({super.key, this.showAppBar = true});

  @override
  State<DoctorListView> createState() => _DoctorListViewState();
}

class _DoctorListViewState extends State<DoctorListView> {
  final DoctorController _doctorController = DoctorController();
  final TextEditingController _searchController = TextEditingController();

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
              title: Text('ডাক্তার খুঁজুন', style: AppTextStyles.heading2),
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

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _doctorController.doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = _doctorController.doctors[index];
                    return DoctorCard(
                      doctor: doctor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorDetailView(doctor: doctor),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
