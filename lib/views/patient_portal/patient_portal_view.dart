import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/language_controller.dart';
import '../../services/api_service.dart';
import '../../services/cache_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../customer_support/customer_support_view.dart';
import '../doctors/doctor_list_view.dart';
import '../offers/offer_list_view.dart';
import '../profile/edit_profile_view.dart';

class PatientPortalView extends StatefulWidget {
  final LanguageController? languageController;
  final AuthController? authController;

  const PatientPortalView({
    super.key,
    this.languageController,
    this.authController,
  });

  @override
  State<PatientPortalView> createState() => _PatientPortalViewState();
}

class _PatientPortalViewState extends State<PatientPortalView> with SingleTickerProviderStateMixin {
  late LanguageController _langController;
  int _selectedVitalTab = 0; // 0: BP, 1: Glucose, 2: Pulse

  // Dynamic Vital Records State
  int _systolic = 120;
  int _diastolic = 80;
  double _glucose = 5.8;
  int _pulse = 72;

  // Dynamic Item Counts
  int _appointmentsCount = 4;
  int _prescriptionsCount = 4;
  int _reportsCount = 4;
  int _paymentsCount = 4;
  int _activityCount = 5;

  Map<String, dynamic> get _bpStatusInfo {
    if (_systolic < 120 && _diastolic < 80) {
      return {'status': 'সুস্থ (Normal)', 'color': const Color(0xFF10B981), 'bg': const Color(0xFFECFDF5), 'border': const Color(0xFFA7F3D0)};
    } else if (_systolic <= 129 && _diastolic < 80) {
      return {'status': 'পর্যবেক্ষণ (Good)', 'color': const Color(0xFF10B981), 'bg': const Color(0xFFECFDF5), 'border': const Color(0xFFA7F3D0)};
    } else if (_systolic <= 139 || _diastolic <= 89) {
      return {'status': 'উচ্চ চাপ (Stage 1)', 'color': const Color(0xFFD97706), 'bg': const Color(0xFFFEF3C7), 'border': const Color(0xFFFDE68A)};
    } else {
      return {'status': 'উচ্চ চাপ (High)', 'color': const Color(0xFFEF4444), 'bg': const Color(0xFFFEF2F2), 'border': const Color(0xFFFECACA)};
    }
  }

  Map<String, dynamic> get _glucoseStatusInfo {
    if (_glucose < 5.6) {
      return {'status': 'নিয়ন্ত্রণ (Good)', 'color': const Color(0xFF0284C7), 'bg': const Color(0xFFF0F9FF), 'border': const Color(0xFFBAE6FD)};
    } else if (_glucose <= 6.9) {
      return {'status': 'সতর্কতা (Pre-diabetes)', 'color': const Color(0xFFD97706), 'bg': const Color(0xFFFEF3C7), 'border': const Color(0xFFFDE68A)};
    } else {
      return {'status': 'উচ্চ সুগার (High)', 'color': const Color(0xFFEF4444), 'bg': const Color(0xFFFEF2F2), 'border': const Color(0xFFFECACA)};
    }
  }

