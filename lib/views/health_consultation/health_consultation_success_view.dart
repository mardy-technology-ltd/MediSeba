import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/language_controller.dart';

class HealthConsultationSuccessView extends StatelessWidget {
  final LanguageController? languageController;

  const HealthConsultationSuccessView({
    super.key,
    this.languageController,
  });

  static const brandGreen = Color(0xFF008536);
  static const darkForest = Color(0xFF064E3B);
  static const textDark = Color(0xFF1E293B);

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final langController = languageController ?? LanguageController();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: Text(
          langController.tr('পরামর্শের অবস্থা', 'Consultation Status'),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),

                      // 1. Success Circle Badge Graphic
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: brandGreen.withValues(alpha: 0.25),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: const BoxDecoration(
                              color: brandGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 42,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 2. Main Title
                      Text(
                        langController.tr(
                          'আপনার প্রশ্নটি সফলভাবে জমা হয়েছে!',
                          'Your Question Has Been Submitted Successfully!',
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: textDark,
                          height: 1.25,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 10),

                      // 3. Ticket ID Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
                        ),
                        child: Text(
                          langController.tr('টিকেট আইডি: #MS-84920', 'Ticket ID: #MS-84920'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: darkForest,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 4. Detailed Informative Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                              Icons.schedule_rounded,
                              langController.tr(
                                'আগামী ২৪ - ৪৮ ঘণ্টার মধ্যে আমাদের অভিজ্ঞ ডাক্তার টিম আপনার প্রশ্নের সঠিক সমাধান প্রদান করবেন।',
                                'Our doctor team will review and respond within 24-48 hours.',
                              ),
                            ),
                            const Divider(height: 20, color: Color(0xFFF1F5F9)),
                            _buildInfoRow(
                              Icons.lock_rounded,
                              langController.tr(
                                'সম্পূর্ণ গোপনীয়তা রক্ষা করে আপনার নোটিফিকেশন ও প্রোফাইলে উত্তরটি পাঠানো হবে।',
                                'Your response will be delivered privately to your profile & notifications.',
                              ),
                            ),
                            const Divider(height: 20, color: Color(0xFFF1F5F9)),
                            _buildInfoRow(
                              Icons.headset_mic_rounded,
                              langController.tr(
                                'জরুরি যেকোনো তথ্যের জন্য মেডিসেবা কাস্টমার হটলাইনে কল করতে পারেন।',
                                'For urgent advice, call our customer care helpline anytime.',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 5. Action Buttons (Call Now & Back To Home)
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => _makePhoneCall('09647111666'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandGreen,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 18),
                      label: Text(
                        langController.tr('জরুরি হটলাইনে কল করুন (09647111666)', 'Call Emergency Helpline (09647111666)'),
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.home_rounded, color: Color(0xFF475569), size: 18),
                      label: Text(
                        langController.tr('হোম পেজে ফিরে যান', 'Back To Home'),
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: brandGreen, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF334155),
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
