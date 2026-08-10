import 'package:flutter/material.dart';
import '../../controllers/language_controller.dart';

class NotificationView extends StatelessWidget {
  final LanguageController? languageController;

  const NotificationView({super.key, this.languageController});

  static const brandGreen = Color(0xFF008536);
  static const textDark = Color(0xFF1E293B);
  static const textMuted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'মেডি সেবা সার্ভিস আপডেট',
        'subtitle': 'এখন ঘরে বসেই ডাক্তার সিরিয়াল ও স্বাস্থ্য পরামর্শ নিন একদম সহজে!',
        'time': '১০ মিনিট আগে',
        'icon': Icons.medical_information_rounded,
        'color': const Color(0xFF0F9D58),
        'bg': const Color(0xFFE8F5E9),
      },
      {
        'title': 'ডাক্তার অপয়েন্টমেন্ট রিমাইন্ডার',
        'subtitle': 'আপনার আগামী কাল সকাল ১০:০০ টায় জেনারেল ফিজিশিয়ানের অ্যাপয়েন্টমেন্ট রয়েছে।',
        'time': '২ ঘণ্টা আগে',
        'icon': Icons.event_available_rounded,
        'color': const Color(0xFF1565C0),
        'bg': const Color(0xFFE3F2FD),
      },
      {
        'title': 'জরুরি অ্যাম্বুলেন্স সেবা',
        'subtitle': 'মেডি সেবা ২৪/৭ জরুরি অ্যাম্বুলেন্স সার্ভিস এখন চালু রয়েছে।',
        'time': '১ দিন আগে',
        'icon': Icons.airport_shuttle_rounded,
        'color': const Color(0xFFE53935),
        'bg': const Color(0xFFFFEBEE),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'নোটিফিকেশন',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${notifications.length} নতুন',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: brandGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Notification List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: item['bg'] as Color,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: item['color'] as Color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item['title'] as String,
                                      style: const TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                        color: textDark,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    item['time'] as String,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: textMuted,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item['subtitle'] as String,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: textMuted,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
