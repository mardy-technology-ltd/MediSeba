import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/custom_app_bar.dart';
import 'donor_list_view.dart';
// import 'donor_reviews_view.dart';
// import 'review_submitted_success_view.dart';

class DonorProfileView extends StatelessWidget {
  final BloodDonor donor;

  const DonorProfileView({
    super.key,
    required this.donor,
  });

  static const Color brandRed = Color(0xFFE11D48);
  static const Color brandRedDark = Color(0xFF991B1B);
  static const Color brandGreen = Color(0xFF008744);
  static const Color bgCanvas = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('কল করা সম্ভব হচ্ছে না: $phoneNumber')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: const CustomAppBar(
        title: 'রক্তদাতার প্রোফাইল',
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── 1. HERO HEADER PROFILE CARD ───────────────────────────
                  _buildProfileHeroCard(context),

                  const SizedBox(height: 20),

                  // ─── 2. QUICK CONTACT ACTION ROW ───────────────────────────
                  _buildQuickContactRow(context),

                  const SizedBox(height: 20),

                  // ─── 3. DONOR INFORMATION SECTIONS ────────────────────────
                  _buildInfoCard(
                    title: 'ব্যক্তিগত ও জরুরি তথ্য',
                    icon: Icons.person_rounded,
                    children: [
                      _buildInfoRow(Icons.badge_outlined, 'রক্তদাতার নাম', donor.name),
                      _buildInfoRow(Icons.invert_colors_rounded, 'রক্তের গ্রুপ', donor.bloodGroup, isHighlight: true),
                      _buildInfoRow(Icons.phone_iphone_rounded, 'ফোন নম্বর', donor.contactNumber),
                      _buildInfoRow(Icons.wc_rounded, 'লিঙ্গ (Gender)', donor.gender),
                      _buildInfoRow(Icons.history_rounded, 'সর্বশেষ রক্তদানের সময়', donor.lastDonationDate),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _buildInfoCard(
                    title: 'ঠিকানা ও অবস্থান',
                    icon: Icons.location_on_rounded,
                    children: [
                      _buildInfoRow(Icons.map_outlined, 'বিভাগ', donor.division),
                      _buildInfoRow(Icons.location_city_outlined, 'জেলা', donor.district),
                      _buildInfoRow(Icons.holiday_village_outlined, 'উপজেলা / থানা', donor.thana),
                      _buildInfoRow(Icons.place_outlined, 'বিস্তারিত ঠিকানা', donor.address),
                    ],
                  ),

                  // const SizedBox(height: 20),

                  // ─── 4. REVIEWS & RATING ACTION BUTTONS (COMMENTED OUT) ─────
                  // _buildActionButtons(context),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── HERO HEADER PROFILE CARD ──────────────────────────────────────
  Widget _buildProfileHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Banner Top Background
          Container(
            height: 110,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [brandRed, brandRedDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Positioned(
                  right: 14,
                  top: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_user_rounded, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'ভেরিফাইড রক্তদাতা',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Overlapping Avatar & Main Details
          Transform.translate(
            offset: const Offset(0, -42),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 104,
                      height: 104,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(52),
                        child: Image.network(
                          donor.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: const Color(0xFFF1F5F9),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 50,
                              color: brandRed,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        color: brandGreen,
                        size: 22,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Name
                Text(
                  donor.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 4),

                // Address Subtitle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 15, color: textMuted),
                    const SizedBox(width: 4),
                    Text(
                      donor.address,
                      style: const TextStyle(fontSize: 13, color: textMuted, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Blood Group Badge Box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE4E6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFECDD3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.water_drop_rounded, size: 16, color: brandRed),
                      const SizedBox(width: 6),
                      Text(
                        'রক্তের গ্রুপ: ${donor.bloodGroup}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: brandRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── QUICK CONTACT ACTION BUTTONS ──────────────────────────────────
  Widget _buildQuickContactRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _makePhoneCall(context, donor.contactNumber),
            icon: const Icon(Icons.phone_in_talk_rounded, size: 18, color: Colors.white),
            label: const Text(
              'সরাসরি কল দিন',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: brandGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ডোনারের তথ্য কপি হয়েছে')),
              );
            },
            icon: const Icon(Icons.share_rounded, size: 18, color: textDark),
            label: const Text(
              'শেয়ার করুন',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textDark),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Color(0xFFCBD5E1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // ─── CARD WITH FIELD ROWS ──────────────────────────────────────────
  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: brandRed, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: isHighlight ? brandRed : textMuted),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: textMuted,
            ),
          ),
          const Spacer(),
          Text(
            value.isNotEmpty ? value : 'N/A',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isHighlight ? FontWeight.w900 : FontWeight.w700,
              color: isHighlight ? brandRed : textDark,
            ),
          ),
        ],
      ),
    );
  }

  /*
  // ─── ACTION BUTTONS (COMMENTED OUT) ────────────────────────────────
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // See Reviews
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DonorReviewsView(donorName: donor.name),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'রিভিউ ও মতামত দেখুন',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: textMuted, size: 22),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Give Review Button
        InkWell(
          onTap: () => _showGiveReviewModal(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: brandGreen,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: brandGreen.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rate_review_rounded, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text(
                  'রিভিউ ও রেটিং দিন',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showGiveReviewModal(BuildContext context) {
    int rating = 5;
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${donor.name}-কে রিভিউ দিন',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close_rounded, color: textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Rating stars
                  const Text(
                    'রেটিং নির্বাচন করুন',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starNumber = index + 1;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() => rating = starNumber);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(
                            starNumber <= rating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: const Color(0xFFFFB800),
                            size: 36,
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),

                  // Comment Input
                  const Text(
                    'আপনার মতামত লিখুন',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      controller: commentController,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 14, color: textDark),
                      decoration: const InputDecoration(
                        hintText: 'ডোনার সম্পর্কে আপনার অভিজ্ঞতা বা মন্তব্য লিখুন...',
                        hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReviewSubmittedSuccessView(),
                          ),
                        );
                      },
                      child: const Text(
                        'রিভিউ জমা দিন',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  */
}
