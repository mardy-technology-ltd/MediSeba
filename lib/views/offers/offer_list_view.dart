import 'package:flutter/material.dart';

class OfferListView extends StatelessWidget {
  final bool showAppBar;
  const OfferListView({super.key, this.showAppBar = false});

  static const brandGreen = Color(0xFF0F9D58);
  static const textDark = Color(0xFF1E293B);
  static const textMuted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final offers = [
      {
        'title': '৫০% ছাড় ফুল বডি হেলথ চেকআপ',
        'subtitle': 'পপুলার ডায়াগনস্টিক সেন্টারে পাচ্ছেন বিশেষ ছাড়।',
        'code': 'HEALTH50',
        'badge': '৫০% OFF',
        'validity': 'মেয়াদ: ৩১ আগস্ট পর্যন্ত',
        'color': const Color(0xFFE53935),
        'bg': const Color(0xFFFFEBEE),
      },
      {
        'title': 'ডাক্তার অপয়েন্টমেন্টে ২০% ক্যাশব্যাক',
        'subtitle': 'মেডি সেবা অ্যাপ দিয়ে প্রথম সিরিয়ালে ২০% ক্যাশব্যাক।',
        'code': 'MED20',
        'badge': '২০% CASHBACK',
        'validity': 'মেয়াদ: ১৫ আগস্ট পর্যন্ত',
        'color': const Color(0xFF1565C0),
        'bg': const Color(0xFFE3F2FD),
      },
      {
        'title': 'ফ্রি ব্লাড প্রেশার ও সুগার টেস্ট',
        'subtitle': 'সকল রেজিস্টার্ড ইউজারদের জন্য সম্পূর্ণ বিনামূল্যে।',
        'code': 'FREECHECK',
        'badge': 'FREE',
        'validity': 'মেয়াদ: সীমিত সময়ের জন্য',
        'color': const Color(0xFF0F9D58),
        'bg': const Color(0xFFE8F5E9),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: showAppBar
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'বিশেষ অফারসমূহ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Title
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text(
                'বিশেষ ডিসকাউন্ট ও অফারসমূহ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ),

            // Offers List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                itemCount: offers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  return Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (offer['color'] as Color).withValues(alpha: 0.3),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (offer['color'] as Color).withValues(alpha: 0.08),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: offer['bg'] as Color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                offer['badge'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: offer['color'] as Color,
                                ),
                              ),
                            ),
                            Text(
                              offer['validity'] as String,
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          offer['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          offer['subtitle'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            color: textMuted,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFCBD5E1)),
                              ),
                              child: Text(
                                'কোড: ${offer['code']}',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: textDark,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: brandGreen,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              ),
                              child: const Text(
                                'কুপন সংগ্রহ করুন',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
