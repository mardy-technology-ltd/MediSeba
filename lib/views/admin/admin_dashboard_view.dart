import 'package:flutter/material.dart';
import 'admin_drawer.dart';
import 'admin_inbox_view.dart';
import 'admin_packages_audit_view.dart';
import 'admin_job_circulars_view.dart';
import 'admin_sales_team_view.dart';
import 'admin_doctors_management_view.dart';
import 'admin_patient_records_view.dart';
import 'admin_appointments_management_view.dart';
import 'admin_medicine_inventory_view.dart';
import '../../widgets/live_chat_widget.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/language_controller.dart';
import '../../services/api_service.dart';
import '../../services/cache_service.dart';

class AdminDashboardView extends StatefulWidget {
  final HomeController? homeController;
  final AuthController? authController;
  final LanguageController? languageController;

  const AdminDashboardView({
    super.key,
    this.homeController,
    this.authController,
    this.languageController,
  });

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  static const darkGreen = Color(0xFF005C45);
  static const brandGreen = Color(0xFF00A859);
  static const textDark = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  bool _isLoading = true;
  Map<String, dynamic>? _dashboardData;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final token = CacheService.get('auth_token') as String? ?? '';
      final data = await ApiService.getAdminDashboard(token);
      if (data != null) {
        setState(() {
          _dashboardData = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'ড্যাশবোর্ড ডেটা লোড করতে ব্যর্থ হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'ত্রুটি ঘটেছে: $e';
        _isLoading = false;
      });
    }
  }

  void _navigateToSection(int index) {
    Widget? screen;
    switch (index) {
      case 1:
        screen = const AdminInboxView();
        break;
      case 2:
        screen = const AdminPackagesAuditView();
        break;
      case 3:
        screen = const AdminJobCircularsView();
        break;
      case 4:
        screen = const AdminSalesTeamView();
        break;
      case 5:
        screen = const AdminDoctorsManagementView();
        break;
      case 6:
        screen = const AdminPatientRecordsView();
        break;
      case 7:
        screen = const AdminAppointmentsManagementView();
        break;
      case 8:
        screen = const AdminMedicineInventoryView();
        break;
    }
    if (screen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen!),
      );
    }
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'অপেক্ষমাণ';
      case 'confirmed':
        return 'কনফার্মড';
      case 'completed':
        return 'সম্পন্ন';
      case 'cancelled':
        return 'বাতিল';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFD97706);
      case 'confirmed':
        return const Color(0xFF059669);
      case 'completed':
        return const Color(0xFF2563EB);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF64748B);
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFEF3C7);
      case 'confirmed':
        return const Color(0xFFD1FAE5);
      case 'completed':
        return const Color(0xFFDBEAFE);
      case 'cancelled':
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildTopAppBar(context),
      drawer: const AdminDrawer(selectedIndex: 0),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchDashboardData,
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
                              onPressed: _fetchDashboardData,
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
                          // 1. Executive Analytics Hero Banner (Navy blue dashboard overview)
                          _buildHeroBanner(),

                          const SizedBox(height: 14),

                          // 2. Stat KPI Cards Grid (6 items matching screenshot)
                          _buildKPIStatsGrid(),

                          const SizedBox(height: 14),

                          // 3. Action Panel Buttons (Hierarchy, Packages, Pharmacy, Partner)
                          _buildActionPanels(),

                          const SizedBox(height: 14),

                          // 4. Recent Appointments Live Record Table
                          _buildRecentAppointmentsSection(),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
        ),
      ),
      floatingActionButton: const LiveChatFabWidget(),
    );
  }

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
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: isSmallScreen ? 24 : 28,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.local_hospital_rounded, color: Color(0xFFED1C24), size: 20),
                SizedBox(width: 4),
                Text(
                  'মেডি সেবা',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: darkGreen),
                ),
              ],
            ),
          ),
          if (!isSmallScreen) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'ADMIN',
                style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: textMuted),
              ),
            ),
          ],
        ],
      ),
      actions: [
        IconButton(
          constraints: const BoxConstraints(minWidth: 36),
          padding: EdgeInsets.zero,
          tooltip: 'ক্যাশ রিফ্রেশ',
          icon: const Icon(Icons.sync_rounded, color: Color(0xFF64748B), size: 20),
          onPressed: _fetchDashboardData,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              constraints: const BoxConstraints(minWidth: 36),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF475569), size: 22),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('২টি নতুন নোটিফিকেশন আছে'), behavior: SnackBarBehavior.floating),
                );
              },
            ),
            Positioned(
              top: 8,
              right: 6,
              child: Container(
                padding: const EdgeInsets.all(3.5),
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '2',
                  style: TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(right: 8, left: 2),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: darkGreen,
                child: Text('S', style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: 3),
              Icon(Icons.keyboard_arrow_down_rounded, size: 15, color: textMuted),
            ],
          ),
        ),
      ],
    );
  }

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
            color: const Color(0xFF0F172A).withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
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
                Icon(Icons.security_rounded, color: Color(0xFF10B981), size: 12),
                SizedBox(width: 4),
                Text(
                  'SYSTEM OVERVIEW & METRICS',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'মেডিসেবা সুপার অ্যাডমিন ড্যাশবোর্ড',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'লাইভ ডাটাবেস ম্যাট্রিক্স, সেলস ও ওভারঅল চ্যানেল পারফরম্যান্স',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _fetchDashboardData,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sync_rounded, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'লাইভ ডেটা রিফ্রেশ',
                          style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'মেডিসেবা সুপার অ্যাডমিন ড্যাশবোর্ড',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'লাইভ ডাটাবেস ম্যাট্রিক্স, সেলস ও ওভারঅল চ্যানেল পারফরম্যান্স',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _fetchDashboardData,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sync_rounded, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'লাইভ ডেটা রিফ্রেশ',
                          style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
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

  Widget _buildKPIStatsGrid() {
    final List<Map<String, dynamic>> kpis = [
      {
        'title': 'সেলস টিম',
        'value': '${_dashboardData?['total_sales_agents'] ?? 0} জন',
        'icon': Icons.people_outline_rounded,
        'color': const Color(0xFF3B82F6),
        'bg': const Color(0xFFEFF6FF),
        'index': 4,
      },
      {
        'title': 'রেজিস্টার্ড ডাক্তার',
        'value': '${_dashboardData?['total_doctors'] ?? 0} জন',
        'icon': Icons.medical_services_outlined,
        'color': const Color(0xFF10B981),
        'bg': const Color(0xFFECFDF5),
        'index': 5,
      },
      {
        'title': 'মোট পেশেন্ট',
        'value': '${_dashboardData?['total_patients'] ?? 0} জন',
        'icon': Icons.person_search_outlined,
        'color': const Color(0xFF0EA5E9),
        'bg': const Color(0xFFF0F9FF),
        'index': 6,
      },
      {
        'title': 'অ্যাপয়েন্টমেন্ট',
        'value': '${_dashboardData?['total_appointments'] ?? 0} টি',
        'icon': Icons.calendar_month_outlined,
        'color': const Color(0xFF8B5CF6),
        'bg': const Color(0xFFF5F3FF),
        'index': 7,
      },
      {
        'title': 'জব সার্কুলার',
        'value': '${_dashboardData?['total_jobs'] ?? 0} টি',
        'icon': Icons.business_center_outlined,
        'color': const Color(0xFFF59E0B),
        'bg': const Color(0xFFFFFBEB),
        'index': 3,
      },
      {
        'title': 'মোট রেভিনিউ',
        'value': '৳ ${_dashboardData?['total_revenue_bdt'] ?? 0}',
        'icon': Icons.payments_outlined,
        'color': const Color(0xFFEF4444),
        'bg': const Color(0xFFFEF2F2),
        'index': 2,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final int crossAxisCount = width > 640 ? 3 : (width < 340 ? 1 : 2);
        // Generous vertical space to ensure no wrapping or overflow
        final double childAspectRatio = width > 640 ? 1.4 : (width < 340 ? 2.5 : 1.15);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: kpis.length,
          itemBuilder: (context, index) {
            final stat = kpis[index];
            final String title = stat['title'].toString();
            final String value = stat['value'].toString();
            final IconData icon = stat['icon'] as IconData;
            final Color iconColor = stat['color'] as Color;
            final Color bgColor = stat['bg'] as Color;
            final int targetIndex = stat['index'] as int;

            return GestureDetector(
              onTap: () => _navigateToSection(targetIndex),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Circular Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: bgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 16,
                      ),
                    ),
                    
                    // Metadata spacing
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: iconColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    
                    // Bottom Link Action Align Left
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ম্যানেজ করুন',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: iconColor.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 10.5,
                          color: iconColor.withValues(alpha: 0.8),
                        ),
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

  Widget _buildActionPanels() {
    final panels = [
      {
        'label': 'HIERARCHY MANAGEMENT',
        'title': 'সেলস এজেন্টস প্যানেল',
        'colors': [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
        'index': 4,
      },
      {
        'label': 'HEALTH PACKAGES',
        'title': 'প্যাকেজ ও রেভিনিউ প্যানেল',
        'colors': [const Color(0xFF00A859), const Color(0xFF005C45)],
        'index': 2,
      },
      {
        'label': 'PHARMACY INVENTORY',
        'title': 'ওষুধ স্টোর প্যানেল',
        'colors': [const Color(0xFF2563EB), const Color(0xFF1D4ED8)],
        'index': 8,
      },
      {
        'label': 'PARTNER MESSAGES',
        'title': 'ইনবক্স ও পার্টনার ইনকুয়েরি',
        'colors': [const Color(0xFF9333EA), const Color(0xFF7E22CE)],
        'index': 1,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.6,
      ),
      itemCount: panels.length,
      itemBuilder: (context, index) {
        final panel = panels[index];
        final String label = panel['label'] as String;
        final String title = panel['title'] as String;
        final List<Color> colors = panel['colors'] as List<Color>;
        final int targetIndex = panel['index'] as int;

        return GestureDetector(
          onTap: () => _navigateToSection(targetIndex),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colors.last.withValues(alpha: 0.22),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white.withValues(alpha: 0.7),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
                const Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.north_east_rounded,
                    color: Colors.white24,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentAppointmentsSection() {
    final recentList = _dashboardData?['recent_appointments'] as List? ?? [];

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'সাম্প্রতিক অ্যাপয়েন্টমেন্ট সমূহের লাইভ রেকর্ড',
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: textDark),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      'ডাটাবেসে সম্প্রতি রেজিস্টার্ড বুকিং',
                      style: TextStyle(fontSize: 10, color: textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _navigateToSection(7),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('সব অ্যাপয়েন্টমেন্ট দেখুন', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: brandGreen)),
                    SizedBox(width: 2),
                    Icon(Icons.arrow_forward_rounded, size: 12, color: brandGreen),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (recentList.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.calendar_today_outlined, color: textMuted.withValues(alpha: 0.5), size: 36),
                    const SizedBox(height: 8),
                    const Text(
                      'ডাটাবেসে এখনো কোনো অ্যাপয়েন্টমেন্ট তৈরি হয়নি।',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: textMuted),
                    ),
                  ],
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final bool isMobileScreen = constraints.maxWidth < 560;

                if (isMobileScreen) {
                  return Column(
                    children: recentList.map((item) {
                      final String id = (item['appointment_no'] ?? '').toString();
                      final String patient = (item['patient_name'] ?? '').toString();
                      final String doctor = (item['doctor'] ?? '').toString();
                      final String fee = '৳${item['consultation_fee'] ?? 0}';
                      final String date = item['appointment_date'] ?? '';
                      final String time = item['appointment_time'] ?? '';
                      final String status = item['status'] ?? 'pending';

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
                            // ID and Status Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  id,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0284C7),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: _getStatusBgColor(status),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _formatStatus(status),
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w900,
                                      color: _getStatusColor(status),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Divider(color: Color(0xFFE2E8F0), height: 1),
                            ),
                            // Patient Info
                            Row(
                              children: [
                                const Icon(Icons.person_outline_rounded, size: 14, color: textMuted),
                                const SizedBox(width: 6),
                                const Text('রোগী: ', style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w500)),
                                Expanded(
                                  child: Text(
                                    patient,
                                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: textDark),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Doctor Info
                            Row(
                              children: [
                                const Icon(Icons.medical_services_outlined, size: 14, color: textMuted),
                                const SizedBox(width: 6),
                                const Text('ডাক্তার: ', style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w500)),
                                Expanded(
                                  child: Text(
                                    doctor,
                                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: textDark),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Date & Fee
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month_outlined, size: 14, color: textMuted),
                                    const SizedBox(width: 6),
                                    Text(
                                      '$date • $time',
                                      style: const TextStyle(fontSize: 10.5, color: textMuted, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Text(
                                  fee,
                                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: textDark),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                } else {
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
                            Expanded(flex: 3, child: Text('আইডি', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textMuted))),
                            Expanded(flex: 3, child: Text('রোগীর নাম', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textMuted))),
                            Expanded(flex: 3, child: Text('ডাক্তারের নাম', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textMuted))),
                            Expanded(flex: 2, child: Text('ফি', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textMuted))),
                            Expanded(flex: 3, child: Text('তারিখ & সময়', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textMuted))),
                            Expanded(flex: 2, child: Text('স্ট্যাটাস', textAlign: TextAlign.right, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textMuted))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recentList.length,
                        separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9), height: 10),
                        itemBuilder: (context, index) {
                          final item = recentList[index];
                          final String id = (item['appointment_no'] ?? '').toString();
                          final String patient = (item['patient_name'] ?? '').toString();
                          final String doctor = (item['doctor'] ?? '').toString();
                          final String fee = '৳${item['consultation_fee'] ?? 0}';
                          final String date = item['appointment_date'] ?? '';
                          final String time = item['appointment_time'] ?? '';
                          final String status = item['status'] ?? 'pending';

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    id,
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    patient,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textDark),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    doctor,
                                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: textDark),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    fee,
                                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textDark),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    '$date $time',
                                    style: const TextStyle(fontSize: 10, color: textMuted),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getStatusBgColor(status),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _formatStatus(status),
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.bold,
                                          color: _getStatusColor(status),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
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
}
