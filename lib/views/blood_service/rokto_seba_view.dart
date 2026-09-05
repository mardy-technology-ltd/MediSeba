import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/custom_app_bar.dart';
import 'donate_blood_view.dart';
import 'donor_list_view.dart';
import 'donor_profile_view.dart';
import 'request_blood_view.dart';

class RoktoSebaView extends StatefulWidget {
  final LanguageController? languageController;

  const RoktoSebaView({super.key, this.languageController});

  @override
  State<RoktoSebaView> createState() => _RoktoSebaViewState();
}

class _RoktoSebaViewState extends State<RoktoSebaView> {
  static const Color brandRed = Color(0xFFE11D48);
  static const Color brandRedDark = Color(0xFF991B1B);
  static const Color bgCanvas = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);

  final TextEditingController _searchController = TextEditingController();
  String _selectedBloodGroup = 'All';

  final List<BloodDonor> _allDonors = const [
    BloodDonor(
      name: 'মোঃ আরিফ হোসেন',
      bloodGroup: 'A+',
      contactNumber: '01752131365',
      address: 'তালাইমারী, রাজশাহী',
      lastDonationDate: '৩ মাস আগে',
      imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80',
      isVerified: true,
    ),
    BloodDonor(
      name: 'তানজিলা আক্তার',
      bloodGroup: 'O+',
      contactNumber: '01710000010',
      address: 'উত্তরা, ঢাকা',
      lastDonationDate: '৪ মাস আগে',
      imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80',
      isVerified: true,
    ),
    BloodDonor(
      name: 'রাকিবুল ইসলাম',
      bloodGroup: 'B+',
      contactNumber: '01819000020',
      address: 'জিইসি, চট্টগ্রাম',
      lastDonationDate: '৬ মাস আগে',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&auto=format&fit=crop&q=80',
      isVerified: true,
    ),
    BloodDonor(
      name: 'সাকিব আল হাসান',
      bloodGroup: 'AB+',
      contactNumber: '01912000030',
      address: 'বয়রা, খুলনা',
      lastDonationDate: '২ মাস আগে',
      imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&auto=format&fit=crop&q=80',
      isVerified: true,
    ),
    BloodDonor(
      name: 'নাসরিন সুলতানা',
      bloodGroup: 'O-',
      contactNumber: '01711000040',
      address: 'চৌহাট্টা, সিলেট',
      lastDonationDate: '৫ মাস আগে',
      imageUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=400&auto=format&fit=crop&q=80',
      isVerified: true,
    ),
    BloodDonor(
      name: 'মাহমুদুল হাসান',
      bloodGroup: 'A-',
      contactNumber: '01511000050',
      address: 'রূপাতলী, বরিশাল',
      lastDonationDate: '১ বছর আগে',
      imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&auto=format&fit=crop&q=80',
      isVerified: true,
    ),
  ];

  final List<String> _bloodGroups = [
    'All',
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('কল করা সম্ভব হচ্ছে না: $phoneNumber')),
        );
      }
    }
  }

  List<BloodDonor> get _filteredDonors {
    final query = _searchController.text.trim().toLowerCase();
    return _allDonors.where((donor) {
      final matchesGroup = _selectedBloodGroup == 'All' || donor.bloodGroup == _selectedBloodGroup;
      final matchesQuery = query.isEmpty ||
          donor.name.toLowerCase().contains(query) ||
          donor.address.toLowerCase().contains(query) ||
          donor.bloodGroup.toLowerCase().contains(query) ||
          donor.contactNumber.contains(query);
      return matchesGroup && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: const CustomAppBar(
        title: 'রক্তসেবা (Blood Bank)',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── 1. HERO EMERGENCY BANNER CARD ────────────────────────────
              _buildHeroBannerCard(context),

              const SizedBox(height: 20),

              // ─── 2. QUICK ACTION TILES ────────────────────────────────────
              _buildQuickActionRow(context),

              const SizedBox(height: 20),

              // ─── 3. BLOOD GROUP FILTER CARD ───────────────────────────────
              _buildFilterCard(context),

              const SizedBox(height: 20),

              // ─── 4. DONORS LIST SECTION ──────────────────────────────────
              _buildDonorsHeader(),

              const SizedBox(height: 12),

              if (_filteredDonors.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.search_off_rounded, size: 48, color: textMuted),
                      SizedBox(height: 8),
                      Text(
                        'কোনো রক্তদাতা পাওয়া যায়নি',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'অন্য কোনো রক্তের গ্রুপ বা এলাকা দিয়ে চেষ্টা করুন',
                        style: TextStyle(fontSize: 12, color: textMuted),
                      ),
                    ],
                  ),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 560;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWide ? 2 : 1,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        mainAxisExtent: 154,
                      ),
                      itemCount: _filteredDonors.length,
                      itemBuilder: (context, index) {
                        final donor = _filteredDonors[index];
                        return _buildWebStyleDonorCard(context, donor);
                      },
                    );
                  },
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ─── HERO BANNER CARD WIDGET ───────────────────────────────────────
  Widget _buildHeroBannerCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [brandRed, brandRedDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: brandRed.withValues(alpha: 0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Glass Badge Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.water_drop_rounded, size: 14, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      'রক্তদান ব্লাড ব্যাংক (Emergency Blood Bank)',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Title
              const Text(
                'জরুরি প্রয়োজনে রক্তদাতা ও রক্তসেবা দ্রুত খুঁজুন',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.3,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                'আপনার এলাকায় যেকোনো গ্রুপের জরুরি রক্তের জন্য আমাদের ভেরিফাইড রক্তদাতাদের সাথে সরাসরি যোগাযোগ করুন।',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),

              // Call Helpline Button
              InkWell(
                onTap: () => _makePhoneCall('09647111666'),
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone_in_talk_rounded, color: brandRed, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'জরুরি হটলাইন: 09647111666',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: brandRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── QUICK ACTION TILES ROW ───────────────────────────────────────
  Widget _buildQuickActionRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionTile(
            title: 'রক্ত চাই',
            subtitle: 'জরুরি রক্তের আবেদন করুন',
            icon: Icons.water_drop_rounded,
            iconColor: const Color(0xFFE11D48),
            iconBg: const Color(0xFFFFE4E6),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RequestBloodView()),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionTile(
            title: 'রক্ত দিতে চাই',
            subtitle: 'রক্তদাতা হিসেবে যুক্ত হন',
            icon: Icons.favorite_rounded,
            iconColor: const Color(0xFF10B981),
            iconBg: const Color(0xFFD1FAE5),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DonateBloodView()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── FILTER CARD WIDGET ───────────────────────────────────────────
  Widget _buildFilterCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
          const Text(
            'রক্তের গ্রুপ সিলেক্ট করুন',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'আপনার প্রয়োজনীয় গ্রুপের ব্লাড ডোনার খুঁজুন',
            style: TextStyle(fontSize: 12, color: textMuted),
          ),
          const SizedBox(height: 14),

          // Search Field
          TextField(
            controller: _searchController,
            onChanged: (val) => setState(() {}),
            style: const TextStyle(fontSize: 14, color: textDark),
            decoration: InputDecoration(
              hintText: '🔍 এলাকা, জেলা বা ডোনারের নাম লিখুন...',
              hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: brandRed, width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Horizontal Blood Group Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _bloodGroups.map((group) {
                final isSelected = _selectedBloodGroup == group;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedBloodGroup = group;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? brandRed : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: brandRed.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        group,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ─── DONORS HEADER WIDGET ──────────────────────────────────────────
  Widget _buildDonorsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.people_alt_rounded, size: 18, color: brandRed),
            const SizedBox(width: 6),
            Text(
              'রক্তদাতাদের তালিকা (${_filteredDonors.length})',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DonorListView()),
            );
          },
          child: const Row(
            children: [
              Text(
                'সব দেখুন ›',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: brandRed,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── WEB-STYLE DONOR CARD WIDGET ──────────────────────────────────
  Widget _buildWebStyleDonorCard(BuildContext context, BloodDonor donor) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DonorProfileView(donor: donor),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Name + Verified Check & Blood Group Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          donor.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified_rounded,
                        color: Color(0xFF10B981),
                        size: 16,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Blood Group Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE4E6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFECDD3)),
                  ),
                  child: Text(
                    donor.bloodGroup,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: brandRed,
                    ),
                  ),
                ),
              ],
            ),

            // Location Pin
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: textMuted,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    donor.address,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const Divider(height: 1, color: Color(0xFFF1F5F9)),

            // Bottom Row: Donation Time & Direct Call Pill Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'শেষ দান: ${donor.lastDonationDate}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // Call Pill Button
                InkWell(
                  onTap: () => _makePhoneCall(donor.contactNumber),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: brandRed,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: brandRed.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone_rounded, color: Colors.white, size: 13),
                        SizedBox(width: 4),
                        Text(
                          'কল দিন',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
