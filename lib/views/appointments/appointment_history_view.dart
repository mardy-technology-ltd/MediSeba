import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/appointment_controller.dart';

class AppointmentHistoryView extends StatelessWidget {
  const AppointmentHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppointmentController appointmentController = AppointmentController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('আমার অ্যাপয়েন্টমেন্টসমূহ', style: AppTextStyles.heading2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListenableBuilder(
        listenable: appointmentController,
        builder: (context, child) {
          if (appointmentController.appointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.event_busy_rounded, size: 60, color: AppColors.textLight),
                  const SizedBox(height: 12),
                  Text('কোনো অ্যাপয়েন্টমেন্ট পাওয়া যায়নি', style: AppTextStyles.heading3),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointmentController.appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointmentController.appointments[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBg),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(appointment.doctorName, style: AppTextStyles.heading3),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: appointment.status == 'Confirmed'
                                ? AppColors.success.withValues(alpha: 0.1)
                                : AppColors.statusPending.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            appointment.status == 'Confirmed' ? 'নিশ্চিত' : 'অপেক্ষমান',
                            style: AppTextStyles.caption.copyWith(
                              color: appointment.status == 'Confirmed'
                                  ? AppColors.success
                                  : AppColors.statusPending,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(appointment.doctorSpecialty, style: AppTextStyles.caption),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.cardBg),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(appointment.appointmentDate, style: AppTextStyles.bodyMedium),
                        const SizedBox(width: 16),
                        const Icon(Icons.access_time_rounded, size: 16, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(appointment.appointmentTime, style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
