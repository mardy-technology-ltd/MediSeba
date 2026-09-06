import 'dart:ui';
import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/language_controller.dart';
import '../../models/doctor_model.dart';
import '../../widgets/auth_guard.dart';
import '../../widgets/custom_app_bar.dart';
import '../appointments/book_appointment_view.dart';
import '../offers/widgets/eps_payment_gateway_dialog.dart';

class DoctorDetailsView extends StatelessWidget {
  final DoctorModel doctor;
  final LanguageController? languageController;
  final AuthController? authController;
  final HomeController? homeController;

  const DoctorDetailsView({
    super.key,
    required this.doctor,
    this.languageController,
    this.authController,
    this.homeController,
  });

  void _handleBooking(BuildContext context) {
    final authCtrl = authController ?? AuthController();
    final homeCtrl = homeController ?? HomeController();
    final langCtrl = languageController ?? LanguageController();

    AuthGuard.check(
      context: context,
      authController: authCtrl,
      homeController: homeCtrl,
      languageController: langCtrl,
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
  }

  @override
  Widget build(BuildContext context) {
    const brandGreen = Color(0xFF008536);
    const textDark = Color(0xFF0F172A);
    final int totalConsultations = doctor.totalReviews > 0 ? (doctor.totalReviews * 6) : 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar(
        title: 'ডাক্তারের প্রোফাইল',
      ),
      body: Stack(
        children: [
          // Background Glow Orbs
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brandGreen.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            top: 250,
            right: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF38BDF8).withValues(alpha: 0.06),
              ),
            ),
          ),

