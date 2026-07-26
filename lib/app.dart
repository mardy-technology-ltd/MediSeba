import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'constants/app_constants.dart';
import 'controllers/home_controller.dart';
import 'controllers/auth_controller.dart';
import 'views/splash/splash_view.dart';

class MediSebaApp extends StatelessWidget {
  const MediSebaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = HomeController();
    final authController = AuthController();

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto', // Default fallback
      ),
      home: SplashView(
        homeController: homeController,
        authController: authController,
      ),
    );
  }
}
