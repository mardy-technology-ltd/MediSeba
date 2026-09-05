import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/custom_app_bar.dart';
import 'donor_profile_view.dart';

class BloodDonor {
  final String name;
  final String division;
  final String district;
  final String thana;
  final String contactNumber;
  final String address;
  final String bloodGroup;
  final String gender;
  final String lastDonationDate;
  final String imageUrl;
  final bool isVerified;

  const BloodDonor({
    required this.name,
    this.division = 'Dhaka',
    this.district = 'Dhaka',
    this.thana = 'Dhanmondi',
    required this.contactNumber,
    this.address = 'House #12, Road #5, Dhanmondi',
    required this.bloodGroup,
    this.gender = 'Female',
    this.lastDonationDate = '৩ মাস আগে',
    required this.imageUrl,
    this.isVerified = true,
  });
}

class DonorListView extends StatefulWidget {
  const DonorListView({super.key});

  @override
  State<DonorListView> createState() => _DonorListViewState();
}

class _DonorListViewState extends State<DonorListView> {
  static const Color brandRed = Color(0xFFE11D48);
  static const Color brandRedDark = Color(0xFF991B1B);
  static const Color bgCanvas = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);

  final List<BloodDonor> _allDonors = const [
    BloodDonor(
      name: 'মোঃ আরিফ হোসেন',
      bloodGroup: 'A+',
      division: 'Rajshahi',
      district: 'Rajshahi',
      thana: 'Boalia',
      contactNumber: '01752131365',
      address: 'তালাইমারী, রাজশাহী',
      lastDonationDate: '৩ মাস আগে',
      imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80',
      isVerified: true,
    ),
    BloodDonor(
      name: 'তানজিলা আক্তার',
      bloodGroup: 'O+',
      division: 'Dhaka',
      district: 'Dhaka',
      thana: 'Uttara',
      contactNumber: '01710000010',
      address: 'উত্তরা, ঢাকা',
      lastDonationDate: '৪ মাস আগে',
      imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80',
      isVerified: true,
    ),
    BloodDonor(
      name: 'রাকিবুল ইসলাম',
      bloodGroup: 'B+',
      division: 'Chittagong',
      district: 'Chittagong',
      thana: 'Panchlaish',
      contactNumber: '01819000020',
      address: 'জিইসি, চট্টগ্রাম',
      lastDonationDate: '৬ মাস আগে',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&auto=format&fit=crop&q=80',
      isVerified: true,
    ),
    BloodDonor(
      name: 'সাকিব আল হাসান',
      bloodGroup: 'AB+',
      division: 'Khulna',
      district: 'Khulna',
      thana: 'Boyra',
      contactNumber: '01912000030',
      address: 'বয়রা, খুলনা',
      lastDonationDate: '২ মাস আগে',
      imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&auto=format&fit=crop&q=80',
      isVerified: true,
    ),
    BloodDonor(
      name: 'নাসরিন সুলতানা',
      bloodGroup: 'O-',
      division: 'Sylhet',
      district: 'Sylhet',
      thana: 'Chowhatta',
      contactNumber: '01711000040',
      address: 'চৌহাট্টা, সিলেট',
      lastDonationDate: '৫ মাস আগে',
      imageUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=400&auto=format&fit=crop&q=80',
      isVerified: true,
    ),
    BloodDonor(
      name: 'মাহমুদুল হাসান',
      bloodGroup: 'A-',
      division: 'Barisal',
      district: 'Barisal',
      thana: 'Rupatali',
      contactNumber: '01511000050',
      address: 'রূপাতলী, বরিশাল',
      lastDonationDate: '১ বছর আগে',
      imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&auto=format&fit=crop&q=80',
      isVerified: true,
    ),
    BloodDonor(
      name: 'Angela',
      bloodGroup: 'A+',
      division: 'Dhaka',
      district: 'Dhaka',
      thana: 'Dhanmondi',
      contactNumber: '01753227645',
      address: 'ধানমন্ডি, ঢাকা',
      lastDonationDate: '২ মাস আগে',
      imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80',
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

  late List<BloodDonor> _filteredDonors;
  final TextEditingController _searchController = TextEditingController();
  String _selectedBloodGroup = 'All';

  @override
  void initState() {
    super.initState();
    _filteredDonors = List.from(_allDonors);
  }

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

  bool _matchesBilingualQuery(BloodDonor donor, String rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return true;

    final docName = donor.name.toLowerCase();
    final docAddress = donor.address.toLowerCase();
    final docBlood = donor.bloodGroup.toLowerCase();
    final docPhone = donor.contactNumber.toLowerCase();

    if (docName.contains(query) ||
        docAddress.contains(query) ||
        docBlood.contains(query) ||
        docPhone.contains(query)) {
      return true;
    }

    const translations = {
      'rajshahi': ['রাজশাহী', 'তালাইমারী'],
      'dhaka': ['ঢাকা', 'উত্তরা', 'ধানমন্ডি', 'মিরপুর', 'গুলশান'],
      'chittagong': ['চট্টগ্রাম', 'জিইসি'],
      'chattogram': ['চট্টগ্রাম', 'জিইসি'],
      'khulna': ['খুলনা', 'বয়রা'],
      'barisal': ['বরিশাল', 'রূপাতলী'],
      'barishal': ['বরিশাল', 'রূপাতলী'],
      'sylhet': ['সিলেট', 'চৌহাট্টা'],
      'angela': ['angela'],
      'arif': ['আরিফ'],
      'tanjila': ['তানজিলা'],
      'rakibul': ['রাকিবুল'],
      'sakib': ['সাকিব'],
      'hasan': ['হাসান'],
    };

    for (final entry in translations.entries) {
      if (entry.key.contains(query) || query.contains(entry.key)) {
        for (final banglaKeyword in entry.value) {
          if (docAddress.contains(banglaKeyword) || docName.contains(banglaKeyword)) {
            return true;
          }
        }
      }
    }

    return false;
  }

  void _applyFilters() {
    final query = _searchController.text;
    setState(() {
      _filteredDonors = _allDonors.where((donor) {
        final matchesSearch = _matchesBilingualQuery(donor, query);
        final matchesGroup = _selectedBloodGroup == 'All' || donor.bloodGroup == _selectedBloodGroup;
        return matchesSearch && matchesGroup;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: const CustomAppBar(
        title: 'রক্তদাতার তালিকা',
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── SEARCH & FILTER CONTAINER ────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(12),
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
                      children: [
                        // Search Input Box
                        TextField(
                          controller: _searchController,
                          onChanged: (val) => _applyFilters(),
                          style: const TextStyle(fontSize: 14, color: textDark),
                          decoration: InputDecoration(
                            hintText: '🔍 এলাকা, জেলা বা ডোনারের নাম লিখুন...',
                            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: brandRed, width: 1.5),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Horizontal Blood Group Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: _bloodGroups.map((group) {
                              final isSelected = _selectedBloodGroup == group;
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedBloodGroup = group;
                                      _applyFilters();
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(18),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isSelected ? brandRed : const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(18),
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
                                        fontSize: 12.5,
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
                  ),

                  const SizedBox(height: 14),

                  // ─── LIST TITLE & COUNT ────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.people_alt_rounded, size: 18, color: brandRed),
                          const SizedBox(width: 6),
                          Text(
                            'রক্তদাতাদের তালিকা (${_filteredDonors.length} জন)',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ─── FULLY RESPONSIVE RED THEMED DONOR LIST ───────────────
                  Expanded(
                    child: _filteredDonors.isEmpty
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off_rounded, size: 48, color: textMuted),
                                SizedBox(height: 8),
                                Text(
                                  'কোনো রক্তদাতা পাওয়া যায়নি',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textDark),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'অন্য কোনো রক্তের গ্রুপ বা এলাকা দিয়ে চেষ্টা করুন',
                                  style: TextStyle(fontSize: 12, color: textMuted),
                                ),
                              ],
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final isWide = constraints.maxWidth > 540;
                              if (isWide) {
                                return GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    mainAxisExtent: 130,
                                  ),
                                  itemCount: _filteredDonors.length,
                                  itemBuilder: (context, index) {
                                    return _buildRedStyleDonorCard(_filteredDonors[index]);
                                  },
                                );
                              } else {
                                return ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: _filteredDonors.length,
                                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                                  itemBuilder: (context, index) {
                                    return _buildRedStyleDonorCard(_filteredDonors[index]);
                                  },
                                );
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── FULLY RESPONSIVE RED THEMED DONOR CARD WIDGET ─────────────────
  Widget _buildRedStyleDonorCard(BloodDonor donor) {
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
        child: Row(
          children: [
            // Profile Avatar with Red Border & Verified Badge
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: brandRed.withValues(alpha: 0.3), width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      donor.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        color: const Color(0xFFFFE4E6),
                        child: const Icon(
                          Icons.person_rounded,
                          color: brandRed,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                if (donor.isVerified)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_rounded,
                      color: Color(0xFF10B981),
                      size: 15,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),

            // Details Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Name + Blood Badge Row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          donor.name,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),

                      // Blood Group Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE4E6),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFECDD3)),
                        ),
                        child: Text(
                          donor.bloodGroup,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            color: brandRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),

                  // Location Row
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 13, color: textMuted),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          donor.address,
                          style: const TextStyle(
                            fontSize: 12,
                            color: textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 3),

                  // Last Donation Row
                  Row(
                    children: [
                      const Icon(Icons.history_rounded, size: 12, color: textMuted),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          'শেষ দান: ${donor.lastDonationDate}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Red View / Call Button
            InkWell(
              onTap: () => _makePhoneCall(donor.contactNumber),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [brandRed, brandRedDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: brandRed.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 13),
                    SizedBox(width: 4),
                    Text(
                      'কল দিন',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
