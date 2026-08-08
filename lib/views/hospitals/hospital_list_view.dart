import 'package:flutter/material.dart';

class HospitalListView extends StatefulWidget {
  final bool showAppBar;
  const HospitalListView({super.key, this.showAppBar = false});

  @override
  State<HospitalListView> createState() => _HospitalListViewState();
}

class _HospitalListViewState extends State<HospitalListView> {
  static const brandGreen = Color(0xFF008536);
  static const textDark = Color(0xFF1E293B);
  static const textMuted = Color(0xFF64748B);

  final TextEditingController _searchController = TextEditingController();

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'হাসপাতাল ও ডায়াগনস্টিক',
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
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'হাসপাতাল বা ডায়াগনস্টিক সেন্টার খুঁজুন...',
                  hintStyle: const TextStyle(fontSize: 13, color: textMuted),
                  prefixIcon: const Icon(Icons.search_rounded, color: brandGreen),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
            ),

            // List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                itemCount: hospitals.length,
                itemBuilder: (context, index) {
                  final item = hospitals[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                          child: Image.network(
                            item['imageUrl']!,
                            width: 105,
                            height: 115,
                            fit: BoxFit.cover,
                          ),
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
                                    fontWeight: FontWeight.bold,
                                    color: textDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_rounded, size: 14, color: brandGreen),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item['address']!,
                                        style: const TextStyle(fontSize: 12, color: textMuted),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFFF59E0B)),
                                    const SizedBox(width: 4),
                                    Text(
                                      item['time']!,
                                      style: const TextStyle(fontSize: 12, color: textMuted),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDCFCE7),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.call_rounded, size: 12, color: brandGreen),
                                          const SizedBox(width: 4),
                                          Text(
                                            item['phone']!,
                                            style: const TextStyle(
                                              fontSize: 11,
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
