import 'package:flutter/material.dart';
import 'admin_drawer.dart';
import '../../widgets/live_chat_widget.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/language_controller.dart';

class AdminPackagesAuditView extends StatefulWidget {
  final HomeController? homeController;
  final AuthController? authController;
  final LanguageController? languageController;

  const AdminPackagesAuditView({
    super.key,
    this.homeController,
    this.authController,
    this.languageController,
  });

  @override
  State<AdminPackagesAuditView> createState() => _AdminPackagesAuditViewState();
}

class _AdminPackagesAuditViewState extends State<AdminPackagesAuditView> {
  static const darkGreen = Color(0xFF005C45);
  static const brandGreen = Color(0xFF00A859);
  static const textDark = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _statCards = [
    {
      'title': 'মোট সক্রিয় প্যাকেজ টিয়ার',
      'value': '4 টি',
      'footnote': '৮৯৯ - ৯৯৯৯ টিয়ার',
      'footnoteColor': const Color(0xFF059669),
      'valueColor': textDark,
    },
    {
      'title': 'EPS গেটওয়ে মোট পেমেন্ট',
      'value': '৳ ৪,৫৮,৯০০',
      'footnote': 'bKash/Nagad/Card Verified',
      'footnoteColor': const Color(0xFF059669),
      'valueColor': const Color(0xFF059669),
    },
    {
      'title': 'HBP সংগৃহীত ফিল্ড ক্যাশ',
      'value': '৳ ১,২৪,৫০০',
      'footnote': 'লাইভ ক্যাশ ক্লিয়ারেন্স',
      'footnoteColor': const Color(0xFF2563EB),
      'valueColor': const Color(0xFF2563EB),
    },
    {
      'title': 'QR ডাইনামিক পয়েন্ট কাটা',
      'value': '৩,৪৫,০০০ Points',
      'footnote': 'হাসপাতাল ডিসকাউন্ট রিডিমড',
      'footnoteColor': const Color(0xFF9333EA),
      'valueColor': const Color(0xFF9333EA),
    },
  ];

  final List<Map<String, dynamic>> _packageList = [
    {
      'name': 'বেসিক হেলথ প্যাকেজ',
      'price': '৳ ৮৯৯',
      'points': '১,০০০ Points',
      'validity': '৩০ দিন',
      'rollover': 'মাসের শেষে এক্সপায়ারড',
      'status': 'সক্রিয়',
      'statusColor': const Color(0xFF059669),
      'statusBg': const Color(0xFFD1FAE5),
    },
    {
      'name': 'ফ্যামিলি সুস্বাস্থ্য প্যাকেজ',
      'price': '৳ ২,৪৯৯',
      'points': '৩,৫০০ Points',
      'validity': '৯০ দিন',
      'rollover': '১০০% পয়েন্ট রোলওভার',
      'status': 'সক্রিয়',
      'statusColor': const Color(0xFF059669),
      'statusBg': const Color(0xFFD1FAE5),
    },
    {
      'name': 'কর্পোরেট এক্সিকিউটিভ প্যাকেজ',
      'price': '৳ ৪,৯৯৯',
      'points': '৭,৫০০ Points',
      'validity': '১৮০ দিন',
      'rollover': '১০০% পয়েন্ট রোলওভার',
      'status': 'সক্রিয়',
      'statusColor': const Color(0xFF059669),
      'statusBg': const Color(0xFFD1FAE5),
    },
    {
      'name': 'মেডিসেবা প্রিমিয়াম প্লাস',
      'price': '৳ ৯,৯৯৯',
      'points': '১৫,০০০ Points',
      'validity': '৩৬৫ দিন',
      'rollover': 'আনলিমিটেড রোলওভার',
      'status': 'সক্রিয়',
      'statusColor': const Color(0xFF059669),
      'statusBg': const Color(0xFFD1FAE5),
    },
  ];

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPackages = _packageList.where((pkg) {
      final name = (pkg['name'] ?? '').toString().toLowerCase();
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildTopAppBar(context),
      drawer: const AdminDrawer(selectedIndex: 2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Banner (Dark Emerald Gradient)
              _buildHeroBanner(),

              const SizedBox(height: 14),

              // 2. Stat Cards Grid (4 Cards)
              _buildStatCardsGrid(),

              const SizedBox(height: 14),

              // 3. Package Configuration Table Card
              _buildPackageTableCard(filteredPackages),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: const LiveChatFabWidget(),
    );
  }

  /// Top App Bar matching web visual header
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
          const Icon(Icons.show_chart_rounded, color: brandGreen, size: 20),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'প্যাকেজ ও ফাইন্যান্সিয়াল অডিট',
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 15,
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

  /// 1. Hero Banner (Dark Emerald Gradient)
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
                child: const Text(
                  'ADMIN CENTRAL CONTROL',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                ),
              ),

