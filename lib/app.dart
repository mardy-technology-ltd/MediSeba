import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'constants/app_constants.dart';
import 'controllers/home_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/language_controller.dart';
import 'views/splash/splash_view.dart';

class MediSebaApp extends StatefulWidget {
  const MediSebaApp({super.key});

  @override
  State<MediSebaApp> createState() => _MediSebaAppState();
}

class _MediSebaAppState extends State<MediSebaApp> {
  late final HomeController _homeController;
  late final AuthController _authController;
  late final LanguageController _languageController;

  @override
  void initState() {
    super.initState();
    _homeController = HomeController();
    _authController = AuthController();
    _languageController = LanguageController();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _languageController,
      builder: (context, _) {
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
            fontFamily: 'Roboto',
          ),
          home: SplashView(
            homeController: _homeController,
            authController: _authController,
            languageController: _languageController,
          ),
        );
      },
    );
  }
}
