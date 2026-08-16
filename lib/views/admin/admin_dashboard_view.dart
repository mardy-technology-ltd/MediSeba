import 'package:flutter/material.dart';
import 'admin_inbox_view.dart';
import 'admin_job_circulars_view.dart';
import 'admin_doctors_management_view.dart';
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
  static const brandGreen = Color(0xFF0F9D58);
  static const darkGreen = Color(0xFF006B4A);
  static const textDark = Color(0xFF0F172A);

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
      'value': '48 জন',
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
    {'month': 'মার্চ', 'amount': '৳ 18.0k', 'heightRatio': 0.42},
    {'month': 'এপ্রিল', 'amount': '৳ 24.0k', 'heightRatio': 0.57},
    {'month': 'মে', 'amount': '৳ 31.0k', 'heightRatio': 0.74},
    {'month': 'জুন', 'amount': '৳ 28.0k', 'heightRatio': 0.66},
    {'month': 'জুলাই', 'amount': '৳ 36.0k', 'heightRatio': 0.85},
    {'month': 'আগস্ট (চলতি)', 'amount': '৳ 42.0k', 'heightRatio': 1.00},
  ];

  final List<Map<String, dynamic>> _recentAppointments = [
    {
      'id': 'APT-20260804-884920',
      'patient': 'Mohammad Ali',
      'doctor': 'Dr. Tanvir Hasan',
      'fee': '৳ ১,২০০',
      'dateTime': 'আজ, ১০:৩০ AM',
      'status': 'কনফার্মড',
      'statusColor': const Color(0xFF10B981),
      'statusBg': const Color(0xFFECFDF5),
    },
    {
      'id': 'APT-20260804-492810',
      'patient': 'Tania Rahman',
      'doctor': 'Dr. Ahmed Rahman',
      'fee': '৳ ১,০০০',
      'dateTime': 'আজ, ১১:০০ AM',
      'status': 'সম্পন্ন',
      'statusColor': const Color(0xFF2563EB),
      'statusBg': const Color(0xFFEFF6FF),
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
          children: [
            const Text(
              'ড্যাশবোর্ড (Overview)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: brandGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
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
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF64748B), size: 22),
            onPressed: () {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('অ্যাডমিন ডাটা ক্যাশ রিফ্রেশ করা হয়েছে'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'ক্যাশ রিফ্রেশ',
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF64748B), size: 24),
                onPressed: () {},
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
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
              // 1. Hero Gradient Banner
              _buildHeroBanner(),

              const SizedBox(height: 18),

              // 2. KPI Stats 2x2 Grid Cards
              _buildKPIStatsGrid(),

              const SizedBox(height: 18),

              // 3. Dynamic Revenue Growth Graph Card
              _buildRevenueGraphCard(),

              const SizedBox(height: 18),

              // 4. Service Share Card
              _buildServiceShareCard(),

              const SizedBox(height: 18),

              // 5. Recent Telemedicine Appointments Section
              _buildRecentAppointmentsSection(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: brandGreen,
        child: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('লাইভ সাপোর্ট চ্যাট ওপেন হয়েছে')),
          );
        },
      ),
    );
  }

  /// Build Hero Gradient Banner
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [darkGreen, Color(0xFF008536), Color(0xFF05583D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.3),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Pill Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.analytics_rounded, color: Colors.white, size: 14),
                SizedBox(width: 6),
                Text(
                  'মেডিসেব অল-ইন-ওয়ান অ্যাডমিন এনালিটিক্স',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Heading
          const Text(
            'ড্যাশবোর্ড ওভারভিউ & লাইভ চার্ট অ্যানালিটিক্স',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),

          // Subtitle
          Text(
            'Stripe & Vercel স্টাইল গ্রোয়িং গ্রাফ চার্ট, রিয়েল-টাইম রেভিনিউ ট্র্যাকিং এবং বুকিং অ্যানালিটিক্স।',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: darkGreen,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  setState(() {});
                },
                icon: const Icon(Icons.refresh_rounded, size: 16, color: darkGreen),
                label: const Text('রিফ্রেশ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.6), width: 1.2),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('নতুন ডাক্তার অ্যাকাউন্ট তৈরির ফরম খুলবে')),
                  );
                },
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 16, color: Colors.white),
                label: const Text('নতুন ডাক্তার অ্যাকাউন্ট', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build KPI Stats 2x2 Grid Cards (Fully Responsive)
  Widget _buildKPIStatsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemCount: _kpiStats.length,
      itemBuilder: (context, index) {
        final stat = _kpiStats[index];
        return Container(
          padding: const EdgeInsets.all(12),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: stat['bg'] as Color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      stat['icon'] as IconData,
                      color: stat['color'] as Color,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  stat['title'] as String,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  stat['value'] as String,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build Revenue Growth Bar Graph Card (Responsive)
  Widget _buildRevenueGraphCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bar_chart_rounded, color: brandGreen, size: 20),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'রেভিনিউ প্রবৃদ্ধি (Revenue Graph)',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'রিয়েল-টাইম আয় ট্র্যাকিং',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Duration Filter Pills (Horizontal Scrollable for small screens)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['গত ৭ দিন', 'গত ৩০ দিন', 'গত ৬ মাস'].map((filter) {
                final isSelected = _selectedGraphFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedGraphFilter = filter;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFF1F5F9) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? const Color(0xFFCBD5E1) : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                          color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // Custom Vertical Bar Chart (Fitted & Responsive)
          SizedBox(
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _monthlyRevenueData.map((data) {
                final heightRatio = data['heightRatio'] as double;
                final barHeight = 100.0 * heightRatio;
                final isCurrent = data['month'].toString().contains('আগস্ট');

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        data['amount'] as String,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? brandGreen : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 20,
                      height: barHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isCurrent
                              ? [brandGreen, const Color(0xFF10B981)]
                              : [const Color(0xFF0D9488), const Color(0xFF14B8A6)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        data['month'] as String,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          color: const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 14),
          const Divider(color: Color(0xFFF1F5F9)),
          const SizedBox(height: 6),

          // Footer Stat
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.trending_up_rounded, color: brandGreen, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'কমিশন প্রাপ্ত হার: +১৭.৪%',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF15803D)),
                  ),
                ],
              ),
              const Text(
                'সর্বশেষ আপডেট: আজ',
                style: TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build Service Share Card
  Widget _buildServiceShareCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
              Icon(Icons.pie_chart_outline_rounded, color: Color(0xFF2563EB), size: 20),
              SizedBox(width: 8),
              Text(
                'সেভিত্তিক বুকিং শেয়ার',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'ডাক্তার ঘর (ভিডিও কল) vs চেম্বার সিরিয়াল',
            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 16),

          // Progress Bar 1: Doctor Ghar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '🩺 ডাক্তার ঘর (ভিডিও কল)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                  ),
                  Text(
                    '58%',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: brandGreen),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: const LinearProgressIndicator(
                  value: 0.58,
                  minHeight: 8,
                  backgroundColor: Color(0xFFF1F5F9),
                  valueColor: AlwaysStoppedAnimation<Color>(brandGreen),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Progress Bar 2: Chamber Serial
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '🏥 চেম্বার সিরিয়াল (শারীরিক)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                  ),
                  Text(
                    '42%',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF0D9488)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: const LinearProgressIndicator(
                  value: 0.42,
                  minHeight: 8,
                  backgroundColor: Color(0xFFF1F5F9),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Success Message Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: Row(
              children: const [
                Icon(Icons.check_circle_outline_rounded, color: Color(0xFF059669), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'গত ৩০ দিনে ৯৪% সফল কনসালটেশন সম্পন্ন হয়েছে!',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF047857)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build Recent Telemedicine Appointments Section
  Widget _buildRecentAppointmentsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'সাম্প্রতিক অ্যাপয়েন্টমেন্ট তালিকা',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('সকল অ্যাপয়েন্টমেন্ট তালিকা দেখাচ্ছে')),
                  );
                },
                child: Row(
                  children: const [
                    Text('সবগুলো', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: brandGreen)),
                    SizedBox(width: 2),
                    Icon(Icons.north_east_rounded, size: 14, color: brandGreen),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentAppointments.length,
            separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9), height: 16),
            itemBuilder: (context, index) {
              final item = _recentAppointments[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['id'] as String,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: item['statusBg'] as Color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item['status'] as String,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: item['statusColor'] as Color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['patient'] as String,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                          ),
                          Text(
                            item['doctor'] as String,
                            style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item['fee'] as String,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                          ),
                          Text(
                            item['dateTime'] as String,
                            style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build Navigation Drawer for Mobile
  Widget _buildAdminDrawer(BuildContext context) {
    final menuItems = [
      {'title': 'ড্যাশবোর্ড (Overview)', 'icon': Icons.dashboard_rounded, 'selected': true},
      {'title': 'ইনবক্স ও অ্যাপ্লিকেশন', 'icon': Icons.mail_outline_rounded, 'selected': false},
      {'title': 'চাকরি ও নিয়োগ সার্কুলার', 'icon': Icons.work_outline_rounded, 'selected': false},
      {'title': 'ডাক্তার ম্যানেজমেন্ট', 'icon': Icons.medical_services_outlined, 'selected': false},
      {'title': 'রোগীর রেকর্ডস', 'icon': Icons.people_outline_rounded, 'selected': false},
      {'title': 'সিরিয়াল ও অ্যাপয়েন্টমেন্ট', 'icon': Icons.calendar_month_outlined, 'selected': false},
      {'title': 'মেডিসিন ইনভেন্টরি', 'icon': Icons.medication_outlined, 'selected': false},
      {'title': 'ডিজিটাল প্রেসক্রিপশন', 'icon': Icons.description_outlined, 'selected': false},
      {'title': 'সিস্টেম সেটিং ও কন্ট্রোল', 'icon': Icons.settings_outlined, 'selected': false},
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header
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
                        if (index == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminInboxView(),
                            ),
                          );
                        } else if (index == 2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminJobCircularsView(),
                            ),
                          );
                        } else if (index == 3) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminDoctorsManagementView(),
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

          // Admin User Profile Footer
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
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
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
                      Navigator.pop(context); // Exit admin panel back to login/home
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


