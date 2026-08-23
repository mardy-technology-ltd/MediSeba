import 'package:flutter/material.dart';
import 'admin_dashboard_view.dart';
import 'admin_inbox_view.dart';
import 'admin_job_circulars_view.dart';
import 'admin_doctors_management_view.dart';
import 'admin_appointments_management_view.dart';
import 'admin_medicine_inventory_view.dart';

class AdminPatientRecordsView extends StatefulWidget {
  const AdminPatientRecordsView({super.key});

  @override
  State<AdminPatientRecordsView> createState() => _AdminPatientRecordsViewState();
}

class _AdminPatientRecordsViewState extends State<AdminPatientRecordsView> {
  static const brandGreen = Color(0xFF0F9D58);
  static const darkGreen = Color(0xFF006B4A);
  static const textDark = Color(0xFF0F172A);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedBloodGroup = 'সকল (All)';

  final List<String> _bloodGroups = [
    'সকল (All)',
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

  // Patient Records Mock Data matching web screenshot
  final List<Map<String, dynamic>> _patients = [
    {
      'id': 'pat_1',
      'name': 'Samiul Islam',
      'bloodGroup': 'A+',
      'email': 'patient1@mediseba.org',
      'phone': '01710000001',
      'regDate': '2026-08-04',
      'initial': 'S',
      'age': 32,
      'gender': 'পুরুষ (Male)',
      'address': 'ধানমন্ডি, ঢাকা-১২০৫',
      'emergencyContact': '01819000111',
      'totalAppointments': 4,
      'medicalHistory': 'উচ্চ রক্তচাপ, নিয়মিত গ্যাস্ট্রিকের ওষুধ সেবন করেন।',
    },
    {
      'id': 'pat_2',
      'name': 'Rahim Uddin',
      'bloodGroup': 'B+',
      'email': 'patient2@mediseba.org',
      'phone': '01710000002',
      'regDate': '2026-08-04',
      'initial': 'R',
      'age': 45,
      'gender': 'পুরুষ (Male)',
      'address': 'মিরপুর-১০, ঢাকা-১২১৬',
      'emergencyContact': '01819000222',
      'totalAppointments': 6,
      'medicalHistory': 'টাইপ-২ ডায়াবেটিস, নিয়মিত চেকআপ প্রয়োজন।',
    },
    {
      'id': 'pat_3',
      'name': 'Karim Hasan',
      'bloodGroup': 'AB-',
      'email': 'patient3@mediseba.org',
      'phone': '01710000003',
      'regDate': '2026-08-04',
      'initial': 'K',
      'age': 28,
      'gender': 'পুরুষ (Male)',
      'address': 'উত্তরা সেক্টর-৭, ঢাকা-১২৩০',
      'emergencyContact': '01819000333',
      'totalAppointments': 2,
      'medicalHistory': 'মাইগ্রেন ও অ্যাজমা সমস্যা।',
    },
    {
      'id': 'pat_4',
      'name': 'Nusrat Jahan',
      'bloodGroup': 'O+',
      'email': 'patient4@mediseba.org',
      'phone': '01710000004',
      'regDate': '2026-08-04',
      'initial': 'N',
      'age': 26,
      'gender': 'মহিলা (Female)',
      'address': 'গুলশান-২, ঢাকা-১২১২',
      'emergencyContact': '01819000444',
      'totalAppointments': 3,
      'medicalHistory': 'কোনো দীর্ঘমেয়াদী জটিলতা নেই।',
    },
    {
      'id': 'pat_5',
      'name': 'Tanvir Ahmed',
      'bloodGroup': 'A-',
      'email': 'patient5@mediseba.org',
      'phone': '01710000005',
      'regDate': '2026-08-04',
      'initial': 'T',
      'age': 38,
      'gender': 'পুরুষ (Male)',
      'address': 'বসুন্ধরা আবাসিক এলাকা, ঢাকা',
      'emergencyContact': '01819000555',
      'totalAppointments': 5,
      'medicalHistory': 'স্পন্ডাইলাইটিস ও থাইরয়েড সমস্যা।',
    },
    {
      'id': 'pat_6',
      'name': 'Farhana Akter',
      'bloodGroup': 'B-',
      'email': 'patient6@mediseba.org',
      'phone': '01710000006',
      'regDate': '2026-08-05',
      'initial': 'F',
      'age': 30,
      'gender': 'মহিলা (Female)',
      'address': 'মোহাম্মদপুর, ঢাকা-১২০৭',
      'emergencyContact': '01819000666',
      'totalAppointments': 1,
      'medicalHistory': 'অ্যালার্জি ও ভিটামিন-ডি এর ঘাটতি।',
    },
  ];

  List<Map<String, dynamic>> get _filteredPatients {
    return _patients.where((p) {
      final name = p['name'].toString().toLowerCase();
      final email = p['email'].toString().toLowerCase();
      final phone = p['phone'].toString().toLowerCase();
      final blood = p['bloodGroup'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase().trim();

      final matchesQuery = query.isEmpty ||
          name.contains(query) ||
          email.contains(query) ||
          phone.contains(query) ||
          blood.contains(query);

      final matchesBlood = _selectedBloodGroup == 'সকল (All)' ||
          p['bloodGroup'] == _selectedBloodGroup;

      return matchesQuery && matchesBlood;
    }).toList();
  }

  void _showPatientDetailsModal(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
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
                const SizedBox(height: 16),

                // Modal Header with Avatar & Name
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDBEAFE),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          item['initial'] as String,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'] as String,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFA7F3D0)),
                            ),
                            child: Text(
                              'রক্তের গ্রুপ: ${item['bloodGroup']}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Patient Info Grid
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(Icons.cake_rounded, 'বয়স / লিঙ্গ', '${item['age']} বছর • ${item['gender']}'),
                      const Divider(height: 16, color: Color(0xFFE2E8F0)),
                      _buildDetailRow(Icons.location_on_rounded, 'ঠিকানা', item['address'] as String),
                      const Divider(height: 16, color: Color(0xFFE2E8F0)),
                      _buildDetailRow(Icons.mail_rounded, 'ইমেইল', item['email'] as String),
                      const Divider(height: 16, color: Color(0xFFE2E8F0)),
                      _buildDetailRow(Icons.phone_rounded, 'মোবাইল নম্বর', item['phone'] as String),
                      const Divider(height: 16, color: Color(0xFFE2E8F0)),
                      _buildDetailRow(Icons.contact_phone_rounded, 'জরুরি মোবাইল', item['emergencyContact'] as String),
                      const Divider(height: 16, color: Color(0xFFE2E8F0)),
                      _buildDetailRow(Icons.calendar_today_rounded, 'নিবন্ধন তারিখ', item['regDate'] as String),
                      const Divider(height: 16, color: Color(0xFFE2E8F0)),
                      _buildDetailRow(Icons.medical_information_rounded, 'মোট সম্পন্ন অ্যাপয়েন্টমেন্ট', '${item['totalAppointments']} টি'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Medical History Note
                const Text(
                  'মেডিকেল হিস্ট্রি ও স্বাস্থ্য সংক্রান্ত তথ্য:',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Text(
                    item['medicalHistory'] as String,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF92400E), height: 1.4),
                  ),
                ),
                const SizedBox(height: 20),

                // Action Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0284C7),
                          side: const BorderSide(color: Color(0xFF38BDF8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${item['name']} এর নম্বরে কল ডায়াল করা হচ্ছে: ${item['phone']}')),
                          );
                        },
                        icon: const Icon(Icons.call_rounded, size: 18),
                        label: const Text('কল দিন', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.check_circle_rounded, size: 18),
                        label: const Text('বন্ধ করুন', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 11.5, color: textDark, fontWeight: FontWeight.w600),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredPatients;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Color(0xFF334155), size: 26),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'রোগীর রেকর্ডস',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),
            Text(
              'ADMIN CONTROL PANEL',
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: brandGreen,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF64748B), size: 22),
            onPressed: () {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('রোগীর ডাটা ক্যাশ রিফ্রেশ করা হয়েছে'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'ক্যাশ রিফ্রেশ',
          ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: _buildAdminDrawer(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP HEADER BANNER matching Web Visual
              _buildHeaderPanel(),

              const SizedBox(height: 16),

              // 2. SEARCH BAR matching Web Visual
              _buildSearchBar(),

              const SizedBox(height: 12),

              // 3. BLOOD GROUP FILTER CHIPS
              _buildBloodGroupFilterChips(),

              const SizedBox(height: 16),

              // 4. PATIENT CARDS GRID / LIST
              if (filtered.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.person_search_rounded, size: 44, color: Color(0xFF94A3B8)),
                      const SizedBox(height: 10),
                      const Text(
                        'কোনো রোগীর রেকর্ড খুঁজে পাওয়া যায়নি',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '"$_searchQuery" অথবা নির্বাচিত ব্লাড গ্রুপ দিয়ে কোনো রেকর্ড নেই।',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return _buildPatientCard(item);
                  },
                ),

              const SizedBox(height: 16),

              // Footer Counter matching Web Visual
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'দেখাচ্ছে ১ - ${filtered.length} জন (মোট ${_patients.length} জন নিবন্ধিত রোগী রেকর্ডস)',
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// 1. Build Header Panel matching Web Screenshot
  Widget _buildHeaderPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.people_alt_rounded, color: brandGreen, size: 22),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'রোগীর রেকর্ডস (Patient Records)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'ডাটাবেজে নিবন্ধিত রোগীদের মেডিকেল প্রোফাইল ও যোগাযোগের তথ্য।',
            style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B), height: 1.4),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF334155),
              side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('রোগীর রেকর্ডস ক্যাশ রিফ্রেশ সম্পন্ন হয়েছে')),
              );
            },
            icon: const Icon(Icons.sync_rounded, size: 16, color: brandGreen),
            label: const Text('ক্যাশ রিফ্রেশ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  /// 2. Build Search Bar matching Web Screenshot
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        style: const TextStyle(fontSize: 13, color: textDark, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: 'রোগীর নাম, ইমেইল, মোবাইল বা ব্লাড গ্রুপ দিয়ে খুঁজুন...',
          hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18, color: Color(0xFF94A3B8)),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  /// 3. Build Blood Group Filter Chips
  Widget _buildBloodGroupFilterChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _bloodGroups.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final group = _bloodGroups[index];
          final isSelected = _selectedBloodGroup == group;

          return ChoiceChip(
            label: Text(
              group,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF475569),
              ),
            ),
            selected: isSelected,
            selectedColor: brandGreen,
            backgroundColor: Colors.white,
            side: BorderSide(
              color: isSelected ? brandGreen : const Color(0xFFCBD5E1),
              width: 1,
            ),
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _selectedBloodGroup = group;
                });
              }
            },
          );
        },
      ),
    );
  }

  /// 4. Build Patient Card matching Web Visual Screenshot
  Widget _buildPatientCard(Map<String, dynamic> item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
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
          // Header Row: Avatar + Name + Blood Group Badge Chip matching Web Screenshot
          Row(
            children: [
              // Avatar Circle
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFDBEAFE),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    item['initial'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Patient Name & Blood Group Chip
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] as String,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                        color: textDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: Text(
                        'রক্তের গ্রুপ: ${item['bloodGroup']}',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // View Profile Button
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF94A3B8), size: 16),
                onPressed: () => _showPatientDetailsModal(item),
                tooltip: 'বিস্তারিত দেখুন',
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Contact Details Block matching Web Screenshot
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email
                Row(
                  children: [
                    const Icon(Icons.mail_outline_rounded, size: 15, color: Color(0xFF64748B)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item['email'] as String,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Phone
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 15, color: Color(0xFF64748B)),
                    const SizedBox(width: 8),
                    Text(
                      item['phone'] as String,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Registration Date
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 15, color: Color(0xFF64748B)),
                    const SizedBox(width: 8),
                    Text(
                      'নিবন্ধন তারিখ: ${item['regDate']}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Details Modal Trigger Button
          SizedBox(
            width: double.infinity,
            height: 38,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: brandGreen,
                side: const BorderSide(color: Color(0xFFA7F3D0), width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => _showPatientDetailsModal(item),
              icon: const Icon(Icons.visibility_outlined, size: 16),
              label: const Text(
                'বিস্তারিত মেডিকেল প্রোফাইল',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build Navigation Drawer matching Web Screenshot
  Widget _buildAdminDrawer(BuildContext context) {
    final menuItems = [
      {'title': 'ড্যাশবোর্ড (Overview)', 'icon': Icons.dashboard_rounded, 'selected': false},
      {'title': 'ইনবক্স ও অ্যাপ্লিকেশন', 'icon': Icons.mail_outline_rounded, 'selected': false},
      {'title': 'চাকরি ও নিয়োগ সার্কুলার', 'icon': Icons.work_outline_rounded, 'selected': false},
      {'title': 'ডাক্তার ম্যানেজমেন্ট', 'icon': Icons.medical_services_outlined, 'selected': false},
      {'title': 'রোগীর রেকর্ডস', 'icon': Icons.people_outline_rounded, 'selected': true},
      {'title': 'সিরিয়াল ও অ্যাপয়েন্টমেন্ট', 'icon': Icons.calendar_month_outlined, 'selected': false},
      {'title': 'মেডিসিন ইনভেন্টরি', 'icon': Icons.medication_outlined, 'selected': false},
      {'title': 'ডিজিটাল প্রেসক্রিপশন', 'icon': Icons.description_outlined, 'selected': false},
      {'title': 'সিস্টেম সেটিং ও কন্ট্রোল', 'icon': Icons.settings_outlined, 'selected': false},
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header matching Screenshot
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

          // Drawer Navigation List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = item['selected'] as bool;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Material(
                    color: isSelected ? darkGreen : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        item['icon'] as IconData,
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                        size: 20,
                      ),
                      title: Text(
                        item['title'] as String,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF334155),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18)
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
                              builder: (context) => const AdminJobCircularsView(),
                            ),
                          );
                        } else if (index == 3) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminDoctorsManagementView(),
                            ),
                          );
                        } else if (index == 5) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminAppointmentsManagementView(),
                            ),
                          );
                        } else if (index == 6) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminMedicineInventoryView(),
                            ),
                          );
                        } else if (!isSelected) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${item['title']} সেকশন নির্বাচন করা হয়েছে')),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // Admin User Profile Footer matching Screenshot
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
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFFD97706),
                      child: const Text(
                        'SA',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'System Admin',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textDark),
                          ),
                          Text(
                            'admin@mediseba.org',
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close drawer
                      Navigator.pop(context); // Exit admin panel back to app
                    },
                    icon: const Icon(Icons.logout_rounded, size: 16),
                    label: const Text('অ্যাপে ফিরে যান', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
