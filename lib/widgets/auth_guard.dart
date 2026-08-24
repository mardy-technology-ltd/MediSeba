import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/language_controller.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';

class AuthGuard {
  /// Checks if user is logged in. If logged in, executes [onAuthenticated].
  /// If not logged in, presents a modal bottom sheet prompting the user to login/register.
  static void check({
    required BuildContext context,
    required AuthController authController,
    required HomeController homeController,
    LanguageController? languageController,
    required VoidCallback onAuthenticated,
    String? title,
    String? message,
  }) {
    if (authController.isLoggedIn) {
      onAuthenticated();
    } else {
      showAuthPromptModal(
        context: context,
        authController: authController,
        homeController: homeController,
        languageController: languageController,
        title: title,
        message: message,
      );
    }
  }

  static void showAuthPromptModal({
    required BuildContext context,
    required AuthController authController,
    required HomeController homeController,
    LanguageController? languageController,
    String? title,
    String? message,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Lock Icon Badge
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4EA),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F9D58).withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lock_person_rounded,
                  color: Color(0xFF0F9D58),
                  size: 38,
                ),
              ),

              const SizedBox(height: 18),

              // Title
              Text(
                title ?? 'লগইন বা সাইন-আপ প্রয়োজন',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Message
              Text(
                message ?? 'এই সেবাটি অ্যাক্সেস করতে অনুগ্রহ করে আপনার মেডিসেবা অ্যাকাউন্টে লগইন করুন অথবা নতুন অ্যাকাউন্ট তৈরি করুন।',
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF64748B),
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 26),

              // Login Button (Primary Emerald)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginView(
                          homeController: homeController,
                          authController: authController,
                          languageController: languageController,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.login_rounded, size: 20, color: Colors.white),
                  label: const Text(
                    'লগইন করুন',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A859),
                    elevation: 3,
                    shadowColor: const Color(0xFF00A859).withValues(alpha: 0.35),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Register Button (Outlined)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegisterView(
                          homeController: homeController,
                          authController: authController,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add_outlined, size: 20, color: Color(0xFF00A859)),
                  label: const Text(
                    'নতুন অ্যাকাউন্ট তৈরি করুন',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00A859),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF00A859), width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Cancel Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'পরে করব',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
