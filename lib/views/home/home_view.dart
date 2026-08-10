import 'package:flutter/material.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../doctor_bari/doctor_bari_view.dart';
import '../doctors/doctor_list_view.dart';
import '../about/about_us_view.dart';
import '../social/social_media_view.dart';
import '../health_consultation/health_consultation_view.dart';
import '../../widgets/share_app_dialog.dart';
import '../../widgets/helpline_bottom_sheet.dart';
import '../../widgets/modern_glow_navbar.dart';
import '../blood_service/rokto_seba_view.dart';
import '../offers/offer_list_view.dart';
import '../hospitals/hospital_list_view.dart';
import '../../controllers/language_controller.dart';
import '../more/more_menu_view.dart';
import '../profile/profile_view.dart';
import '../patient_portal/patient_portal_view.dart';
import '../medishop/medishop_view.dart';

class HomeView extends StatefulWidget {
  final HomeController homeController;
  final AuthController authController;
  final LanguageController? languageController;

  const HomeView({
    super.key,
    required this.homeController,
    required this.authController,
    this.languageController,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentBottomNavIndex = 0;
  int _currentBannerIndex = 0;
  final PageController _bannerPageController = PageController();

  late final LanguageController _langController;

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
  }

  static const brandGreen = Color(0xFF008536);
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
      drawer: _buildSidebarDrawer(context),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: brandGreen, size: 28),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Image.asset(
          'assets/images/logo.png',
          height: 42,
          fit: BoxFit.contain,
        ),
        actions: [
          // User Profile Button (Switches to Profile Tab)
          ListenableBuilder(
            listenable: widget.authController,
            builder: (context, _) {
              final uData = widget.authController.currentUserData;
              final hasImage = uData?.profileImageUrl != null && uData!.profileImageUrl!.isNotEmpty;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileView(
                        authController: widget.authController,
                        homeController: widget.homeController,
                        showAppBarLeading: true,
                        languageController: _langController,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF1F5F9),
                    border: Border.all(color: brandGreen, width: 1.5),
                    image: hasImage
                        ? DecorationImage(
                            image: NetworkImage(uData.profileImageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: !hasImage
                      ? const Icon(
                          Icons.person_rounded,
                          color: brandGreen,
                          size: 20,
                        )
                      : null,
                ),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: IndexedStack(
        index: _currentBottomNavIndex,
        children: [
          // Tab 0: Home Content
          _buildHomeBodyContent(),
          // Tab 1: Offer List View
          OfferListView(languageController: _langController),
          // Tab 2: Hospital List View
          HospitalListView(languageController: _langController),
          // Tab 3: Doctor List View
          DoctorListView(showAppBar: false, languageController: _langController),
          // Tab 4: More Menu View
          MoreMenuView(
            authController: widget.authController,
            homeController: widget.homeController,
            languageController: _langController,
          ),
        ],
      ),
      bottomNavigationBar: ModernGlowNavBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() => _currentBottomNavIndex = index);
        },
        items: [
          ModernGlowNavBarItem(
            icon: Icons.home_rounded,
            label: _langController.tr('হোম', 'Home'),
          ),
          ModernGlowNavBarItem(
            icon: Icons.local_offer_rounded,
            label: _langController.tr('অফার', 'Offers'),
          ),
          ModernGlowNavBarItem(
            icon: Icons.local_hospital_rounded,
            label: _langController.tr('হাসপাতাল', 'Hospitals'),
          ),
          ModernGlowNavBarItem(
            icon: Icons.medical_services_rounded,
            label: _langController.tr('ডাক্তার', 'Doctors'),
          ),
          ModernGlowNavBarItem(
            icon: Icons.grid_view_rounded,
            label: _langController.tr('আরও', 'More'),
          ),
        ],
      ),
    );
  }

  // Home Screen Center Scroll Body
  Widget _buildHomeBodyContent() {
    return SingleChildScrollView(
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

  // Category Grid — Service Cards Matched to Reference Layout with Original Logos
  Widget _buildCategoryGrid() {
    final lang = _langController;

    final categories = [
      _CategoryItem(
        title: lang.tr(
          'ডাক্তার সিরিয়াল (চেম্বার সিরিয়াল)',
          'Doctor Serial (Chamber Serial)',
        ),
        subtitle: lang.tr(
          'দেশের প্রখ্যাত প্রফেশনাল বিশেষজ্ঞদের চেম্বার সিরিয়াল বুকিং।',
          'Chamber serial booking of renowned professional specialists.',
        ),
        actionText: lang.tr('সেবা গ্রহণ করুন', 'Get Service'),
        icon: Icons.calendar_month_outlined,
        iconColor: const Color(0xFF0288D1),
        iconBg: const Color(0xFFE1F5FE),
        borderColor: const Color(0xFF81D4FA),
        imagePath: 'assets/images/dr_serial.png',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorBariView(languageController: _langController),
          ),
        ),
      ),
      _CategoryItem(
        title: lang.tr('ডাক্তার ঘর (টেলিমেডিসিন)', 'Doctor Bari (Telemedicine)'),
        subtitle: lang.tr(
          'অনলাইন ভিডিও কনসালটেশন ও সরাসরি ডাক্তারের পরামর্শ।',
          'Online video consultation & direct doctor advice.',
        ),
        actionText: lang.tr('সেবা গ্রহণ করুন', 'Get Service'),
        icon: Icons.monitor_heart_outlined,
        iconColor: const Color(0xFF0F9D58),
        iconBg: const Color(0xFFE8F5E9),
        borderColor: const Color(0xFFC8E6C9),
        imagePath: 'assets/images/dr_ghor.png',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorListView(languageController: _langController),
          ),
        ),
      ),
      _CategoryItem(
        title: lang.tr('মেডিশপ', 'MediShop'),
        subtitle: lang.tr(
          'ঘরে বসেই ৮২,০০০+ অরিজিনাল ওষুধ অর্ডার করুন।',
          'Order 82,000+ original medicines sitting at home.',
        ),
        actionText: lang.tr('সেবা গ্রহণ করুন', 'Get Service'),
        icon: Icons.medication_outlined,
        iconColor: const Color(0xFF00796B),
        iconBg: const Color(0xFFE0F2F1),
        borderColor: const Color(0xFF80CBC4),
        imagePath: 'assets/images/medishop.png',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MediShopView(languageController: _langController),
          ),
        ),
      ),
      _CategoryItem(
        title: lang.tr('রক্তসেবা', 'Blood Service'),
        subtitle: lang.tr(
          'জরুরি রক্তদাতা ও রক্তসেবা দ্রুত খুঁজে নিন।',
          'Find emergency blood donors & blood services quickly.',
        ),
        actionText: lang.tr('সেবা গ্রহণ করুন', 'Get Service'),
        icon: Icons.water_drop_outlined,
        iconColor: const Color(0xFFED1C24),
        iconBg: const Color(0xFFFFEBEE),
        borderColor: const Color(0xFFFFCDD2),
        imagePath: 'assets/images/roktoseba.png',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RoktoSebaView(languageController: _langController),
          ),
        ),
      ),
      _CategoryItem(
        title: lang.tr('অ্যাম্বুলেন্স', 'Ambulance'),
        subtitle: lang.tr(
          '২৪/৭ জরুরি অ্যাম্বুলেন্স সেবা এখন এক কলেই।',
          '24/7 emergency ambulance service now in one call.',
        ),
        actionText: lang.tr('সেবা গ্রহণ করুন', 'Get Service'),
        icon: Icons.airport_shuttle_outlined,
        iconColor: const Color(0xFF1565C0),
        iconBg: const Color(0xFFE3F2FD),
        borderColor: const Color(0xFF90CAF9),
        imagePath: 'assets/images/ambulance_seba.png',
        onTap: () => showHelplineBottomSheet(context),
      ),
      _CategoryItem(
        title: lang.tr('মাতৃসেবা', 'Maternal Care'),
        subtitle: lang.tr(
          'মা ও শিশুর জন্য বিশেষ স্বাস্থ্যসেবা ও পরামর্শ।',
          'Special healthcare & consultation for mother and child.',
        ),
        actionText: lang.tr('সেবা গ্রহণ করুন', 'Get Service'),
        icon: Icons.child_care_outlined,
        iconColor: const Color(0xFFE91E63),
        iconBg: const Color(0xFFFCE4EC),
        borderColor: const Color(0xFFF48FB1),
        imagePath: 'assets/images/matriseba.png',
        onTap: () => showHelplineBottomSheet(context),
      ),
      _CategoryItem(
        title: lang.tr('ডিসকাউন্ট অফার', 'Discount Offers'),
        subtitle: lang.tr(
          'হাসপাতাল ও ডায়াগনস্টিক টেস্টে ৪০% পর্যন্ত ছাড়।',
          'Up to 40% discount on hospital & diagnostic tests.',
        ),
        actionText: lang.tr('সেবা গ্রহণ করুন', 'Get Service'),
        icon: Icons.percent_rounded,
        iconColor: const Color(0xFFEF6C00),
        iconBg: const Color(0xFFFFE0B2),
        borderColor: const Color(0xFFFFCC80),
        imagePath: 'assets/images/discount_offer.png',
        onTap: () {
          setState(() {
            _currentBottomNavIndex = 1;
          });
        },
      ),
      _CategoryItem(
        title: lang.tr('কাস্টমার সাপোর্ট', 'Customer Support'),
        subtitle: lang.tr(
          '২৪/৭ কাস্টমার সাপোর্ট টিম আপনার পাশে রয়েছে।',
          '24/7 customer support team is by your side.',
        ),
        actionText: lang.tr('সেবা গ্রহণ করুন', 'Get Service'),
        icon: Icons.headset_mic_outlined,
        iconColor: const Color(0xFF5E35B1),
        iconBg: const Color(0xFFEDE7F6),
        borderColor: const Color(0xFFB39DDB),
        imagePath: 'assets/images/customer_support.png',
        onTap: () => showHelplineBottomSheet(context),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final crossAxisCount = screenWidth > 600 ? 4 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: screenWidth > 600
                ? 1.05
                : (screenWidth < 360 ? 0.84 : 0.90),
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final item = categories[index];
            return _buildServiceCard(item);
          },
        );
      },
    );
  }

  Widget _buildServiceCard(_CategoryItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: item.borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: item.iconColor.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Icon / Image Box (Enlarged & Centered)
                item.imagePath != null
                    ? SizedBox(
                        width: 58,
                        height: 58,
                        child: Image.asset(
                          item.imagePath!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: item.iconColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              item.icon,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: item.iconColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: item.iconColor.withValues(alpha: 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          item.icon,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                const SizedBox(height: 8),

                // Card Title (Centered)
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Subtitle / Description Text (Centered)
                Text(
                  item.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            // Bottom Action Link "সেবা গ্রহণ করুন ->" (Centered)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.actionText,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F9D58),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Color(0xFF0F9D58),
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
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

  // Sidebar Drawer (bKash Menu Inspired Design)
  Widget _buildSidebarDrawer(BuildContext context) {
    final isBangla = _langController.isBangla;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      backgroundColor: Colors.white,
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top Header Bar: Title + bKash Style Language Toggle Switch (Eng | বাং)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // MediSeba Logo Image
                  Image.asset(
                    'assets/images/logo.png',
                    height: 40,
                    fit: BoxFit.contain,
                  ),

                  // bKash Style Segmented Language Toggle Button (Eng | বাং)
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Eng Segment
                        GestureDetector(
                          onTap: () {
                            _langController.setLanguage(AppLanguage.english);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: !isBangla ? brandGreen : Colors.transparent,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Text(
                              'Eng',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: !isBangla ? Colors.white : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),

                        // বাং Segment
                        GestureDetector(
                          onTap: () {
                            _langController.setLanguage(AppLanguage.bangla);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isBangla ? brandGreen : Colors.transparent,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Text(
                              'বাং',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isBangla ? Colors.white : const Color(0xFF64748B),
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

            const SizedBox(height: 8),

            // Assistant Banner Card (bKash Beta Assistant style card)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF008744).withValues(alpha: 0.3), width: 1.2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: brandGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.medical_services_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                isBangla ? 'মেডিসেবা' : 'MediSeba',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFED1C24),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '২৪/৭',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isBangla ? 'ডিজিটাল হেলথ ও জরুরি সেবা' : 'Digital Health & Emergency Services',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // bKash-style Menu List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                children: [
                  _buildBkashMenuItem(
                    icon: Icons.assignment_ind_outlined,
                    title: isBangla ? 'পেশেন্ট পোর্টাল' : 'Patient Portal',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PatientPortalView(
                            languageController: _langController,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildBkashMenuItem(
                    icon: Icons.video_call_outlined,
                    title: isBangla ? 'ডাক্তার ঘর' : 'Doctor Ghor',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DoctorBariView(languageController: _langController)),
                      );
                    },
                  ),
                  _buildBkashMenuItem(
                    icon: Icons.bloodtype_outlined,
                    title: isBangla ? 'রক্তসেবা' : 'Blood Service',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RoktoSebaView(languageController: _langController)),
                      );
                    },
                  ),
                  _buildBkashMenuItem(
                    icon: Icons.airport_shuttle_outlined,
                    title: isBangla ? 'অ্যাম্বুলেন্স সেবা' : 'Ambulance Service',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildBkashMenuItem(
                    icon: Icons.local_hospital_outlined,
                    title: isBangla ? 'হাসপাতাল সেবা' : 'Hospitals',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HospitalListView(languageController: _langController)),
                      );
                    },
                  ),
                  _buildBkashMenuItem(
                    icon: Icons.local_offer_outlined,
                    title: isBangla ? 'ডিসকাউন্ট অফার' : 'Discount Offers',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => OfferListView(languageController: _langController)),
                      );
                    },
                  ),
                  _buildBkashMenuItem(
                    icon: Icons.headset_mic_outlined,
                    title: isBangla ? 'গ্রাহক সেবা' : 'Customer Helpline',
                    onTap: () {
                      Navigator.pop(context);
                      showHelplineBottomSheet(context);
                    },
                  ),
                  _buildBkashMenuItem(
                    icon: Icons.public_outlined,
                    title: isBangla ? 'সোশ্যাল মিডিয়া' : 'Social Media',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SocialMediaView()),
                      );
                    },
                  ),
                  _buildBkashMenuItem(
                    icon: Icons.info_outline_rounded,
                    title: isBangla ? 'আমাদের সম্পর্কে' : 'About Us',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AboutUsView(languageController: _langController)),
                      );
                    },
                  ),
                  _buildBkashMenuItem(
                    icon: Icons.share_outlined,
                    title: isBangla ? 'রেফার ও শেয়ার' : 'Share App',
                    onTap: () {
                      Navigator.pop(context);
                      showShareAppDialog(context);
                    },
                  ),
                ],
              ),
            ),

            // Footer Version
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
              child: Text(
                isBangla ? 'ভার্সন: ১.০.০' : 'Version: 1.0.0',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBkashMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? badgeText,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF334155),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
      ),
      trailing: badgeText != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFED1C24),
                ),
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}

// Data class for service category items
class _CategoryItem {
  final String title;
  final String subtitle;
  final String actionText;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final Color borderColor;
  final String? imagePath;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.borderColor,
    this.imagePath,
    required this.onTap,
  });
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
