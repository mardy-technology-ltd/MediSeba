import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showHelplineBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const HelplineBottomSheet(),
  );
}

class HelplineBottomSheet extends StatelessWidget {
  const HelplineBottomSheet({super.key});

  static const hotlinePhone = '+88009647111666';
  static const hotlinePhoneDisplay = '+880 09647 111 666';
  static const supportEmail = 'info@mediseba.org';

  Future<void> _makePhoneCall() async {
    final Uri uri = Uri.parse('tel:$hotlinePhone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error making phone call: $e');
    }
  }

  Future<void> _openWhatsApp() async {
    final Uri uri = Uri.parse('https://wa.me/8809647111666?text=${Uri.encodeComponent('হ্যালো মেডিসেবা, আমার তথ্য/সহায়তা প্রয়োজন।')}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error opening WhatsApp: $e');
    }
  }

  Future<void> _sendEmail() async {
    final Uri uri = Uri.parse('mailto:$supportEmail?subject=${Uri.encodeComponent('MediSeba Helpline Query')}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error sending email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Pill handle
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Header Title & Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.headset_mic_rounded,
                      color: Color(0xFF0F9D58),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'হেল্পলাইন ও সাপোর্ট',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'মেডিসেবার যেকোনো প্রয়োজনে আমাদের সাথে সরাসরি যোগাযোগ করুন:',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 1. Direct Phone Call Card
          _buildOptionCard(
            context: context,
            iconData: Icons.phone_in_talk_rounded,
            iconBgColor: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF0F9D58),
            title: 'হটলাইনে কল করুন',
            subtitle: hotlinePhoneDisplay,
            badgeText: '24/7 Helpline',
            onTap: () {
              Navigator.pop(context);
              _makePhoneCall();
            },
          ),

          const SizedBox(height: 12),

          // 2. WhatsApp Support Card
          _buildOptionCard(
            context: context,
            iconData: Icons.chat_bubble_rounded,
            iconBgColor: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF25D366),
            title: 'হোয়াটসঅ্যাপে মেসেজ দিন',
            subtitle: 'তাৎক্ষণিক চ্যাট সাপোর্ট',
            badgeText: 'WhatsApp',
            onTap: () {
              Navigator.pop(context);
              _openWhatsApp();
            },
          ),

          const SizedBox(height: 12),

          // 3. Email Support Card
          _buildOptionCard(
            context: context,
            iconData: Icons.mail_rounded,
            iconBgColor: const Color(0xFFEEF2FF),
            iconColor: const Color(0xFF6366F1),
            title: 'ইমেইল সাপোর্ট',
            subtitle: supportEmail,
            badgeText: 'Email Us',
            onTap: () {
              Navigator.pop(context);
              _sendEmail();
            },
          ),

          const SizedBox(height: 20),

          // Operating Hours Notice Badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.access_time_filled_rounded,
                  color: Color(0xFF0F9D58),
                  size: 18,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'কাস্টমার সাপোর্ট সময়সূচী: প্রতিদিন সকাল ৮:০০ - রাত ১০:০০',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required IconData iconData,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String badgeText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                iconData,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