          // Main Scrollable Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Doctor Card Header
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.7), width: 1.5),
                        ),
                        child: Column(
                          children: [
                            // Doctor Image & Status
                            Center(
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3.5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: doctor.isAvailableToday ? brandGreen : const Color(0xFF38BDF8),
                                        width: 2.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: doctor.isAvailableToday
                                              ? brandGreen.withValues(alpha: 0.3)
                                              : const Color(0xFF38BDF8).withValues(alpha: 0.3),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        doctor.imageUrl,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          width: 100,
                                          height: 100,
                                          color: const Color(0xFFE2E8F0),
                                          child: const Icon(Icons.person, color: Color(0xFF94A3B8), size: 50),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: doctor.isAvailableToday ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2.5),
                                        boxShadow: [
                                          if (doctor.isAvailableToday)
                                            BoxShadow(
                                              color: const Color(0xFF10B981).withValues(alpha: 0.4),
                                              blurRadius: 6,
                                              spreadRadius: 1,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Name
                            Text(
                              doctor.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: textDark,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Degree
                            Text(
                              doctor.degree,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Specialty Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFBAE6FD)),
                              ),
                              child: Text(
                                doctor.specialty,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0284C7),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Stats Row (Experience, Rating, Consultations)
                            Row(
                              children: [
                                _buildStatCard(
                                  icon: Icons.workspace_premium_rounded,
                                  iconColor: const Color(0xFF0284C7),
                                  value: '${doctor.experienceYears}+ বছর',
                                  label: 'অভিজ্ঞতা',
                                ),
                                const SizedBox(width: 10),
                                _buildStatCard(
                                  icon: Icons.star_rounded,
                                  iconColor: const Color(0xFFF59E0B),
                                  value: doctor.rating.toString(),
                                  label: 'রেটিং (${doctor.totalReviews})',
                                ),
                                const SizedBox(width: 10),
                                _buildStatCard(
                                  icon: Icons.people_alt_rounded,
                                  iconColor: brandGreen,
                                  value: '$totalConsultations+',
                                  label: 'রোগী দেখেছন',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Section 1: Chamber & Workplace Info
                _buildSectionHeader('কর্মস্থল ও সেবা'),
                const SizedBox(height: 10),
                _buildInfoCard(
                  child: Column(
                    children: [
                      _buildDetailTile(
                        icon: Icons.domain_rounded,
                        iconColor: brandGreen,
                        title: 'কর্মস্থল / হাসপাতাল',
                        subtitle: doctor.hospital.isNotEmpty ? doctor.hospital : 'পপুলার ডায়াগনস্টিক সেন্টার',
                      ),
                      const Divider(height: 24, color: Color(0xFFF1F5F9)),
                      _buildDetailTile(
                        icon: Icons.videocam_rounded,
                        iconColor: const Color(0xFF0284C7),
                        title: 'পরামর্শের মাধ্যম',
                        subtitle: 'এইচডি ভিডিও কল এবং ভয়েস কল সাপোর্ট',
                      ),
                      const Divider(height: 24, color: Color(0xFFF1F5F9)),
                      _buildDetailTile(
                        icon: doctor.isAvailableToday ? Icons.flash_on_rounded : Icons.calendar_today_rounded,
                        iconColor: doctor.isAvailableToday ? const Color(0xFF10B981) : const Color(0xFFEAB308),
                        title: 'উপলব্ধতা (Availability)',
                        subtitle: doctor.isAvailableToday
                            ? 'আজকে উপলব্ধ (অনলাইন ইনস্ট্যান্ট কনসালটেশন)'
                            : 'অ্যাপয়েন্টমেন্ট ভিত্তিক সেশন',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 2: About Doctor
                _buildSectionHeader('ডাক্তার সম্পর্কে'),
                const SizedBox(height: 10),
                _buildInfoCard(
                  child: Text(
                    '${doctor.name} একজন অভিজ্ঞ ও নিবেদিতপ্রাণ চিকিৎসক। তিনি দীর্ঘ ${doctor.experienceYears} বছর ধরে বিশ্বস্ততার সাথে চিকিৎসা সেবা দিয়ে আসছেন। সঠিক রোগ নির্ণয় এবং প্রয়োজনীয় ওষুধ ও লাইফস্টাইল নির্দেশনার মাধ্যমে রোগীদের দ্রুত আরোগ্য লাভে তিনি বিশেষ যত্নশীল।',
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF334155),
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Section 3: Specialized Care Areas
                _buildSectionHeader('যেসব ক্ষেত্রে পরামর্শ নিতে পারেন'),
                const SizedBox(height: 10),
                _buildInfoCard(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTagChip('সাধারণ শারীরিক পরামর্শ'),
                      _buildTagChip('রোগ প্রতিরোধ ও গাইডলাইন'),
                      _buildTagChip('প্রেসক্রিপশন রিভিউ'),
                      _buildTagChip('মেডিকেল রিপোর্ট পরীক্ষা'),
                      _buildTagChip('জরুরি স্বাস্থ্য উপদেশ'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 4: Patient Reviews & Feedback
                _buildSectionHeader('রোগীদের সাম্প্রতিক রিভিউ'),
                const SizedBox(height: 10),
                _buildInfoCard(
                  child: Column(
                    children: [
                      _buildReviewTile(
                        name: 'তানভীর আহমেদ',
                        rating: 5.0,
                        date: '২ দিন আগে',
                        comment: 'স্যার খুবই মন দিয়ে সমস্যাগুলো শুনেছেন এবং সুন্দরভাবে বুঝিয়ে ওষুধ দিয়েছেন। অনেক ধন্যবাদ!',
                      ),
                      const Divider(height: 20, color: Color(0xFFF1F5F9)),
                      _buildReviewTile(
                        name: 'নাসরিন আক্তার',
                        rating: 5.0,
                        date: '১ সপ্তাহ আগে',
                        comment: 'ইনস্ট্যান্ট ভিডিও কলে পরামর্শ পেয়ে অনেক বড় উপকার হলো। প্রেসক্রিপশনও সাথে সাথে পেয়েছি।',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Sticky Action Container
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Fee Display
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'পরামর্শ ফি',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '৳ ${doctor.consultationFee.toInt()}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: textDark,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Book Action Button
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandGreen,
                            elevation: 4,
                            shadowColor: brandGreen.withValues(alpha: 0.35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          onPressed: () => _handleBooking(context),
                          icon: Icon(
                            doctor.isAvailableToday ? Icons.videocam_rounded : Icons.calendar_today_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: Text(
                            doctor.isAvailableToday ? 'ডাক্তার দেখান' : 'অ্যাপয়েন্টমেন্ট বুক করুন',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: Color(0xFF0F172A),
      ),
    );
  }

  Widget _buildInfoCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF334155),
        ),
      ),
    );
  }

  Widget _buildReviewTile({
    required String name,
    required double rating,
    required String date,
    required String comment,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                const SizedBox(width: 2),
                Text(
                  rating.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          comment,
          style: const TextStyle(
            fontSize: 12.5,
            color: Color(0xFF475569),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
