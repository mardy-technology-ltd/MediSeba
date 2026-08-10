import 'package:flutter/material.dart';
import '../../models/doctor_model.dart';
import '../../models/doctor_availability_model.dart';
import '../../services/api_service.dart';
import '../appointments/book_appointment_view.dart';
import '../payment/payment_view.dart';

class DoctorDetailView extends StatefulWidget {
  final DoctorModel doctor;

  const DoctorDetailView({super.key, required this.doctor});

  @override
  State<DoctorDetailView> createState() => _DoctorDetailViewState();
}

class _DoctorDetailViewState extends State<DoctorDetailView> {
  bool _isAvailable = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    try {
      final availabilities = await ApiService.getDoctorAvailabilities();
      final currentDocId = int.tryParse(widget.doctor.id);

      final matchingAvailability = availabilities.firstWhere(
        (item) {
          if (currentDocId != null && item.doctorId == currentDocId) return true;
          return item.uuid == widget.doctor.id;
        },
        orElse: () => DoctorAvailabilityModel(
          id: 0,
          uuid: '',
          doctorId: 0,
          availableDate: '',
          startTime: '',
          endTime: '',
          slotDuration: 0,
          maxPatients: 0,
          isAvailable: widget.doctor.isAvailableToday,
        ),
      );

      if (mounted) {
        setState(() {
          if (matchingAvailability.id != 0) {
            _isAvailable = matchingAvailability.isAvailable;
          } else {
            _isAvailable = widget.doctor.isAvailableToday;
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isAvailable = widget.doctor.isAvailableToday;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.doctor;
    final int totalConsultations = doc.totalReviews > 0 ? (doc.totalReviews * 6) : 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'ডাক্তার প্রোফাইল',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF64748B), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Main Profile Information Body
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: Doctor Image + Experience Box
                    Column(
                      children: [
                        // Stack Image & Online Green Dot Indicator
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                doc.imageUrl,
                                width: 105,
                                height: 105,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 105,
                                  height: 105,
                                  color: const Color(0xFFE2E8F0),
                                  child: const Icon(Icons.person, color: Color(0xFF94A3B8), size: 50),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: _isAvailable ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Experience Soft Box
                        Container(
                          width: 105,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${doc.experienceYears}+ বছর',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'অভিজ্ঞতা',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
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
                            doc.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),

                          // Degree
                          Text(
                            doc.degree,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),

                          // Chips (Specialty & Instant Call)
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              // Specialty Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2FE),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  doc.specialty.contains('(')
                                      ? doc.specialty.split('(').last.replaceAll(')', '').trim()
                                      : doc.specialty,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0284C7),
                                  ),
                                ),
                              ),

                              // Instant Call Badge (If Available)
                              if (_isAvailable)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCFCE7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'ইনস্ট্যান্ট কল',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF16A34A),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Rating & Consultations Count
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18),
                              const SizedBox(width: 3),
                              Text(
                                doc.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const Text(
                                '  •  ',
                                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                              ),
                              const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF94A3B8), size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '$totalConsultations+ রোগী পরামর্শ নিয়েছেন',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF475569),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Hospital / Workplace
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.domain_rounded, color: Color(0xFF0F9D58), size: 17),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: 'কর্মস্থল: ',
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF334155),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: doc.hospital,
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

              // Bottom Footer Bar (Fee & Action Button)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  border: Border(
                    top: BorderSide(color: Color(0xFFF1F5F9), width: 1.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Fee Label & Amount
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'পরামর্শ ফি',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '৳ ${doc.consultationFee.toInt()}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),

                    // Action Button
                    ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_isAvailable) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentView(doctor: doc),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookAppointmentView(doctor: doc),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isAvailable ? const Color(0xFF0F9D58) : Colors.white,
                        foregroundColor: _isAvailable ? Colors.white : const Color(0xFF2563EB),
                        elevation: _isAvailable ? 2 : 0,
                        shadowColor: const Color(0xFF0F9D58).withValues(alpha: 0.3),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: _isAvailable
                              ? BorderSide.none
                              : const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                        ),
                      ),
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Icon(
                              _isAvailable ? Icons.videocam_rounded : Icons.calendar_today_rounded,
                              size: 18,
                            ),
                      label: Text(
                        _isAvailable ? 'ডাক্তার দেখান' : 'অ্যাপয়েন্টমেন্ট বুক করুন',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
