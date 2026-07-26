import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../models/doctor_model.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback onTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.cardBg, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                // Doctor Image Avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    doctor.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: AppColors.primaryLight.withValues(alpha: 0.2),
                      child: const Icon(Icons.person, color: AppColors.primary, size: 40),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Doctor Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor.name, style: AppTextStyles.heading3),
                      const SizedBox(height: 2),
                      Text(
                        doctor.degree,
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.hospital,
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.highlight, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            doctor.rating.toString(),
                            style: AppTextStyles.heading3.copyWith(fontSize: 13),
                          ),
                          Text(
                            ' (${doctor.totalReviews})',
                            style: AppTextStyles.caption,
                          ),
                          const Spacer(),
                          Text(
                            '৳${doctor.consultationFee.toInt()}',
                            style: AppTextStyles.heading2.copyWith(
                              color: AppColors.primary,
                              fontSize: 16,
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
        ),
      ),
    );
  }
}