  Map<String, dynamic> get _pulseStatusInfo {
    if (_pulse >= 60 && _pulse <= 100) {
      return {'status': 'সুস্থ (Normal)', 'color': const Color(0xFFE11D48), 'bg': const Color(0xFFFFF1F2), 'border': const Color(0xFFFECDD3)};
    } else if (_pulse < 60) {
      return {'status': 'কম (Low)', 'color': const Color(0xFFD97706), 'bg': const Color(0xFFFEF3C7), 'border': const Color(0xFFFDE68A)};
    } else {
      return {'status': 'বেশি (High)', 'color': const Color(0xFFEF4444), 'bg': const Color(0xFFFEF2F2), 'border': const Color(0xFFFECACA)};
    }
  }

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
    _loadPatientData();
  }

  void _loadPatientData() async {
    final token = widget.authController?.token ?? AuthController.instance?.token ?? CacheService.get('auth_token')?.toString() ?? '';
    if (token.isNotEmpty) {
      final data = await ApiService.fetchPatientDashboard(token);
      if (data != null && mounted) {
        setState(() {
          if (data['vitals'] != null && data['vitals'] is Map) {
            final v = data['vitals'] as Map<String, dynamic>;
            if (v['systolic'] != null) _systolic = (v['systolic'] as num).toInt();
            if (v['diastolic'] != null) _diastolic = (v['diastolic'] as num).toInt();
            if (v['glucose'] != null) _glucose = (v['glucose'] as num).toDouble();
            if (v['pulse'] != null) _pulse = (v['pulse'] as num).toInt();
          }
          if (data['appointments_count'] != null) {
            _appointmentsCount = (data['appointments_count'] as num).toInt();
          }
          if (data['prescriptions_count'] != null) {
            _prescriptionsCount = (data['prescriptions_count'] as num).toInt();
          }
          if (data['reports_count'] != null) {
            _reportsCount = (data['reports_count'] as num).toInt();
          }
          if (data['payments_count'] != null) {
            _paymentsCount = (data['payments_count'] as num).toInt();
          }
          if (data['activity_count'] != null) {
            _activityCount = (data['activity_count'] as num).toInt();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = _langController.isBangla;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: CustomAppBar(
        title: isBangla ? 'পেশেন্ট পোর্টাল ওভারভিউ' : 'Patient Portal Overview',
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF475569), size: 22),
                onPressed: () {},
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFED1C24),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Patient Profile Header Card (Web Portal Aligned)
            _buildPatientHeaderCard(isBangla),

            const SizedBox(height: 14),

            // 2. Live Health Vitals Tracker Card
            _buildHealthVitalsCard(isBangla),

            const SizedBox(height: 16),

            // 3. 2x3 Grid Overview Section Cards (Clicking opens dedicated sub-screen)
            _build2x3GridOverviewSection(isBangla),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 3. 2x3 Grid Overview Section Cards Widget (2 Columns x 3 Rows - Navigates to sub screen on tap)
  Widget _build2x3GridOverviewSection(bool isBangla) {
    final List<Map<String, dynamic>> gridItems = [
      {
        'title': isBangla ? 'আমার সিরিয়াল ও অ্যাপয়েন্টমেন্ট' : 'My Serials & Appointments',
        'subtitle': '$_appointmentsCount ${isBangla ? "টি সক্রিয় সিরিয়াল" : "active serials"}',
        'icon': Icons.calendar_month_rounded,
        'color': const Color(0xFF0F9D58),
        'bg': const Color(0xFFECFDF5),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PatientPortalDetailView(
                title: isBangla ? 'সিরিয়াল ও অ্যাপয়েন্টমেন্ট' : 'Serials & Appointments',
                children: _buildSerialsAndAppointmentsList(isBangla),
              ),
            ),
          );
        },
      },
      {
        'title': isBangla ? 'ডিজিটাল প্রেসক্রিপশন' : 'Digital Prescriptions',
        'subtitle': '$_prescriptionsCount ${isBangla ? "টি ই-প্রেসক্রিপশন" : "e-prescriptions"}',
        'icon': Icons.description_outlined,
        'color': const Color(0xFF0284C7),
        'bg': const Color(0xFFF0F9FF),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PatientPortalDetailView(
                title: isBangla ? 'ডিজিটাল প্রেসক্রিপশন' : 'Digital Prescriptions',
                children: _buildDigitalPrescriptionsList(isBangla),
              ),
            ),
          );
        },
      },
      {
        'title': isBangla ? 'মেডিকেল রেকর্ডস & রিপোর্টস' : 'Medical Records & Reports',
        'subtitle': '$_reportsCount ${isBangla ? "টি ল্যাব রিপোর্ট" : "lab reports"}',
        'icon': Icons.folder_shared_outlined,
        'color': const Color(0xFF7E22CE),
        'bg': const Color(0xFFF3E8FF),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PatientPortalDetailView(
                title: isBangla ? 'মেডিকেল রেকর্ডস & রিপোর্টস' : 'Medical Records & Reports',
                children: _buildMedicalRecordsList(isBangla),
              ),
            ),
          );
        },
      },
      {
        'title': isBangla ? 'পেমেন্ট হিস্ট্রি ও রিসিট' : 'Payment History & Receipts',
        'subtitle': '$_paymentsCount ${isBangla ? "টি পেইড ট্রানজেকশন" : "paid receipts"}',
        'icon': Icons.receipt_long_outlined,
        'color': const Color(0xFFD97706),
        'bg': const Color(0xFFFEF3C7),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PatientPortalDetailView(
                title: isBangla ? 'পেমেন্ট হিস্ট্রি ও রিসিট' : 'Payment History & Receipts',
                children: _buildPaymentHistoryList(isBangla),
              ),
            ),
          );
        },
      },
      {
        'title': isBangla ? 'অ্যাক্টিভিটি ও একশন লগ' : 'Activity & Action Logs',
        'subtitle': '$_activityCount ${isBangla ? "টি সাম্প্রতিক লগ" : "recent logs"}',
        'icon': Icons.history_rounded,
        'color': const Color(0xFF0D9488),
        'bg': const Color(0xFFCCFBF1),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PatientPortalDetailView(
                title: isBangla ? 'অ্যাক্টিভিটি ও একশন লগ' : 'Activity & Action Logs',
                children: _buildActivityLogList(isBangla),
              ),
            ),
          );
        },
      },
      {
        'title': isBangla ? 'স্বাস্থ্য প্রোফাইল ও সাপোর্ট' : 'Health Profile & Support',
        'subtitle': isBangla ? 'হেল্পলাইন ও সাপোর্ট' : 'Helpline & Support',
        'icon': Icons.health_and_safety_outlined,
        'color': const Color(0xFFE11D48),
        'bg': const Color(0xFFFFF1F2),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CustomerSupportView(languageController: _langController),
            ),
          );
        },
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.12,
      ),
      itemCount: gridItems.length,
      itemBuilder: (context, index) {
        final item = gridItems[index];
        final Color color = item['color'] as Color;
        final Color bg = item['bg'] as Color;

        return InkWell(
          onTap: item['onTap'] as VoidCallback,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1.1,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Centered Icon Container
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.35)),
                  ),
                  child: Icon(item['icon'] as IconData, color: color, size: 24),
                ),
                const SizedBox(height: 8),

                // Centered Title Text
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Centered Subtitle Text
                Text(
                  item['subtitle'] as String,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 1. Patient Profile Banner Card (Dark Emerald Web Theme Aligned)
  Widget _buildPatientHeaderCard(bool isBangla) {
    final authCtrl = widget.authController ?? AuthController.instance;
    final user = authCtrl?.currentUserData;
    final authUser = authCtrl?.currentUser;

    final String name = (user?.name != null && user!.name.isNotEmpty && user.name != 'User')
        ? user.name
        : (authUser?.displayName ?? 'Rofiqul Islam');
    final String phone = (user?.phone != null && user!.phone.isNotEmpty)
        ? user.phone
        : '01789989865';
    final String email = phone.contains('@') ? phone : (authUser?.email ?? '$phone@mediseba.org');
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : 'R';
    final String bloodGroup = '-';
    final String package = 'মাতৃমমতা (Matrumomota)';
    final int points = 2500;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF04201D), Color(0xFF063D36)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF04201D).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with Edit Icon
              Stack(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F9D58),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        if (authCtrl != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfileView(authController: authCtrl),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(3.5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: Color(0xFF0F9D58), size: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Patient Name & Badges
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        // Blood Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            'Blood: $bloodGroup',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFA7F3D0),
                            ),
                          ),
                        ),
                        // Edit Profile Button
                        InkWell(
                          onTap: () {
                            if (authCtrl != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditProfileView(authController: authCtrl),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.edit_note_rounded, color: Colors.white, size: 12),
                                const SizedBox(width: 2),
                                Text(
                                  isBangla ? 'এডিট' : 'Edit',
                                  style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Contact Details
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, size: 12, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            email,
                            style: const TextStyle(fontSize: 11, color: Color(0xFFCBD5E1)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.phone_outlined, size: 12, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            phone,
                            style: const TextStyle(fontSize: 11, color: Color(0xFFCBD5E1)),
                            maxLines: 1,
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

          const SizedBox(height: 12),
          Divider(color: Colors.white.withValues(alpha: 0.15), height: 1),
          const SizedBox(height: 10),

          // Sub Badges Row: Package & Wallet Points
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_user_outlined, size: 13, color: Color(0xFF6EE7B7)),
                  const SizedBox(width: 4),
                  Text(
                    '${isBangla ? "প্যাকেজ:" : "Package:"} ',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                  Text(
                    package,
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF6EE7B7)),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stars_rounded, size: 13, color: Color(0xFFFDE047)),
                  const SizedBox(width: 4),
                  Text(
                    '${isBangla ? "ওয়ালেট:" : "Wallet:"} ',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                  Text(
                    '$points Points',
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFFFDE047)),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Quick Action Buttons Row (Matching Web Portal Header)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildHeaderActionButton(
                  icon: Icons.video_call_rounded,
                  label: isBangla ? 'ডাক্তার দেখান (ভিডিও)' : 'Video Doctor',
                  color: const Color(0xFF0F9D58),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DoctorListView()),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildHeaderActionButton(
                  icon: Icons.qr_code_scanner_rounded,
                  label: isBangla ? 'QR স্ক্যান' : 'QR Scan',
                  color: const Color(0xFF0284C7),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isBangla ? 'QR স্ক্যানার শীঘ্রই আসবে!' : 'QR Scanner coming soon!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildHeaderActionButton(
                  icon: Icons.card_membership_rounded,
                  label: isBangla ? 'প্যাকেজ / রিচার্জ' : 'Packages / Recharge',
                  color: const Color(0xFFD97706),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OfferListView(
                          showAppBar: true,
                          languageController: _langController,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildHeaderActionButton(
                  icon: Icons.add_circle_outline_rounded,
                  label: isBangla ? 'নতুন সিরিয়াল নিন' : 'Book New Serial',
                  color: const Color(0xFF10B981),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DoctorListView()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: Colors.white),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Live Health Vitals Card & Graph
  Widget _buildHealthVitalsCard(bool isBangla) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Row
          Row(
            children: [
              const Icon(Icons.show_chart_rounded, color: Color(0xFF0F9D58), size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isBangla ? 'রক্তচাপ ও স্বাস্থ্য ভাইটাল হিস্ট্রি' : 'Health Vitals History',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),

              // Entry Button (Tapping opens Add Vital Record Dialog)
              GestureDetector(
                onTap: () => _showAddVitalDialog(isBangla),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add, size: 13, color: Color(0xFF0F9D58)),
                      const SizedBox(width: 2),
                      Text(
                        isBangla ? 'এন্ট্রি দিন' : 'Add Entry',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F9D58),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Vitals Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildVitalTabChip('রক্তচাপ (BP)', 0),
                const SizedBox(width: 8),
                _buildVitalTabChip('সুগার (Glucose)', 1),
                const SizedBox(width: 8),
                _buildVitalTabChip('পালস (Pulse)', 2),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 3 Metric Cards Row (Reactive to calculated state)
          Row(
            children: [
              Expanded(
                child: _buildMetricMiniCard(
                  title: 'রক্তচাপ (BP)',
                  value: '$_systolic/$_diastolic',
                  unit: 'mmHg',
                  status: _bpStatusInfo['status'] as String,
                  statusColor: _bpStatusInfo['color'] as Color,
                  bgColor: _bpStatusInfo['bg'] as Color,
                  borderColor: _bpStatusInfo['border'] as Color,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildMetricMiniCard(
                  title: 'ডায়াবেটিস',
                  value: _glucose.toStringAsFixed(1),
                  unit: 'mmol/L',
                  status: _glucoseStatusInfo['status'] as String,
                  statusColor: _glucoseStatusInfo['color'] as Color,
                  bgColor: _glucoseStatusInfo['bg'] as Color,
                  borderColor: _glucoseStatusInfo['border'] as Color,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildMetricMiniCard(
                  title: 'হার্ট রেট',
                  value: '$_pulse',
                  unit: 'BPM',
                  status: _pulseStatusInfo['status'] as String,
                  statusColor: _pulseStatusInfo['color'] as Color,
                  bgColor: _pulseStatusInfo['bg'] as Color,
                  borderColor: _pulseStatusInfo['border'] as Color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Visual Vitals Trend Chart Representation (Dynamic wave flow based on BP, Glucose, Pulse)
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: CustomPaint(
              painter: VitalsChartPainter(
                selectedTab: _selectedVitalTab,
                systolic: _systolic,
                diastolic: _diastolic,
                glucose: _glucose,
                pulse: _pulse,
              ),
              child: Container(),
            ),
          ),
          const SizedBox(height: 6),

          // Chart Date Labels
          const FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('01 Aug', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                SizedBox(width: 8),
                Text('02 Aug', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                SizedBox(width: 8),
                Text('03 Aug', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                SizedBox(width: 8),
                Text('04 Aug', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                SizedBox(width: 8),
                Text('05 Aug', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                SizedBox(width: 8),
                Text('06 Aug', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                SizedBox(width: 8),
                Text('07 Aug', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalTabChip(String title, int index) {
    final bool isSelected = _selectedVitalTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVitalTab = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F9D58) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF0F9D58) : const Color(0xFFCBD5E1),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  // Add New Health Vital Record Dialog Popup (Web Matching UI)
  void _showAddVitalDialog(bool isBangla) {
    final TextEditingController systolicController = TextEditingController(text: '120');
    final TextEditingController diastolicController = TextEditingController(text: '80');
    final TextEditingController glucoseController = TextEditingController(text: '5.8');
    final TextEditingController pulseController = TextEditingController(text: '72');

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.show_chart_rounded, color: Color(0xFF0F9D58), size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isBangla ? 'নতুন হেলথ ভাইটাল রেকর্ড যুক্ত করুন' : 'Add New Health Vital Record',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Text(
                    isBangla ? 'রক্তচাপ Systolic / Diastolic (mmHg)' : 'Blood Pressure Systolic / Diastolic (mmHg)',
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(child: _buildDialogInput(controller: systolicController, hint: '120')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildDialogInput(controller: diastolicController, hint: '80')),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    isBangla ? 'ডায়াবেটিস / সুগার লেভেল (mmol/L)' : 'Diabetes / Sugar Level (mmol/L)',
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                  ),
                  const SizedBox(height: 6),
                  _buildDialogInput(controller: glucoseController, hint: '5.8'),
                  const SizedBox(height: 16),

                  Text(
                    isBangla ? 'হার্ট রেট / পালস (BPM)' : 'Heart Rate / Pulse (BPM)',
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                  ),
                  const SizedBox(height: 6),
                  _buildDialogInput(controller: pulseController, hint: '72'),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            isBangla ? 'বাতিল' : 'Cancel',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final int newSystolic = int.tryParse(systolicController.text.trim()) ?? _systolic;
                            final int newDiastolic = int.tryParse(diastolicController.text.trim()) ?? _diastolic;
                            final double newGlucose = double.tryParse(glucoseController.text.trim()) ?? _glucose;
                            final int newPulse = int.tryParse(pulseController.text.trim()) ?? _pulse;

                            setState(() {
                              _systolic = newSystolic;
                              _diastolic = newDiastolic;
                              _glucose = newGlucose;
                              _pulse = newPulse;
                            });

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isBangla ? 'নতুন হেলথ ভাইটাল রেকর্ড সংরক্ষিত ও চার্ট আপডেট হয়েছে!' : 'Health Vitals record saved and chart updated!',
                                ),
                                backgroundColor: const Color(0xFF0F9D58),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F9D58),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            isBangla ? 'সেভ করুন' : 'Save Record',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogInput({required TextEditingController controller, required String hint}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.normal),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildMetricMiniCard({
    required String title,
    required String value,
    required String unit,
    required String status,
    required Color statusColor,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                ),
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: statusColor.withValues(alpha: 0.5)),
            ),
            child: Text(
              status,
              style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: statusColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // --- List Data Generators for Detail Screens ---

  List<Widget> _buildSerialsAndAppointmentsList(bool isBangla) {
    return [
      _buildAppointmentCardItem(
        serialNo: 'SERIAL-20260804-99812',
        status: 'কনফার্মড',
        statusBg: const Color(0xFFE0F2FE),
        statusColor: const Color(0xFF0284C7),
        paymentStatus: 'পেমেন্ট: ভেরিফাইড',
        doctorName: 'অধ্যাপক ড. এ. কে. এম. ফজলে রাব্বি',
        specialty: 'হৃদরোগ ও মেডিসিন বিশেষজ্ঞ • পপুলার ডায়াগনস্টিক সেন্টার, ধানমন্ডি, ঢাকা',
        time: 'আজ, বিকাল ০৪:৩০ PM',
        buttonText: 'ডিজিটাল সিরিয়াল স্লিপ',
        buttonColor: const Color(0xFF0F9D58),
        icon: Icons.confirmation_number_outlined,
      ),
      const SizedBox(height: 12),
      _buildAppointmentCardItem(
        serialNo: 'APT-20260804-88192',
        status: 'ডাক্তার প্রস্তুত আছেন (সিরিয়াল: #১)',
        statusBg: const Color(0xFFDCFCE7),
        statusColor: const Color(0xFF16A34A),
        doctorName: 'Dr. Tanvir Hasan',
        specialty: 'অর্থোপেডিক সার্জারি • মেডিসেবা ডিজিটাল চেম্বার (অনলাইন)',
        buttonText: 'HD ভিডিও কল',
        buttonColor: const Color(0xFFED1C24),
        icon: Icons.videocam_rounded,
      ),
      const SizedBox(height: 12),
      _buildAppointmentCardItem(
        serialNo: 'SERIAL-20260802-77123',
        status: 'কনফার্মড',
        statusBg: const Color(0xFFE0F2FE),
        statusColor: const Color(0xFF0284C7),
        paymentStatus: 'পেমেন্ট: পেইড',
        doctorName: 'ডা. শারমিন আক্তার',
        specialty: 'স্ত্রী রোগ ও প্রসূতি বিদ্যা বিশেষজ্ঞ • ল্যাবএইড স্পেশালাইজড হাসপাতাল',
        time: 'আগামীকাল, সকাল ১১:০০ AM',
        buttonText: 'ডিজিটাল সিরিয়াল স্লিপ',
        buttonColor: const Color(0xFF0F9D58),
        icon: Icons.confirmation_number_outlined,
      ),
      const SizedBox(height: 12),
      _buildAppointmentCardItem(
        serialNo: 'APT-20260801-66512',
        status: 'সম্পন্ন',
        statusBg: const Color(0xFFF1F5F9),
        statusColor: const Color(0xFF64748B),
        doctorName: 'ডা. মোঃ আরিফুল ইসলাম',
        specialty: 'চর্ম ও যৌন রোগ বিশেষজ্ঞ • মেডিসেবা অনলাইন চেম্বার',
        buttonText: 'প্রেসক্রিপশন দেখুন',
        buttonColor: const Color(0xFF0284C7),
        icon: Icons.description_outlined,
      ),
    ];
  }

  Widget _buildAppointmentCardItem({
    required String serialNo,
    required String status,
    required Color statusBg,
    required Color statusColor,
    String? paymentStatus,
    required String doctorName,
    required String specialty,
    String? time,
    required String buttonText,
    required Color buttonColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              Text(
                serialNo,
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
              ),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                  ),
                  if (paymentStatus != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        paymentStatus,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            doctorName,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 3),
          Text(
            specialty,
            style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
          ),
          if (time != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF0F9D58)),
                const SizedBox(width: 4),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F9D58)),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              icon: Icon(icon, size: 16),
              label: Text(buttonText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDigitalPrescriptionsList(bool isBangla) {
    return [
      _buildPrescriptionItemCard(
        rxId: 'RX-20260804-8819',
        doctorName: 'Dr. Tanvir Hasan',
        disease: 'Acute Knee Joint Inflammation',
        date: '04 Aug 2026',
      ),
      const SizedBox(height: 10),
      _buildPrescriptionItemCard(
        rxId: 'RX-20260728-4412',
        doctorName: 'অধ্যাপক ড. এ. কে. এম. ফজলে রাব্বি',
        disease: 'Hypertension & Cardiac Care Routine',
        date: '28 Jul 2026',
      ),
      const SizedBox(height: 10),
      _buildPrescriptionItemCard(
        rxId: 'RX-20260715-3398',
        doctorName: 'ডা. শারমিন আক্তার',
        disease: 'Antenatal Routine Medication',
        date: '15 Jul 2026',
      ),
      const SizedBox(height: 10),
      _buildPrescriptionItemCard(
        rxId: 'RX-20260630-1102',
        doctorName: 'ডা. মোঃ আরিফুল ইসলাম',
        disease: 'Allergic Dermatitis Treatment',
        date: '30 Jun 2026',
      ),
    ];
  }

  Widget _buildPrescriptionItemCard({
    required String rxId,
    required String doctorName,
    required String disease,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  rxId,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(date, style: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8))),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            doctorName,
            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 2),
          Text(
            disease,
            style: const TextStyle(fontSize: 12, color: Color(0xFFD97706), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    side: const BorderSide(color: Color(0xFF0F9D58)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.print_outlined, size: 15, color: Color(0xFF0F9D58)),
                  label: const Text('প্রিন্ট / A4', style: TextStyle(fontSize: 12, color: Color(0xFF0F9D58), fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F9D58),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.download_rounded, size: 15),
                  label: const Text('১-ক্লিক PDF', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMedicalRecordsList(bool isBangla) {
    return [
      _buildLabReportItem(
        category: 'Blood Test',
        title: 'CBC & Blood Sugar Lab Report',
        fileName: 'CBC_Report_Aug2026.pdf',
        date: '02 Aug 2026',
        bgColor: const Color(0xFFE0F2FE),
        textColor: const Color(0xFF0284C7),
      ),
      const SizedBox(height: 10),
      _buildLabReportItem(
        category: 'X-Ray',
        title: 'Chest X-Ray Digital Scan',
        fileName: 'Chest_XRay_July2026.png',
        date: '28 Jul 2026',
        bgColor: const Color(0xFFF3E8FF),
        textColor: const Color(0xFF7E22CE),
      ),
      const SizedBox(height: 10),
      _buildLabReportItem(
        category: 'ECG Test',
        title: 'Cardiac Rhythm & ECG Report',
        fileName: 'ECG_July2026.pdf',
        date: '15 Jul 2026',
        bgColor: const Color(0xFFDCFCE7),
        textColor: const Color(0xFF16A34A),
      ),
      const SizedBox(height: 10),
      _buildLabReportItem(
        category: 'Ultrasound',
        title: 'USG Abdomen Scan Report',
        fileName: 'USG_Report_June2026.pdf',
        date: '10 Jun 2026',
        bgColor: const Color(0xFFFEF3C7),
        textColor: const Color(0xFFD97706),
      ),
    ];
  }

  Widget _buildLabReportItem({
    required String category,
    required String title,
    required String fileName,
    required String date,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(category, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textColor)),
                ),
                const SizedBox(height: 6),
                Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                const SizedBox(height: 3),
                Text('$fileName • $date', style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Color(0xFF0F9D58), size: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPaymentHistoryList(bool isBangla) {
    return [
      _buildPaymentItem(
        txnId: 'BKASH-99120491',
        title: 'চেম্বার সিরিয়াল ফি (ডা. ফজলে রাব্বি)',
        amount: '৳ 1500 • bKash Merchant',
        isPaid: true,
      ),
      const SizedBox(height: 10),
      _buildPaymentItem(
        txnId: 'NAGAD-88492019',
        title: 'ভিডিও কনসালটেশন ফি (Dr. Tanvir)',
        amount: '৳ 1000 • Nagad Online',
        isPaid: true,
      ),
      const SizedBox(height: 10),
      _buildPaymentItem(
        txnId: 'BKASH-77129034',
        title: 'মেডিসিন শপ ও প্রেসক্রিপশন অর্ডার',
        amount: '৳ 850 • MediShop Express',
        isPaid: true,
      ),
      const SizedBox(height: 10),
      _buildPaymentItem(
        txnId: 'BKASH-66364798',
        title: 'ল্যাব টেস্ট হোম কালেকশন',
        amount: '৳ 1200 • bKash Merchant',
        isPaid: true,
      ),
    ];
  }

  Widget _buildPaymentItem({
    required String txnId,
    required String title,
    required String amount,
    required bool isPaid,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(txnId, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Paid', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                const SizedBox(height: 2),
                Text(amount, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.receipt_outlined, size: 15, color: Color(0xFF0F9D58)),
            label: const Text('মেমো', style: TextStyle(fontSize: 11.5, color: Color(0xFF0F9D58), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActivityLogList(bool isBangla) {
    return [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            _buildActivityLogTile(
              icon: Icons.check_circle_outline,
              iconColor: const Color(0xFF10B981),
              title: 'BKASH পেমেন্ট সম্পন্ন হয়েছে',
              subtitle: '৳ 1000 (TxnID: BKASH-66364798)',
              time: '০৭:৫২ PM',
            ),
            const Divider(height: 16, color: Color(0xFFF1F5F9)),
            _buildActivityLogTile(
              icon: Icons.calendar_today_outlined,
              iconColor: const Color(0xFF0284C7),
              title: 'চেম্বার সিরিয়াল বুক করা হয়েছে',
              subtitle: 'অধ্যাপক ড. এ. কে. এম. ফজলে রাব্বি (ধানমন্ডি)',
              time: '০৪:৫০ PM',
            ),
            const Divider(height: 16, color: Color(0xFFF1F5F9)),
            _buildActivityLogTile(
              icon: Icons.payment_rounded,
              iconColor: const Color(0xFF6366F1),
              title: 'bKash পেমেন্ট সম্পন্ন হয়েছে',
              subtitle: '৳ ১,৫০০ (TxnID: BKASH-99120491)',
              time: '০৭:১৮ PM',
            ),
            const Divider(height: 16, color: Color(0xFFF1F5F9)),
            _buildActivityLogTile(
              icon: Icons.upload_file_rounded,
              iconColor: const Color(0xFF8B5CF6),
              title: 'ল্যাব রিপোর্ট আপলোড করা হয়েছে',
              subtitle: 'CBC & Blood Sugar Lab Report.pdf',
              time: 'সকাল ১১:৪৫ AM',
            ),
            const Divider(height: 16, color: Color(0xFFF1F5F9)),
            _buildActivityLogTile(
              icon: Icons.assignment_outlined,
              iconColor: const Color(0xFFEC4899),
              title: 'নতুন প্রেসক্রিপশন গ্রহণ করা হয়েছে',
              subtitle: 'Dr. Tanvir Hasan (Acute Knee Joint)',
              time: 'গতকাল',
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildActivityLogTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              Text(subtitle, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
            ],
          ),
        ),
        Text(time, style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8))),
      ],
    );
  }
}

// Standalone Patient Portal Detail Sub-Screen Page (Clean App Bar without Icon & Subtitle)
class PatientPortalDetailView extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const PatientPortalDetailView({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: CustomAppBar(
        title: title,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...children,
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// Custom Dynamic Vitals Trend Wave Line Chart Painter
class VitalsChartPainter extends CustomPainter {
  final int selectedTab;
  final int systolic;
  final int diastolic;
  final double glucose;
  final int pulse;

  VitalsChartPainter({
    required this.selectedTab,
    required this.systolic,
    required this.diastolic,
    required this.glucose,
    required this.pulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedTab == 0) {
      final double sysNorm = ((systolic - 90) / (180 - 90)).clamp(0.1, 0.9);
      final double diaNorm = ((diastolic - 50) / (120 - 50)).clamp(0.1, 0.9);

      final paintFill = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF10B981).withValues(alpha: 0.3),
            const Color(0xFF10B981).withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;

      final paintLine = Paint()
        ..color = const Color(0xFF10B981)
        ..strokeWidth = 2.8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path();
      final h1 = size.height * (1.0 - (sysNorm * 0.65 + 0.15));
      path.moveTo(0, h1 + 10);
      path.cubicTo(size.width * 0.2, h1 - 15, size.width * 0.4, h1 + 20, size.width * 0.6, h1 - 10);
      path.cubicTo(size.width * 0.8, h1 - 25, size.width * 0.9, h1 + 15, size.width, h1);

      final pathFill = Path.from(path);
      pathFill.lineTo(size.width, size.height);
      pathFill.lineTo(0, size.height);
      pathFill.close();

      canvas.drawPath(pathFill, paintFill);
      canvas.drawPath(path, paintLine);

      final paintBase = Paint()
        ..color = const Color(0xFF0284C7)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      final h2 = size.height * (1.0 - (diaNorm * 0.45 + 0.1));
      final basePath = Path();
      basePath.moveTo(0, h2 + 8);
      basePath.cubicTo(size.width * 0.25, h2 - 10, size.width * 0.6, h2 + 12, size.width, h2 - 5);
      canvas.drawPath(basePath, paintBase);

    } else if (selectedTab == 1) {
      final double glucNorm = ((glucose - 3.0) / (12.0 - 3.0)).clamp(0.1, 0.9);

      final paintFill = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0284C7).withValues(alpha: 0.3),
            const Color(0xFF0284C7).withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;

      final paintLine = Paint()
        ..color = const Color(0xFF0284C7)
        ..strokeWidth = 2.8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final h = size.height * (1.0 - (glucNorm * 0.65 + 0.15));
      final path = Path();
      path.moveTo(0, h + 15);
      path.cubicTo(size.width * 0.25, h - 20, size.width * 0.5, h + 25, size.width * 0.75, h - 15);
      path.lineTo(size.width, h);

      final pathFill = Path.from(path);
      pathFill.lineTo(size.width, size.height);
      pathFill.lineTo(0, size.height);
      pathFill.close();

      canvas.drawPath(pathFill, paintFill);
      canvas.drawPath(path, paintLine);

    } else {
      final double pulseNorm = ((pulse - 40) / (130 - 40)).clamp(0.1, 0.9);

      final paintFill = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFE11D48).withValues(alpha: 0.3),
            const Color(0xFFE11D48).withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;

      final paintLine = Paint()
        ..color = const Color(0xFFE11D48)
        ..strokeWidth = 2.6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final h = size.height * (1.0 - (pulseNorm * 0.55 + 0.2));
      final path = Path();
      path.moveTo(0, h);
      path.lineTo(size.width * 0.15, h);
      path.lineTo(size.width * 0.2, h - 35 * pulseNorm);
      path.lineTo(size.width * 0.25, h + 20 * pulseNorm);
      path.lineTo(size.width * 0.3, h);
      path.lineTo(size.width * 0.5, h);
      path.lineTo(size.width * 0.55, h - 40 * pulseNorm);
      path.lineTo(size.width * 0.6, h + 25 * pulseNorm);
      path.lineTo(size.width * 0.65, h);
      path.lineTo(size.width * 0.85, h);
      path.lineTo(size.width * 0.9, h - 30 * pulseNorm);
      path.lineTo(size.width, h);

      final pathFill = Path.from(path);
      pathFill.lineTo(size.width, size.height);
      pathFill.lineTo(0, size.height);
      pathFill.close();

      canvas.drawPath(pathFill, paintFill);
      canvas.drawPath(path, paintLine);
    }
  }

  @override
  bool shouldRepaint(covariant VitalsChartPainter oldDelegate) {
    return oldDelegate.selectedTab != selectedTab ||
        oldDelegate.systolic != systolic ||
        oldDelegate.diastolic != diastolic ||
        oldDelegate.glucose != glucose ||
        oldDelegate.pulse != pulse;
  }
}
