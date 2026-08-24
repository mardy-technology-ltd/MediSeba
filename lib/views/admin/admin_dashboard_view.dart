import 'package:flutter/material.dart';
import 'admin_drawer.dart';
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

  String _selectedGraphFilter = 'গত ৩ মাস';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> _kpiStats = [
    {
      'title': 'সক্রিয় ডাক্তার',
      'value': '12',
      'icon': Icons.medical_services_outlined,
      'color': const Color(0xFF10B981),
      'bg': const Color(0xFFECFDF5),
    },
    {
      'title': 'নিবন্ধিত রোগী',
      'value': '48',
      'icon': Icons.people_outline_rounded,
      'color': const Color(0xFF3B82F6),
      'bg': const Color(0xFFEFF6FF),
    },
    {
      'title': 'মোট অ্যাপয়েন্টমেন্ট',
      'value': '84',
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
    {'month': 'মার্চ', 'amount': '৳ 18.0k', 'heightRatio': 0.40},
    {'month': 'এপ্রিল', 'amount': '৳ 24.6k', 'heightRatio': 0.55},
    {'month': 'মে', 'amount': '৳ 31.0k', 'heightRatio': 0.70},
    {'month': 'জুন', 'amount': '৳ 28.8k', 'heightRatio': 0.65},
    {'month': 'জুলাই', 'amount': '৳ 35.0k', 'heightRatio': 0.80},
    {'month': 'আগস্ট (চলতি)', 'amount': '৳ 45.0k', 'heightRatio': 1.00},
  ];

  final List<Map<String, dynamic>> _recentAppointments = [
    {
      'id': 'APT-20268004-884920',
      'patient': 'Mohammad Ali',
      'dateTime': 'আজ, ১০:০০ AM',
      'status': 'সম্পন্ন',
      'statusColor': const Color(0xFF15803D),
      'statusBg': const Color(0xFFDCFCE7),
    },
    {
      'id': 'APT-20268604-493E10',
      'patient': 'Tania Rahman',
      'dateTime': 'আজ, ০১:০০ PM',
      'status': 'অপেক্ষমান',
      'statusColor': const Color(0xFF0369A1),
      'statusBg': const Color(0xFFE0F2FE),
    },
    {
      'id': 'APT-20268804-104938',
      'patient': 'Kabir Hossain',
      'dateTime': 'আজ, ০২:৩৩ PM',
      'status': 'প্রসেসিং',
      'statusColor': const Color(0xFFB45309),
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
        elevation: 0.5,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Color(0xFF334155), size: 26),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 32,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.favorite_rounded, color: Color(0xFFED1B24), size: 20),
                    SizedBox(width: 4),
                    Text(
                      'মেডি সেবা',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: darkGreen),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFECFDF5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_none_rounded, color: Color(0xFF059669), size: 22),
                ),
                Positioned(
                  top: 2,
                  right: 2,
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
          ),
        ],
      ),
      drawer: const AdminDrawer(selectedIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Gradient Banner Card
              _buildHeroBanner(),

              const SizedBox(height: 14),

              // 2. Secondary Flagship Banner Card
              _buildFlagshipSalesBanner(),

              const SizedBox(height: 16),

              // 3. KPI Stats 2x2 Grid Cards
              _buildKPIStatsGrid(),

              const SizedBox(height: 16),

              // 4. Dynamic Revenue Growth Graph Card
              _buildRevenueGraphCard(),

              const SizedBox(height: 16),

              // 5. Recent Telemedicine Appointments Table
              _buildRecentAppointmentsSection(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('লাইভ সাপোর্ট চ্যাট ওপেন হয়েছে')),
          );
        },
      ),
    );
  }

  /// Build Hero Banner (Teal Dark Green Card) - Fully Responsive
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: darkGreen, // Color(0xFF005C45)
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.25),
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
            spacing: 8,
            runSpacing: 8,
            children: [
              // Pill Chip Left
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.analytics_outlined, color: Colors.white, size: 13),
                    SizedBox(width: 5),
                    Text(
                      'প্রিমিয়াম সার্ভিস ও আপডেট',
                      style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),

              // Action Button Right (+ নতুন সত্তার অ্যাকাউন্ট তৈরি করুন)
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('নতুন সত্তার অ্যাকাউন্ট তৈরির সুবিধা')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.person_add_alt_outlined, color: darkGreen, size: 13),
                      SizedBox(width: 4),
                      Text(
                        'নতুন সত্তার অ্যাকাউন্ট তৈরি করুন',
                        style: TextStyle(color: darkGreen, fontSize: 10.5, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Flexible(
                child: Text(
                  'ড্যাশবোর্ড ওভারভিউ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.sync_rounded, color: Colors.white, size: 20),
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

  /// Build Flagship Sales Hierarchy Banner (Deep Navy Card) - Fully Responsive
  Widget _buildFlagshipSalesBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B4B), // Deep Navy / Slate Blue
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '⚡ ফ্ল্যাগশিপ সেবা পেশেন্ট টিম (HSP & S...)',
              style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'সেলস টিম হায়ারার্কি ও পারফরম্যান্স',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'stripe knill (gee new / ২৬৬... আসামী তামাম, ডাক্তার/রিসেলার ১০০ জন টিমস ও প্রিজার্ভ স্বাক্লি অ্যাসাইনমেন্ট তৈরি করুন)',
            style: TextStyle(
              fontSize: 10.5,
              color: Colors.white.withValues(alpha: 0.75),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1), // Purple Accent
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('নতুন অ্যাকাউন্ট তৈরি ও আমন্ত্রণ লিংক খুলছে')),
              );
            },
            icon: const Icon(Icons.person_add_rounded, size: 14),
            label: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    'নতুন একাউন্ট তৈরি ও আমন্ত্রণ করুন',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
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

  /// Build KPI Stats 2x2 Grid Cards - Fully Responsive
  Widget _buildKPIStatsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.25,
      ),
      itemCount: _kpiStats.length,
      itemBuilder: (context, index) {
        final stat = _kpiStats[index];
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
                  color: stat['bg'] as Color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  stat['icon'] as IconData,
                  color: stat['color'] as Color,
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
                      stat['title'] as String,
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
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build Revenue Growth Graph Card - Fully Responsive
  Widget _buildRevenueGraphCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          // Header Row with Expanded Title Column
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.bar_chart_rounded, color: Color(0xFF10B981), size: 18),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'রেভিনিউ প্রবৃদ্ধি',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'সমগ্র সময় পরিক্রমা হতে রিয়েল টাইম অটো তথ্য',
                      style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Filter Chips on right
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['গত ৭ দিন', 'গত ৩০ দিন', 'গত ৩ মাস'].map((filter) {
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
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFDCFCE7) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                              color: isSelected ? const Color(0xFF15803D) : const Color(0xFF64748B),
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

          const SizedBox(height: 18),

          // Custom Vertical Bar Chart
          SizedBox(
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _monthlyRevenueData.map((data) {
                final heightRatio = data['heightRatio'] as double;
                final barHeight = 85.0 * heightRatio;
                final isCurrent = data['month'].toString().contains('আগস্ট');

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        data['amount'] as String,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? const Color(0xFF059669) : const Color(0xFF64748B),
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
                              ? [const Color(0xFF10B981), const Color(0xFF059669)]
                              : [const Color(0xFF14B8A6), const Color(0xFF0D9488)],
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
                        data['month'] as String,
                        style: TextStyle(
                          fontSize: 9,
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

          const SizedBox(height: 12),
          const Divider(color: Color(0xFFF1F5F9)),
          const SizedBox(height: 4),

          // Footer Stat - Wrap layout to prevent right overflow
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: const [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded, color: Color(0xFF10B981), size: 14),
                  SizedBox(width: 4),
                  Text(
                    'রেভিনিউ প্রবৃদ্ধি গ্রোথ হার: +২৫.৪%',
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF15803D)),
                  ),
                ],
              ),
              Text(
                'সর্বশেষ আপডেট: আজ',
                style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build Recent Telemedicine Appointments Table - Fully Responsive
  Widget _buildRecentAppointmentsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('সকল অ্যাপয়েন্টমেন্ট তালিকা দেখাচ্ছে')),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('সবগুলো', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF10B981))),
                    SizedBox(width: 2),
                    Icon(Icons.north_east_rounded, size: 12, color: Color(0xFF10B981)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Table Headers Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Expanded(flex: 3, child: Text('আইডি', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)), overflow: TextOverflow.ellipsis)),
                Expanded(flex: 3, child: Text('রোগীর নাম', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)), overflow: TextOverflow.ellipsis)),
                Expanded(flex: 3, child: Text('তারিখ & সময়', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)), overflow: TextOverflow.ellipsis)),
                Expanded(flex: 2, child: Text('স্ট্যাটাস', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)), overflow: TextOverflow.ellipsis)),
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        item['id'] as String,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        item['patient'] as String,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        item['dateTime'] as String,
                        style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: item['statusBg'] as Color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item['status'] as String,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                              color: item['statusColor'] as Color,
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
      ),
    );
  }
}
