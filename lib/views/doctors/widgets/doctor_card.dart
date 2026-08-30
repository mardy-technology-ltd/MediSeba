import 'dart:ui';
import 'package:flutter/material.dart';
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
    final int totalConsultations = doctor.totalReviews > 0 ? (doctor.totalReviews * 6) : 800;
    const brandGreen = Color(0xFF008536);
    const textDark = Color(0xFF0F172A);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.55), width: 1.5),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: onTap,
                child: Column(
                  children: [
                    // Upper Section: Left Column (Image & Experience) & Right Column (Info)
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column: Doctor Image + Experience
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2.5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: doctor.isAvailableToday
                                            ? brandGreen
                                            : const Color(0xFF38BDF8),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: doctor.isAvailableToday
                                              ? brandGreen.withValues(alpha: 0.25)
                                              : const Color(0xFF38BDF8).withValues(alpha: 0.25),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Image.network(
                                        doctor.imageUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          width: 80,
                                          height: 80,
                                          color: const Color(0xFFE2E8F0),
                                          child: const Icon(Icons.person, color: Color(0xFF94A3B8), size: 40),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 2,
                                    right: 2,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: doctor.isAvailableToday ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                        boxShadow: [
                                          if (doctor.isAvailableToday)
                                            BoxShadow(
                                              color: const Color(0xFF10B981).withValues(alpha: 0.4),
                                              blurRadius: 4,
                                              spreadRadius: 1,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Experience Box
                              Container(
                                width: 88,
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.45),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '${doctor.experienceYears}+ বছর',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        color: textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 1.5),
                                    const Text(
                                      'অভিজ্ঞতা',
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),

                          // Right Column: Details & Badges
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Doctor Name
                                Text(
                                  doctor.name,
                                  style: const TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w900,
                                    color: textDark,
                                    height: 1.25,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),

                                // Degree
                                Text(
                                  doctor.degree,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF475569),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),

                                // Chips (Specialty & Instant Call)
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE0F2FE),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        doctor.specialty.contains('(')
                                            ? doctor.specialty.split('(').last.replaceAll(')', '').trim()
                                            : doctor.specialty,
                                        style: const TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF0284C7),
                                        ),
                                      ),
                                    ),
                                    if (doctor.isAvailableToday)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDCFCE7),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          'ইনস্ট্যান্ট কল',
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF16A34A),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Rating & Consultations
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 16),
                                    const SizedBox(width: 2),
                                    Text(
                                      doctor.rating.toString(),
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w900,
                                        color: textDark,
                                      ),
                                    ),
                                    const Text(
                                      '  •  ',
                                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                                    ),
                                    const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF64748B), size: 12),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        '$totalConsultations+ রোগী পরামর্শ নিয়েছেন',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF475569),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Workplace Hospital
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.domain_rounded, color: Color(0xFF0F9D58), size: 15),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          text: 'কর্মস্থল: ',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF334155),
                                          ),
                                          children: [
                                            TextSpan(
                                              text: doctor.hospital,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF475569),
                                              ),
                                            ),
                                          ],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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

                    // Bottom Footer Bar (Fee Label & Action Button)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.45),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(23),
                          bottomRight: Radius.circular(23),
                        ),
                        border: Border(
                          top: BorderSide(color: Colors.white.withValues(alpha: 0.5), width: 1.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Fee Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'পরামর্শ ফি',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                '৳ ${doctor.consultationFee.toInt()}',
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                  color: textDark,
                                ),
                              ),
                            ],
                          ),

                          // Action Button
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: doctor.isAvailableToday
                                  ? const LinearGradient(
                                      colors: [brandGreen, Color(0xFF0F9D58)],
                                    )
                                  : null,
                              color: doctor.isAvailableToday ? null : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: doctor.isAvailableToday
                                  ? null
                                  : Border.all(color: const Color(0xFF2563EB), width: 1.5),
                              boxShadow: [
                                if (doctor.isAvailableToday)
                                  BoxShadow(
                                    color: brandGreen.withValues(alpha: 0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  doctor.isAvailableToday ? Icons.videocam_rounded : Icons.calendar_today_rounded,
                                  size: 15,
                                  color: doctor.isAvailableToday ? Colors.white : const Color(0xFF2563EB),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  doctor.isAvailableToday ? 'ডাক্তার দেখান' : 'অ্যাপয়েন্টমেন্ট বুক করুন',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: doctor.isAvailableToday ? Colors.white : const Color(0xFF2563EB),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
