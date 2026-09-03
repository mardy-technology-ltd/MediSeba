import 'dart:async';
import 'dart:ui';
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
import '../../widgets/partner_bottom_sheet.dart';
import '../../widgets/modern_glow_navbar.dart';
import '../blood_service/rokto_seba_view.dart';
import '../offers/offer_list_view.dart';
import '../hospitals/hospital_list_view.dart';
import '../../controllers/language_controller.dart';
import '../more/more_menu_view.dart';
import '../profile/profile_view.dart';
import '../patient_portal/patient_portal_view.dart';
import '../hbp/hbp_dashboard_view.dart';
import '../medishop/medishop_view.dart';
import '../ambulance/ambulance_seba_view.dart';
import '../career/career_view.dart';
import '../blog/blog_view.dart';
import '../contact/contact_us_view.dart';
import '../matriseba/matriseba_view.dart';
import '../customer_support/customer_support_view.dart';
import '../../widgets/auth_guard.dart';

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

  final TextEditingController _homeSearchController = TextEditingController();
  Timer? _bannerTimer;
  late final LanguageController _langController;

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
    _startBannerAutoSlide();
  }

  void _startBannerAutoSlide() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      if (_bannerPageController.hasClients) {
        int currentPage = _bannerPageController.page?.round() ?? _currentBannerIndex;
        int nextPage = (currentPage + 1) % 3;
        _bannerPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  static const brandGreen = Color(0xFF008536);
  static const textDark = Color(0xFF222222);
  static const textMuted = Color(0xFF777777);

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _homeSearchController.dispose();
    _bannerPageController.dispose();
    super.dispose();
  }

  void _performHomeSearch() {
    final query = _homeSearchController.text.trim();
    FocusScope.of(context).unfocus();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorListView(
          showAppBar: true,
          languageController: _langController,
          initialSearchQuery: query,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _langController,
      builder: (context, _) {
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
              height: 48,
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
                      AuthGuard.check(
                        context: context,
                        authController: widget.authController,
                        homeController: widget.homeController,
                        languageController: _langController,
                        title: 'প্রোফাইলে প্রবেশ করতে লগইন করুন',
                        message: 'আপনার প্রোফাইল তথ্য, রসিদ ও হেলথ রেকর্ডস দেখতে অনুগ্রহ করে লগইন করুন।',
                        onAuthenticated: () {
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
      },
    );
  }

  // Home Screen Center Scroll Body (Redesigned UI/UX)
  Widget _buildHomeBodyContent() {
    return Stack(
      children: [
        // Futuristic Ambient Glowing Orbs behind the content
        Positioned(
          top: -60,
          left: -60,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: brandGreen.withValues(alpha: 0.08),
            ),
          ),
        ),
        Positioned(
          top: 320,
          right: -90,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF38BDF8).withValues(alpha: 0.08), // Sky Blue Accent
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          left: -100,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: brandGreen.withValues(alpha: 0.06),
            ),
          ),
        ),

        // Main Content Scroll view
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Personalized Greeting & Universal Search Header Card
              _buildUserGreetingAndSearchBar(),

              const SizedBox(height: 20),

              // 2. Category Service Grid Section
              _buildSectionHeader(
                title: _langController.tr('আমাদের সেবাসমূহ', 'Our Healthcare Services'),
                onSeeAllTap: null,
              ),
              const SizedBox(height: 12),
              _buildCategoryGrid(),

              const SizedBox(height: 22),

              // 4. Banner Slider Carousel
              _buildHeroBanner(),

              const SizedBox(height: 18),

              // 5. Health Query Banner
              _buildQueryBanner(),

              const SizedBox(height: 22),

              // 5. Top Doctors Section (Horizontal Scroll Carousel)
              _buildSectionHeader(
                title: _langController.tr('বিশেষজ্ঞ ডাক্তারগণ', 'Top Doctors In Your Area'),
                onSeeAllTap: () {
                  setState(() => _currentBottomNavIndex = 3);
                },
              ),
              const SizedBox(height: 12),
              _buildHorizontalDoctorsList(),

              const SizedBox(height: 24),

              // 6. Nearby Hospitals Section
              _buildSectionHeader(
                title: _langController.tr('নিকটস্থ হাসপাতাল ও ডায়াগনস্টিক', 'Nearby Hospitals & Diagnostics'),
                onSeeAllTap: () {
                  setState(() => _currentBottomNavIndex = 2);
                },
              ),
              const SizedBox(height: 12),

              // Hospitals Grid (Responsive Compact Grid)
              LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  final crossAxisCount = screenWidth > 600 ? 4 : 2;
                  final aspectRatio = screenWidth > 600
                      ? 1.15
                      : (screenWidth < 360 ? 0.88 : 0.96);

                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: aspectRatio,
                    children: [
                      _buildHospitalCard(
                        name: 'পপুলার ডায়াগনস্টিক',
                        address: 'উত্তরা ব্রাঞ্চ, ঢাকা',
                        time: '07:00 am - 11:30 pm',
                        rating: '4.9',
                        imageUrl:
                            'https://img.freepik.com/free-photo/empty-emergency-room-with-medical-equipment_23-2149138092.jpg',
                      ),
                      _buildHospitalCard(
                        name: 'ইবনে সিনা হাসপাতাল',
                        address: 'ধানমন্ডি, ঢাকা',
                        time: '২৪ ঘণ্টা খোলা',
                        rating: '4.8',
                        imageUrl:
                            'https://img.freepik.com/free-photo/modern-operating-room-hospital_23-2148942918.jpg',
                      ),
                      _buildHospitalCard(
                        name: 'ল্যাবএইড হাসপাতাল',
                        address: 'গুলশান, ঢাকা',
                        time: '২৪ ঘণ্টা খোলা',
                        rating: '4.9',
                        imageUrl:
                            'https://img.freepik.com/free-photo/interior-view-operating-room_1170-2254.jpg',
                      ),
                      _buildHospitalCard(
                        name: 'স্কয়ার হাসপাতাল',
                        address: 'পান্থপথ, ঢাকা',
                        time: '২৪ ঘণ্টা খোলা',
                        rating: '5.0',
                        imageUrl:
                            'https://img.freepik.com/free-photo/medical-clinic-reception-counter-registration_482257-26804.jpg',
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  // 1. User Greeting & Universal Search Bar Header Card
  Widget _buildUserGreetingAndSearchBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.55), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: brandGreen.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Health tracker pill row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: brandGreen.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.shield_rounded, color: brandGreen, size: 13),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _langController.tr('হেলথ কোর: সুরক্ষিত', 'Health Core: Secured'),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: brandGreen,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.2), width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: Color(0xFF38BDF8),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _langController.tr('লাইভ ট্র্যাকার', 'Live Tracker'),
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [brandGreen, brandGreen.withValues(alpha: 0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: brandGreen.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.waving_hand_rounded, color: Color(0xFFFBBF24), size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _langController.tr('👋 শুভ দিন, সুস্থ থাকুন', '👋 Good Day, Stay Healthy'),
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w900,
                            color: textDark,
                          ),
                        ),
                        Text(
                          _langController.tr(
                            'আজ আপনার কী ধরনের স্বাস্থ্যসেবা প্রয়োজন?',
                            'What healthcare service do you need today?',
                          ),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Interactive Universal Search Bar Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _homeSearchController,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (_) => _performHomeSearch(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: _langController.tr(
                      'ডাক্তার, বিশেষত্ব, হাসপাতাল বা ওষুধ খুঁজুন...',
                      'Search doctor, specialty, hospital or medicine...',
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: const Icon(Icons.search_rounded, color: brandGreen, size: 22),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_homeSearchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear_rounded, color: Colors.grey, size: 18),
                            onPressed: () {
                              setState(() {
                                _homeSearchController.clear();
                              });
                            },
                          ),
                        InkWell(
                          onTap: _performHomeSearch,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [brandGreen, Color(0xFF0F9D58)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: brandGreen.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 15),
                          ),
                        ),
                      ],
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: brandGreen, width: 1.8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 5. Horizontal Top Doctors List Carousel
  Widget _buildHorizontalDoctorsList() {
    final doctors = [
      {
        'name': 'Dr. Nusrat Jahan',
        'specialty': 'Gynecologist & FCPS Specialist',
        'degree': 'MBBS, FCPS (Gynae)',
        'rating': '4.9',
        'reviews': '142',
        'time': '07:00 pm - 09:30 pm',
        'image': 'https://img.freepik.com/free-photo/female-doctor-hospital-with-stethoscope_23-2148827766.jpg',
      },
      {
        'name': 'Dr. Billy Edwards',
        'specialty': 'Medicine Specialist & GP',
        'degree': 'MBBS, MD (Medicine)',
        'rating': '4.8',
        'reviews': '98',
        'time': '05:00 pm - 09:00 pm',
        'image': 'https://img.freepik.com/free-photo/doctor-offering-medical-teleconsultation_23-2149329007.jpg',
      },
      {
        'name': 'Dr. Mahbub Hasan',
        'specialty': 'Cardiologist & Heart Specialist',
        'degree': 'MBBS, MD (Cardiology)',
        'rating': '5.0',
        'reviews': '210',
        'time': '06:00 pm - 10:00 pm',
        'image': 'https://img.freepik.com/free-photo/woman-doctor-wearing-stethoscope_23-2148827768.jpg',
      },
    ];

    return SizedBox(
      height: 182,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: doctors.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final doc = doctors[index];
          return GestureDetector(
            onTap: () {
              setState(() => _currentBottomNavIndex = 3);
            },
            child: Container(
              width: 275,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withValues(alpha: 0.55), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: brandGreen.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: brandGreen.withValues(alpha: 0.25), width: 1.2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                doc['image']!,
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 52,
                                  height: 52,
                                  color: const Color(0xFFE2E8F0),
                                  child: const Icon(Icons.person, color: textMuted),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 2,
                            bottom: 2,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.35),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                                const SizedBox(width: 3),
                                Text(
                                  '${doc['rating']} (${doc['reviews']})',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: textDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              doc['name']!,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              doc['degree']!,
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: brandGreen,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9).withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade100, width: 0.8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time_rounded, color: Color(0xFF64748B), size: 13),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            doc['time']!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF475569),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    height: 34,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [brandGreen, Color(0xFF0F9D58)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: brandGreen.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _currentBottomNavIndex = 3);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        _langController.tr('সিরিয়াল বুক করুন', 'Book Serial'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Category Grid — Service Cards Matched to Reference Layout with Original Logos
  Widget _buildCategoryGrid() {
    final lang = _langController;

    final categories = [
      _CategoryItem(
        title: lang.tr('ডাক্তার সিরিয়াল', 'Doctor Serial'),
        subtitle: lang.tr(
          'বিশেষজ্ঞদের চেম্বার সিরিয়াল বুকিং।',
          'Chamber serial booking of specialists.',
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
        title: lang.tr('ডাক্তার ঘর', 'Doctor Bari'),
        subtitle: lang.tr(
          'ভিডিও কনসালটেশন ও ডাক্তারের পরামর্শ।',
          'Online video doctor consultation.',
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
          'ঘরে বসেই অরিজিনাল ওষুধ অর্ডার করুন।',
          'Order original medicines sitting at home.',
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
          'Find emergency blood donors quickly.',
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
          '২৪/৭ জরুরি অ্যাম্বুলেন্স সেবা এক কলেই।',
          '24/7 emergency ambulance in one call.',
        ),
        actionText: lang.tr('সেবা গ্রহণ করুন', 'Get Service'),
        icon: Icons.airport_shuttle_outlined,
        iconColor: const Color(0xFF1565C0),
        iconBg: const Color(0xFFE3F2FD),
        borderColor: const Color(0xFF90CAF9),
        imagePath: 'assets/images/ambulance_seba.png',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AmbulanceSebaView(languageController: _langController),
          ),
        ),
      ),
      _CategoryItem(
        title: lang.tr('মাতৃসেবা', 'Maternal Care'),
        subtitle: lang.tr(
          'মা ও শিশুর বিশেষ স্বাস্থ্যসেবা ও পরামর্শ।',
          'Special care for mother and child.',
        ),
        actionText: lang.tr('সেবা গ্রহণ করুন', 'Get Service'),
        icon: Icons.child_care_outlined,
        iconColor: const Color(0xFFE91E63),
        iconBg: const Color(0xFFFCE4EC),
        borderColor: const Color(0xFFF48FB1),
        imagePath: 'assets/images/matriseba.png',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MatriSebaView(languageController: _langController),
          ),
        ),
      ),
      _CategoryItem(
        title: lang.tr('ডিসকাউন্ট অফার', 'Discount Offers'),
        subtitle: lang.tr(
          'হাসপাতাল ও টেস্টে ৪০% পর্যন্ত ছাড়।',
          'Up to 40% discount on tests.',
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
          '২৪/৭ সাপোর্ট টিম আপনার পাশে রয়েছে।',
          '24/7 customer support team.',
        ),
        actionText: lang.tr('সেবা গ্রহণ করুন', 'Get Service'),
        icon: Icons.headset_mic_outlined,
        iconColor: const Color(0xFF5E35B1),
        iconBg: const Color(0xFFEDE7F6),
        borderColor: const Color(0xFFB39DDB),
        imagePath: 'assets/images/customer_support.png',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CustomerSupportView(languageController: _langController),
          ),
        ),
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
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: screenWidth > 600
                ? 1.30
                : (screenWidth < 360 ? 1.02 : 1.14),
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.95),
              Colors.white.withValues(alpha: 0.65),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: item.borderColor.withValues(alpha: 0.65), width: 1.3),
          boxShadow: [
            BoxShadow(
              color: item.iconColor.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
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
                // Top Icon / Image Box (Compact Size)
                item.imagePath != null
                    ? Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: item.iconColor.withValues(alpha: 0.18),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          item.imagePath!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: item.iconColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              item.icon,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: item.iconColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: item.iconColor.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          item.icon,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                const SizedBox(height: 8),

                // Card Title (Centered)
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                    height: 1.15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),

                // Subtitle / Description Text (Centered)
                Text(
                  item.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            // Bottom Action Link "সেবা গ্রহণ করুন ->" (Centered)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: item.iconColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.actionText,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: item.iconColor,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: item.iconColor,
                    size: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hero Banner Slider Card (Exactly 3 unique medical-related banner slides)
  Widget _buildHeroBanner() {
    final List<Map<String, dynamic>> banners = [
      {
        'title': _langController.tr('আপনার স্বাস্থ্যের সুরক্ষাই আমাদের প্রথম অগ্রাধিকার', 'Your Health Is Our Top Priority'),
        'subtitle': _langController.tr('২৪/৭ অভিজ্ঞ প্রফেশনাল ডাক্তারের সেবা বুকিং করুন', 'Book 24/7 experienced doctor consultation'),
        'badge': 'OPEN 24/7',
        'assetImage': null,
        'color1': const Color(0xFF008536),
        'color2': const Color(0xFF02A946),
        'icon': Icons.medical_services_rounded,
      },
      {
        'title': _langController.tr('মেডিশপ: ৮২,০০০+ অরিজিনাল ওষুধ ডিসকাউন্টে অর্ডার করুন', 'MediShop: Order 82,000+ Original Medicines'),
        'subtitle': _langController.tr('ঘরে বসেই জেনুইন ওষুধ ও হেলথ প্রোডাক্টের হোম ডেলিভারি', 'Fast home delivery of genuine medicines & health care'),
        'badge': '20% OFF',
        'assetImage': null,
        'color1': const Color(0xFF0288D1),
        'color2': const Color(0xFF38BDF8),
        'icon': Icons.medication_rounded,
      },
      {
        'title': _langController.tr('২৪/৭ ইমার্জেন্সি আইসিইউ ও এসি অ্যাম্বুলেন্স সেবা', '24/7 Emergency ICU & AC Ambulance Service'),
        'subtitle': _langController.tr('এক কলেই দ্রুত জরুরি স্থানান্তরের জন্য কল করুন', 'Call now for quick emergency medical transport'),
        'badge': 'HOTLINE',
        'assetImage': null,
        'color1': const Color(0xFFED1B24),
        'color2': const Color(0xFFEF4444),
        'icon': Icons.airport_shuttle_rounded,
      },
    ];

    return Column(
      children: [
        SizedBox(
          height: 155,
          child: PageView.builder(
            controller: _bannerPageController,
            itemCount: 3,
            onPageChanged: (index) {
              setState(() => _currentBannerIndex = index);
            },
            itemBuilder: (context, index) {
              final banner = banners[index];
              final String? assetImg = banner['assetImage'];

              if (assetImg != null) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.asset(
                      assetImg,
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [banner['color1'] as Color, banner['color2'] as Color],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: (banner['color1'] as Color).withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Custom tech background grid
                        Positioned.fill(
                          child: CustomPaint(
                            painter: TechGridPainter(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                        ),

                        // Banner Content
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        banner['badge'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      banner['title'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        height: 1.25,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      banner['subtitle'],
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.85),
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  banner['icon'] as IconData,
                                  color: Colors.white,
                                  size: 30,
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
            },
          ),
        ),
        const SizedBox(height: 10),

        // Indicator Dots (3 Dots for 3 Banners)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final isSelected = _currentBannerIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isSelected ? 22 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isSelected ? brandGreen : const Color(0xFFCBD5E1),
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
    VoidCallback? onSeeAllTap,
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
        if (onSeeAllTap != null)
          GestureDetector(
            onTap: onSeeAllTap,
            child: Text(
              _langController.tr('সব দেখুন >', 'See All >'),
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: brandGreen,
              ),
            ),
          ),
      ],
    );
  }

  // Hospital Grid Card Item (Redesigned UI/UX)
  Widget _buildHospitalCard({
    required String name,
    required String address,
    required String time,
    required String imageUrl,
    String rating = '4.9',
  }) {
    return GestureDetector(
      onTap: () {
        setState(() => _currentBottomNavIndex = 2);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: brandGreen.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(21),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 84,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 84,
                      color: const Color(0xFFE2E8F0),
                      child: const Icon(Icons.local_hospital_rounded, color: textMuted, size: 28),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [brandGreen, Color(0xFF0F9D58)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: brandGreen.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      _langController.tr('সুপারিশকৃত', 'Sponsor'),
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                        color: Colors.black.withValues(alpha: 0.55),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 10),
                            const SizedBox(width: 2),
                            Text(
                              rating,
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                        height: 1.15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      address,
                      style: const TextStyle(
                        fontSize: 9.5,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 10.5,
                          color: brandGreen,
                        ),
                        const SizedBox(width: 3.5),
                        Expanded(
                          child: Text(
                            time,
                            style: const TextStyle(
                              fontSize: 9,
                              color: brandGreen,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

  // Sidebar Drawer (Redesigned Glassmorphic Modern Sidebar)
  Widget _buildSidebarDrawer(BuildContext context) {
    final isBangla = _langController.isBangla;
    final userData = widget.authController.currentUserData;
    final loginIdentifier = (widget.authController.loginIdentifier ?? '').toLowerCase();
    final userPhone = (userData?.phone ?? '').toLowerCase();
    final userName = (userData?.name ?? '').toLowerCase();
    final bool isHbpUser = loginIdentifier.contains('hbp') ||
        userPhone.contains('01798456879') ||
        userName.contains('sojib') ||
        userName.contains('hbp');

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      backgroundColor: Colors.white.withValues(alpha: 0.75),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Top Header Bar: Title + Segmented Language Toggle Switch (Eng | বাং)
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

                      // Glassmorphic Segmented Language Toggle Button (Eng | বাং)
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1),
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
                                  boxShadow: !isBangla
                                      ? [
                                          BoxShadow(
                                            color: brandGreen.withValues(alpha: 0.25),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          ),
                                        ]
                                      : null,
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
                                  boxShadow: isBangla
                                      ? [
                                          BoxShadow(
                                            color: brandGreen.withValues(alpha: 0.25),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          ),
                                        ]
                                      : null,
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

                // Assistant Banner Card (Glassmorphic High-Tech Card)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.7), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: brandGreen.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [brandGreen, Color(0xFF0F9D58)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: brandGreen.withValues(alpha: 0.25),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2)),
                            ],
                          ),
                          child: const Icon(
                            Icons.medical_services_rounded,
                            color: Colors.white,
                            size: 20,
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
                                      fontWeight: FontWeight.w900,
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
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
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
                                  fontSize: 11.5,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
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

                // Menu List (Glow Sidebar List Items)
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    children: [
                      if (isHbpUser)
                        _buildBkashMenuItem(
                          icon: Icons.shield_outlined,
                          title: isBangla ? 'এইচবিপি ফিল্ড পোর্টাল' : 'HBP Field Portal',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HbpDashboardView(
                                  homeController: widget.homeController,
                                  authController: widget.authController,
                                  languageController: _langController,
                                ),
                              ),
                            );
                          },
                        ),
                      _buildBkashMenuItem(
                        icon: Icons.assignment_ind_outlined,
                        title: isBangla ? 'পেশেন্ট পোর্টাল' : 'Patient Portal',
                        onTap: () {
                          Navigator.pop(context);
                          AuthGuard.check(
                            context: context,
                            authController: widget.authController,
                            homeController: widget.homeController,
                            languageController: _langController,
                            title: 'পেশেন্ট পোর্টালে প্রবেশ করতে লগইন করুন',
                            message: 'আপনার ডিজিটাল প্রেসক্রিপশন ও হেলথ রেকর্ডস সুরক্ষিত রাখতে লগইন করুন।',
                            onAuthenticated: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PatientPortalView(
                                    languageController: _langController,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      _buildBkashMenuItem(
                        icon: Icons.handshake_outlined,
                        title: isBangla ? 'পার্টনার' : 'Partner',
                        onTap: () {
                          Navigator.pop(context);
                          showPartnerBottomSheet(context, languageController: _langController);
                        },
                      ),
                      _buildBkashMenuItem(
                        icon: Icons.work_outline_rounded,
                        title: isBangla ? 'ক্যারিয়ার' : 'Career',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CareerView(languageController: _langController)),
                          );
                        },
                      ),
                      _buildBkashMenuItem(
                        icon: Icons.article_outlined,
                        title: isBangla ? 'ব্লগ' : 'Blog',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => BlogView(languageController: _langController)),
                          );
                        },
                      ),
                      _buildBkashMenuItem(
                        icon: Icons.call_outlined,
                        title: isBangla ? 'যোগাযোগ' : 'Contact Us',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ContactUsView(languageController: _langController)),
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
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
          color: brandGreen.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: brandGreen.withValues(alpha: 0.15), width: 0.8),
        ),
        child: Icon(
          icon,
          color: brandGreen,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1E293B),
        ),
      ),
      trailing: badgeText != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.2), width: 0.8),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFEF4444),
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

// Health Query Banner Card (Redesigned Modern Glassmorphism & Emerald Theme)
class _QueryBannerCard extends StatefulWidget {
  const _QueryBannerCard();

  @override
  State<_QueryBannerCard> createState() => _QueryBannerCardState();
}

class _QueryBannerCardState extends State<_QueryBannerCard> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.96);
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
          colors: [Color(0xFF064E3B), Color(0xFF047857)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF047857).withValues(alpha: 0.3),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: _navigateToHealthConsultation,
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.white.withValues(alpha: 0.15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Left Icon Graphic Container
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white24, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),

                // Content Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'ফ্রি কনসালটেশন',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'স্বাস্থ্য বিষয়ক জিজ্ঞাসা',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'অভিজ্ঞ ডাক্তারদের মতামত পান',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.15,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Interactive Proceed Button
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'প্রশ্ন করুন',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF064E3B),
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xFF064E3B),
                            size: 15,
                          ),
                        ],
                      ),
                    ),
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

class TechGridPainter extends CustomPainter {
  final Color color;
  TechGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    const double step = 20.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double j = 0; j < size.height; j += step) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), paint);
    }
    
    // Draw some tech diagnostic circles
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.5), 45, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.5), 55, paint..strokeWidth = 0.4);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

