import 'package:flutter/material.dart';
import 'admin_drawer.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/language_controller.dart';

class AdminSettingsView extends StatefulWidget {
  final HomeController? homeController;
  final AuthController? authController;
  final LanguageController? languageController;

  const AdminSettingsView({
    super.key,
    this.homeController,
    this.authController,
    this.languageController,
  });

  @override
  State<AdminSettingsView> createState() => _AdminSettingsViewState();
}

class _AdminSettingsViewState extends State<AdminSettingsView> {
  static const darkGreen = Color(0xFF005C45);
  static const brandGreen = Color(0xFF00A859);
  static const textDark = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _noticeController = TextEditingController(
    text: '২৪/৭ জরুরি স্বাস্থ্য সেবায় আমাদের অভিজ্ঞ ডাক্তাররা অনলাইনে আছেন। কল করুন: 09647111666',
  );

  final TextEditingController _helplineController = TextEditingController(
    text: '09647111666',
  );

  final TextEditingController _emailController = TextEditingController(
    text: 'info@mediseba.org',
  );

  @override
  void dispose() {
    _noticeController.dispose();
    _helplineController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildTopAppBar(context),
      drawer: const AdminDrawer(selectedIndex: 10),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Header
              _buildHeroHeader(),

              const SizedBox(height: 16),

              // 2. Live Notice Marquee Card
              _buildNoticeCard(),

              const SizedBox(height: 16),

              // 3. Live Helpline Config Card
              _buildHelplineConfigCard(),

              const SizedBox(height: 16),

              // 4. Save & Instant Live Button
              _buildSaveButton(),

              const SizedBox(height: 20),

              // 5. Dynamic 1-Click CSV Reports Export Card
              _buildCsvExportCard(),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.topRight,
        children: [
          FloatingActionButton(
            backgroundColor: darkGreen,
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('লাইভ সাপোর্ট চ্যাট ওপেন হয়েছে'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 24),
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
                '1',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
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
          const Icon(Icons.settings_outlined, color: brandGreen, size: 20),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'সিস্টেম সেটিং ও কন্ট্রোল',
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

  /// 1. Hero Header
  Widget _buildHeroHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Row(
          children: [
            Icon(Icons.settings_suggest_rounded, color: brandGreen, size: 24),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'সিস্টেম সেটিং ও লাইভ কন্ট্রোল (System Control Panel)',
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w900,
                  color: textDark,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          'অ্যাডমিন প্যানেল থেকে লাইভ অ্যানাউন্সমেন্ট, হেল্পলাইন নম্বর, সাইট স্ট্যাটাস ও ডাইনামিক CSV রিপোর্ট রিয়েল-টাইমে পরিচালনা করুন।',
          style: TextStyle(
            fontSize: 11.5,
            color: textMuted,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  /// 2. Live Notice Marquee Card
  Widget _buildNoticeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
              Icon(Icons.campaign_outlined, color: Color(0xFFD97706), size: 20),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'লাইভ স্ক্রোলিং নোটিশ ও অ্যানাউন্সমেন্ট (Live Notice Marquee)',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: textDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          const Text(
            'ওয়েবসাইটের টপ-বারে প্রদর্শিত জরুরি নোটিশ',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textDark),
          ),
          const SizedBox(height: 6),

          // Multi-line Textarea
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: _noticeController,
              maxLines: 3,
              style: const TextStyle(fontSize: 12.5, color: textDark, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(12),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            '* এই নোটিশটি মিডিয়ায় সরাসরি ফ্রন্টএন্ডে দেখানো হবে।',
            style: TextStyle(fontSize: 10.5, color: textMuted, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  /// 3. Live Helpline Config Card
  Widget _buildHelplineConfigCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
              Icon(Icons.phone_in_talk_outlined, color: brandGreen, size: 20),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'হেল্পলাইন ও অফিশিয়াল কন্টাক্ট ইনফরমেশন (Live Helpline Config)',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: textDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Responsive Row / Column for Helpline Number & Email
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isMobile = constraints.maxWidth < 540;

              final helplineField = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('২৪/৭ হেল্পলাইন নম্বর', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted)),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      controller: _helplineController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: textDark),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              );

              final emailField = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('অফিশিয়াল ইমেইল এড্রেস', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted)),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: textDark),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              );

              if (isMobile) {
                return Column(
                  children: [
                    helplineField,
                    const SizedBox(height: 10),
                    emailField,
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(child: helplineField),
                    const SizedBox(width: 14),
                    Expanded(child: emailField),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  /// 4. Save & Instant Live Button
  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandGreen,
          foregroundColor: Colors.white,
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('সিস্টেম সেটিংস সফলভাবে সেভ ও ইনস্ট্যান্ট লাইভ আপডেট করা হয়েছে!'),
              backgroundColor: brandGreen,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        icon: const Icon(Icons.save_rounded, size: 18),
        label: const Text(
          'সেটিং সেভ ও ইনস্ট্যান্ট লাইভ করুন',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  /// 5. Dynamic 1-Click CSV Reports Export Card
  Widget _buildCsvExportCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
              Icon(Icons.download_for_offline_outlined, color: Color(0xFF2563EB), size: 20),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'ডাইনামিক ১-ক্লিক সিএসভি/এক্সেল ডাটা এক্সপোর্ট (Export Real CSV Reports)',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: textDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3 Export Buttons Row / Wrap
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              // 1. Patients CSV Export
              InkWell(
                onTap: () => _exportCsv('রোগীদের CSV রিপোর্ট'),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.download_rounded, color: Color(0xFF2563EB), size: 16),
                      SizedBox(width: 6),
                      Text(
                        'রোগীদের CSV এক্সপোর্ট',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF1D4ED8)),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Revenue CSV Export
              InkWell(
                onTap: () => _exportCsv('রেভিনিউ CSV রিপোর্ট'),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.download_rounded, color: brandGreen, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'রেভিনিউ CSV এক্সপোর্ট',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: darkGreen),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Doctors CSV Export
              InkWell(
                onTap: () => _exportCsv('ডাক্তারদের CSV রিপোর্ট'),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFDDD6FE)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.download_rounded, color: Color(0xFF7C3AED), size: 16),
                      SizedBox(width: 6),
                      Text(
                        'ডাক্তারদের CSV এক্সপোর্ট',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF6D28D9)),
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

  void _exportCsv(String reportName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ $reportName সফলভাবে ডাউনলোড শুরু হয়েছে!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
