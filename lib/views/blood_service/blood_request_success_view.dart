import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/helpline_bottom_sheet.dart';

Future<void> showBloodRequestSuccessDialog(BuildContext context) async {
  // Show non-dismissible success popup dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Colors.white,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // SVG Illustration
              Center(
                child: SvgPicture.asset(
                  'assets/images/blood_request_submitted.svg',
                  width: 200,
                  height: 160,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              // Title
              const Text(
                'Your Request Have Submitted',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155),
                  letterSpacing: 0.2,
                ),
              ),

              const SizedBox(height: 10),

              // Subtitle Message
              const Text(
                'We appreciate your request our team will reach you in 48 hours of your request',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF94A3B8),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  // Auto-dismiss dialog and automatically navigate back after 2.5 seconds
  await Future.delayed(const Duration(milliseconds: 2500));

  if (context.mounted) {
    Navigator.of(context, rootNavigator: true).pop(); // Close dialog
    Navigator.of(context).pop(); // Auto-navigate back to previous screen
  }
}

class BloodRequestSuccessView extends StatelessWidget {
  const BloodRequestSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // SVG Illustration
              Center(
                child: SvgPicture.asset(
                  'assets/images/blood_request_submitted.svg',
                  width: 240,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 36),

              // Title
              const Text(
                'Your Request Have Submitted',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155),
                  letterSpacing: 0.2,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle Message
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'We appreciate your request our team will reach you in 48 hours of your request',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF94A3B8),
                    height: 1.4,
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // Bottom Action Buttons
              Row(
                children: [
                  // Back To Home Button
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFED1C24),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        child: const Text(
                          'Back To Home',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Call Now Button
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF008744),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          showHelplineBottomSheet(context);
                        },
                        child: const Text(
                          'Call Now',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
