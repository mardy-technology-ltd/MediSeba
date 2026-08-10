import 'package:flutter/material.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/language_controller.dart';
import '../../services/cache_service.dart';
import '../home/home_view.dart';
import '../onboarding/onboarding_view.dart';

class SplashView extends StatefulWidget {
  final HomeController homeController;
  final AuthController authController;
  final LanguageController languageController;

  const SplashView({
    super.key,
    required this.homeController,
    required this.authController,
    required this.languageController,
  });

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();

    // Check if user has already seen onboarding
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        final bool hasSeenOnboarding = CacheService.get('has_seen_onboarding') == true;

        final Widget destinationView = hasSeenOnboarding
            ? HomeView(
                homeController: widget.homeController,
                authController: widget.authController,
                languageController: widget.languageController,
              )
            : OnboardingView(
                homeController: widget.homeController,
                authController: widget.authController,
                languageController: widget.languageController,
              );

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => destinationView,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
