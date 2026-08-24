import 'package:flutter/material.dart';
import 'admin_drawer.dart';
import '../../widgets/live_chat_widget.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/language_controller.dart';

class AdminSalesTeamView extends StatefulWidget {
  final HomeController? homeController;
  final AuthController? authController;
  final LanguageController? languageController;

  const AdminSalesTeamView({
    super.key,
    this.homeController,
    this.authController,
    this.languageController,
  });

  @override
  State<AdminSalesTeamView> createState() => _AdminSalesTeamViewState();
}

class _AdminSalesTeamViewState extends State<AdminSalesTeamView> {
  static const darkGreen = Color(0xFF005C45);
  static const brandGreen = Color(0xFF00A859);
  static const textDark = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedRoleFilter = 'সকল';

  late List<Map<String, dynamic>> _usersList;

  final List<String> _availableRoles = [
    'Sales Director',
    'Head of Sales',
    'Marketing Manager',
    'Area Manager',
    'Supervisor',
    'HBP Field Agent',
    'Verified Doctor',
    'Patient',
  ];

  @override
  void initState() {
    super.initState();
    _usersList = [
      {
        'id': '1',
        'name': 'ফারহান আহমেদ',
        'contact': '01700000001 | director@mediseba.com',
        'role': 'Sales Director',
        'boss': '-- কোনো রিপোর্টিং বস নেই (Top Boss / None) --',
        'date': '2026-08-01 10:00',
        'isSelected': false,
      },
      {
        'id': '2',
        'name': 'মোঃ রফিকুল ইসলাম',
        'contact': '01700000002 | headsales@mediseba.com',
        'role': 'Head of Sales',
        'boss': 'ফারহান আহমেদ (Sales Director)',
        'date': '2026-08-01 10:30',
        'isSelected': false,
      },
      {
        'id': '3',
        'name': 'নাসরিন আক্তার',
        'contact': '01700000003 | marketing@mediseba.com',
        'role': 'Marketing Manager',
        'boss': 'মোঃ রফিকুল ইসলাম (Head of Sales)',
        'date': '2026-08-01 11:00',
        'isSelected': false,
      },
      {
        'id': '4',
        'name': 'শাহরিয়ার কবির',
        'contact': '01700000004 | areamanager@mediseba.com',
        'role': 'Area Manager',
        'boss': 'নাসরিন আক্তার (Marketing Manager)',
        'date': '2026-08-01 11:30',
        'isSelected': false,
      },
      {
        'id': '5',
        'name': 'তানভীর আহমেদ',
        'contact': '01700000005 | tanvir@mediseba.com',
        'role': 'Supervisor',
        'boss': 'শাহরিয়ার কবির (Area Manager)',
        'date': '2026-08-01 12:00',
        'isSelected': false,
      },
      {
        'id': '6',
        'name': 'আব্দুর রহিম',
        'contact': '01700000006 | rahim@mediseba.com',
        'role': 'HBP Field Agent',
        'boss': 'তানভীর আহমেদ (Supervisor)',
        'date': '2026-08-01 12:30',
        'isSelected': false,
      },
      {
        'id': '7',
        'name': 'Dr. Tanvir Hasan',
        'contact': '01700000007 | doctor@mediseba.org',
        'role': 'Verified Doctor',
        'boss': '-- কোনো রিপোর্টিং বস নেই (Top Boss / None) --',
        'date': '2026-08-01 13:00',
        'isSelected': false,
      },
      {
        'id': '8',
        'name': 'Samiul Islam',
        'contact': '01700000008 | patient@mediseba.org',
        'role': 'Patient',
        'boss': '-- কোনো রিপোর্টিং বস নেই (Top Boss / None) --',
        'date': '2026-08-01 13:30',
        'isSelected': false,
      },
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Get list of reporting bosses dynamically from current sales leaders
  List<String> get _dynamicReportingBosses {
    final List<String> bosses = [
      '-- কোনো রিপোর্টিং বস নেই (Top Boss / None) --',
    ];
    for (var u in _usersList) {
      final role = (u['role'] ?? '').toString();
      final name = (u['name'] ?? '').toString();
      if (role == 'Sales Director' ||
          role == 'Head of Sales' ||
          role == 'Marketing Manager' ||
          role == 'Area Manager' ||
          role == 'Supervisor') {
        bosses.add('$name ($role)');
      }
    }
    return bosses;
  }

  /// Get role count dynamically
  int _getRoleCount(String roleKey) {
    if (roleKey == 'সকল') {
      return _usersList.where((u) {
        final r = (u['role'] ?? '').toString();
        return r != 'Verified Doctor' && r != 'Patient';
      }).length;
    }
    return _usersList.where((u) => (u['role'] ?? '').toString() == roleKey).length;
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _usersList.where((u) {
      final name = (u['name'] ?? '').toString().toLowerCase();
      final contact = (u['contact'] ?? '').toString().toLowerCase();
      final role = (u['role'] ?? '').toString();

      final matchesQuery = name.contains(_searchQuery.toLowerCase()) || contact.contains(_searchQuery.toLowerCase());
      final matchesRole = _selectedRoleFilter == 'সকল' || role == _selectedRoleFilter;

      return matchesQuery && matchesRole;
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildTopAppBar(context),
      drawer: const AdminDrawer(selectedIndex: 4),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Banner (Deep Navy Slate)
              _buildHeroBanner(),

              const SizedBox(height: 14),

              // 2. 6 Role Stat Cards Grid
              _buildRoleStatCardsGrid(),

              const SizedBox(height: 14),

              // 3. Filter & Realtime Search Card
              _buildFilterSearchCard(),

              const SizedBox(height: 14),

              // 4. Hierarchy & Reporting Boss Table / Mobile Card Grid
              _buildHierarchyTableCard(filteredUsers),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: const LiveChatFabWidget(),
    );
  }

  /// Top App Bar
  PreferredSizeWidget _buildTopAppBar(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 400;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: Color(0xFF334155), size: 24),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          const Icon(Icons.group_outlined, color: brandGreen, size: 20),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'সেলস টিম ও হায়ারার্কি',
              style: TextStyle(
                fontSize: isSmallScreen ? 13.5 : 15.5,
                fontWeight: FontWeight.w900,
                color: textDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        // Cash Refresh Button
        IconButton(
          constraints: const BoxConstraints(minWidth: 32),
          padding: EdgeInsets.zero,
          tooltip: 'ক্যাশ রিফ্রেশ',
          icon: const Icon(Icons.sync_rounded, color: Color(0xFF64748B), size: 19),
          onPressed: () {
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ক্যাশ রিফ্রেশ সম্পন্ন হয়েছে'), behavior: SnackBarBehavior.floating),
            );
          },
        ),

        // Notifications Bell
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              constraints: const BoxConstraints(minWidth: 32),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF475569), size: 20),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('২টি নতুন নোটিফিকেশন আছে'), behavior: SnackBarBehavior.floating),
                );
              },
            ),
            Positioned(
              top: 8,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '2',
                  style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),

        // Profile Avatar Menu Pill
        Container(
          margin: const EdgeInsets.only(right: 8, left: 2),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 9,
                backgroundColor: darkGreen,
                child: Text('S', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: 2),
              Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: textMuted),
            ],
          ),
        ),
      ],
    );
  }

  /// 1. Hero Banner (Deep Navy Slate)
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield_rounded, color: Color(0xFF818CF8), size: 12),
                    SizedBox(width: 4),
                    Text(
                      'SUPER ADMIN MANAGEMENT',
                      style: TextStyle(color: Color(0xFFC7D2FE), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),

              // Action Button Right (+ নতুন একাউন্ট তৈরি করুন)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: _showCreateUserModal,
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 14),
                label: const Text(
                  '+ নতুন একাউন্ট তৈরি করুন (Create Profile)',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'সেলস টিম & হায়ারার্কি ম্যানেজমেন্ট প্যানেল',
            style: TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'HBP, Supervisor, Area Manager, Marketing Manager, Head of Sales ও Sales Director আইডি সৃষ্টি ও অ্যাসাইনমেন্ট',
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF94A3B8),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  /// 2. 6 Role Stat Cards Grid
  Widget _buildRoleStatCardsGrid() {
    final statCards = [
      {
        'title': '✨ HBP এজেন্টস',
        'count': '${_getRoleCount('HBP Field Agent')} জন',
        'icon': Icons.stars_rounded,
        'iconColor': const Color(0xFF059669),
        'roleKey': 'HBP Field Agent',
      },
      {
        'title': '🛡️ সুপারভাইজার',
        'count': '${_getRoleCount('Supervisor')} জন',
        'icon': Icons.shield_outlined,
        'iconColor': const Color(0xFFD97706),
        'roleKey': 'Supervisor',
      },
      {
        'title': '🏢 এরিয়া ম্যানেজার',
        'count': '${_getRoleCount('Area Manager')} জন',
        'icon': Icons.business_outlined,
        'iconColor': const Color(0xFF4F46E5),
        'roleKey': 'Area Manager',
      },
      {
        'title': '📈 মার্কেটিং ম্যানেজার',
        'count': '${_getRoleCount('Marketing Manager')} জন',
        'icon': Icons.edit_note_rounded,
        'iconColor': const Color(0xFF0891B2),
        'roleKey': 'Marketing Manager',
      },
      {
        'title': '👔 হেড অব সেলস',
        'count': '${_getRoleCount('Head of Sales')} জন',
        'icon': Icons.bar_chart_rounded,
        'iconColor': const Color(0xFF0284C7),
        'roleKey': 'Head of Sales',
      },
      {
        'title': '📊 সেলস ডিরেক্টর',
        'count': '${_getRoleCount('Sales Director')} জন',
        'icon': Icons.account_balance_outlined,
        'iconColor': const Color(0xFF7C3AED),
        'roleKey': 'Sales Director',
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final int crossAxisCount = width > 700 ? 6 : (width > 450 ? 3 : 2);
        final double childAspectRatio = width > 700 ? 1.4 : 1.35;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: statCards.length,
          itemBuilder: (context, index) {
            final card = statCards[index];
            final String title = (card['title'] ?? '').toString();
            final String count = (card['count'] ?? '').toString();
            final String roleKey = (card['roleKey'] ?? '').toString();

            final bool isSelected = _selectedRoleFilter == roleKey;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRoleFilter = isSelected ? 'সকল' : roleKey;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? brandGreen : const Color(0xFFE2E8F0),
                    width: isSelected ? 1.8 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected ? brandGreen.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.02),
                      blurRadius: isSelected ? 8 : 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: textMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      count,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: textDark),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ফিল্টার করুন',
                          style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: isSelected ? brandGreen : const Color(0xFFD97706)),
                        ),
                        const SizedBox(width: 2),
                        Icon(Icons.arrow_forward_rounded, size: 10, color: isSelected ? brandGreen : const Color(0xFFD97706)),
                      ],
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

  /// 3. Filter & Realtime Search Card
  Widget _buildFilterSearchCard() {
    final filterOptions = [
      {'label': '🌐 সকল সেলস সদস্য', 'count': '${_getRoleCount('সকল')}', 'role': 'সকল'},
      {'label': '✨ HBP ফিল্ড এজেন্ট', 'count': '${_getRoleCount('HBP Field Agent')}', 'role': 'HBP Field Agent'},
      {'label': '🛡️ সুপারভাইজার', 'count': '${_getRoleCount('Supervisor')}', 'role': 'Supervisor'},
      {'label': '🏢 এরিয়া ম্যানেজার', 'count': '${_getRoleCount('Area Manager')}', 'role': 'Area Manager'},
      {'label': '📈 মার্কেটিং ম্যানেজার', 'count': '${_getRoleCount('Marketing Manager')}', 'role': 'Marketing Manager'},
      {'label': '👔 হেড অব সেলস', 'count': '${_getRoleCount('Head of Sales')}', 'role': 'Head of Sales'},
      {'label': '📊 সেলস ডিরেক্টর', 'count': '${_getRoleCount('Sales Director')}', 'role': 'Sales Director'},
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.filter_list_rounded, color: Color(0xFF4F46E5), size: 18),
                      SizedBox(width: 6),
                      Text(
                        'রোল অনুসারে ফিল্টার ও রিয়েল-টাইম সার্চ',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: textDark),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    'মেম্বারদের দ্রুত খুঁজে বের করতে ট্যাব বেছে নিন অথবা ফিল্ডে টাইপ করুন',
                    style: TextStyle(fontSize: 10, color: textMuted),
                  ),
                ],
              ),

              // Search Box matching web placeholder
              SizedBox(
                width: 230,
                height: 36,
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  style: const TextStyle(fontSize: 11.5),
                  decoration: InputDecoration(
                    hintText: '🔍 নাম, ফোন, ইমেইল বা বস দিয়ে খুঁজুন...',
                    hintStyle: const TextStyle(fontSize: 10.5, color: textMuted),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Filter Chips Scroll View
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filterOptions.map((opt) {
                final String label = opt['label']!;
                final String count = opt['count']!;
                final String role = opt['role']!;
                final bool isSelected = _selectedRoleFilter == role;

                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRoleFilter = role;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected ? Colors.white : const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white.withValues(alpha: 0.25) : const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              count,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : textDark,
                              ),
                            ),
                          ),
                        ],
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

  /// 4. Hierarchy & Reporting Boss Table / Mobile Card Grid
  Widget _buildHierarchyTableCard(List<Map<String, dynamic>> users) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  '👥 নিবন্ধিত সকল ইউজার ও হায়ারার্কি রিপোর্টিং বস তালিকা',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: textDark),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ফিল্টারকৃত সদস্য: ${users.length} জন',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: textMuted),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          LayoutBuilder(
            builder: (context, constraints) {
              final bool isMobile = constraints.maxWidth < 680;

              if (users.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  child: const Text(
                    'কোনো ইউজার পাওয়া যায়নি।',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textMuted),
                  ),
                );
              }

              if (isMobile) {
                // Mobile Card Layout
                return Column(
                  children: users.map((u) {
                    final String name = (u['name'] ?? '').toString();
                    final String contact = (u['contact'] ?? '').toString();
                    final String role = (u['role'] ?? '').toString();
                    final String boss = (u['boss'] ?? '').toString();
                    final String date = (u['date'] ?? '').toString();
                    final bool isSelected = (u['isSelected'] as bool?) ?? false;

                    final bossesList = _dynamicReportingBosses;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isSelected ? brandGreen : const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: isSelected,
                                activeColor: brandGreen,
                                onChanged: (val) {
                                  setState(() {
                                    u['isSelected'] = val ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: textDark)),
                                    const SizedBox(height: 1),
                                    Text(contact, style: const TextStyle(fontSize: 10, color: textMuted)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Color(0xFFE2E8F0)),
                          const SizedBox(height: 4),

                          // Role Selector Dropdown
                          const Text('পদবী (UPDATE ROLE):', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textMuted)),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFCBD5E1)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _availableRoles.contains(role) ? role : _availableRoles.last,
                                isExpanded: true,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textDark),
                                items: _availableRoles.map((r) {
                                  return DropdownMenuItem<String>(
                                    value: r,
                                    child: Text(r),
                                  );
                                }).toList(),
                                onChanged: (newRole) {
                                  if (newRole != null) {
                                    setState(() {
                                      u['role'] = newRole;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('$name এর পদবী [$newRole] এ আপডেট করা হয়েছে'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Reporting Boss Selector Dropdown
                          const Text('রিপোর্টিং বস (REPORTING BOSS SELECTION):', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textMuted)),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFCBD5E1)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: bossesList.contains(boss) ? boss : bossesList.first,
                                isExpanded: true,
                                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: textDark),
                                items: bossesList.map((b) {
                                  return DropdownMenuItem<String>(
                                    value: b,
                                    child: Text(b, overflow: TextOverflow.ellipsis),
                                  );
                                }).toList(),
                                onChanged: (newBoss) {
                                  if (newBoss != null) {
                                    setState(() {
                                      u['boss'] = newBoss;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('$name এর রিপোর্টিং বস পরিবর্তন করা হয়েছে'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text('তৈরির তারিখ: $date', style: const TextStyle(fontSize: 9.5, color: textMuted)),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              } else {
                // Desktop / Tablet Full Data Table View
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 30),
                          Expanded(flex: 3, child: Text('নাম ও যোগাযোগের তথ্য', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textMuted))),
                          Expanded(flex: 3, child: Text('পদবী (UPDATE ROLE)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textMuted))),
                          Expanded(flex: 4, child: Text('রিপোর্টিং বস (REPORTING BOSS SELECTION)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textMuted))),
                          Expanded(flex: 2, child: Text('তৈরির তারিখ', textAlign: TextAlign.right, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textMuted))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: users.length,
                      separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9), height: 8),
                      itemBuilder: (context, index) {
                        final u = users[index];
                        final String name = (u['name'] ?? '').toString();
                        final String contact = (u['contact'] ?? '').toString();
                        final String role = (u['role'] ?? '').toString();
                        final String boss = (u['boss'] ?? '').toString();
                        final String date = (u['date'] ?? '').toString();
                        final bool isSelected = (u['isSelected'] as bool?) ?? false;

                        final bossesList = _dynamicReportingBosses;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 30,
                                child: Checkbox(
                                  value: isSelected,
                                  activeColor: brandGreen,
                                  onChanged: (val) {
                                    setState(() {
                                      u['isSelected'] = val ?? false;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: textDark)),
                                    Text(contact, style: const TextStyle(fontSize: 9.5, color: textMuted)),
                                  ],
                                ),
                              ),

                              // Role Dropdown
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: 36,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _availableRoles.contains(role) ? role : _availableRoles.last,
                                      isExpanded: true,
                                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textDark),
                                      items: _availableRoles.map((r) {
                                        return DropdownMenuItem<String>(
                                          value: r,
                                          child: Text(r, overflow: TextOverflow.ellipsis),
                                        );
                                      }).toList(),
                                      onChanged: (newRole) {
                                        if (newRole != null) {
                                          setState(() {
                                            u['role'] = newRole;
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('$name এর পদবী [$newRole] এ আপডেট করা হয়েছে'),
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Reporting Boss Dropdown
                              Expanded(
                                flex: 4,
                                child: Container(
                                  height: 36,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: bossesList.contains(boss) ? boss : bossesList.first,
                                      isExpanded: true,
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textDark),
                                      items: bossesList.map((b) {
                                        return DropdownMenuItem<String>(
                                          value: b,
                                          child: Text(b, overflow: TextOverflow.ellipsis),
                                        );
                                      }).toList(),
                                      onChanged: (newBoss) {
                                        if (newBoss != null) {
                                          setState(() {
                                            u['boss'] = newBoss;
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('$name এর রিপোর্টিং বস পরিবর্তন করা হয়েছে'),
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 2,
                                child: Text(
                                  date,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 9.5, color: textMuted),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  /// Create Profile Modal (Modal Bottom Sheet / Dialog)
  void _showCreateUserModal() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    String selectedRole = 'HBP Field Agent';
    String selectedBoss = _dynamicReportingBosses.first;

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
            final bosses = _dynamicReportingBosses;

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF4F46E5), size: 22),
                          SizedBox(width: 8),
                          Text(
                            'নতুন অ্যাকাউন্ট তৈরি করুন',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: textDark),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 22),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 10),

                  // Name Input
                  const Text('পূর্ণ নাম', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textMuted)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: nameCtrl,
                    style: const TextStyle(fontSize: 12.5),
                    decoration: InputDecoration(
                      hintText: 'যেমন: ফারহান আহমেদ',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Phone Input
                  const Text('মোবাইল নাম্বার', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textMuted)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontSize: 12.5),
                    decoration: InputDecoration(
                      hintText: '01700000000',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Email Input
                  const Text('ইমেইল অ্যাড্রেস', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textMuted)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 12.5),
                    decoration: InputDecoration(
                      hintText: 'agent@mediseba.com',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Role Dropdown Selection
                  const Text('পদবী নির্বাচন করুন (Update Role)', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textMuted)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedRole,
                        isExpanded: true,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textDark),
                        items: _availableRoles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              selectedRole = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Reporting Boss Dropdown Selection
                  const Text('রিপোর্টিং বস নির্বাচন করুন (Reporting Boss)', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textMuted)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: bosses.contains(selectedBoss) ? selectedBoss : bosses.first,
                        isExpanded: true,
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: textDark),
                        items: bosses.map((b) => DropdownMenuItem(value: b, child: Text(b, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              selectedBoss = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        final name = nameCtrl.text.trim();
                        final phone = phoneCtrl.text.trim();
                        final email = emailCtrl.text.trim();

                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('দয়া করে নাম টাইপ করুন'), behavior: SnackBarBehavior.floating),
                          );
                          return;
                        }

                        final contactStr = '${phone.isNotEmpty ? phone : "01700000000"} | ${email.isNotEmpty ? email : "agent@mediseba.com"}';
                        final nowStr = DateTime.now().toString().substring(0, 16);

                        setState(() {
                          _usersList.insert(0, {
                            'id': DateTime.now().millisecondsSinceEpoch.toString(),
                            'name': name,
                            'contact': contactStr,
                            'role': selectedRole,
                            'boss': selectedBoss,
                            'date': nowStr,
                            'isSelected': false,
                          });
                        });

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$name এর জন্য নতুন অ্যাকাউন্ট সফলভাবে সৃষ্টি করা হয়েছে!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text('অ্যাকাউন্ট তৈরি করুন', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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
}
