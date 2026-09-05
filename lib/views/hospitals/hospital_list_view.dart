import 'dart:ui';
import 'package:flutter/material.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/custom_app_bar.dart';

class HospitalListView extends StatefulWidget {
  final bool showAppBar;
  final LanguageController? languageController;

  const HospitalListView({
    super.key,
    this.showAppBar = false,
    this.languageController,
  });

  @override
  State<HospitalListView> createState() => _HospitalListViewState();
}

class _HospitalListViewState extends State<HospitalListView> {
  static const brandGreen = Color(0xFF008536);
  static const textDark = Color(0xFF1E293B);
  static const textMuted = Color(0xFF64748B);

  final TextEditingController _searchController = TextEditingController();
  late final LanguageController _langController;

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {});
  }

  final List<Map<String, String>> hospitals = [
    {
      'name': 'পপুলার ডায়াগনস্টিক সেন্টার',
      'address': 'হাউজ #১৬, রোড #২, ধানমন্ডি, ঢাকা',
      'time': '২৪ ঘণ্টা খোলা',
      'phone': '09613787801',
      'imageUrl': 'https://img.freepik.com/free-photo/empty-emergency-room-with-medical-equipment_23-2149138092.jpg',
    },
    {
      'name': 'ল্যাবএইড স্পেশালাইজড হাসপাতাল',
      'address': 'মিরপুর রোড, ধানমন্ডি, ঢাকা',
      'time': '২৪ ঘণ্টা খোলা',
      'phone': '10606',
      'imageUrl': 'https://img.freepik.com/free-photo/modern-operating-room-hospital_23-2148942918.jpg',
    },
    {
      'name': 'স্কয়ার হাসপাতাল',
      'address': '১৮/এফ বীর উত্তম কাজী নুরুজ্জামান সড়ক, ঢাকা',
      'time': '২৪ ঘণ্টা খোলা',
      'phone': '10616',
      'imageUrl': 'https://img.freepik.com/free-photo/interior-view-operating-room_1170-2254.jpg',
    },
    {
      'name': 'ইবনে সিনা ডায়াগনস্টিক সেন্টার',
      'address': 'ধানমন্ডি, ঢাকা',
      'time': '০৭:০০ am - ১১:০০ pm',
      'phone': '09610009610',
      'imageUrl': 'https://img.freepik.com/free-photo/medical-clinic-reception-counter-registration_482257-26804.jpg',
    },
  ];

  List<Map<String, String>> get _filteredHospitals {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return hospitals;
    return hospitals.where((h) {
      final name = h['name']?.toLowerCase() ?? '';
      final address = h['address']?.toLowerCase() ?? '';
      return name.contains(query) || address.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredHospitals;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: widget.showAppBar
          ? CustomAppBar(
              title: _langController.tr('হাসপাতাল ও ডায়াগনস্টিক', 'Hospitals & Diagnostics'),
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            // Ambient Glow Orbs in background matching home & offer view
            Positioned(
              top: -60,
              left: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: brandGreen.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              right: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.06), // Sky Blue Accent
                ),
              ),
            ),

            Column(
              children: [
                // Glassmorphic Search Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: brandGreen.withValues(alpha: 0.03),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textDark,
                          ),
                          decoration: InputDecoration(
                            hintText: _langController.tr('হাসপাতাল বা ডায়াগনস্টিক সেন্টার খুঁজুন...', 'Search hospitals or diagnostic centers...'),
                            hintStyle: const TextStyle(fontSize: 12, color: textMuted, fontWeight: FontWeight.w500),
                            prefixIcon: const Icon(Icons.search_rounded, color: brandGreen, size: 22),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, color: Colors.grey, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                      });
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // List View for Hospitals
                Expanded(
                  child: list.isEmpty
                      ? Center(
                          child: Text(
                            _langController.tr('কোনো হাসপাতাল পাওয়া যায়নি', 'No hospitals found'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textMuted,
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 100),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final item = list[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 14,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.7),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.55), width: 1.5),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Left Image section with partner badge overlay
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius.horizontal(left: Radius.circular(19)),
                                              child: Image.network(
                                                item['imageUrl']!,
                                                width: 110,
                                                height: 125,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              top: 6,
                                              left: 6,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(
                                                    colors: [brandGreen, Color(0xFF0F9D58)],
                                                  ),
                                                  borderRadius: BorderRadius.circular(5),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: brandGreen.withValues(alpha: 0.25),
                                                      blurRadius: 4,
                                                      offset: const Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  _langController.tr('অংশীদার', 'Partner'),
                                                  style: const TextStyle(
                                                    fontSize: 7.5,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['name']!,
                                                  style: const TextStyle(
                                                    fontSize: 14.5,
                                                    fontWeight: FontWeight.w900,
                                                    color: textDark,
                                                    height: 1.25,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.location_on_rounded, size: 13, color: brandGreen),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        item['address']!,
                                                        style: const TextStyle(fontSize: 11.5, color: textMuted, fontWeight: FontWeight.w500),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.access_time_rounded, size: 13, color: Color(0xFFFBBF24)),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      item['time']!,
                                                      style: const TextStyle(fontSize: 11.5, color: textMuted, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                      decoration: BoxDecoration(
                                                        color: brandGreen.withValues(alpha: 0.12),
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(color: brandGreen.withValues(alpha: 0.15), width: 0.8),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          const Icon(Icons.call_rounded, size: 11, color: brandGreen),
                                                          const SizedBox(width: 4),
                                                          Text(
                                                            item['phone']!,
                                                            style: const TextStyle(
                                                              fontSize: 10.5,
                                                              fontWeight: FontWeight.bold,
                                                              color: brandGreen,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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
