import 'package:flutter/material.dart';

class AdminInboxView extends StatefulWidget {
  const AdminInboxView({super.key});

  @override
  State<AdminInboxView> createState() => _AdminInboxViewState();
}

class _AdminInboxViewState extends State<AdminInboxView> {
  static const brandGreen = Color(0xFF0F9D58);
  static const darkGreen = Color(0xFF006B4A);
  static const textDark = Color(0xFF0F172A);

  int _selectedTabIndex = 1; // Default 1: Partnership Applications (as shown in web screenshot)
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String _selectedContactId = 'msg_101';
  String _selectedPartnerId = 'partner_201';
  String _selectedJobId = 'job_301';

  // 1. Contact Messages Mock Data
  final List<Map<String, dynamic>> _contactMessages = [
    {
      'id': 'msg_101',
      'name': 'মোহাম্মদ আলী',
      'phone': '01711223344',
      'time': 'আজ, দুপুর ১২:৫০ PM',
      'message':
          'আসসালামু আলাইকুম। আমি রাজশাহী তালাইমারী পপুলার চেম্বারে অধ্যাপক ড. ফাজলে রাব্বি স্যারের আগামীকালের একটি সিরিয়াল কনফার্ম করতে চাচ্ছি। দয়া করে কল দিন।',
      'isRead': false,
    },
    {
      'id': 'msg_102',
      'name': 'তানিয়া রহমান',
      'phone': '01811223344',
      'time': 'গতকাল, রাত ০৮:১৫ PM',
      'message':
          'হ্যালো মেডিসেব টিম, আমি বিকাশ দিয়ে কনসালটেশন ফি জমা দিয়েছি। রিসিট কপি পেয়েছি। কল কোন সময় আসবে?',
      'isRead': true,
    },
  ];

  // 2. Partnership Applications Mock Data (Matching Web Screenshot precisely)
  final List<Map<String, dynamic>> _partnershipApps = [
    {
      'id': 'partner_201',
      'type': 'Doctor Partner',
      'typeSimple': 'Doctor',
      'typeBg': Color(0xFFDCFCE7),
      'typeColor': Color(0xFF15803D),
      'name': 'Dr. Md. Imran Kabir',
      'bmdc': 'A-10294',
      'specialty': 'Neurology',
      'phone': '01710000001',
      'location': 'Khulna City Medical Center',
      'status': 'পেন্ডিং (Pending)',
      'isApproved': false,
      'approvedSection': null,
    },
    {
      'id': 'partner_202',
      'type': 'Ambulance Partner',
      'typeSimple': 'Ambulance',
      'typeBg': Color(0xFFCCFBF1),
      'typeColor': Color(0xFF0F766E),
      'name': 'Md. Aslam Hossain',
      'bmdc': 'N/A',
      'specialty': 'Emergency Service',
      'phone': '01710000002',
      'location': 'Rajshahi',
      'status': 'এপ্রুভড (Approved)',
      'isApproved': true,
      'approvedSection': 'অ্যাম্বুলেন্স সার্ভিস',
    },
    {
      'id': 'partner_203',
      'type': 'Hospital Partner',
      'typeSimple': 'Hospital/Diagnostic',
      'typeBg': Color(0xFFCFFAFE),
      'typeColor': Color(0xFF0E7490),
      'name': 'Popular Diagnostic Center',
      'bmdc': 'REG-88219',
      'specialty': 'Diagnostic & Pathology',
      'phone': '01710000003',
      'location': 'Talaimari, Rajshahi',
      'status': 'পেন্ডিং (Pending)',
      'isApproved': false,
      'approvedSection': null,
    },
    {
      'id': 'partner_204',
      'type': 'Dealer Partner',
      'typeSimple': 'Medicine Dealer',
      'typeBg': Color(0xFFE0E7FF),
      'typeColor': Color(0xFF4338CA),
      'name': 'SA Health Traders',
      'bmdc': 'DRUG-55410',
      'specialty': 'Pharma Supply',
      'phone': '01710000004',
      'location': 'Bogura',
      'status': 'পেন্ডিং (Pending)',
      'isApproved': false,
      'approvedSection': null,
    },
  ];