              // Action Button Right (🔄 রিফ্রেশ ডাটা)
              InkWell(
                onTap: () {
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('অডিট ডাটা রিফ্রেশ করা হয়েছে'), behavior: SnackBarBehavior.floating),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: brandGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sync_rounded, color: Colors.white, size: 13),
                      SizedBox(width: 4),
                      Text(
                        'রিফ্রেশ ডাটা',
                        style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'প্রিমিয়াম প্যাকেজ ও ফাইনান্সিয়াল অডিট প্যানেল',
            style: TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'প্যাকেজ সেলস, EPS গেটওয়ে স্টেটমেন্ট, HBP পারফরম্যান্স ও ডাইনামিক QR ডিসকাউন্ট অডিট হাব',
            style: TextStyle(
              fontSize: 11.5,
              color: Colors.white70,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Stat Cards Grid (4 Cards)
  Widget _buildStatCardsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final int crossAxisCount = width > 640 ? 4 : (width < 340 ? 1 : 2);
        final double childAspectRatio = width > 640 ? 1.55 : (width < 340 ? 2.8 : 1.35);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: _statCards.length,
          itemBuilder: (context, index) {
            final stat = _statCards[index];
            final String title = (stat['title'] ?? '').toString();
            final String value = (stat['value'] ?? '').toString();
            final String footnote = (stat['footnote'] ?? '').toString();
            final Color footnoteColor = (stat['footnoteColor'] as Color?) ?? textMuted;
            final Color valueColor = (stat['valueColor'] as Color?) ?? textDark;

            return Container(
              padding: const EdgeInsets.all(12),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: valueColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    footnote,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                      color: footnoteColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// 3. Package Configuration Table Card
  Widget _buildPackageTableCard(List<Map<String, dynamic>> packages) {
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
          // Header Row with Title & Search Input
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inventory_2_outlined, color: brandGreen, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'প্যাকেজ কনফিগারেশন তালিকা',
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: textDark),
                  ),
                ],
              ),

              // Search Box
              SizedBox(
                width: 180,
                height: 36,
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  style: const TextStyle(fontSize: 11.5),
                  decoration: InputDecoration(
                    hintText: 'প্যাকেজ খুঁজুন...',
                    hintStyle: const TextStyle(fontSize: 11, color: textMuted),
                    prefixIcon: const Icon(Icons.search_rounded, size: 16, color: textMuted),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
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

          const SizedBox(height: 14),

          // Responsive View (Mobile Cards vs Desktop Table)
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isMobile = constraints.maxWidth < 620;

              if (isMobile) {
                return Column(
                  children: packages.map((item) {
                    final String name = (item['name'] ?? '').toString();
                    final String price = (item['price'] ?? '').toString();
                    final String points = (item['points'] ?? '').toString();
                    final String validity = (item['validity'] ?? '').toString();
                    final String rollover = (item['rollover'] ?? '').toString();
                    final String status = (item['status'] ?? '').toString();
                    final Color statusColor = (item['statusColor'] as Color?) ?? brandGreen;
                    final Color statusBg = (item['statusBg'] as Color?) ?? const Color(0xFFD1FAE5);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
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
                              Expanded(
                                child: Text(
                                  name,
                                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: textDark),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: statusBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: statusColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('মূল্য: $price', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: darkGreen)),
                              Text('ক্রেডিট: $points', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('মেয়াদ: $validity', style: const TextStyle(fontSize: 10, color: textMuted)),
                              Text('পলিসি: $rollover', style: const TextStyle(fontSize: 10, color: textMuted)),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              } else {
                // Table View
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
                          Expanded(flex: 3, child: Text('প্যাকেজ নাম', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textMuted))),
                          Expanded(flex: 2, child: Text('মূল্য (টাকা)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textMuted))),
                          Expanded(flex: 2, child: Text('ক্রেডিট পয়েন্ট', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textMuted))),
                          Expanded(flex: 2, child: Text('মেয়াদ (দিন)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textMuted))),
                          Expanded(flex: 3, child: Text('পয়েন্ট রোলওভার পলিসি', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textMuted))),
                          Expanded(flex: 2, child: Text('স্ট্যাটাস', textAlign: TextAlign.right, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textMuted))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: packages.length,
                      separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9), height: 10),
                      itemBuilder: (context, index) {
                        final item = packages[index];
                        final String name = (item['name'] ?? '').toString();
                        final String price = (item['price'] ?? '').toString();
                        final String points = (item['points'] ?? '').toString();
                        final String validity = (item['validity'] ?? '').toString();
                        final String rollover = (item['rollover'] ?? '').toString();
                        final String status = (item['status'] ?? '').toString();
                        final Color statusColor = (item['statusColor'] as Color?) ?? brandGreen;
                        final Color statusBg = (item['statusBg'] as Color?) ?? const Color(0xFFD1FAE5);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  name,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textDark),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  price,
                                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: darkGreen),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  points,
                                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  validity,
                                  style: const TextStyle(fontSize: 10, color: textMuted),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  rollover,
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
