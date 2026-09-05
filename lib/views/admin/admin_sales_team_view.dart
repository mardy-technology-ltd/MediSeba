import 'package:flutter/material.dart';
import 'admin_drawer.dart';
import '../../widgets/live_chat_widget.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/language_controller.dart';
import '../../services/api_service.dart';
import '../../services/cache_service.dart';

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

  bool _isLoading = true;
  String? _error;
  
  List<Map<String, dynamic>> _usersList = [];
  List<Map<String, dynamic>> _supervisorsList = [];

  final List<String> _availableRoles = [
    'Sales Director',
    'Head of Sales',
    'Marketing Manager',
    'Asst. Marketing Manager',
    'Area Manager',
    'Supervisor',
    'HBP Field Agent',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Map UI Role to Backend API Role value
  String _mapRoleUiToApi(String uiRole) {
    switch (uiRole) {
      case 'Sales Director':
        return 'sales-director';
      case 'Head of Sales':
        return 'head-of-sales';
      case 'Marketing Manager':
        return 'marketing-manager';
      case 'Asst. Marketing Manager':
        return 'asst-marketing-manager';
      case 'Area Manager':
        return 'area-manager';
      case 'Supervisor':
        return 'supervisor';
      case 'HBP Field Agent':
        return 'hbp';
      default:
        return uiRole;
    }
  }

  /// Map Backend API Role to UI Role display label
  String _mapRoleApiToUi(String apiRole) {
    switch (apiRole.toLowerCase()) {
      case 'sales-director':
        return 'Sales Director';
      case 'head-of-sales':
        return 'Head of Sales';
      case 'marketing-manager':
        return 'Marketing Manager';
      case 'asst-marketing-manager':
        return 'Asst. Marketing Manager';
      case 'area-manager':
        return 'Area Manager';
      case 'supervisor':
        return 'Supervisor';
      case 'hbp':
        return 'HBP Field Agent';
      default:
        return apiRole;
    }
  }

  /// Fetch users and supervisors lists from API
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final token = widget.authController?.token ?? AuthController.instance?.token ?? (CacheService.get('auth_token') as String? ?? '');
      debugPrint('====================================================');
      debugPrint('🔍 [ADMIN SALES TEAM DEBUG] _loadData() started');
      debugPrint('🔍 [ADMIN SALES TEAM DEBUG] Auth Token: ${token.isNotEmpty ? "Available (${token.substring(0, token.length > 15 ? 15 : token.length)}...)" : "EMPTY"}');

      // 1. Fetch sales agents
      final agents = await ApiService.getSalesAgents(token: token);
      debugPrint('🔍 [ADMIN SALES TEAM DEBUG] ApiService.getSalesAgents() returned: ${agents?.length ?? "null"} items');
      if (agents != null && agents.isNotEmpty) {
        debugPrint('🔍 [ADMIN SALES TEAM DEBUG] Sample Agent #1: ${agents.first}');
      }

      // 2. Fetch supervisors list
      final supervisors = await ApiService.getSupervisors(token);
      debugPrint('🔍 [ADMIN SALES TEAM DEBUG] ApiService.getSupervisors() returned: ${supervisors?.length ?? "null"} items');
      if (supervisors != null && supervisors.isNotEmpty) {
        debugPrint('🔍 [ADMIN SALES TEAM DEBUG] Sample Supervisor #1: ${supervisors.first}');
      }
      debugPrint('====================================================');

      if (agents != null) {
        setState(() {
          _usersList = agents.map((u) {
            final String rawRole = (u['role'] ?? '').toString();
            final String dateStr = (u['created_at'] ?? '').toString();
            String formattedDate = dateStr;
            if (dateStr.length > 16) {
              formattedDate = dateStr.substring(0, 16).replaceAll('T', ' ');
            }
            
            return {
              'id': (u['id'] ?? '').toString(),
              'name': (u['name'] ?? '').toString(),
              'phone': (u['phone'] ?? '').toString(),
              'email': (u['email'] ?? '').toString(),
              'role': _mapRoleApiToUi(rawRole),
              'boss': (u['supervisor_name'] ?? '-- কোনো রিপোর্টিং বস নেই (Top Executive) --').toString(),
              'supervisor_id': u['supervisor_id'] != null
                  ? int.tryParse(u['supervisor_id'].toString())
                  : (u['supervisor'] != null
                      ? (u['supervisor'] is Map
                          ? int.tryParse(u['supervisor']['id']?.toString() ?? '')
                          : int.tryParse(u['supervisor'].toString()))
                      : null),
              'date': formattedDate,
              'isSelected': false,
            };
          }).toList();

          _supervisorsList = supervisors ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'ডাটা লোড করতে ব্যর্থ হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ [ADMIN SALES TEAM DEBUG] Exception in _loadData(): $e');
      setState(() {
        _error = 'ত্রুটি ঘটেছে: $e';
        _isLoading = false;
      });
    }
  }

  /// Create Sales Agent API Action
  Future<void> _createUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    int? supervisorId,
  }) async {
    setState(() => _isLoading = true);
    final token = widget.authController?.token ?? AuthController.instance?.token ?? (CacheService.get('auth_token') as String? ?? '');
    final apiRole = _mapRoleUiToApi(role);
    
    final success = await ApiService.createSalesAgent(
      name: name,
      email: email,
      phone: phone,
      password: password,
      role: apiRole,
      supervisorId: supervisorId,
      token: token,
    );

    if (success) {
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name এর জন্য নতুন প্রোফাইল তৈরি হয়েছে!'), behavior: SnackBarBehavior.floating),
      );
    } else {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('অ্যাকাউন্ট তৈরি করতে ব্যর্থ হয়েছে। তথ্য চেক করুন।'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  /// Update User (Role & Supervisor) API Action
  Future<void> _updateUser({
    required int userId,
    required String name,
    required String currentRole,
    required String newRole,
    required int? currentSupervisorId,
    required int? newSupervisorId,
  }) async {
    setState(() => _isLoading = true);
    final token = widget.authController?.token ?? AuthController.instance?.token ?? (CacheService.get('auth_token') as String? ?? '');
    bool roleSuccess = true;
    bool supervisorSuccess = true;

    // Call role update if changed
    if (currentRole != newRole) {
      roleSuccess = await ApiService.updateAgentRole(
        userId: userId,
        role: _mapRoleUiToApi(newRole),
        token: token,
      );
    }

    // Call supervisor update if changed
    if (currentSupervisorId != newSupervisorId && newSupervisorId != null) {
      supervisorSuccess = await ApiService.assignSupervisor(
        userId: userId,
        supervisorId: newSupervisorId,
        token: token,
      );
    }

    if (roleSuccess && supervisorSuccess) {
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name এর তথ্য সফলভাবে আপডেট করা হয়েছে!'), behavior: SnackBarBehavior.floating),
      );
    } else {
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('কিছু তথ্য আপডেট করা সম্ভব হয়নি। আবার চেষ্টা করুন।'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  /// Delete User API Action
  Future<void> _deleteUser(int userId, String name) async {
    setState(() => _isLoading = true);
    final token = widget.authController?.token ?? AuthController.instance?.token ?? (CacheService.get('auth_token') as String? ?? '');
    final success = await ApiService.deleteSalesAgent(userId: userId, token: token);
    
    if (success) {
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"$name" সফলভাবে তালিকা থেকে মুছে ফেলা হয়েছে।'), behavior: SnackBarBehavior.floating),
      );
    } else {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ইউজার মুছে ফেলতে ব্যর্থ হয়েছে।'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  /// Get role color code
  Color _getRoleColor(String role) {
    switch (role) {
      case 'Sales Director':
        return const Color(0xFF7C3AED);
      case 'Head of Sales':
        return const Color(0xFF0284C7);
      case 'Marketing Manager':
        return const Color(0xFF0D9488);
      case 'Asst. Marketing Manager':
        return const Color(0xFFEC4899);
      case 'Area Manager':
        return const Color(0xFF4F46E5);
      case 'Supervisor':
        return const Color(0xFFD97706);
      case 'HBP Field Agent':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF64748B);
    }
  }

  /// Get role background color for badge
  Color _getRoleBgColor(String role) {
    return _getRoleColor(role).withValues(alpha: 0.08);
  }

  /// Resolve supervisor UI role from API data, users list, or text parsing
  String _getSupervisorUiRole(Map<String, dynamic> s) {
    final String rawRole = (s['role'] ?? s['user_type'] ?? s['type'] ?? '').toString();
    if (rawRole.isNotEmpty) {
      final mapped = _mapRoleApiToUi(rawRole);
      if (mapped.isNotEmpty && mapped != rawRole) {
        return mapped;
      }
    }
    final String sIdStr = (s['id'] ?? '').toString();
    for (final u in _usersList) {
      if (u['id'] == sIdStr) {
        return u['role'] ?? '';
      }
    }
    final String nameLower = (s['name'] ?? '').toString().toLowerCase();
    final String emailLower = (s['email'] ?? '').toString().toLowerCase();
    if (nameLower.contains('director') || emailLower.contains('sd@')) {
      return 'Sales Director';
    }
    if (nameLower.contains('head of sales') || nameLower.contains('hos') || emailLower.contains('hos@')) {
      return 'Head of Sales';
    }
    if (nameLower.contains('asst. marketing') || nameLower.contains('amm') || emailLower.contains('amm@')) {
      return 'Asst. Marketing Manager';
    }
    if (nameLower.contains('marketing') || nameLower.contains('mm') || emailLower.contains('mm@')) {
      return 'Marketing Manager';
    }
    if (nameLower.contains('area') || nameLower.contains('am') || emailLower.contains('am@')) {
      return 'Area Manager';
    }
    if (nameLower.contains('supervisor') || emailLower.contains('supervisor@')) {
      return 'Supervisor';
    }
    if (nameLower.contains('hbp') || emailLower.contains('hbp@')) {
      return 'HBP Field Agent';
    }
    return '';
  }

  /// Get list of reporting bosses dynamically filtered from supervisors list
  List<Map<String, dynamic>> _getFilteredBossesList(String selectedRoleUi) {
    debugPrint('====================================================');
    debugPrint('🔍 [BOSS DROPDOWN DEBUG] _getFilteredBossesList for UI Role: "$selectedRoleUi"');
    debugPrint('🔍 [BOSS DROPDOWN DEBUG] _supervisorsList count: ${_supervisorsList.length}');
    debugPrint('🔍 [BOSS DROPDOWN DEBUG] _usersList count: ${_usersList.length}');

    final List<Map<String, dynamic>> list = [
      {'id': 0, 'name': '-- কোনো রিপোর্টিং বস নেই (Top Executive) --'},
    ];
    String? targetRoleUi;
    if (selectedRoleUi == 'HBP Field Agent') {
      targetRoleUi = 'Supervisor';
    } else if (selectedRoleUi == 'Supervisor') {
      targetRoleUi = 'Area Manager';
    } else if (selectedRoleUi == 'Area Manager') {
      targetRoleUi = 'Asst. Marketing Manager';
    } else if (selectedRoleUi == 'Asst. Marketing Manager') {
      targetRoleUi = 'Marketing Manager';
    } else if (selectedRoleUi == 'Marketing Manager') {
      targetRoleUi = 'Head of Sales';
    } else if (selectedRoleUi == 'Head of Sales') {
      targetRoleUi = 'Sales Director';
    }

    debugPrint('🔍 [BOSS DROPDOWN DEBUG] Target Boss Role expected: "$targetRoleUi"');

    int matchedCount = 0;

    // 1. Filter from _supervisorsList
    for (var s in _supervisorsList) {
      final String roleUi = _getSupervisorUiRole(s);
      final int id = int.tryParse(s['id']?.toString() ?? '') ?? 0;
      final String name = (s['name'] ?? '').toString();
      final String email = (s['email'] ?? '').toString();
      final String rawRole = (s['role'] ?? s['user_type'] ?? '').toString();

      debugPrint('   👉 Checking Supervisor Item: id=$id, name="$name", rawRole="$rawRole", resolvedRoleUi="$roleUi"');

      if (targetRoleUi == null ||
          roleUi.toLowerCase() == targetRoleUi.toLowerCase() ||
          rawRole.toLowerCase() == _mapRoleUiToApi(targetRoleUi).toLowerCase() ||
          (targetRoleUi == 'Supervisor' && (rawRole.toLowerCase().contains('supervisor') || name.toLowerCase().contains('supervisor')))) {
        if (id > 0 && !list.any((item) => item['id'] == id)) {
          list.add({'id': id, 'name': '$name ($email)'});
          matchedCount++;
          debugPrint('   ✅ Matched & Added Boss from _supervisorsList: id=$id, name="$name"');
        }
      }
    }

    // 2. Filter from _usersList
    for (var u in _usersList) {
      final String uRole = (u['role'] ?? '').toString();
      final int id = int.tryParse(u['id']?.toString() ?? '') ?? 0;
      final String name = (u['name'] ?? '').toString();
      final String email = (u['email'] ?? '').toString();

      if (targetRoleUi != null && uRole.toLowerCase() == targetRoleUi.toLowerCase()) {
        if (id > 0 && !list.any((item) => item['id'] == id)) {
          list.add({'id': id, 'name': '$name ($email)'});
          matchedCount++;
          debugPrint('   ✅ Matched & Added Boss from _usersList: id=$id, name="$name", role="$uRole"');
        }
      }
    }

    // 3. Fallback: If no exact matching boss was found, list all available supervisors/managers so dropdown has options!
    if (matchedCount == 0 && (_supervisorsList.isNotEmpty || _usersList.isNotEmpty)) {
      debugPrint('⚠️ [BOSS DROPDOWN DEBUG] No exact boss match for "$targetRoleUi". Populating fallback supervisors/managers list.');
      for (var s in _supervisorsList) {
        final int id = int.tryParse(s['id']?.toString() ?? '') ?? 0;
        final String name = (s['name'] ?? '').toString();
        final String email = (s['email'] ?? '').toString();
        if (id > 0 && !list.any((item) => item['id'] == id)) {
          list.add({'id': id, 'name': '$name ($email)'});
        }
      }
      for (var u in _usersList) {
        final String uRole = (u['role'] ?? '').toString();
        final int id = int.tryParse(u['id']?.toString() ?? '') ?? 0;
        final String name = (u['name'] ?? '').toString();
        final String email = (u['email'] ?? '').toString();
        if (id > 0 && uRole != 'HBP Field Agent' && !list.any((item) => item['id'] == id)) {
          list.add({'id': id, 'name': '$name ($email) - [$uRole]'});
        }
      }
    }

    debugPrint('🔍 [BOSS DROPDOWN DEBUG] Total Options in Dropdown: ${list.length}');
    debugPrint('====================================================');
    return list;
  }

  /// Get role count dynamically
  int _getRoleCount(String roleKey) {
    if (roleKey == 'সকল') {
      return _usersList.length;
    }
    return _usersList.where((u) => (u['role'] ?? '').toString() == roleKey).length;
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _usersList.where((u) {
      final name = (u['name'] ?? '').toString().toLowerCase();
      final phone = (u['phone'] ?? '').toString().toLowerCase();
      final email = (u['email'] ?? '').toString().toLowerCase();
      final role = (u['role'] ?? '').toString();

      final matchesQuery = name.contains(_searchQuery.toLowerCase()) || 
                           phone.contains(_searchQuery.toLowerCase()) || 
                           email.contains(_searchQuery.toLowerCase());
      final matchesRole = _selectedRoleFilter == 'সকল' || role == _selectedRoleFilter;

      return matchesQuery && matchesRole;
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildTopAppBar(context),
      drawer: const AdminDrawer(selectedIndex: 4),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: brandGreen,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: brandGreen),
                )
              : _error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textDark),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: brandGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: _loadData,
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text('আবার চেষ্টা করুন', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Hero Banner (Deep Navy Slate with hierarchy flow)
                          _buildHeroBanner(),

                          const SizedBox(height: 14),

                          // 2. Roles Horizontal Scroll metrics row
                          _buildRoleStatRow(),

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
              'নিবন্ধিত সকল ইউজার ও হায়ারার্কি',
              style: TextStyle(
                fontSize: isSmallScreen ? 13.5 : 15.0,
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
          onPressed: _loadData,
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

  /// 1. Hero Banner (Deep Navy Slate with hierarchy flow)
  Widget _buildHeroBanner() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 480;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.hub_rounded, color: Color(0xFF818CF8), size: 12),
                    SizedBox(width: 4),
                    Text(
                      'FULL SYSTEM INTEGRATION',
                      style: TextStyle(color: Color(0xFFC7D2FE), fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
              if (!isMobile) _buildCreateProfileButton(),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            '👥 সেলস টিম ও হায়ারার্কি ম্যানেজমেন্ট প্যানেল',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Sales Director ➔ Head of Sales ➔ Marketing Manager ➔ Asst. Marketing Manager ➔ Area Manager ➔ Supervisor ➔ HBP Field Agent (লাইভ MySQL সিঙ্ক)',
            style: TextStyle(
              fontSize: 10.5,
              color: Color(0xFF94A3B8),
              height: 1.35,
            ),
          ),

          const SizedBox(height: 12),
          // Horizontally scrollable visual hierarchy timeline
          _buildHierarchyPipeline(),

          if (isMobile) ...[
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: _buildCreateProfileButton()),
          ],
        ],
      ),
    );
  }

  Widget _buildCreateProfileButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: brandGreen,
        foregroundColor: Colors.white,
        elevation: 1,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: _showCreateUserModal,
      icon: const Icon(Icons.person_add_alt_1_rounded, size: 15),
      label: const Text(
        '+ নতুন অ্যাকাউন্ট তৈরি করুন (Create Profile)',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
      ),
    );
  }

  Widget _buildHierarchyPipeline() {
    final pipeline = [
      'Sales Director',
      'Head of Sales',
      'Marketing Manager',
      'Asst. Marketing Manager',
      'Area Manager',
      'Supervisor',
      'HBP Field Agent',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: pipeline.asMap().entries.map((entry) {
          final idx = entry.key;
          final role = entry.value;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getRoleBgColor(role),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _getRoleColor(role).withValues(alpha: 0.3)),
                ),
                child: Text(
                  role,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    color: _getRoleColor(role),
                  ),
                ),
              ),
              if (idx < pipeline.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 14),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  /// 2. Roles Scroll metrics row
  Widget _buildRoleStatRow() {
    final statCards = [
      {
        'title': 'HBP এজেন্ট',
        'count': '${_getRoleCount('HBP Field Agent')}',
        'roleKey': 'HBP Field Agent',
      },
      {
        'title': 'সুপারভাইজার',
        'count': '${_getRoleCount('Supervisor')}',
        'roleKey': 'Supervisor',
      },
      {
        'title': 'মার্কেটিং ম্যানেজার',
        'count': '${_getRoleCount('Marketing Manager')}',
        'roleKey': 'Marketing Manager',
      },
      {
        'title': 'Asst. মার্কেটিং ম্যানেজার',
        'count': '${_getRoleCount('Asst. Marketing Manager')}',
        'roleKey': 'Asst. Marketing Manager',
      },
      {
        'title': 'এরিয়া ম্যানেজার',
        'count': '${_getRoleCount('Area Manager')}',
        'roleKey': 'Area Manager',
      },
      {
        'title': 'হেড অব সেলস',
        'count': '${_getRoleCount('Head of Sales')}',
        'roleKey': 'Head of Sales',
      },
      {
        'title': 'সেলস ডিরেক্টর',
        'count': '${_getRoleCount('Sales Director')}',
        'roleKey': 'Sales Director',
      },
    ];

    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: statCards.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final card = statCards[index];
          final String title = card['title']!;
          final String count = card['count']!;
          final String roleKey = card['roleKey']!;
          final bool isSelected = _selectedRoleFilter == roleKey;
          final Color themeColor = _getRoleColor(roleKey);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedRoleFilter = isSelected ? 'সকল' : roleKey;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? themeColor : const Color(0xFFE2E8F0),
                  width: isSelected ? 2.0 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected ? themeColor.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.01),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 3.5,
                    height: 24,
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textMuted),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        count,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: textDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 3. Filter & Realtime Search Card
  Widget _buildFilterSearchCard() {
    final filterOptions = [
      {'label': 'সকল সেলস মেম্বার', 'count': '${_getRoleCount('সকল')}', 'role': 'সকল'},
      {'label': 'HBP Field Agent', 'count': '${_getRoleCount('HBP Field Agent')}', 'role': 'HBP Field Agent'},
      {'label': 'Supervisor', 'count': '${_getRoleCount('Supervisor')}', 'role': 'Supervisor'},
      {'label': 'Area Manager', 'count': '${_getRoleCount('Area Manager')}', 'role': 'Area Manager'},
      {'label': 'Asst. Marketing Manager', 'count': '${_getRoleCount('Asst. Marketing Manager')}', 'role': 'Asst. Marketing Manager'},
      {'label': 'Marketing Manager', 'count': '${_getRoleCount('Marketing Manager')}', 'role': 'Marketing Manager'},
      {'label': 'Head of Sales', 'count': '${_getRoleCount('Head of Sales')}', 'role': 'Head of Sales'},
      {'label': 'Sales Director', 'count': '${_getRoleCount('Sales Director')}', 'role': 'Sales Director'},
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
          // Search Box with prefix magnifying glass
          TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            style: const TextStyle(fontSize: 12.5),
            decoration: InputDecoration(
              hintText: '🔍 নাম, ফোন বা ইমেইল দিয়ে খুঁজুন...',
              hintStyle: const TextStyle(fontSize: 11, color: textMuted),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
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
                borderSide: const BorderSide(color: brandGreen, width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Filter Chips Scroll View
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: filterOptions.map((opt) {
                final String label = opt['label']!;
                final String count = opt['count']!;
                final String role = opt['role']!;
                final bool isSelected = _selectedRoleFilter == role;
                final Color themeColor = role == 'সকল' ? const Color(0xFF4F46E5) : _getRoleColor(role);

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
                        color: isSelected ? themeColor : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? themeColor : const Color(0xFFE2E8F0),
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
                                  color: isSelected ? Colors.white : textDark),
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
                  '👥 নিবন্ধিত সদস্য ও হায়ারার্কি রিপোর্টিং বস তালিকা',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: textDark),
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
                  'মোট: ${users.length} জন',
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
                    final String phone = (u['phone'] ?? '').toString();
                    final String email = (u['email'] ?? '').toString();
                    final String role = (u['role'] ?? '').toString();
                    final String boss = (u['boss'] ?? '').toString();
                    final String date = (u['date'] ?? '').toString();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Name and Role Badge Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: textDark),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                                decoration: BoxDecoration(
                                  color: _getRoleBgColor(role),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: _getRoleColor(role).withValues(alpha: 0.15)),
                                ),
                                child: Text(
                                  role,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: _getRoleColor(role),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(color: Color(0xFFE2E8F0), height: 1),
                          ),

                          // Contact Info Row
                          Row(
                            children: [
                              const Icon(Icons.phone_android_rounded, size: 13, color: textMuted),
                              const SizedBox(width: 4),
                              Text(phone, style: const TextStyle(fontSize: 10.5, color: textMuted, fontWeight: FontWeight.w500)),
                              const SizedBox(width: 8),
                              const Icon(Icons.email_outlined, size: 13, color: textMuted),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  email,
                                  style: const TextStyle(fontSize: 10.5, color: textMuted, fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Reporting Boss Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.account_tree_outlined, size: 13, color: textMuted),
                              const SizedBox(width: 4),
                              const Text(
                                'রিপোর্টিং বস: ',
                                style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(
                                  boss,
                                  style: const TextStyle(fontSize: 11, color: textDark, fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Footer with Creation Date and CRUD actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'তৈরির তারিখ: $date',
                                style: const TextStyle(fontSize: 9.5, color: textMuted, fontWeight: FontWeight.w500),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.all(4),
                                    icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent, size: 16),
                                    onPressed: () => _showEditUserModal(u),
                                  ),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.all(4),
                                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 16),
                                    onPressed: () => _confirmDeleteUser(u),
                                  ),
                                ],
                              ),
                            ],
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
                          Expanded(flex: 3, child: Text('নাম ও যোগাযোগের তথ্য', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted))),
                          Expanded(flex: 2, child: Text('পদবী (ROLE)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted))),
                          Expanded(flex: 4, child: Text('রিপোর্টিং বস (SUPERVISOR/MANAGER)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted))),
                          Expanded(flex: 2, child: Text('তৈরির তারিখ', textAlign: TextAlign.right, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted))),
                          SizedBox(width: 80),
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
                        final String phone = (u['phone'] ?? '').toString();
                        final String email = (u['email'] ?? '').toString();
                        final String role = (u['role'] ?? '').toString();
                        final String boss = (u['boss'] ?? '').toString();
                        final String date = (u['date'] ?? '').toString();

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: textDark)),
                                    Text('$phone | $email', style: const TextStyle(fontSize: 9.5, color: textMuted)),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getRoleBgColor(role),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    role,
                                    style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: _getRoleColor(role)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  boss,
                                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: textDark),
                                  overflow: TextOverflow.ellipsis,
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
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 70,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent, size: 16),
                                      onPressed: () => _showEditUserModal(u),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 16),
                                      onPressed: () => _confirmDeleteUser(u),
                                    ),
                                  ],
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
    final passCtrl = TextEditingController(text: '123456'); // Default password matching backend mockup
    String selectedRole = 'HBP Field Agent';
    int selectedBossId = 0;

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
            final bosses = _getFilteredBossesList(selectedRole);

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.person_add_alt_1_rounded, color: brandGreen, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'নতুন অ্যাকাউন্ট তৈরি করুন',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: textDark),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 8),

                    // Name Input
                    const Text('পূর্ণ নাম', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: nameCtrl,
                      style: const TextStyle(fontSize: 12.5),
                      decoration: InputDecoration(
                        hintText: 'যেমন: ফারহান আহমেদ',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Phone Input
                    const Text('মোবাইল নাম্বার', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 12.5),
                      decoration: InputDecoration(
                        hintText: 'যেমন: 017XXXXXXXX',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Email Input
                    const Text('ইমেইল অ্যাড্রেস', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 12.5),
                      decoration: InputDecoration(
                        hintText: 'যেমন: agent@mediseba.com',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Password Input
                    const Text('পাসওয়ার্ড', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: passCtrl,
                      style: const TextStyle(fontSize: 12.5),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Role Dropdown Selection
                    const Text('পদবী নির্বাচন করুন', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                        borderRadius: BorderRadius.circular(10),
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
                                selectedBossId = 0;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Reporting Boss Dropdown Selection
                    const Text('রিপোর্টিং বস নির্বাচন করুন', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: selectedBossId,
                          isExpanded: true,
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: textDark),
                          items: bosses.map((b) => DropdownMenuItem<int>(
                            value: b['id'] as int, 
                            child: Text(b['name'].toString(), overflow: TextOverflow.ellipsis)
                          )).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                selectedBossId = val;
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
                      height: 42,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          final name = nameCtrl.text.trim();
                          final phone = phoneCtrl.text.trim();
                          final email = emailCtrl.text.trim();
                          final password = passCtrl.text.trim();

                          if (name.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('দয়া করে নাম টাইপ করুন'), behavior: SnackBarBehavior.floating),
                            );
                            return;
                          }

                          if (phone.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('দয়া করে মোবাইল নাম্বার টাইপ করুন'), behavior: SnackBarBehavior.floating),
                            );
                            return;
                          }

                          if (password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('দয়া করে পাসওয়ার্ড টাইপ করুন'), behavior: SnackBarBehavior.floating),
                            );
                            return;
                          }

                          Navigator.pop(context);
                          _createUser(
                            name: name,
                            email: email.isNotEmpty ? email : '$phone@mediseba.com',
                            phone: phone,
                            password: password,
                            role: selectedRole,
                            supervisorId: selectedBossId == 0 ? null : selectedBossId,
                          );
                        },
                        child: const Text('অ্যাকাউন্ট তৈরি করুন', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
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

  /// Edit User Modal Sheet
  void _showEditUserModal(Map<String, dynamic> u) {
    final nameCtrl = TextEditingController(text: u['name']);
    final phoneCtrl = TextEditingController(text: u['phone']);
    final emailCtrl = TextEditingController(text: u['email']);
    String selectedRole = u['role'];
    int? currentBossId = u['supervisor_id'];
    int selectedBossId = currentBossId ?? 0;
    final int userId = int.tryParse(u['id'] ?? '') ?? 0;

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
            final bosses = _getFilteredBossesList(selectedRole);
            final bool hasCurrentBoss = bosses.any((b) => b['id'] == selectedBossId);
            if (!hasCurrentBoss) {
              String currentBossName = 'আইডি: $selectedBossId';
              for (final b in _supervisorsList) {
                if (b['id'] == selectedBossId) {
                  currentBossName = '${b['name']} (${b['email']})';
                  break;
                }
              }
              bosses.add({'id': selectedBossId, 'name': '$currentBossName (বর্তমান বস)'});
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.edit_outlined, color: _getRoleColor(selectedRole), size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'ইউজার তথ্য পরিবর্তন করুন',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: textDark),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 8),

                    // Name Input (Disabled/Read-only representation matching API)
                    const Text('পূর্ণ নাম', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: nameCtrl,
                      enabled: false,
                      style: const TextStyle(fontSize: 12.5, color: textMuted),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Phone Input (Disabled/Read-only)
                    const Text('মোবাইল নাম্বার', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: phoneCtrl,
                      enabled: false,
                      style: const TextStyle(fontSize: 12.5, color: textMuted),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Email Input (Disabled/Read-only)
                    const Text('ইমেইল অ্যাড্রেস', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: emailCtrl,
                      enabled: false,
                      style: const TextStyle(fontSize: 12.5, color: textMuted),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Role Dropdown Selection
                    const Text('পদবী নির্বাচন করুন', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                        borderRadius: BorderRadius.circular(10),
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
                                selectedBossId = 0;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Reporting Boss Dropdown Selection
                    const Text('রিপোর্টিং বস নির্বাচন করুন', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: selectedBossId,
                          isExpanded: true,
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: textDark),
                          items: bosses.map((b) => DropdownMenuItem<int>(
                            value: b['id'] as int, 
                            child: Text(b['name'].toString(), overflow: TextOverflow.ellipsis)
                          )).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                selectedBossId = val;
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
                      height: 42,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getRoleColor(selectedRole),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          final name = nameCtrl.text.trim();
                          if (name.isEmpty) return;

                          Navigator.pop(context);
                          _updateUser(
                            userId: userId,
                            name: name,
                            currentRole: u['role'],
                            newRole: selectedRole,
                            currentSupervisorId: currentBossId,
                            newSupervisorId: selectedBossId == 0 ? null : selectedBossId,
                          );
                        },
                        child: const Text('তথ্য সংরক্ষণ করুন', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
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

  /// Confirm Delete Dialog
  void _confirmDeleteUser(Map<String, dynamic> u) {
    final int userId = int.tryParse(u['id'] ?? '') ?? 0;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 22),
            SizedBox(width: 8),
            Text('অ্যাকাউন্ট মুছে ফেলুন', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: textDark)),
          ],
        ),
        content: Text(
          'আপনি কি নিশ্চিতভাবে "${u['name']}"-এর অ্যাকাউন্ট এবং হায়ারার্কি রেকর্ড মুছে ফেলতে চান?',
          style: const TextStyle(fontSize: 12.5, color: textDark, height: 1.35),
        ),
        actions: [
          TextButton(
            child: const Text('বাতিল', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: textMuted)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('মুছে ফেলুন', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(userId, u['name']);
            },
          ),
        ],
      ),
    );
  }
}
