import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'constants/app_constants.dart';
import 'controllers/home_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/language_controller.dart';
// import 'views/splash/splash_view.dart';
import 'views/home/home_view.dart';
import 'views/admin/admin_dashboard_view.dart';
import 'views/auth/login_view.dart';

class RootRouteGate extends StatelessWidget {
  final HomeController homeController;
  final AuthController authController;
  final LanguageController languageController;

  const RootRouteGate({
    super.key,
    required this.homeController,
    required this.authController,
    required this.languageController,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authController,
      builder: (context, _) {
        if (authController.isLoggedIn) {
          final phone = authController.currentUserData?.phone.toLowerCase() ?? '';
          final email = authController.currentUser?.email?.toLowerCase() ?? '';
          final loginIdentifier = phone.isNotEmpty ? phone : email;

          // Dynamically detect if staff or admin login matching LoginRole pattern
          final bool isAdminOrStaff = loginIdentifier.contains('admin') ||
              loginIdentifier.contains('doctor') ||
              loginIdentifier.contains('rahim') || // HBP
              loginIdentifier.contains('tanvir') || // Supervisor
              loginIdentifier.contains('areamanager') || // Area Manager
              loginIdentifier.contains('marketing') || // Marketing Manager
              loginIdentifier.contains('headsales') || // Head of Sales
              loginIdentifier.contains('director'); // Sales Director

          if (isAdminOrStaff) {
            return AdminDashboardView(
              homeController: homeController,
              authController: authController,
              languageController: languageController,
            );
          } else {
            return HomeView(
              homeController: homeController,
              authController: authController,
              languageController: languageController,
            );
          }
        } else {
          return LoginView(
            homeController: homeController,
            authController: authController,
            languageController: languageController,
          );
        }
      },
    );
  }
}

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
          home: RootRouteGate(
            homeController: _homeController,
            authController: _authController,
            languageController: _languageController,
          ),
        );
      },
    );
  }
}
