import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/doctor_model.dart';
import '../shared_widgets/custom_button.dart';
import '../appointments/book_appointment_view.dart';

class DoctorDetailView extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailView({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('ডাক্তার প্রোফাইল', style: AppTextStyles.heading2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Main Info Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          doctor.imageUrl,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 90,
                            height: 90,
                            color: AppColors.primaryLight.withValues(alpha: 0.2),
                            child: const Icon(Icons.person, color: AppColors.primary, size: 45),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doctor.name, style: AppTextStyles.heading2),
                            const SizedBox(height: 4),
                            Text(
                              doctor.degree,
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                            ),
                            const SizedBox(height: 4),
                            Text(doctor.hospital, style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.cardBg),
                  const SizedBox(height: 12),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('অভিজ্ঞতা', '${doctor.experienceYears}+ বছর'),
                      _buildStatItem('রেটিং', '⭐ ${doctor.rating}'),
                      _buildStatItem('ফি', '৳${doctor.consultationFee.toInt()}'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // About Section
            Text('ডাক্তার সম্পর্কিত তথ্য', style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${doctor.name} একজন অভিজ্ঞ ${doctor.specialty} বিশেষজ্ঞ। তিনি ${doctor.hospital}-এ কর্মরত আছেন। রোগীর স্বাস্থ্য ও সঠিক চিকিৎসার জন্য তিনি সার্বক্ষণিক নিয়োজিত।',
                style: AppTextStyles.bodyLarge.copyWith(height: 1.5, color: AppColors.textSecondary),
              ),
            ),

            const SizedBox(height: 20),

            // Schedule Availability Card
            Text('চেম্বার ও সময়সূচি', style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.access_time_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('প্রতিদিন বৈকালিক চেম্বার', style: AppTextStyles.heading3),
                      Text('বিকাল ০৫:০০ - রাত ০৯:০০ (শনি - বৃহস্পতি)', style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Action Button
            CustomButton(
              text: 'সিরিয়াল / অ্যাপয়েন্টমেন্ট বুক করুন',
              icon: Icons.calendar_today_rounded,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookAppointmentView(doctor: doctor),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.heading2.copyWith(fontSize: 16, color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
