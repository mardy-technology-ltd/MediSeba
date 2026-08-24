import 'package:flutter/material.dart';
import 'admin_drawer.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/language_controller.dart';

class AdminPrescriptionsView extends StatefulWidget {
  final HomeController? homeController;
  final AuthController? authController;
  final LanguageController? languageController;

  const AdminPrescriptionsView({
    super.key,
    this.homeController,
    this.authController,
    this.languageController,
  });

  @override
  State<AdminPrescriptionsView> createState() => _AdminPrescriptionsViewState();
}

class _AdminPrescriptionsViewState extends State<AdminPrescriptionsView> {
  static const darkGreen = Color(0xFF005C45);
  static const brandGreen = Color(0xFF00A859);
  static const textDark = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  final List<Map<String, dynamic>> _prescriptionsList = [
    {
      'rxNo': 'RX-20260804-8819',
      'patientName': 'Samiul Islam',
      'doctorName': 'Dr. Tanvir Hasan',
      'doctorSpecialty': 'Orthopedics',
      'diagnosis': 'Acute Knee Joint Inflammation',
      'medicines': [
        {'name': 'Napa Extra 500mg', 'dose': '1-0-1 (7 Days)'},
        {'name': 'Seclo 20mg', 'dose': '1-0-0 (Before meal) (14 Days)'},
      ],
    },
    {
      'rxNo': 'RX-20260804-9912',
      'patientName': 'Rahim Uddin',
      'doctorName': 'Dr. Ahmed Rahman',
      'doctorSpecialty': 'Cardiology',
      'diagnosis': 'Essential Hypertension & Tachycardia',
      'medicines': [
        {'name': 'Ace 500mg', 'dose': '1-0-1 (5 Days)'},
        {'name': 'Sergel 20mg', 'dose': '1-0-0 (30 Days)'},
      ],
    },
    {
      'rxNo': 'RX-20260804-7741',
      'patientName': 'Taniya Rahman',
      'doctorName': 'Dr. Nusrat Jahan',
      'doctorSpecialty': 'Gynecology',
      'diagnosis': 'Seasonal Allergic Rhinitis & Fatigue',
      'medicines': [
        {'name': 'Fexo 120mg', 'dose': '0-0-1 (10 Days)'},
        {'name': 'Bextron Gold', 'dose': '1-0-0 (30 Days)'},
      ],
    },
    {
      'rxNo': 'RX-20260804-6632',
      'patientName': 'Kabir Hossain',
      'doctorName': 'Dr. Rafiqul Islam',
      'doctorSpecialty': 'Neurology',
      'diagnosis': 'Tension Headache & Mild Migraine',
      'medicines': [
        {'name': 'Ceevit 250mg', 'dose': '1-0-1 (15 Days)'},
        {'name': 'Tory 90mg', 'dose': '1-0-0 (5 Days)'},
      ],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _prescriptionsList.where((rx) {
      final rxNo = (rx['rxNo'] ?? '').toString().toLowerCase();
      final patient = (rx['patientName'] ?? '').toString().toLowerCase();
      final doctor = (rx['doctorName'] ?? '').toString().toLowerCase();
      final diagnosis = (rx['diagnosis'] ?? '').toString().toLowerCase();

      final q = _searchQuery.toLowerCase();
      return rxNo.contains(q) || patient.contains(q) || doctor.contains(q) || diagnosis.contains(q);
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildTopAppBar(context),
      drawer: const AdminDrawer(selectedIndex: 9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Hero Title
              _buildHeroHeader(),

              const SizedBox(height: 14),

              // 2. Search Box Input
              _buildSearchInputCard(),

              const SizedBox(height: 16),

              // 3. Responsive Prescriptions Grid
              _buildPrescriptionsGrid(filteredList),

              const SizedBox(height: 24),
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
                  content: Text('লাইভ সাপোর্ট চ্যাট সাপোর্ট ওপেন হয়েছে'),
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
          const Icon(Icons.description_outlined, color: brandGreen, size: 20),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'ডিজিটাল প্রেসক্রিপশন',
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

  /// 1. Header Hero Title
  Widget _buildHeroHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Row(
          children: [
            Icon(Icons.description_rounded, color: brandGreen, size: 24),
            SizedBox(width: 8),
            Text(
              'ডিজিটাল প্রেসক্রিপশন ভল্ট (Prescription Vault)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: textDark,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          'আর্কাইভকৃত ডিজিটাল ই-প্রেসক্রিপশন, ডাক্তারের ডায়াগনোসিস ও প্রেসক্রাইবড ওষুধ',
          style: TextStyle(
            fontSize: 11.5,
            color: textMuted,
          ),
        ),
      ],
    );
  }

  /// 2. Search Box Input Card
  Widget _buildSearchInputCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
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
        style: const TextStyle(fontSize: 12.5),
        decoration: InputDecoration(
          hintText: 'প্রেসক্রিপশন নম্বর, রোগীর নাম বা ডাক্তারের নাম দিয়ে খুঁজুন...',
          hintStyle: const TextStyle(fontSize: 12, color: textMuted),
          prefixIcon: const Icon(Icons.search_rounded, color: textMuted, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  /// 3. Responsive Prescriptions Grid
  Widget _buildPrescriptionsGrid(List<Map<String, dynamic>> list) {
    if (list.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        alignment: Alignment.center,
        child: const Text(
          'কোনো প্রেসক্রিপশন পাওয়া যায়নি।',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textMuted),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        if (width >= 660) {
          // 2 Column Grid for Tablet / Desktop
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              mainAxisExtent: 310,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) => _buildPrescriptionCard(list[index]),
          );
        } else {
          // 1 Column for Mobile
          return Column(
            children: list.map((rx) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildPrescriptionCard(rx),
            )).toList(),
          );
        }
      },
    );
  }

  /// Single Prescription Card matching Web Screenshot
  Widget _buildPrescriptionCard(Map<String, dynamic> rx) {
    final String rxNo = (rx['rxNo'] ?? '').toString();
    final String patientName = (rx['patientName'] ?? '').toString();
    final String doctorName = (rx['doctorName'] ?? '').toString();
    final String doctorSpecialty = (rx['doctorSpecialty'] ?? '').toString();
    final String diagnosis = (rx['diagnosis'] ?? '').toString();
    final List medicines = (rx['medicines'] as List?) ?? [];

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
          // Top Row: Rx Number + PDF Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rxNo,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: brandGreen,
                ),
              ),

              // PDF Button (Triggers Toast Modal matching Image 2!)
              InkWell(
                onTap: () => _showPdfDownloadModal(rxNo),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.download_rounded, color: brandGreen, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'PDF',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: brandGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Patient Name
          Row(
            children: [
              const Icon(Icons.person_outline_rounded, size: 16, color: Color(0xFF2563EB)),
              const SizedBox(width: 6),
              Text(
                patientName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: textDark,
                ),
              ),
            ],
          ),

          const Divider(height: 18, color: Color(0xFFF1F5F9)),

          // Doctor & Specialty
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.medical_services_outlined, size: 14, color: brandGreen),
              const SizedBox(width: 6),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 11.5, color: textDark),
                    children: [
                      const TextSpan(text: 'ডাক্তার: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: doctorName, style: const TextStyle(fontWeight: FontWeight.bold, color: textDark)),
                      TextSpan(text: ' ($doctorSpecialty)', style: const TextStyle(color: textMuted)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),

          // Diagnosis
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 11, color: Color(0xFFB45309)),
              children: [
                const TextSpan(text: 'ডায়াগনোসিস: ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: diagnosis, style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Prescribed Medicines Header
          const Row(
            children: [
              Icon(Icons.medication_outlined, size: 13, color: brandGreen),
              SizedBox(width: 4),
              Text(
                'প্রেসক্রাইবড ওষুধসমূহ:',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textDark),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Medicines List
          Column(
            children: medicines.map<Widget>((med) {
              final String name = (med['name'] ?? '').toString();
              final String dose = (med['dose'] ?? '').toString();

              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textDark),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        dose,
                        style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: brandGreen),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// PDF Download Success Pop-Up Toast matching Image 2 precisely!
  void _showPdfDownloadModal(String rxNo) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          alignment: Alignment.topCenter,
          insetPadding: const EdgeInsets.only(top: 60, left: 16, right: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFA7F3D0), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: brandGreen.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: const Icon(Icons.close_rounded, size: 16, color: brandGreen),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Success Title
                const Text(
                  'প্রেসক্রিপশন পিডিএফ ডাউনলোড হয়েছে!',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: darkGreen,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle with Check Icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: brandGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded, size: 14, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$rxNo.pdf আপনার ডিভাইসে ডাউনলোড হয়েছে।',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                          height: 1.3,
                        ),
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
}
