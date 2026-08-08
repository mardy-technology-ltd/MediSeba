import 'package:flutter/material.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  static const brandGreen = Color(0xFF008536);
  static const textDark = Color(0xFF1E293B);
  static const textMuted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFF64748B),
                        size: 20,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'আমাদের সম্পর্কে (About Us)',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),

            // Content Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Official MediSeba Banner Image
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          'assets/images/mediseba_banner.jpeg',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Introduction Card
                    _buildContentCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('আমাদের পরিচিতি', Icons.info_outline_rounded),
                          const SizedBox(height: 10),
                          const Text(
                            'মেডিসেবা একটি আধুনিক ডিজিটাল স্বাস্থ্যসেবা প্রতিষ্ঠান, যার মূল লক্ষ্য প্রযুক্তির মাধ্যমে বাংলাদেশের প্রতিটি মানুষের কাছে সহজ, দ্রুত, নির্ভরযোগ্য ও সাশ্রয়ী স্বাস্থ্যসেবা পৌঁছে দেওয়া।',
                            style: TextStyle(
                              fontSize: 14.5,
                              color: textDark,
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'বর্তমান সময়ে অনেক মানুষ বিশেষজ্ঞ ডাক্তারের কাছে সহজে পৌঁছাতে পারেন না বা প্রয়োজনীয় স্বাস্থ্যসেবা সময়মতো পান না। এই সমস্যা সমাধানের লক্ষ্যে মেডিসেবা একটি সমন্বিত স্বাস্থ্যসেবা প্ল্যাটফর্ম হিসেবে কাজ করছে।',
                            style: TextStyle(
                              fontSize: 14.5,
                              color: textDark,
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Services Card
                    _buildContentCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('মেডিসেবার প্রধান সেবাসমূহ', Icons.medical_services_outlined),
                          const SizedBox(height: 14),
                          _buildServiceTile(Icons.medical_information_outlined, 'অনলাইন ও অফলাইন ডাক্তার পরামর্শ'),
                          _buildServiceTile(Icons.video_call_outlined, 'ভিডিও কলের মাধ্যমে বিশেষজ্ঞ ডাক্তারের কনসালটেশন'),
                          _buildServiceTile(Icons.receipt_long_outlined, 'অনলাইন প্রেসক্রিপশন ও ফলো-আপ সেবা'),
                          _buildServiceTile(Icons.local_pharmacy_outlined, 'বাসায় ওষুধ সরবরাহের সুবিধা'),
                          _buildServiceTile(Icons.airport_shuttle_outlined, 'অ্যাম্বুলেন্স সেবা'),
                          _buildServiceTile(Icons.bloodtype_outlined, 'রক্তসেবা (রক্তদাতা খুঁজে পেতে সহায়তা)'),
                          _buildServiceTile(Icons.biotech_outlined, 'বিভিন্ন স্বাস্থ্য পরীক্ষা ও ফ্যামিলি হেলথ প্যাকেজ'),
                          _buildServiceTile(Icons.health_and_safety_outlined, 'স্বাস্থ্যসেবা বিষয়ক তথ্য ও পরামর্শ'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Dealer Network Card
                    _buildContentCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('ডিলার ও প্রতিনিধি নেটওয়ার্ক', Icons.hub_outlined),
                          const SizedBox(height: 10),
                          const Text(
                            'এছাড়াও মেডিসেবা দেশের বিভিন্ন এলাকায় ডিলার ও প্রতিনিধি নেটওয়ার্কের মাধ্যমে স্থানীয় জনগণের কাছে স্বাস্থ্যসেবা পৌঁছে দিতে কাজ করছে। ডিলাররা তাদের নিজ নিজ এলাকায় মেডিসেবার সেবা পরিচিত করা, গ্রাহক নিবন্ধন, স্বাস্থ্যসেবা সমন্বয় এবং স্থানীয় পর্যায়ে সেবা সম্প্রসারণে গুরুত্বপূর্ণ ভূমিকা পালন করেন।',
                            style: TextStyle(
                              fontSize: 14.5,
                              color: textDark,
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Mission & Vision Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFC8E6C9), width: 1.2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.flag_outlined, color: brandGreen, size: 22),
                              SizedBox(width: 8),
                              Text(
                                'আমাদের লক্ষ্য (Our Mission)',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: brandGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'আমাদের লক্ষ্য হলো প্রযুক্তির সহায়তায় একটি বিশ্বস্ত স্বাস্থ্যসেবা নেটওয়ার্ক গড়ে তোলা, যাতে শহর থেকে শুরু করে প্রত্যন্ত অঞ্চলের মানুষও সহজে মানসম্মত স্বাস্থ্যসেবা গ্রহণ করতে পারেন।',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: textDark,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: brandGreen, size: 20),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceTile(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: brandGreen, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textDark,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
