import 'package:flutter/material.dart';
import 'admin_drawer.dart';
import '../../widgets/live_chat_widget.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/language_controller.dart';

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

  String _selectedGraphFilter = 'গত ৬ মাস';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> _kpiStats = [
    {
      'title': 'সক্রিয় ডাক্তার',
      'value': '12 জন',
      'icon': Icons.medical_services_outlined,
      'color': const Color(0xFF10B981),
      'bg': const Color(0xFFECFDF5),
    },
    {
      'title': 'নিবন্ধিত রোগী',
      'value': '49 জন',
      'icon': Icons.people_outline_rounded,
      'color': const Color(0xFF3B82F6),
      'bg': const Color(0xFFEFF6FF),
    },
    {
      'title': 'মোট অ্যাপয়েন্টমেন্ট',
      'value': '84 টি',
      'icon': Icons.calendar_month_outlined,
      'color': const Color(0xFF8B5CF6),
      'bg': const Color(0xFFF5F3FF),
    },
    {
      'title': 'মোট রেভিনিউ',
      'value': '৳ 42,000',
      'icon': Icons.attach_money_rounded,
      'color': const Color(0xFFD97706),
      'bg': const Color(0xFFFEF3C7),
    },
  ];

  final List<Map<String, dynamic>> _monthlyRevenueData = [
    {'month': 'মার্চ', 'amount': '৳ 18.0k', 'heightRatio': 0.43},
    {'month': 'এপ্রিল', 'amount': '৳ 24.0k', 'heightRatio': 0.57},
    {'month': 'মে', 'amount': '৳ 31.0k', 'heightRatio': 0.74},
    {'month': 'জুন', 'amount': '৳ 28.0k', 'heightRatio': 0.67},
    {'month': 'জুলাই', 'amount': '৳ 36.0k', 'heightRatio': 0.86},
    {'month': 'আগস্ট (চলতি)', 'amount': '৳ 42.0k', 'heightRatio': 1.00},
  ];

  final List<Map<String, dynamic>> _recentAppointments = [
    {
      'id': 'APT-20260804-884920',
      'patient': 'Mohammad Ali',
      'doctor': 'Dr. Tanvir Hasan',
      'fee': '৳ ১,২০০',
      'dateTime': 'আজ, ১০:০০ AM',
      'status': 'কনফার্মড',
      'statusColor': const Color(0xFF059669),
      'statusBg': const Color(0xFFD1FAE5),
    },
    {
      'id': 'APT-20260804-492810',
      'patient': 'Tania Rahman',
      'doctor': 'Dr. Ahmed Rahman',
      'fee': '৳ ১,০০০',
      'dateTime': 'আজ, ১১:০০ AM',
      'status': 'সম্পন্ন',
      'statusColor': const Color(0xFF2563EB),
      'statusBg': const Color(0xFFDBEAFE),
    },
    {
      'id': 'APT-20260804-104928',
      'patient': 'Kabir Hossain',
      'doctor': 'Dr. Farzana Islam',
      'fee': '৳ ১,২০০',
      'dateTime': 'আজ, ০২:১৫ PM',
      'status': 'অপেক্ষমাণ',
      'statusColor': const Color(0xFFD97706),
      'statusBg': const Color(0xFFFEF3C7),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildTopAppBar(context),
      drawer: const AdminDrawer(selectedIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Executive Analytics Hero Banner (Teal Dark Green Card)
              _buildHeroBanner(),

              const SizedBox(height: 14),

              // 2. Stat Cards Grid (4 Cards: Active Doctors, Patients, Appointments, Revenue)
              _buildKPIStatsGrid(),

              const SizedBox(height: 14),

              // 3. Sales Team Hierarchy Banner (Deep Navy Card)
              _buildFlagshipSalesBanner(),

              const SizedBox(height: 14),

              // 4. Analytics Row: Left Revenue Graph + Right Booking Share
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 768) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildRevenueGraphCard()),
                        const SizedBox(width: 14),
                        Expanded(flex: 2, child: _buildBookingShareCard()),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildRevenueGraphCard(),
                        const SizedBox(height: 14),
                        _buildBookingShareCard(),
                      ],
                    );
                  }
                },
              ),

              const SizedBox(height: 14),

              // 5. Recent Telemedicine Appointments Table / Cards
              _buildRecentAppointmentsSection(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: const LiveChatFabWidget(),
    );
  }

  /// Top App Bar matching web visual header with full responsive adaptivity
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
        // Cash Refresh Button
        IconButton(
          constraints: const BoxConstraints(minWidth: 36),
          padding: EdgeInsets.zero,
          tooltip: 'ক্যাশ রিফ্রেশ',
          icon: const Icon(Icons.sync_rounded, color: Color(0xFF64748B), size: 20),
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

        // Profile Avatar Menu Pill
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

  /// 1. Executive Analytics Hero Banner (Teal Dark Green Card)
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Badge & Action Button
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'মেডিসেবা এক্সিকিউটিভ অ্যানালিটিক্স',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),

              // Action Button Right (+ চেইন অ্যাকাউন্ট তৈরি)
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('চেইন অ্যাকাউন্ট তৈরি স্ক্রিন খুলছে...'), behavior: SnackBarBehavior.floating),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_add_alt_outlined, color: darkGreen, size: 13),
                      SizedBox(width: 4),
                      Text(
                        '+ চেইন অ্যাকাউন্ট তৈরি',
                        style: TextStyle(color: darkGreen, fontSize: 10, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Main Header Title with Refresh Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ড্যাশবোর্ড ওভারভিউ & লাইভ চার্ট অ্যানালিটিক্স',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Stripe & Vercel স্টাইল গ্রোয়িং গ্রাফ চার্ট, রিয়েল-টাইম রেভিনিউ ট্র্যাকিং এবং বুকিং অ্যানালিটিক্স।',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                constraints: const BoxConstraints(minWidth: 32),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.sync_rounded, color: Colors.white, size: 18),
                onPressed: () {
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 2. Stat Cards Grid (4 Cards: Active Doctors, Patients, Appointments, Revenue)
  Widget _buildKPIStatsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final int crossAxisCount = width > 640 ? 4 : (width < 340 ? 1 : 2);
        final double childAspectRatio = width > 640 ? 1.6 : (width < 340 ? 3.0 : 1.35);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: _kpiStats.length,
          itemBuilder: (context, index) {
            final stat = _kpiStats[index];
            final String title = (stat['title'] ?? '').toString();
            final String value = (stat['value'] ?? '').toString();
            final IconData icon = (stat['icon'] as IconData?) ?? Icons.analytics_outlined;
            final Color iconColor = (stat['color'] as Color?) ?? brandGreen;
            final Color bgColor = (stat['bg'] as Color?) ?? const Color(0xFFECFDF5);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
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

  /// 3. Sales Team Hierarchy Banner (Deep Navy Card)
  Widget _buildFlagshipSalesBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up_rounded, color: Color(0xFF818CF8), size: 12),
                SizedBox(width: 4),
                Text(
                  'ফিল্ড লেভেল সেলস টিম (HBP & Supervisor)',
                  style: TextStyle(color: Color(0xFFC7D2FE), fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'সেলস টিম হায়ারার্কি ও পারফরম্যান্স ম্যানেজমেন্ট',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'এইচআরপি টার্গেট (৬৫০ সেলস / ৩০% স্যালারি প্রমোশন), সুপারভাইজারের ফেক সেল ফিল্টার ও ইউজার আইডি পাসওয়ার্ড তৈরি করুন।',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF94A3B8),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('সেলস এজেন্ট তৈরি ও ম্যানেজমেন্ট খুলছে...'), behavior: SnackBarBehavior.floating),
              );
            },
            icon: const Icon(Icons.person_add_alt_rounded, size: 15),
            label: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'সেলস এজেন্ট তৈরি ও ম্যানেজ করুন',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 13),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 4. Left Chart Card: Revenue Growth Bar Graph Card
  Widget _buildRevenueGraphCard() {
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
          // Header Wrap
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bar_chart_rounded, color: Color(0xFF10B981), size: 18),
                      SizedBox(width: 5),
                      Text(
                        'রেভিনিউ প্রবৃদ্ধি & কাস্টম চার্ট',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    'সময়সীমা পরিবর্তন করে রিয়েল-টাইমে আয় দেখুন',
                    style: TextStyle(fontSize: 9.5, color: textMuted),
                  ),
                ],
              ),
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['গত ৭ দিন', 'গত ৩০ দিন', 'গত ৬ মাস'].map((filter) {
                    final isSelected = _selectedGraphFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGraphFilter = filter;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFCCFBF1) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? brandGreen : const Color(0xFFE2E8F0),
                              width: isSelected ? 1.3 : 1.0,
                            ),
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected ? darkGreen : textMuted,
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

          const SizedBox(height: 16),

          // Bar Chart Visual
          SizedBox(
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _monthlyRevenueData.map((data) {
                final double heightRatio = (data['heightRatio'] as num?)?.toDouble() ?? 0.5;
                final String month = (data['month'] ?? '').toString();
                final String amount = (data['amount'] ?? '').toString();
                final barHeight = 85.0 * heightRatio;
                final isCurrent = month.contains('আগস্ট');

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        amount,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? darkGreen : const Color(0xFF475569),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 18,
                      height: barHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isCurrent
                              ? [const Color(0xFF10B981), const Color(0xFF00A859)]
                              : [const Color(0xFF059669), const Color(0xFF047857)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 5),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        month,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                          color: isCurrent ? textDark : textMuted,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),
          const Divider(color: Color(0xFFF1F5F9)),
          const SizedBox(height: 4),

          // Footnote Summary
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: const [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded, color: brandGreen, size: 14),
                  SizedBox(width: 3),
                  Text(
                    'প্ল্যাটফর্ম কমিশন গ্রোথ হার: +২৭.৪%',
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF059669)),
                  ),
                ],
              ),
              Text(
                'সর্বশেষ আপডেট: আজ',
                style: TextStyle(fontSize: 9.5, color: textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 5. Right Chart Card: Booking Share Analytics (`সর্বাধিক বুকিং শেয়ার`)
  Widget _buildBookingShareCard() {
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
          const Row(
            children: [
              Icon(Icons.pie_chart_outline_rounded, color: Color(0xFF0284C7), size: 18),
              SizedBox(width: 5),
              Text(
                'সর্বাধিক বুকিং শেয়ার',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textDark),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'ডাক্তার ঘর vs ফিজিক্যাল চেম্বার',
            style: TextStyle(fontSize: 9.5, color: textMuted),
          ),

          const SizedBox(height: 16),

          // Telemedicine (Doctor Ghar) 58% Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('📺 ডাক্তার ঘর (ভিডিও কল)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: textDark)),
                  Text('58%', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: Color(0xFF059669))),
                ],
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: const LinearProgressIndicator(
                  value: 0.58,
                  minHeight: 8,
                  backgroundColor: Color(0xFFF1F5F9),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Chamber Physical Serial 42% Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('🏢 চেম্বার সিরিয়াল (শারীরিক)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: textDark)),
                  Text('42%', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: Color(0xFF0284C7))),
                ],
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: const LinearProgressIndicator(
                  value: 0.42,
                  minHeight: 8,
                  backgroundColor: Color(0xFFF1F5F9),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0284C7)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Bottom Success Callout Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 15),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'গত ৩০ দিনে ৯৬% সফল কনসাল্টেশন সম্পন্ন হয়েছে!',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF047857)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 6. Recent Telemedicine Appointments Section (Responsive Data Table / Mobile Card Grid)
  Widget _buildRecentAppointmentsSection() {
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
                  'সাম্প্রতিক টেলিমেডিসিন অ্যাপয়েন্টমেন্ট তালিকা',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: textDark),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('সকল অ্যাপয়েন্টমেন্ট তালিকা দেখাচ্ছে'), behavior: SnackBarBehavior.floating),
                  );
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('সবগুলো', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: brandGreen)),
                    SizedBox(width: 2),
                    Icon(Icons.north_east_rounded, size: 12, color: brandGreen),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // LayoutBuilder to check screen width for Table vs Mobile Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isMobileScreen = constraints.maxWidth < 560;

              if (isMobileScreen) {
                // Mobile Clean Card View for Appointments
                return Column(
                  children: _recentAppointments.map((item) {
                    final String id = (item['id'] ?? '').toString();
                    final String patient = (item['patient'] ?? '').toString();
                    final String doctor = (item['doctor'] ?? '').toString();
                    final String fee = (item['fee'] ?? '').toString();
                    final String dateTime = (item['dateTime'] ?? '').toString();
                    final String status = (item['status'] ?? '').toString();
                    final Color statusColor = (item['statusColor'] as Color?) ?? const Color(0xFF059669);
                    final Color statusBg = (item['statusBg'] as Color?) ?? const Color(0xFFD1FAE5);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                id,
                                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: statusBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.person_outline_rounded, size: 14, color: textMuted),
                              const SizedBox(width: 4),
                              Text(
                                patient,
                                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: textDark),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded, size: 12, color: textMuted),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  doctor,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textDark),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dateTime,
                                style: const TextStyle(fontSize: 10, color: textMuted),
                              ),
                              Text(
                                fee,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textDark),
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
                      itemCount: _recentAppointments.length,
                      separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9), height: 10),
                      itemBuilder: (context, index) {
                        final item = _recentAppointments[index];
                        final String id = (item['id'] ?? '').toString();
                        final String patient = (item['patient'] ?? '').toString();
                        final String doctor = (item['doctor'] ?? '').toString();
                        final String fee = (item['fee'] ?? '').toString();
                        final String dateTime = (item['dateTime'] ?? '').toString();
                        final String status = (item['status'] ?? '').toString();
                        final Color statusColor = (item['statusColor'] as Color?) ?? const Color(0xFF059669);
                        final Color statusBg = (item['statusBg'] as Color?) ?? const Color(0xFFD1FAE5);

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
                                  dateTime,
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
                                      color: statusBg,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                        color: statusColor,
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
