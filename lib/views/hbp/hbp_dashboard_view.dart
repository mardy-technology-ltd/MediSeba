import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/language_controller.dart';
import '../../services/api_service.dart';
import '../../services/cache_service.dart';
import 'widgets/hbp_drawer.dart';
import 'widgets/hbp_register_customer_dialog.dart';

class HbpDashboardView extends StatefulWidget {
  final HomeController homeController;
  final AuthController authController;
  final LanguageController? languageController;

  const HbpDashboardView({
    super.key,
    required this.homeController,
    required this.authController,
    this.languageController,
  });

  @override
  State<HbpDashboardView> createState() => _HbpDashboardViewState();
}

class _HbpDashboardViewState extends State<HbpDashboardView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedFilter = 'সকল';
  int _currentDrawerIndex = 0;

  // Agent Referral Constants
  final String _referralCode = 'MSB-1101';
  final String _referralPhone = '01710000010';

  // Target and Progress state
  int _monthlyTarget = 214;
  int _totalSold = 1;
  int _todaySold = 1;
  int _collectedAmount = 350;

  // Registered customer list
  late List<Map<String, dynamic>> _customers;

  @override
  void initState() {
    super.initState();
    _customers = [];
    _fetchApiMetrics();
  }

  void _fetchApiMetrics() async {
    final String? token = widget.authController.token ?? CacheService.get('auth_token')?.toString();
    if (token != null && token.isNotEmpty) {
      final data = await ApiService.fetchHbpMetrics(token);
      if (data != null && mounted) {
        setState(() {
          final stats = data['stats'] as Map<String, dynamic>?;
          final targets = data['targets'] as Map<String, dynamic>?;

          if (stats != null) {
            _totalSold = stats['monthly_total'] ?? stats['total_packages_sold'] ?? _totalSold;
            _todaySold = stats['today_sales'] ?? _todaySold;
            if (stats['total_sales_amount'] != null) {
              _collectedAmount = stats['total_sales_amount'] as int;
            }
          } else {
            _totalSold = data['total_packages_sold'] ?? _totalSold;
            _collectedAmount = data['total_sales_amount'] ?? _collectedAmount;
          }

          if (targets != null) {
            _monthlyTarget = targets['min_threshold_33_percent'] ?? targets['monthly_target'] ?? _monthlyTarget;
          }

          final rawHistory = data['sales_history'] ?? data['recent_sales'] ?? data['customers'];
          if (rawHistory is List && rawHistory.isNotEmpty) {
            final apiHistory = rawHistory.map((item) {
              final map = Map<String, dynamic>.from(item as Map);
              return {
                'id': map['id']?.toString() ?? map['uuid']?.toString() ?? 'REG-000',
                'name': map['customer_name'] ?? map['name'] ?? map['user']?['name'] ?? 'গ্রাহক',
                'phone': map['customer_phone'] ?? map['phone'] ?? map['user']?['phone'] ?? '',
                'package': map['package_name'] ?? map['package']?['name'] ?? 'প্যাকেজ',
                'price': map['purchased_price'] ?? map['price'] ?? 99,
                'paymentMethod': map['payment_method'] == 'cash'
                    ? 'ক্যাশ কালেকশন'
                    : (map['payment_method'] == 'qr' ? 'বিকাশ QR' : 'ডিজিটাল গেটওয়ে'),
                'status': map['status'] ?? 'সক্রিয় (Verified)',
                'date': map['created_at'] != null ? map['created_at'].toString().split('T')[0] : (map['date'] ?? ''),
                'address': map['address'] ?? 'মাঠ পর্যায়',
              };
            }).toList();

            _customers = List<Map<String, dynamic>>.from(apiHistory);
          }

          // Dynamically sum collected amount from customers list if API total_sales_amount is null
          if (stats?['total_sales_amount'] == null && data['total_sales_amount'] == null) {
            _collectedAmount = _customers.fold<int>(
              0,
              (sum, item) => sum + ((item['price'] as num?)?.toInt() ?? 0),
            );
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _copyReferralCode() {
    Clipboard.setData(ClipboardData(text: _referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'রেফারেল কোড "$_referralCode" ক্লিপবোর্ডে কপি করা হয়েছে!',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F9D58),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openRegisterCustomerModal() {
    showDialog(
      context: context,
      builder: (context) => HbpRegisterCustomerDialog(
        onCustomerAdded: (newCustomer) {
          setState(() {
            _customers.insert(0, newCustomer);
            _totalSold += 1;
            _todaySold += 1;
            _collectedAmount += (newCustomer['price'] as int? ?? 0);
          });
        },
      ),
    );
  }

  void _showWalletDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
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
                      Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF0F9D58), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'এইচবিপি ওয়ালেট ও কমিশন',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF005A36), Color(0xFF0F9D58)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F9D58).withValues(alpha: 0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'বর্তমান উপলব্ধ কমিশন ব্যালেন্স',
                      style: TextStyle(fontSize: 12.5, color: Color(0xFFE2E8F0)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '৳ ${(_collectedAmount * 0.20).toInt()}',
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'মোট সেলস কালেকশন: ৳ $_collectedAmount',
                            style: const TextStyle(fontSize: 11.5, color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'উইথড্র রিকোয়েস্ট সফলভাবে সাবমিট হয়েছে। অ্যাডমিন পর্যালোচনা করছেন।',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: Color(0xFF0F9D58),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  icon: const Icon(Icons.send_to_mobile_rounded, size: 18),
                  label: const Text('কমিশন ক্যাশ-আউট করুন (bKash/Nagad)', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F9D58),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double percentAchieved = (_totalSold / _monthlyTarget).clamp(0.0, 1.0);
    final int remainingToTarget = (_monthlyTarget - _totalSold).clamp(0, _monthlyTarget);

    final filteredCustomers = _customers.where((cust) {
      final name = cust['name'].toString().toLowerCase();
      final phone = cust['phone'].toString().toLowerCase();
      final pkg = cust['package'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();

      final matchesQuery = name.contains(query) || phone.contains(query) || pkg.contains(query);
      if (!matchesQuery) return false;

      if (_selectedFilter == 'সকল') return true;
      if (_selectedFilter == 'ক্যাশ' && cust['paymentMethod'].toString().contains('ক্যাশ')) return true;
      if (_selectedFilter == 'ডিজিটাল' && !cust['paymentMethod'].toString().contains('ক্যাশ')) return true;
      return true;
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF1F5F9),
      drawer: HbpDrawer(
        authController: widget.authController,
        homeController: widget.homeController,
        languageController: widget.languageController,
        selectedIndex: _currentDrawerIndex,
        onItemSelected: (index) {
          setState(() => _currentDrawerIndex = index);
          if (index == 2) _showWalletDialog();
        },
        onRegisterCustomerTap: _openRegisterCustomerModal,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Color(0xFF0F172A), size: 24),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 26,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Text(
                  'মেডিসেবা',
                  style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF00A859), fontSize: 16),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A859).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF00A859).withValues(alpha: 0.3)),
                ),
                child: const Text(
                  'HBP',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF00A859),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: const EdgeInsets.all(6),
            icon: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF0F9D58), size: 22),
            tooltip: 'ওয়ালেট ও আর্নিং',
            onPressed: _showWalletDialog,
          ),
          // Agent Profile Chip
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: Container(
              margin: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF005A36),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Color(0xFF00A859),
                    child: Text(
                      'S',
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Sojib',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openRegisterCustomerModal,
        backgroundColor: const Color(0xFF0F9D58),
        icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
        label: const Text(
          'নতুন কাস্টমার',
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 13.5),
        ),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Hero Header Card (Dark Pine Green)
            _buildHeroHeaderCard(),

            const SizedBox(height: 16),

            // 2. Monthly Salary & Promotion Tracker Card
            _buildSalaryTrackerCard(percentAchieved, remainingToTarget),

            const SizedBox(height: 16),

            // 3. 4 KPI Statistics Cards Grid
            _buildKPIStatsGrid(remainingToTarget),

            const SizedBox(height: 20),

            // 4. Registered Customer & Package List Section
            _buildCustomerListSection(filteredCustomers),

            const SizedBox(height: 70), // Spacing for floating action button
          ],
        ),
      ),
    );
  }

  // 1. Hero Header Card matching Web UI
  Widget _buildHeroHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF003822), Color(0xFF005A36)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003822).withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield_outlined, color: Color(0xFF4ADE80), size: 14),
                SizedBox(width: 6),
                Text(
                  'HBP FIELD AGENT PORTAL',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4ADE80),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Heading
          const Text(
            'এইচবিপি ফিল্ড এজেন্ট রেজিস্ট্রেশন পোর্টাল',
            style: TextStyle(
              fontSize: 18.5,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle
          const Text(
            'মাঠ পর্যায়ে কাস্টমার অ্যাকাউন্ট তৈরি ও প্রিমিয়াম হেলথ প্যাকেজ বিক্রয় হাব',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFCBD5E1),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Referral Code Container & Action Button
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'আপনার ইউনিক রেফারেল কোড:',
                        style: TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: _copyReferralCode,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAB308),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.copy_rounded, color: Color(0xFF0F172A), size: 13),
                            SizedBox(width: 4),
                            Text(
                              'কোড কপি',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      Text(
                        _referralCode,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFBBF24),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(বা ফোন: $_referralPhone)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE2E8F0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Primary Action: + নতুন কাস্টমার অ্যাকাউন্ট
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openRegisterCustomerModal,
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: const Text(
                '+ নতুন কাস্টমার অ্যাকাউন্ট',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF005A36),
                elevation: 3,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Salary & Promotion Tracker Card matching Web UI
  Widget _buildSalaryTrackerCard(double percentAchieved, int remainingToTarget) {
    final int percentInt = (percentAchieved * 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.trending_up_rounded, color: Color(0xFF0F9D58), size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ফিল্ড সেলস ও স্যালারি যোগ্যতা ট্র্যাকার',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      '(Monthly Salary & Promotion Tracker)',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Target Calculation Formula Tag
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: const Text(
              'মাসিক ফিল্ড কাস্টমার কভারেজ: ২৬ দিন × ২৫ জন = ~৬৫০ জন | ৩৩% প্যাকেজ সেলস টার্গেট: ২১৪টি প্যাকেজ / মাস',
              style: TextStyle(fontSize: 10.5, color: Color(0xFF475569), height: 1.3),
            ),
          ),
          const SizedBox(height: 12),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline_rounded, color: Color(0xFFD97706), size: 14),
                const SizedBox(width: 6),
                Text(
                  'স্যালারি পে-আউট: $percentInt% (পার্সেন্টেজ স্কেল)',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFFB45309)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Progress Bar Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'মাসিক প্যাকেজ বিক্রয়: $_totalSoldটি / $_monthlyTargetটি (৩৩% বেঞ্চমার্ক)',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$percentInt% অর্জন',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF0F9D58)),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Linear Progress Indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentAchieved,
              minHeight: 10,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0F9D58)),
            ),
          ),
          const SizedBox(height: 12),

          // Footnote Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  '💡 ৩৩% (২১৪টি) সেলস পার হলে প্রমোশন ও বোনাস পাবেন।',
                  style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'বাকি: $remainingToTargetটি সেলস',
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF2563EB)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. 4 KPI Statistics Cards (2-Column Responsive Grid)
  Widget _buildKPIStatsGrid(int remainingToTarget) {
    final kpis = [
      {
        'title': 'আজকের প্যাকেজ সেলস (Daily)',
        'value': '$_todaySold টি',
        'subtitle': 'আজকের সংগৃহীত পেমেন্ট',
        'icon': Icons.flash_on_rounded,
        'color': const Color(0xFF0F9D58),
        'bg': const Color(0xFFE8F5E9),
      },
      {
        'title': 'মাসিক মোট প্যাকেজ সেলস',
        'value': '$_totalSold / $_monthlyTargetটি',
        'subtitle': 'মাসিক টার্গেট কাউন্টার',
        'icon': Icons.inventory_2_outlined,
        'color': const Color(0xFF2563EB),
        'bg': const Color(0xFFEFF6FF),
      },
      {
        'title': 'সংগৃহীত ক্যাশ ও ডিজিটাল পেমেন্ট',
        'value': '৳ $_collectedAmount',
        'subtitle': 'ক্যাশ + QR স্ক্যান + EPS',
        'icon': Icons.payments_outlined,
        'color': const Color(0xFF7C3AED),
        'bg': const Color(0xFFF5F3FF),
      },
      {
        'title': 'প্রমোশন পেতে সেলস বাকি',
        'value': '$remainingToTarget টি',
        'subtitle': '৩৩% বেঞ্চমার্ক অর্জন বাকি',
        'icon': Icons.military_tech_outlined,
        'color': const Color(0xFFEA580C),
        'bg': const Color(0xFFFFF7ED),
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final int crossAxisCount = width > 600 ? 4 : 2;
        final double childAspectRatio = width > 600 ? 1.3 : (width < 340 ? 1.05 : 1.18);

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
            final kpi = kpis[index];
            final String title = kpi['title'] as String;
            final String value = kpi['value'] as String;
            final String subtitle = kpi['subtitle'] as String;
            final IconData icon = kpi['icon'] as IconData;
            final Color color = kpi['color'] as Color;
            final Color bg = kpi['bg'] as Color;

            return Container(
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
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: bg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 18),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 11,
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
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF94A3B8),
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

  // 4. Registered Customer & Package List Section matching Web UI
  Widget _buildCustomerListSection(List<Map<String, dynamic>> customers) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: const [
                    Icon(Icons.inventory_2_outlined, color: Color(0xFF0F9D58), size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'রেজিস্টার্ড কাস্টমার ও প্যাকেজ তালিকা',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'মোট: ${customers.length}টি এন্ট্রি',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Search Field
          TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            style: const TextStyle(fontSize: 13.5, color: Color(0xFF0F172A)),
            decoration: InputDecoration(
              hintText: 'কাস্টমারের নাম, ফোন বা প্যাকেজ খুঁজুন...',
              hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF0F9D58), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['সকল', 'ক্যাশ', 'ডিজিটাল'].map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _selectedFilter = filter),
                    labelStyle: TextStyle(
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF475569),
                    ),
                    backgroundColor: const Color(0xFFF1F5F9),
                    selectedColor: const Color(0xFF0F9D58),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Customer Cards
          if (customers.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Column(
                children: [
                  Icon(Icons.person_search_outlined, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 10),
                  const Text(
                    'কোনো কাস্টমার বা প্যাকেজ ডেটা পাওয়া যায়নি',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _openRegisterCustomerModal,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('নতুন কাস্টমার নিবন্ধন করুন', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F9D58),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: customers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final cust = customers[index];
                return _buildCustomerItemCard(cust);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCustomerItemCard(Map<String, dynamic> cust) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top: Name, ID and Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCFCE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: Color(0xFF0F9D58), size: 16),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cust['name'] as String,
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${cust['phone']} | ${cust['address']}',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'সক্রিয়',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF15803D)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 8),

          // Bottom: Package details & Payment mode
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.card_membership_rounded, size: 14, color: Color(0xFF2563EB)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        cust['package'] as String,
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '৳ ${cust['price']}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF0F9D58)),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        cust['paymentMethod'] as String,
                        style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
