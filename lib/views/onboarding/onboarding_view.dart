import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/language_controller.dart';
import '../../services/cache_service.dart';
import '../home/home_view.dart';


class OnboardingView extends StatefulWidget {
  final HomeController homeController;
  final AuthController authController;
  final LanguageController languageController;

  const OnboardingView({
    super.key,
    required this.homeController,
    required this.authController,
    required this.languageController,
  });

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _finishOnboarding() async {
    await CacheService.put('has_seen_onboarding', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomeView(
          homeController: widget.homeController,
          authController: widget.authController,
          languageController: widget.languageController,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = widget.languageController.isBangla;

    final List<Map<String, dynamic>> onboardingData = [
      {
        'image': 'assets/images/onboarding_1.jpg',
        'icon': Icons.medical_services_rounded,
        'title': isBangla ? 'অনলাইনে অভিজ্ঞ ডাক্তার দেখান' : 'Consult Expert Doctors Online',
        'subtitle': isBangla
            ? 'ঘরে বসেই যেকোনো বিশেষজ্ঞ ডাক্তারের এইচডি ভিডিও কল অথবা চেম্বার সিরিয়াল বুক করুন অতি সহজে।'
            : 'Book chamber serials or consult specialist doctors via HD video calls directly from home.',
        'bgColor': const Color(0xFFE6F4EA),
        'accentColor': const Color(0xFF0F9D58),
        'badge': isBangla ? '২৪/৭ ডক্টর সেবা' : '24/7 Doctor Care',
      },
      {
        'image': 'assets/images/onboarding_2.jpg',
        'icon': Icons.bloodtype_rounded,
        'title': isBangla ? 'জরুরি রক্তসেবা ও স্বাস্থ্য ক্যাম্প' : 'Emergency Blood & Health Care',
        'subtitle': isBangla
            ? 'জরুরি প্রয়োজনে রক্তদাতা ও ব্লাড ব্যাংক খুঁজুন এবং বিনামূল্যে হেলথ ক্যাম্প সেবা গ্রহন করুন।'
            : 'Find emergency blood donors & blood banks and attend free health care camps.',
        'bgColor': const Color(0xFFFEF2F2),
        'accentColor': const Color(0xFFDC2626),
        'badge': isBangla ? 'রক্তদান ও ডক্টর সেবা' : 'Blood & Care',
      },
      {
        'image': 'assets/images/onboarding_3.jpg',
        'icon': Icons.airport_shuttle_rounded,
        'title': isBangla ? 'জরুরি অ্যাম্বুলেন্স ও ইমার্জেন্সি' : 'Rapid Ambulance & Emergency',
        'subtitle': isBangla
            ? 'যেকোনো স্থানে ২৪/৭ দ্রুত অ্যাম্বুলেন্স বুকিং এবং জরুরি চিকিৎসা সহায়তা পান নিমিষেই।'
            : 'Book 24/7 rapid ambulance service and emergency medical assistance anywhere, instantly.',
        'bgColor': const Color(0xFFE0F2FE),
        'accentColor': const Color(0xFF0284C7),
        'badge': isBangla ? 'জরুরি অ্যাম্বুলেন্স সেবা' : '24/7 Ambulance Service',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Header: Skip Button (Right Aligned)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _finishOnboarding,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF64748B),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    backgroundColor: const Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isBangla ? 'এড়িয়ে যান' : 'Skip',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 12),
                    ],
                  ),
                ),
              ),
            ),

            // PageView Slider Body
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  final screenHeight = constraints.maxHeight;

                  // Responsive Sizing Calculations
                  final double responsiveLogoWidth = (screenWidth * 0.72).clamp(240.0, 420.0);
                  final double responsiveLogoHeight = (screenHeight * 0.12).clamp(65.0, 105.0);
                  final double responsiveImageHeight = (screenHeight * 0.35).clamp(180.0, 260.0);

                  return PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: onboardingData.length,
                    itemBuilder: (context, index) {
                      final data = onboardingData[index];
                      return Center(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Prominent Responsive MediSeba Logo directly above the image
                                Image.asset(
                                  'assets/images/logo.png',
                                  width: responsiveLogoWidth,
                                  height: responsiveLogoHeight,
                                  fit: BoxFit.contain,
                                ),

                                const SizedBox(height: 16),

                                // Premium Image Card Container
                                Container(
                                  width: double.infinity,
                                  height: responsiveImageHeight,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (data['accentColor'] as Color).withValues(alpha: 0.15),
                                        blurRadius: 25,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      data['image'] as String,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: data['bgColor'] as Color,
                                        child: Center(
                                          child: Icon(
                                            data['icon'] as IconData,
                                            size: 80,
                                            color: data['accentColor'] as Color,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                            const SizedBox(height: 36),

                            // Badge Tag
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: (data['accentColor'] as Color).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: (data['accentColor'] as Color).withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                data['badge'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: data['accentColor'] as Color,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Title Text
                            Text(
                              data['title'] as String,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                                height: 1.25,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 12),

                            // Subtitle Description
                            Text(
                              data['subtitle'] as String,
                              style: const TextStyle(
                                fontSize: 13.5,
                                color: Color(0xFF64748B),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

            // Bottom Controller Bar: Page Indicator Dots + Action Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Page Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFF0F9D58)
                              : const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bottom Primary Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < onboardingData.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _finishOnboarding();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F9D58),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: const Color(0xFF0F9D58).withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == onboardingData.length - 1
                                ? (isBangla ? 'সেবা শুরু করুন 🚀' : 'Get Started 🚀')
                                : (isBangla ? 'পরবর্তী' : 'Next'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_currentPage < onboardingData.length - 1) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
