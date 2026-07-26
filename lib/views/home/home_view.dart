import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../doctors/doctor_list_view.dart';
import '../doctor_bari/doctor_bari_view.dart';
import '../about/about_us_view.dart';
import '../social/social_media_view.dart';
import '../health_consultation/health_consultation_view.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            // MediSeba Logo
            Image.asset(
              'assets/images/logo.png',
              height: 38,
              fit: BoxFit.contain,
            ),
            const Spacer(),

            // Doctor Bari Button
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DoctorBariView()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: brandGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ডাক্তার ঘর',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Category 2x3 Grid Section
            _buildCategoryGrid(),

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DoctorListView()),
                );
              },
            ),
            const SizedBox(height: 12),

            // Doctor List
            _buildDoctorItem(
              name: 'Dr. Billy',
              specialty: 'GP-general practitioner',
              time: '07:00 am - 09:30 pm',
              isSponsor: true,
              imageUrl: 'https://img.freepik.com/free-photo/doctor-offering-medical-teleconsultation_23-2149329007.jpg',
            ),
            _buildDoctorItem(
              name: 'Dr. Billy',
              specialty: 'GP-general practitioner',
              time: '07:00 am - 09:30 pm',
              isSponsor: true,
              imageUrl: 'https://img.freepik.com/free-photo/female-doctor-hospital-with-stethoscope_23-2148827766.jpg',
            ),
            _buildDoctorItem(
              name: 'Dr. Harry',
              specialty: 'GP-general practitioner',
              time: '09:30 am - 12:00 pm',
              isSponsor: true,
              imageUrl: 'https://img.freepik.com/free-photo/young-handsome-physician-medical-robe-with-stethoscope_1303-17818.jpg',
            ),
            _buildDoctorItem(
              name: 'Dr. Angel',
              specialty: 'GP-general practitioner',
              time: '07:00 am - 15:30 pm',
              isSponsor: false,
              imageUrl: 'https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-crossed-arms_409827-254.jpg',
            ),

            const SizedBox(height: 24),

            // 5. Nearby Hospitals Section Header
            _buildSectionHeader(
              title: 'Nearby Hospitals',
              onSeeAllTap: () {},
            ),
            const SizedBox(height: 12),

            // Hospitals Grid (Responsive Grid)
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final crossAxisCount = screenWidth > 600 ? 3 : 2;
                final aspectRatio = screenWidth > 600 ? 0.95 : (screenWidth < 360 ? 0.82 : 0.92);

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
                      imageUrl: 'https://img.freepik.com/free-photo/empty-emergency-room-with-medical-equipment_23-2149138092.jpg',
                    ),
                    _buildHospitalCard(
                      name: 'Popular Diagonistic',
                      address: 'Street Address',
                      time: '07:00 am - 15:30 pm',
                      imageUrl: 'https://img.freepik.com/free-photo/modern-operating-room-hospital_23-2148942918.jpg',
                    ),
                    _buildHospitalCard(
                      name: 'Popular Diagonistic',
                      address: 'Street Address',
                      time: '07:00 am - 15:30 pm',
                      imageUrl: 'https://img.freepik.com/free-photo/interior-view-operating-room_1170-2254.jpg',
                    ),
                    _buildHospitalCard(
                      name: 'Popular Diagonistic',
                      address: 'Street Address',
                      time: '07:00 am - 15:30 pm',
                      imageUrl: 'https://img.freepik.com/free-photo/medical-clinic-reception-counter-registration_482257-26804.jpg',
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem('assets/images/Group 1000004073.svg', 0),
            _buildNavItem('assets/images/Group 1000004069.svg', 1),
            _buildNavItem('assets/images/Group 1000004070.svg', 2),
            _buildNavItem('assets/images/Group 1000004071.svg', 3),
            _buildNavItem('assets/images/Group 1000004072.svg', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String assetPath, int index) {
    final isSelected = _currentBottomNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _currentBottomNavIndex = index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: SvgPicture.asset(
          assetPath,
          height: 42,
          fit: BoxFit.contain,
          colorFilter: isSelected
              ? const ColorFilter.mode(brandGreen, BlendMode.srcIn)
              : const ColorFilter.mode(Color(0xFFBCBCBC), BlendMode.srcIn),
        ),
      ),
    );
  }

  // Category Grid (6 Cards 100% pixel-perfect matching Figma design, responsive across devices)
  Widget _buildCategoryGrid() {
    final perfectCardAssets = [
      'assets/images/perfect_card_1.png',
      'assets/images/perfect_card_2.png',
      'assets/images/perfect_card_3.png',
      'assets/images/perfect_card_4.png',
      'assets/images/perfect_card_5.png',
      'assets/images/perfect_card_6.png',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final crossAxisCount = screenWidth > 600 ? 3 : 2;
        final aspectRatio = screenWidth > 600 ? 1.85 : (screenWidth < 360 ? 1.85 : 2.05);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: aspectRatio,
          ),
          itemCount: perfectCardAssets.length,
          itemBuilder: (context, index) {
            final assetPath = perfectCardAssets[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DoctorListView()),
                );
              },
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
              ),
            );
          },
        );
      },
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

  // Health Query Banner (100% pixel-matched with Figma screenshot)
  Widget _buildQueryBanner() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthConsultationView()),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/perfect_query_banner.png',
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  // Section Header Component
  Widget _buildSectionHeader({required String title, required VoidCallback onSeeAllTap}) {
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
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textDark),
                    ),
                    if (isSponsor)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: brandGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Sponsor',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(specialty, style: const TextStyle(fontSize: 11.5, color: textMuted)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 13, color: brandGreen),
                    const SizedBox(width: 4),
                    Text(time, style: const TextStyle(fontSize: 11, color: textMuted)),
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: brandGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Sponsor',
                    style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.white),
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
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textDark),
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
                    const Icon(Icons.access_time_rounded, size: 11, color: brandGreen),
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
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 24),
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
                    MaterialPageRoute(builder: (context) => const AboutUsView()),
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
                    MaterialPageRoute(builder: (context) => const SocialMediaView()),
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
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 14),

              // 4. Helpline (Headset Icon)
              _buildDrawerCard(
                icon: const Icon(Icons.headset_mic_outlined, color: Color(0xFF334155), size: 22),
                title: 'Helpline',
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 14),

              // 5. Language Selector (Bangla / English Expandable Options)
              _buildDrawerCard(
                icon: const Icon(Icons.translate_rounded, color: Color(0xFF334155), size: 22),
                title: _selectedLanguage,
                trailing: Icon(
                  _isLanguageExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
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
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
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
              const Icon(Icons.check_circle_rounded, color: brandGreen, size: 18),
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
