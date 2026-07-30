import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../doctor_bari/doctor_bari_view.dart';
import '../profile/profile_view.dart';
import '../doctors/doctor_list_view.dart';
import '../about/about_us_view.dart';
import '../social/social_media_view.dart';
import '../health_consultation/health_consultation_view.dart';
import '../../widgets/share_app_dialog.dart';
import '../../widgets/helpline_bottom_sheet.dart';
import '../../widgets/modern_glow_navbar.dart';
import '../notifications/notification_view.dart';
import '../offers/offer_list_view.dart';
import '../hospitals/hospital_list_view.dart';
import '../more/more_menu_view.dart';
import 'widgets/service_tile_card.dart';

class HomeView extends StatefulWidget {
  final HomeController homeController;
  final AuthController authController;

  const HomeView({
    super.key,
    required this.homeController,
    required this.authController,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentBottomNavIndex = 0;
  int _currentBannerIndex = 0;
  final PageController _bannerPageController = PageController();

  bool _isLanguageExpanded = false;
  String _selectedLanguage = 'Bangla';

  static const brandGreen = Color(0xFF009245);
  static const textDark = Color(0xFF222222);
  static const textMuted = Color(0xFF777777);
  static const cardBg = Color(0xFFF8FAFC);

  @override
  void dispose() {
    _bannerPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildSidebarDrawer(context),
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _currentBottomNavIndex == 0
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 16,
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 44,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu_rounded, color: brandGreen, size: 28),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
      body: IndexedStack(
        index: _currentBottomNavIndex,
        children: [
          // Tab 0: Home Content
          _buildHomeBodyContent(),
          // Tab 1: Offer List View
          const OfferListView(),
          // Tab 2: Hospital List View
          const HospitalListView(),
          // Tab 3: Doctor List View
          const DoctorListView(showAppBar: false),
          // Tab 4: More Menu View
          MoreMenuView(
            authController: widget.authController,
            homeController: widget.homeController,
          ),
        ],
      ),
      bottomNavigationBar: ModernGlowNavBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() => _currentBottomNavIndex = index);
        },
        items: const [
          ModernGlowNavBarItem(icon: Icons.home_rounded, label: 'Home'),
          ModernGlowNavBarItem(icon: Icons.local_offer_rounded, label: 'Offers'),
          ModernGlowNavBarItem(icon: Icons.apartment_rounded, label: 'Hospitals'),
          ModernGlowNavBarItem(icon: Icons.person_rounded, label: 'Doctors'),
          ModernGlowNavBarItem(icon: Icons.more_horiz_rounded, label: 'More'),
        ],
      ),
    );
  }

  // Home Screen Center Scroll Body with Cyan Header Container
  Widget _buildHomeBodyContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Soft Cyan Header Container
          _buildTopCyanHeader(),

          const SizedBox(height: 18),

          // 2. 8 Service Grid Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildCategoryGrid(),
          ),

          const SizedBox(height: 20),

          // 2. Banner Slider Carousel
          _buildHeroBanner(),

          const SizedBox(height: 16),

          // 3. Health Query Banner
          _buildQueryBanner(),

          const SizedBox(height: 24),

          // 4. Top Doctors Section Header
          _buildSectionHeader(
            title: 'Top Doctors In Your Area',
            onSeeAllTap: () {
              setState(() => _currentBottomNavIndex = 3);
            },
          ),
          const SizedBox(height: 12),

          // Doctor List
          _buildDoctorItem(
            name: 'Dr. Billy',
            specialty: 'GP-general practitioner',
            time: '07:00 am - 09:30 pm',
            isSponsor: true,
            imageUrl:
                'https://img.freepik.com/free-photo/doctor-offering-medical-teleconsultation_23-2149329007.jpg',
          ),
          _buildDoctorItem(
            name: 'Dr. Billy',
            specialty: 'GP-general practitioner',
            time: '07:00 am - 09:30 pm',
            isSponsor: true,
            imageUrl:
                'https://img.freepik.com/free-photo/female-doctor-hospital-with-stethoscope_23-2148827766.jpg',
          ),
          _buildDoctorItem(
            name: 'Dr. Billy',
            specialty: 'GP-general practitioner',
            time: '07:00 am - 09:30 pm',
            isSponsor: false,
            imageUrl:
                'https://img.freepik.com/free-photo/woman-doctor-wearing-stethoscope_23-2148827768.jpg',
          ),

          const SizedBox(height: 24),

          // 5. Nearby Hospitals Section Header
          _buildSectionHeader(
            title: 'Nearby Hospitals',
            onSeeAllTap: () {
              setState(() => _currentBottomNavIndex = 2);
            },
          ),
          const SizedBox(height: 12),

          // Hospitals Grid (Responsive Grid)
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final crossAxisCount = screenWidth > 600 ? 3 : 2;
              final aspectRatio = screenWidth > 600
                  ? 0.95
                  : (screenWidth < 360 ? 0.82 : 0.92);

              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: aspectRatio,
                children: [
                  _buildHospitalCard(
                    name: 'Popular Diagonistic',
                    address: 'Street Address',
                    time: '07:00 am - 15:30 pm',
                    imageUrl:
                        'https://img.freepik.com/free-photo/empty-emergency-room-with-medical-equipment_23-2149138092.jpg',
                  ),
                  _buildHospitalCard(
                    name: 'Popular Diagonistic',
                    address: 'Street Address',
                    time: '07:00 am - 15:30 pm',
                    imageUrl:
                        'https://img.freepik.com/free-photo/modern-operating-room-hospital_23-2148942918.jpg',
                  ),
                  _buildHospitalCard(
                    name: 'Popular Diagonistic',
                    address: 'Street Address',
                    time: '07:00 am - 15:30 pm',
                    imageUrl:
                        'https://img.freepik.com/free-photo/interior-view-operating-room_1170-2254.jpg',
                  ),
                  _buildHospitalCard(
                    name: 'Popular Diagonistic',
                    address: 'Street Address',
                    time: '07:00 am - 15:30 pm',
                    imageUrl:
                        'https://img.freepik.com/free-photo/medical-clinic-reception-counter-registration_482257-26804.jpg',
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning, 👋';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon, 👋';
    } else {
      return 'Good Evening, 👋';
    }
  }

  // 1. Top Soft Cyan Header Section matching reference image
  Widget _buildTopCyanHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFE2F4F2), // Exact soft mint cyan tint from design mockup
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Greeting + Bell + Profile + Drawer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 2-Line Dynamic Time-Based Greeting Layout (Wrapped in Expanded for overflow safety)
                Expanded(
                  child: ListenableBuilder(
                    listenable: widget.authController,
                    builder: (context, _) {
                      final uData = widget.authController.currentUserData;
                      final userName = (uData?.name != null && uData!.name.trim().isNotEmpty)
                          ? uData.name
                          : 'Basic Learner';
                      final greetingSubtitle = _getTimeBasedGreeting();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Line 1: Top Subtitle (Time-based Greeting)
                          Text(
                            greetingSubtitle,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Line 2: Bottom Title (User Name)
                          Text(
                            userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),

                // Top Actions Right (3 Uniform 40x40 Action Containers)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. Notification Bell Button (40x40)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NotificationView()),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.notifications_none_rounded,
                              color: Color(0xFF0F172A),
                              size: 22,
                            ),
                            Positioned(
                              top: 9,
                              right: 10,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // 2. User Profile Avatar Button (40x40)
                    ListenableBuilder(
                      listenable: widget.authController,
                      builder: (context, _) {
                        final uData = widget.authController.currentUserData;
                        final profileImg = uData?.profileImageUrl;
                        final hasImage = profileImg != null && profileImg.isNotEmpty;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfileView(
                                  authController: widget.authController,
                                  homeController: widget.homeController,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              image: hasImage
                                  ? DecorationImage(
                                      image: NetworkImage(profileImg),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: !hasImage
                                ? const CircleAvatar(
                                    backgroundColor: Color(0xFFCBD5E1),
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: Color(0xFF334155),
                                      size: 20,
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),

                    const SizedBox(width: 8),

                    // 3. Hamburger Menu Button (40x40)
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () => Scaffold.of(context).openEndDrawer(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.menu_rounded,
                              color: Color(0xFF0F172A),
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Row 2: Search Bar Input Widget
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DoctorListView(showAppBar: true),
                  ),
                );
              },
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: Color(0xFF64748B),
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Doctors, Medicine, or Services',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Row 3: 24/7 Teleconsultation Banner Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DoctorBariView()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    // Green Avatar Box
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A884),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00A884).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '24/7 Teleconsultation &\nExpress Healthcare',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                              height: 1.2,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Connect with medical professionals instantly.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF475569),
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Category Grid — 8 Vibrant Service Cards matching reference image
  Widget _buildCategoryGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.45,
      children: [
        ServiceTileCard(
          title: 'Doctor\nSerial',
          svgPath: 'assets/icons/doctor_serial.svg',
          backgroundColor: const Color(0xFF00A884),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DoctorListView()),
            );
          },
        ),
        ServiceTileCard(
          title: 'Doctor Home/\nTeleconsult',
          svgPath: 'assets/icons/doctor_home.svg',
          backgroundColor: const Color(0xFFE53935),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DoctorBariView()),
            );
          },
        ),
        ServiceTileCard(
          title: 'MediShop',
          svgPath: 'assets/icons/medishop.svg',
          backgroundColor: const Color(0xFF475569),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HealthConsultationView(),
              ),
            );
          },
        ),
        ServiceTileCard(
          title: 'Blood\nDonation',
          svgPath: 'assets/icons/blood_donation.svg',
          backgroundColor: const Color(0xFFD32F2F),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const HelplineBottomSheet(),
            );
          },
        ),
        ServiceTileCard(
          title: 'Special\nDiscounts',
          svgPath: 'assets/icons/special_discounts.svg',
          backgroundColor: const Color(0xFF00A884),
          onTap: () {
            setState(() => _currentBottomNavIndex = 1);
          },
        ),
        ServiceTileCard(
          title: 'Emergency\nAmbulance',
          svgPath: 'assets/icons/ambulance.svg',
          backgroundColor: const Color(0xFF475569),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const HelplineBottomSheet(),
            );
          },
        ),
        ServiceTileCard(
          title: 'Maternal &\nChild Care',
          svgPath: 'assets/icons/maternal_care.svg',
          backgroundColor: const Color(0xFF475569),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DoctorBariView()),
            );
          },
        ),
        ServiceTileCard(
          title: '24/7 Customer\nSupport',
          svgPath: 'assets/icons/customer_support.svg',
          backgroundColor: const Color(0xFF78350F),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const HelplineBottomSheet(),
            );
          },
        ),
      ],
    );
  }


  // Hero Banner Slider Card (5 sliding banner pages 100% pixel-matched)
  Widget _buildHeroBanner() {
    return Column(
      children: [
        SizedBox(
          height: 155,
          child: PageView.builder(
            controller: _bannerPageController,
            itemCount: 5,
            onPageChanged: (index) {
              setState(() => _currentBannerIndex = index);
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Image.asset(
                  'assets/images/perfect_hero_banner.png',
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),

        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final isSelected = _currentBannerIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isSelected ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isSelected ? brandGreen : const Color(0xFFDDDDDD),
              ),
            );
          }),
        ),
      ],
    );
  }

  // Health Query Banner (Interactive Banner with larger Proceed button and tap effect)
  Widget _buildQueryBanner() {
    return const _QueryBannerCard();
  }

  // Section Header Component
  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onSeeAllTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        GestureDetector(
          onTap: onSeeAllTap,
          child: const Text(
            'See All',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: brandGreen,
            ),
          ),
        ),
      ],
    );
  }

  // Doctor List Item Card
  Widget _buildDoctorItem({
    required String name,
    required String specialty,
    required String time,
    required bool isSponsor,
    required String imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 70,
                height: 70,
                color: const Color(0xFFE2E8F0),
                child: const Icon(Icons.person, color: textMuted),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    if (isSponsor)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: brandGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Sponsor',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  specialty,
                  style: const TextStyle(fontSize: 11.5, color: textMuted),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: brandGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 11, color: textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Hospital Grid Card Item
  Widget _buildHospitalCard({
    required String name,
    required String address,
    required String time,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  imageUrl,
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 90,
                    color: const Color(0xFFE2E8F0),
                    child: const Icon(Icons.local_hospital, color: textMuted),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: brandGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Sponsor',
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  address,
                  style: const TextStyle(fontSize: 10, color: textMuted),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 11,
                      color: brandGreen,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 9.5, color: textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar Drawer (Pixel-perfect matching Figma design)
  Widget _buildSidebarDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      backgroundColor: Colors.white,
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Sharp non-rounded drawer corners
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Right Close (X) Button
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF64748B),
                    size: 24,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              const SizedBox(height: 8),

              // MediSeba Logo Aligned to Left (Matching card left alignment)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // 1. About us
              _buildDrawerCard(
                icon: SvgPicture.asset(
                  'assets/images/person-lines-fill 3.svg',
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                ),
                title: 'About us',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutUsView(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              // 2. Social Media
              _buildDrawerCard(
                icon: SvgPicture.asset(
                  'assets/images/Group 1000004064.svg',
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                ),
                title: 'Social Media',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SocialMediaView(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              // 3. Share App
              _buildDrawerCard(
                icon: SvgPicture.asset(
                  'assets/images/share.svg',
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                ),
                title: 'Share App',
                onTap: () {
                  Navigator.pop(context);
                  showShareAppDialog(context);
                },
              ),
              const SizedBox(height: 14),

              // 4. Helpline (Headset Icon)
              _buildDrawerCard(
                icon: const Icon(
                  Icons.headset_mic_outlined,
                  color: Color(0xFF334155),
                  size: 22,
                ),
                title: 'Helpline',
                onTap: () {
                  Navigator.pop(context);
                  showHelplineBottomSheet(context);
                },
              ),
              const SizedBox(height: 14),

              // 5. Language Selector (Bangla / English Expandable Options)
              _buildDrawerCard(
                icon: const Icon(
                  Icons.translate_rounded,
                  color: Color(0xFF334155),
                  size: 22,
                ),
                title: _selectedLanguage,
                trailing: Icon(
                  _isLanguageExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF64748B),
                  size: 22,
                ),
                onTap: () {
                  setState(() {
                    _isLanguageExpanded = !_isLanguageExpanded;
                  });
                },
              ),
              if (_isLanguageExpanded) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildLanguageOption('Bangla', 'বাংলা (Bangla)'),
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      _buildLanguageOption('English', 'English (English)'),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildLanguageOption(String langKey, String label) {
    final isSelected = _selectedLanguage == langKey;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = langKey;
          _isLanguageExpanded = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? brandGreen : const Color(0xFF334155),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: brandGreen,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerCard({
    required Widget icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

// Health Query Banner Card with Larger Interactive Animated Proceed Button
class _QueryBannerCard extends StatefulWidget {
  const _QueryBannerCard();

  @override
  State<_QueryBannerCard> createState() => _QueryBannerCardState();
}

class _QueryBannerCardState extends State<_QueryBannerCard> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.94);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  void _navigateToHealthConsultation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HealthConsultationView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9FF7E8), Color(0xFF85E6D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF009245).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: _navigateToHealthConsultation,
          borderRadius: BorderRadius.circular(18),
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                // Illustration
                SizedBox(
                  width: 125,
                  height: 105,
                  child: Image.asset(
                    'assets/images/query_people.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/perfect_query_banner.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Text & Button Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'স্বাস্থ্য বিষয়ক জিজ্ঞাসা',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'We will answer you in 48 hours',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF334155).withValues(alpha: 0.75),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Interactive Larger Proceed Button
                      GestureDetector(
                        onTapDown: _onTapDown,
                        onTapUp: (d) {
                          _onTapUp(d);
                          _navigateToHealthConsultation();
                        },
                        onTapCancel: _onTapCancel,
                        child: AnimatedScale(
                          scale: _scale,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeInOut,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F9D58),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0F9D58).withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Proceed',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
