import 'package:flutter/material.dart';
import '../../widgets/service_card_widget.dart';
import '../../views/doctors/doctor_list_view.dart';
import '../../views/health_consultation/health_consultation_view.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback? onDoctorTap;
  final VoidCallback? onConsultTap;
  final String userName;
  final String? profileImgUrl;

  const HomeTab({
    super.key,
    this.onDoctorTap,
    this.onConsultTap,
    this.userName = 'Tanvir',
    this.profileImgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F8F7),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ─── Minty Top Header Section ───────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE2F0EC),
                    Color(0xFFEDF6F4),
                    Color(0xFFF4F8F7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // 1. Hello Greeting + Bell & Profile Photo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hello, $userName',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Row(
                        children: [
                          // Bell Notification Circle
                          Stack(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.notifications_none_rounded,
                                  color: Color(0xFF334155),
                                  size: 22,
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE11D48),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),

                          // User Circle Avatar
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              image: profileImgUrl != null && profileImgUrl!.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(profileImgUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: profileImgUrl == null || profileImgUrl!.isEmpty
                                ? const Icon(
                                    Icons.person_rounded,
                                    color: Color(0xFF0D9488),
                                    size: 24,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // 2. Pill Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Doctors, Medicine, or Services',
                        hintStyle: TextStyle(
                          fontSize: 13.5,
                          color: Color(0xFF94A3B8),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 14, right: 8),
                          child: Icon(
                            Icons.search_rounded,
                            color: Color(0xFF94A3B8),
                            size: 22,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 3. 24/7 Teleconsultation Banner Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Left Teal Doctor Icon Box
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D9488),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.health_and_safety_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Text Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                '24/7 Teleconsultation &\nExpress Healthcare',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                  height: 1.25,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Connect with medical professionals instantly.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF64748B),
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

            // ─── 8 Service Cards Grid (Matching Reference Image 100%) ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.52,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ServiceCardWidget(
                    title: 'Doctor\nSerial',
                    svgAsset: 'assets/icons/doctor_serial.svg',
                    backgroundColor: const Color(0xFF059669),
                    onTap: onDoctorTap ??
                        () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const DoctorListView()),
                            ),
                  ),
                  ServiceCardWidget(
                    title: 'Doctor Home/\nTeleconsult',
                    svgAsset: 'assets/icons/doctor_home.svg',
                    backgroundColor: const Color(0xFFE11D48),
                    onTap: onConsultTap ??
                        () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const HealthConsultationView()),
                            ),
                  ),
                  ServiceCardWidget(
                    title: 'MediShop',
                    svgAsset: 'assets/icons/medishop.svg',
                    backgroundColor: const Color(0xFF475569),
                    onTap: () {},
                  ),
                  ServiceCardWidget(
                    title: 'Blood\nDonation',
                    svgAsset: 'assets/icons/blood_donation.svg',
                    backgroundColor: const Color(0xFFBE123C),
                    onTap: () {},
                  ),
                  ServiceCardWidget(
                    title: 'Special\nDiscounts',
                    svgAsset: 'assets/icons/special_discounts.svg',
                    backgroundColor: const Color(0xFF0D9488),
                    onTap: () {},
                  ),
                  ServiceCardWidget(
                    title: 'Emergency\nAmbulance',
                    svgAsset: 'assets/icons/ambulance.svg',
                    backgroundColor: const Color(0xFF475569),
                    onTap: () {},
                  ),
                  ServiceCardWidget(
                    title: 'Maternal &\nChild Care',
                    svgAsset: 'assets/icons/maternal_care.svg',
                    backgroundColor: const Color(0xFF475569),
                    onTap: () {},
                  ),
                  ServiceCardWidget(
                    title: '24/7 Customer\nSupport',
                    svgAsset: 'assets/icons/customer_support.svg',
                    backgroundColor: const Color(0xFF854D0E),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