  // 3. Job Applications Mock Data
  final List<Map<String, dynamic>> _jobApps = [
    {
      'id': 'job_301',
      'position': 'মেডিকেল অফিসার (Telemedicine Officer)',
      'name': 'Dr. Farhana Yasmin',
      'bmdc': 'A-98124',
      'phone': '01720000001',
      'email': 'farhana@gmail.com',
      'time': 'আজ, ০৯:২০ AM',
      'experience': '৩ বছরের অভিজ্ঞতা (MBBS)',
    },
    {
      'id': 'job_302',
      'position': 'কাস্টমার সাপোর্ট ও হেল্পডেস্ক এক্সিকিউটিভ',
      'name': 'Sabbir Hossain',
      'bmdc': 'N/A',
      'phone': '01720000002',
      'email': 'sabbir@gmail.com',
      'time': 'গতকাল, ০২:১৫ PM',
      'experience': '২ বছরের কাস্টমার সার্ভিস অভিজ্ঞতা',
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF334155), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'ইনবক্স ও অ্যাপ্লিকেশন',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textDark),
            ),
            Text(
              'ADMIN INBOX CONTROL PANEL',
              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: brandGreen, letterSpacing: 0.5),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: const [
                Icon(Icons.refresh_rounded, size: 14, color: brandGreen),
                SizedBox(width: 4),
                Text('ক্যাশ রিফ্রেশ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.sync_rounded, color: Color(0xFF64748B), size: 22),
            onPressed: () {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ডাটা রিফ্রেশ সম্পন্ন হয়েছে'), duration: Duration(seconds: 1)),
              );
            },
            tooltip: 'ডাটা রিফ্রেশ',
          ),
        ],
      ),

      // Floating Live Support Chat Action Button (Matching Web UI)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('লাইভ সাপোর্ট চ্যাট হেল্পডেস্ক ওপেন হচ্ছে...')),
          );
        },
        backgroundColor: brandGreen,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 24),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFDC2626),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '1',
                  style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // 1. Header Banner & Subtitle
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.mail_rounded, color: brandGreen, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'ইনবক্স ও অ্যাপ্লিকেশন কন্ট্রোল প্যানেল (Admin Inbox)',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textDark),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'গ্রাহকদের মেসেজ, পার্টনার রেজিস্ট্রেশন ও চাকরির আবেদনসমূহ পরিচালনা করুন।',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 2. Segmented Filter Tabs (Scrollable)
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildTabPill(
                    index: 0,
                    icon: Icons.mail_outline_rounded,
                    title: 'কন্টাক্ট মেসেজ (${_contactMessages.length})',
                  ),
                  const SizedBox(width: 8),
                  _buildTabPill(
                    index: 1,
                    icon: Icons.people_outline_rounded,
                    title: 'পার্টনারশিপ আবেদন (${_partnershipApps.length})',
                  ),
                  const SizedBox(width: 8),
                  _buildTabPill(
                    index: 2,
                    icon: Icons.work_outline_rounded,
                    title: 'চাকরির আবেদন (${_jobApps.length})',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 3. Helper Info Prompt Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.touch_app_rounded, size: 16, color: brandGreen),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getTabHelperText(),
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 4. Live Search Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim().toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'নাম, ফোন নম্বর বা পদবি দিয়ে অনুসন্ধান করুন...',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
                    prefixIcon: const Icon(Icons.search_rounded, color: brandGreen, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, color: Color(0xFF94A3B8), size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 5. Tab Content Views
            Expanded(
              child: IndexedStack(
                index: _selectedTabIndex,
                children: [
                  _buildContactMessagesTab(),
                  _buildPartnershipAppsTab(),
                  _buildJobAppsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get helper prompt based on selected tab
  String _getTabHelperText() {
    switch (_selectedTabIndex) {
      case 0:
        return 'মেসেজে ক্লিক করে কন্টাক্ট রিকোয়েস্ট বিস্তারিত দেখুন';
      case 1:
        return 'পার্টনার ক্যান্ডিডেটে ক্লিক করে ভেরিফিকেশন ডিটেইলস ও ১-ক্লিক এপ্রুভাল বাটন দেখুন';
      case 2:
        return 'চাকরি প্রার্থীর আবেদনে ক্লিক করে সিভি দেখুন';
      default:
        return '';
    }
  }

  /// Build Tab Selection Pill
  Widget _buildTabPill({required int index, required IconData icon, required String title}) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? darkGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? darkGreen : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: darkGreen.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Contact Messages Tab View
  Widget _buildContactMessagesTab() {
    final filtered = _contactMessages.where((item) {
      if (_searchQuery.isEmpty) return true;
      final name = item['name'].toString().toLowerCase();
      final phone = item['phone'].toString().toLowerCase();
      final msg = item['message'].toString().toLowerCase();
      return name.contains(_searchQuery) || phone.contains(_searchQuery) || msg.contains(_searchQuery);
    }).toList();

    if (filtered.isEmpty) {
      return _buildEmptyState('কোনো কন্টাক্ট মেসেজ পাওয়া যায়নি');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        final isSelected = _selectedContactId == item['id'];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isSelected ? brandGreen : const Color(0xFFE2E8F0),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              setState(() {
                _selectedContactId = item['id'] as String;
              });
              _showContactDetailModal(item);
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['name'] as String,
                        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: textDark),
                      ),
                      Text(
                        item['time'] as String,
                        style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['phone'] as String,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['message'] as String,
                    style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.4),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 2. Partnership Applications Tab View (Matching Web Screenshot precisely)
  Widget _buildPartnershipAppsTab() {
    final filtered = _partnershipApps.where((item) {
      if (_searchQuery.isEmpty) return true;
      final name = item['name'].toString().toLowerCase();
      final phone = item['phone'].toString().toLowerCase();
      final type = item['type'].toString().toLowerCase();
      final loc = item['location'].toString().toLowerCase();
      return name.contains(_searchQuery) ||
          phone.contains(_searchQuery) ||
          type.contains(_searchQuery) ||
          loc.contains(_searchQuery);
    }).toList();

    if (filtered.isEmpty) {
      return _buildEmptyState('কোনো পার্টনারশিপ আবেদন পাওয়া যায়নি');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        final isApproved = item['isApproved'] as bool;
        final isSelected = _selectedPartnerId == item['id'];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isSelected ? brandGreen : const Color(0xFFE2E8F0),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              setState(() {
                _selectedPartnerId = item['id'] as String;
              });
              _showPartnerDetailModal(item);
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Partner Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: item['typeBg'] as Color? ?? const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item['type'] as String,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: item['typeColor'] as Color? ?? const Color(0xFF15803D),
                          ),
                        ),
                      ),

                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isApproved ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isApproved ? const Color(0xFFA7F3D0) : const Color(0xFFFDE68A),
                          ),
                        ),
                        child: Text(
                          item['status'] as String,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: isApproved ? const Color(0xFF047857) : const Color(0xFFB45309),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item['name'] as String,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textDark),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 14, color: Color(0xFF0284C7)),
                      const SizedBox(width: 4),
                      Text(
                        item['phone'] as String,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                      ),
                      const Text('  •  ', style: TextStyle(color: Color(0xFFCBD5E1))),
                      const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          item['location'] as String,
                          style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 3. Job Applications Tab View
  Widget _buildJobAppsTab() {
    final filtered = _jobApps.where((item) {
      if (_searchQuery.isEmpty) return true;
      final name = item['name'].toString().toLowerCase();
      final phone = item['phone'].toString().toLowerCase();
      final email = item['email'].toString().toLowerCase();
      final pos = item['position'].toString().toLowerCase();
      return name.contains(_searchQuery) ||
          phone.contains(_searchQuery) ||
          email.contains(_searchQuery) ||
          pos.contains(_searchQuery);
    }).toList();

    if (filtered.isEmpty) {
      return _buildEmptyState('কোনো চাকরির আবেদন পাওয়া যায়নি');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        final isSelected = _selectedJobId == item['id'];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isSelected ? brandGreen : const Color(0xFFE2E8F0),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              setState(() {
                _selectedJobId = item['id'] as String;
              });
              _showJobApplicantModal(item);
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Designation Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item['position'] as String,
                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['name'] as String,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textDark),
                      ),
                      Text(
                        item['time'] as String,
                        style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 14, color: Color(0xFF0284C7)),
                      const SizedBox(width: 4),
                      Text(
                        item['phone'] as String,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                      ),
                      const Text('  •  ', style: TextStyle(color: Color(0xFFCBD5E1))),
                      const Icon(Icons.email_outlined, size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item['email'] as String,
                          style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Empty State Helper
  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_rounded, size: 50, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }

  /// Detail Modal: Contact Message Details
  void _showContactDetailModal(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'কন্টাক্ট মেসেজ বিস্তারিত',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: textDark),
              ),
              const Divider(color: Color(0xFFF1F5F9), height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['name'] as String,
                    style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: textDark),
                  ),
                  Text(
                    item['time'] as String,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.phone_rounded, size: 14, color: Color(0xFF0284C7)),
                  const SizedBox(width: 4),
                  Text(
                    item['phone'] as String,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'বার্তার বিবরণ:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  item['message'] as String,
                  style: const TextStyle(fontSize: 13, color: textDark, height: 1.5),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFF0284C7)),
                        foregroundColor: const Color(0xFF0284C7),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${item['phone']} নম্বরে এসএমেশ চালু হচ্ছে...')),
                        );
                      },
                      icon: const Icon(Icons.sms_outlined, size: 18),
                      label: const Text('মেসেজ পাঠান', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${item['phone']} নম্বরে সরাসরি কল করা হচ্ছে...')),
                        );
                      },
                      icon: const Icon(Icons.call_rounded, size: 18),
                      label: const Text('কল দিন', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Detail Modal: Partner Verification & 1-Click Multi-Section Approval (EXACT Web Match!)
  void _showPartnerDetailModal(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final approvedSection = item['approvedSection'] as String?;

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Title
                    const Text(
                      'পার্টনারশিপ আবেদন বিস্তারিত',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: textDark),
                    ),
                    const Divider(color: Color(0xFFF1F5F9), height: 18),

                    // Details Key-Value List (Exact Web Format)
                    _buildDetailRow('পার্টনার টাইপ:', item['typeSimple'] as String? ?? item['type'] as String),
                    _buildDetailRow('নাম / প্রতিষ্ঠান:', item['name'] as String),
                    _buildDetailRow('BMDC নম্বর:', item['bmdc'] as String? ?? 'N/A', isHighlight: true),
                    _buildDetailRow('বিশেষজ্ঞতা:', item['specialty'] as String? ?? 'N/A'),
                    _buildDetailRow('ফোন:', item['phone'] as String, isPhone: true),

                    if (approvedSection != null) ...[
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'বর্তমান অনুমোদন সেকশন: $approvedSection',
                                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF047857)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 10),

                    // Section Approval Header (Exact Web Text)
                    const Text(
                      '১-ক্লিক ডাক্তার এপ্রুভ করে সেকশনে যুক্ত করুন:',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF334155)),
                    ),
                    const SizedBox(height: 12),

                    // Button 1: Approve & Add to Doctor Ghar (Teal Green Button)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00897B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          setState(() {
                            item['isApproved'] = true;
                            item['status'] = 'এপ্রুভড (Approved)';
                            item['approvedSection'] = 'ডাক্তার ঘর (ভিডিও কল)';
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item['name']} সফলভাবে "ডাক্তার ঘর" সেকশনে এপ্রুভড করা হয়েছে!'),
                              backgroundColor: const Color(0xFF00897B),
                            ),
                          );
                        },
                        icon: const Icon(Icons.videocam_rounded, size: 18),
                        label: const Text(
                          'এপ্রুভ & ডাক্তার ঘরে যুক্ত করুন',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Button 2: Approve & Add to Chamber Serial (Emerald Green Button)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006B4A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          setState(() {
                            item['isApproved'] = true;
                            item['status'] = 'এপ্রুভড (Approved)';
                            item['approvedSection'] = 'চেম্বার সিরিয়াল';
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item['name']} সফলভাবে "চেম্বার সিরিয়াল" সেকশনে এপ্রুভড করা হয়েছে!'),
                              backgroundColor: const Color(0xFF006B4A),
                            ),
                          );
                        },
                        icon: const Icon(Icons.local_hospital_rounded, size: 18),
                        label: const Text(
                          'এপ্রুভ & চেম্বার সিরিয়ালে যুক্ত করুন',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Button 3: Approve & Add to Both Sections (Purple/Indigo Button)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B21B6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          setState(() {
                            item['isApproved'] = true;
                            item['status'] = 'এপ্রুভড (Approved)';
                            item['approvedSection'] = 'ডাক্তার ঘর & চেম্বার সিরিয়াল (উভয়)';
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item['name']} সফলভাবে "উভয়" সেকশনে এপ্রুভড করা হয়েছে!'),
                              backgroundColor: const Color(0xFF5B21B6),
                            ),
                          );
                        },
                        icon: const Icon(Icons.medical_services_rounded, size: 18),
                        label: const Text(
                          'এপ্রুভ & উভয় সেকশনে যুক্ত করুন',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Button 4: Call Candidate (Dark Navy Blue Button)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${item['phone']} ক্যান্ডিডেটকে ডায়াল করা হচ্ছে...')),
                          );
                        },
                        icon: const Icon(Icons.call_rounded, size: 18),
                        label: const Text(
                          'ক্যান্ডিডেটকে কল দিন',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Helper key-value text row for detail view
  Widget _buildDetailRow(String label, String value, {bool isHighlight = false, bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: (isHighlight || isPhone) ? FontWeight.w900 : FontWeight.w700,
                color: isPhone
                    ? const Color(0xFF0284C7)
                    : isHighlight
                        ? const Color(0xFF059669)
                        : textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Detail Modal: Job Applicant CV & Contact
  void _showJobApplicantModal(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'চাকরির আবেদন বিস্তারিত',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: textDark),
              ),
              const Divider(color: Color(0xFFF1F5F9), height: 18),

              _buildDetailRow('পদের নাম:', item['position'] as String),
              _buildDetailRow('প্রার্থীর নাম:', item['name'] as String),
              _buildDetailRow('BMDC / আইডেন্টিটি:', item['bmdc'] as String? ?? 'N/A'),
              _buildDetailRow('ফোন:', item['phone'] as String, isPhone: true),
              _buildDetailRow('ইমেইল:', item['email'] as String),
              if (item.containsKey('experience'))
                _buildDetailRow('অভিজ্ঞতা:', item['experience'] as String),

              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${item['name']} এর সিভি (Curriculum Vitae) ডাউনলোড হচ্ছে...')),
                        );
                      },
                      icon: const Icon(Icons.picture_as_pdf_outlined, color: Color(0xFFDC2626), size: 18),
                      label: const Text('সিভি দেখুন (PDF)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${item['phone']} নম্বরে ডায়াল করা হচ্ছে...')),
                        );
                      },
                      icon: const Icon(Icons.call_rounded, size: 18),
                      label: const Text('কল দিন', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
