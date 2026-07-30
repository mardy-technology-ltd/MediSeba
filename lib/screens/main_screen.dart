import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../views/offers/offer_list_view.dart';
import '../views/hospitals/hospital_list_view.dart';
import '../views/doctors/doctor_list_view.dart';
import '../views/more/more_menu_view.dart';
import '../views/profile/profile_view.dart';
import '../widgets/modern_glow_navbar.dart';
import 'tabs/home_tab.dart';

class MainScreen extends StatefulWidget {
  final AuthController authController;
  final HomeController homeController;

  const MainScreen({
    super.key,
    required this.authController,
    required this.homeController,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = widget.authController.currentUser;
    final userData = widget.authController.currentUserData;
    final name = userData?.name ?? user?.displayName ?? 'Tanvir';
    final profileImg = userData?.profileImageUrl ?? user?.photoURL;

    final List<Widget> pages = [
      // Tab 0: Scrollable Home Tab Body (Exact Match to Reference UI)
      HomeTab(
        userName: name,
        profileImgUrl: profileImg,
        onDoctorTap: () => setState(() => _selectedIndex = 3),
        onConsultTap: () => setState(() => _selectedIndex = 4),
      ),
      // Tab 1: Offers Page
      const OfferListView(),
      // Tab 2: Hospitals Page
      const HospitalListView(),
      // Tab 3: Doctors Page
      const DoctorListView(showAppBar: false),
      // Tab 4: More Menu Page
      MoreMenuView(
        authController: widget.authController,
        homeController: widget.homeController,
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      extendBody: false,
      backgroundColor: const Color(0xFFF0FDFA),

      // ─── Top AppBar (Shown on subpages) ────────────────
      appBar: _selectedIndex == 0
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Image.asset(
          'assets/images/logo.png',
          height: 44,
          fit: BoxFit.contain,
        ),
        actions: [
          // User Profile Avatar
          ListenableBuilder(
            listenable: widget.authController,
            builder: (context, _) {
              final uData = widget.authController.currentUserData;
              final hasImage = uData?.profileImageUrl != null &&
                  uData!.profileImageUrl!.isNotEmpty;

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
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF1F5F9),
                    border: Border.all(color: AppColors.primaryTeal, width: 1.5),
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
                          color: AppColors.primaryTeal,
                          size: 20,
                        )
                      : null,
                ),
              );
            },
          ),
          const SizedBox(width: 6),

          // Menu Icon Button
          IconButton(
            icon: const Icon(
              Icons.menu_rounded,
              color: AppColors.primaryTeal,
              size: 28,
            ),
            onPressed: () {
              setState(() => _selectedIndex = 4);
            },
          ),
          const SizedBox(width: 4),
        ],
      ),

      // ─── Dynamic Body using IndexedStack ─────────────────
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),

      // ─── Persistent Bottom Navigation Bar ─────────────────
      bottomNavigationBar: ModernGlowNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          ModernGlowNavBarItem(iconPath: 'assets/icons/nav_home.svg', label: 'হোম'),
          ModernGlowNavBarItem(iconPath: 'assets/icons/nav_offers.png', label: 'অফার', isPng: true),
          ModernGlowNavBarItem(iconPath: 'assets/icons/nav_hospitals.svg', label: 'হাসপাতাল'),
          ModernGlowNavBarItem(iconPath: 'assets/icons/nav_doctors.svg', label: 'ডাক্তার'),
          ModernGlowNavBarItem(iconPath: 'assets/icons/nav_more.svg', label: 'আরও'),
        ],
      ),
    );
  }
}
