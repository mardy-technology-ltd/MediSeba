import 'package:flutter/material.dart';
import 'admin_dashboard_view.dart';
import 'admin_inbox_view.dart';
import 'admin_job_circulars_view.dart';
import 'admin_doctors_management_view.dart';
import 'admin_patient_records_view.dart';
import 'admin_medicine_inventory_view.dart';
import 'admin_drawer.dart';

class AdminAppointmentsManagementView extends StatefulWidget {
  const AdminAppointmentsManagementView({super.key});

  @override
  State<AdminAppointmentsManagementView> createState() =>
      _AdminAppointmentsManagementViewState();
}

class _AdminAppointmentsManagementViewState
    extends State<AdminAppointmentsManagementView> {
  static const brandGreen = Color(0xFF0F9D58);
  static const darkGreen = Color(0xFF006B4A);
  static const textDark = Color(0xFF0F172A);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedFilter = 'সকল সিরিয়াল';
  bool _isRefreshing = false;

  // Appointment & Serial Data matching the web admin dashboard
  final List<Map<String, dynamic>> _appointments = [
    {
      'id': 'SERIAL-20260804-99812',
      'patientName': 'Mohammad Ali',
      'patientPhone': '01710000001',
      'patientAge': '42 বছর',
      'patientGender': 'পুরুষ',
      'doctorName': 'অধ্যাপক ড. এ. কে. এম. ফজলে রাব্বি',
      'specialty': 'হৃদরোগ বিশেষজ্ঞ',
      'chamber': 'পপুলার ডায়াগনস্টিক সেন্টার, ধানমন্ডি, ঢাকা',
      'type': 'চেম্বার সিরিয়াল',
      'fee': '৳ ১,৫০০',
      'dateTime': 'আজ, ১০:৩০ AM',
      'paymentMethod': 'bKash (গ্যারান্টেড)',
      'status': 'কনফার্মড',
      'statusColor': const Color(0xFF10B981),
      'statusBg': const Color(0xFFECFDF5),
    },
    {
      'id': 'SERIAL-20260804-88192',
      'patientName': 'Tania Rahman',
      'patientPhone': '01710000002',
      'patientAge': '29 বছর',
      'patientGender': 'মহিলা',
      'doctorName': 'ডা. শারমিন সুলতানা',
      'specialty': 'স্ত্রীরোগ ও প্রসূতি বিশেষজ্ঞ',
      'chamber': 'ল্যাবএইড স্পেশালাইজড হাসপাতাল, ধানমন্ডি',
      'type': 'চেম্বার সিরিয়াল',
      'fee': '৳ ১,২০০',
      'dateTime': 'আজ, ১১:০০ AM',
      'paymentMethod': 'Nagad',
      'status': 'পেন্ডিং',
      'statusColor': const Color(0xFFD97706),
      'statusBg': const Color(0xFFFEF3C7),
    },
    {
      'id': 'APT-20260804-10492',
      'patientName': 'Kabir Hossain',
      'patientPhone': '01710000003',
      'patientAge': '36 বছর',
      'patientGender': 'পুরুষ',
      'doctorName': 'Dr. Tanvir Hasan',
      'specialty': 'মেডিসিন বিশেষজ্ঞ',
      'chamber': 'অনলাইন ভিডিও কনসালটেশন',
      'type': 'টেলিমেডিসিন কল',
      'fee': '৳ ১,০০০',
      'dateTime': 'আজ, ০২:১৫ PM',
      'paymentMethod': 'Card (Visa)',
      'status': 'কনফার্মড',
      'statusColor': const Color(0xFF10B981),
      'statusBg': const Color(0xFFECFDF5),
    },
    {
      'id': 'SERIAL-20260804-77381',
      'patientName': 'Nasrin Sultana',
      'patientPhone': '01710000004',
      'patientAge': '31 বছর',
      'patientGender': 'মহিলা',
      'doctorName': 'ডা. মো. রফিকুল ইসলাম',
      'specialty': 'চর্ম ও যৌনরোগ বিশেষজ্ঞ',
      'chamber': 'ইবনে সিনা মেডিকেল কলেজ হাসপাতাল, মিরপুর',
      'type': 'চেম্বার সিরিয়াল',
      'fee': '৳ ১,০০০',
      'dateTime': 'আগামীকাল, ১০:০০ AM',
      'paymentMethod': 'Rocket',
      'status': 'পেন্ডিং',
      'statusColor': const Color(0xFFD97706),
      'statusBg': const Color(0xFFFEF3C7),
    },
    {
      'id': 'APT-20260804-66291',
      'patientName': 'Anwar Hossain',
      'patientPhone': '01710000005',
      'patientAge': '50 বছর',
      'patientGender': 'পুরুষ',
      'doctorName': 'Dr. Farzana Islam',
      'specialty': 'শিশু রোগ বিশেষজ্ঞ',
      'chamber': 'অনলাইন ভিডিও কনসালটেশন',
      'type': 'টেলিমেডিসিন কল',
      'fee': '৳ ৮০০',
      'dateTime': 'আগামীকাল, ০৪:০০ PM',
      'paymentMethod': 'bKash',
      'status': 'বাতিল',
      'statusColor': const Color(0xFFEF4444),
      'statusBg': const Color(0xFFFEF2F2),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshData() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚡ ক্যশ ও অপয়েন্টমেন্ট ডাটা সফলভাবে রিফ্রেশ হয়েছে!'),
          duration: Duration(seconds: 2),
          backgroundColor: brandGreen,
        ),
      );
    }
  }

  void _updateAppointmentStatus(String id, String newStatus) {
    setState(() {
      final index = _appointments.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        _appointments[index]['status'] = newStatus;
        if (newStatus == 'কনফার্মড') {
          _appointments[index]['statusColor'] = const Color(0xFF10B981);
          _appointments[index]['statusBg'] = const Color(0xFFECFDF5);
        } else if (newStatus == 'বাতিল') {
          _appointments[index]['statusColor'] = const Color(0xFFEF4444);
          _appointments[index]['statusBg'] = const Color(0xFFFEF2F2);
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('অ্যাপয়েন্টমেন্ট $id এখন "$newStatus"'),
        backgroundColor:
            newStatus == 'কনফার্মড' ? brandGreen : Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredAppointments {
    return _appointments.where((item) {
      final matchesSearch = item['id']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          item['patientName']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          item['doctorName']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          item['patientPhone'].toString().contains(_searchQuery);

      if (!matchesSearch) return false;

      if (_selectedFilter == 'সকল সিরিয়াল') return true;
      if (_selectedFilter == 'চেম্বার সিরিয়াল') {
        return item['type'] == 'চেম্বার সিরিয়াল';
      }
      if (_selectedFilter == 'টেলিমেডিসিন কল') {
        return item['type'] == 'টেলিমেডিসিন কল';
      }
      if (_selectedFilter == 'পেন্ডিং') return item['status'] == 'পেন্ডিং';

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = _appointments.length;
    final chamberCount =
        _appointments.where((e) => e['type'] == 'চেম্বার সিরিয়াল').length;
    final teleCount =
        _appointments.where((e) => e['type'] == 'টেলিমেডিসিন কল').length;
    final pendingCount =
        _appointments.where((e) => e['status'] == 'পেন্ডিং').length;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const AdminDrawer(selectedIndex: 6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.menu_rounded, color: Color(0xFF334155), size: 26),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'সিরিয়াল ও অ্যাপয়েন্টমেন্ট',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),
            Text(
              'ADMIN CONTROL PANEL',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: brandGreen,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'ক্যাশ রিফ্রেশ',
            onPressed: _isRefreshing ? null : _refreshData,
            icon: _isRefreshing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: brandGreen,
                    ),
                  )
                : const Icon(Icons.sync_rounded,
                    color: Color(0xFF0284C7), size: 22),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded,
                    color: Color(0xFF64748B)),
                onPressed: () {},
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Welcome & Quick Refresh Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F9D58), Color(0xFF006B4A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x330F9D58),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'সিরিয়াল ও অ্যাপয়েন্টমেন্ট ম্যানেজমেন্ট',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'সকল প্রখ্যাত ডাক্তারের চেম্বার সিরিয়াল ও ভিডিও কনসালটেশন অ্যাপয়েন্টমেন্ট কুইক অনুমোদন করুন',
                          style: TextStyle(
                            color: Color(0xFFE2E8F0),
                            fontSize: 11.5,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _isRefreshing ? null : _refreshData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: darkGreen,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text(
                      'ক্যাশ রিফ্রেশ',
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Stat Summary Cards Grid (2x2)
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'মোট সিরিয়াল',
                    count: '$totalCount টি',
                    icon: Icons.calendar_month_rounded,
                    color: const Color(0xFF0284C7),
                    bg: const Color(0xFFE0F2FE),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    title: 'চেম্বার সিরিয়াল',
                    count: '$chamberCount টি',
                    icon: Icons.domain_rounded,
                    color: const Color(0xFF10B981),
                    bg: const Color(0xFFECFDF5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'টেলিমেডিসিন কল',
                    count: '$teleCount টি',
                    icon: Icons.videocam_rounded,
                    color: const Color(0xFF8B5CF6),
                    bg: const Color(0xFFF5F3FF),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    title: 'পেন্ডিং অনুমোদন',
                    count: '$pendingCount টি',
                    icon: Icons.pending_actions_rounded,
                    color: const Color(0xFFD97706),
                    bg: const Color(0xFFFEF3C7),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Live Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'সিরিয়াল আইডি, রোগী বা ডাক্তার খুঁজুন...',
                  hintStyle:
                      const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: Color(0xFF64748B), size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded,
                              size: 18, color: Color(0xFF94A3B8)),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Filter Chips Bar matching Web exact 3 options
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('সকল সিরিয়াল', 'সকল সিরিয়াল ($totalCount)'),
                  const SizedBox(width: 8),
                  _buildFilterChip('চেম্বার সিরিয়াল', '🏢 চেম্বার সিরিয়াল'),
                  const SizedBox(width: 8),
                  _buildFilterChip('টেলিমেডিসিন কল', '🎥 টেলিমেডিসিন কল'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'সিরিয়াল তালিকা (${_filteredAppointments.length})',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                Text(
                  'ফিল্টার: $_selectedFilter',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Appointment Cards List
            _filteredAppointments.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: const [
                        Icon(Icons.event_busy_rounded,
                            size: 48, color: Color(0xFFCBD5E1)),
                        SizedBox(height: 8),
                        Text(
                          'কোনো সিরিয়াল বা অ্যাপয়েন্টমেন্ট পাওয়া যায়নি',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredAppointments.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _filteredAppointments[index];
                      return _buildAppointmentCard(context, item);
                    },
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
    required Color bg,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filterKey, String label) {
    final isSelected = _selectedFilter == filterKey;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedFilter = filterKey);
        }
      },
      selectedColor: darkGreen,
      backgroundColor: Colors.white,
      side: BorderSide(
        color: isSelected ? darkGreen : const Color(0xFFCBD5E1),
      ),
      labelStyle: TextStyle(
        fontSize: 11.5,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
        color: isSelected ? Colors.white : const Color(0xFF475569),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }

  Widget _buildAppointmentCard(
      BuildContext context, Map<String, dynamic> item) {
    final isPending = item['status'] == 'পেন্ডিং';
    final isTelemedicine = item['type'] == 'টেলিমেডিসিন কল';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isPending
              ? const Color(0xFFFDE68A)
              : const Color(0xFFE2E8F0),
          width: isPending ? 1.5 : 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card Header with Serial ID & Status Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isPending ? const Color(0xFFFFFBEB) : const Color(0xFFF8FAFC),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(13)),
              border: const Border(
                  bottom: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isTelemedicine
                          ? Icons.videocam_rounded
                          : Icons.domain_rounded,
                      size: 16,
                      color: isTelemedicine
                          ? const Color(0xFF8B5CF6)
                          : const Color(0xFF0F9D58),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item['id'] as String,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: item['statusBg'] as Color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: item['statusColor'] as Color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item['status'] as String,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: item['statusColor'] as Color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Info Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person_outline_rounded,
                                  size: 15, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  item['patientName'] as String,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: textDark,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.phone_outlined,
                                  size: 13, color: Color(0xFF0F9D58)),
                              const SizedBox(width: 4),
                              Text(
                                item['patientPhone'] as String,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Fee Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['fee'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: textDark,
                        ),
                      ),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                ),

                // Doctor & Chamber Details
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.medical_services_outlined,
                          size: 16, color: brandGreen),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['doctorName'] as String,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 12, color: Color(0xFF94A3B8)),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  item['chamber'] as String,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
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
                  ],
                ),

                const SizedBox(height: 10),

                // Time & Payment Info Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            size: 13, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Text(
                          item['dateTime'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '💳 ${item['paymentMethod']}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Admin Actions Bar
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF334155),
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _showAppointmentDetails(context, item),
                        icon: const Icon(Icons.visibility_outlined, size: 14),
                        label: const Text(
                          'বিবরণ দেখুন',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    if (isPending) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _updateAppointmentStatus(
                              item['id'] as String, 'কনফার্মড'),
                          icon: const Icon(Icons.check_circle_outline_rounded,
                              size: 14),
                          label: const Text(
                            '✓ কনফার্ম',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFEF4444),
                            side: const BorderSide(color: Color(0xFFFCA5A5)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _updateAppointmentStatus(
                              item['id'] as String, 'বাতিল'),
                          icon: const Icon(Icons.close_rounded, size: 14),
                          label: const Text(
                            '✕ বাতিল',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ] else if (item['status'] == 'কনফার্মড') ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFEF4444),
                            side: const BorderSide(color: Color(0xFFFCA5A5)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _updateAppointmentStatus(
                              item['id'] as String, 'বাতিল'),
                          icon: const Icon(Icons.cancel_outlined, size: 14),
                          label: const Text(
                            '✕ বাতিল',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAppointmentDetails(
      BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['id'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                      const Text(
                        'সিরিয়াল ও অপয়েন্টমেন্ট বিবরণী',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: item['statusBg'] as Color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item['status'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: item['statusColor'] as Color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE2E8F0)),
              const SizedBox(height: 10),

              _buildDetailRow('রোগীর নাম:', item['patientName'] as String),
              _buildDetailRow('মোবাইল নম্বর:', item['patientPhone'] as String),
              _buildDetailRow('বয়স ও লিঙ্গ:',
                  '${item['patientAge']}, ${item['patientGender']}'),
              _buildDetailRow('ডাক্তারের নাম:', item['doctorName'] as String),
              _buildDetailRow('বিশেষজ্ঞতা:', item['specialty'] as String),
              _buildDetailRow('চেম্বার / মাধ্যম:', item['chamber'] as String),
              _buildDetailRow('অ্যাপয়েন্টমেন্ট ধরন:', item['type'] as String),
              _buildDetailRow('তারিখ ও সময়:', item['dateTime'] as String),
              _buildDetailRow('পেমেন্ট মাধ্যম:', item['paymentMethod'] as String),
              _buildDetailRow('ফি পরিমাণ:', item['fee'] as String,
                  isBold: true),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'বন্ধ করুন',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
                color: isBold ? brandGreen : textDark,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminDrawer(BuildContext context) {
    return const AdminDrawer(selectedIndex: 6);
  }

  Widget _ignored_buildAdminDrawer(BuildContext context) {
    final menuItems = [
      {
        'title': 'ড্যাশবোর্ড (Overview)',
        'icon': Icons.dashboard_rounded,
        'selected': false
      },
      {
        'title': 'ইনবক্স ও অ্যাপ্লিকেশন',
        'icon': Icons.mail_outline_rounded,
        'selected': false
      },
      {
        'title': 'চাকরি ও নিয়োগ সার্কুলার',
        'icon': Icons.work_outline_rounded,
        'selected': false
      },
      {
        'title': 'ডাক্তার ম্যানেজমেন্ট',
        'icon': Icons.medical_services_outlined,
        'selected': false
      },
      {
        'title': 'রোগীর রেকর্ডস',
        'icon': Icons.people_outline_rounded,
        'selected': false
      },
      {
        'title': 'সিরিয়াল ও অ্যাপয়েন্টমেন্ট',
        'icon': Icons.calendar_month_outlined,
        'selected': true
      },
      {
        'title': 'মেডিসিন ইনভেন্টরি',
        'icon': Icons.medication_outlined,
        'selected': false
      },
      {
        'title': 'ডিজিটাল প্রেসক্রিপশন',
        'icon': Icons.description_outlined,
        'selected': false
      },
      {
        'title': 'সিস্টেম সেটিং ও কন্ট্রোল',
        'icon': Icons.settings_outlined,
        'selected': false
      },
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 36,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.local_hospital_rounded,
                    size: 40,
                    color: brandGreen,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'ADMIN CONTROL PANEL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: brandGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = item['selected'] as bool;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Material(
                    color: isSelected ? darkGreen : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        item['icon'] as IconData,
                        color:
                            isSelected ? Colors.white : const Color(0xFF475569),
                        size: 20,
                      ),
                      title: Text(
                        item['title'] as String,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color:
                              isSelected ? Colors.white : const Color(0xFF334155),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.chevron_right_rounded,
                              color: Colors.white, size: 18)
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        if (index == 0) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminDashboardView(),
                            ),
                          );
                        } else if (index == 1) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminInboxView(),
                            ),
                          );
                        } else if (index == 2) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AdminJobCircularsView(),
                            ),
                          );
                        } else if (index == 3) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AdminDoctorsManagementView(),
                            ),
                          );
                        } else if (index == 4) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AdminPatientRecordsView(),
                            ),
                          );
                        } else if (index == 6) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AdminMedicineInventoryView(),
                            ),
                          );
                        } else if (!isSelected) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    '${item['title']} সেকশন নির্বাচন করা হয়েছে')),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFFD97706),
                      child: Text(
                        'SA',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'System Admin',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A)),
                          ),
                          Text(
                            'admin@mediseba.org',
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                      side: const BorderSide(color: Color(0xFFFCA5A5)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.logout_rounded, size: 16),
                    label: const Text('অ্যাপে ফিরে যান',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
