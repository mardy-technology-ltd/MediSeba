import 'package:flutter/material.dart';
import '../../controllers/language_controller.dart';
import '../doctors/doctor_list_view.dart';

class PatientPortalView extends StatefulWidget {
  final LanguageController? languageController;

  const PatientPortalView({super.key, this.languageController});

  @override
  State<PatientPortalView> createState() => _PatientPortalViewState();
}

class _PatientPortalViewState extends State<PatientPortalView> with SingleTickerProviderStateMixin {
  late LanguageController _langController;
  int _selectedVitalTab = 0; // 0: BP, 1: Glucose, 2: Pulse

  // Expand / Collapse state toggles for 3-item cap limit
  bool _showAllAppointments = false;
  bool _showAllPrescriptions = false;
  bool _showAllReports = false;
  bool _showAllPayments = false;
  bool _showAllLogs = false;

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = _langController.isBangla;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF475569), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.monitor_heart_outlined, color: Color(0xFF0F9D58), size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    isBangla ? 'পেশেন্ট পোর্টাল ওভারভিউ' : 'PATIENT PORTAL OVERVIEW',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Text(
              isBangla ? 'স্বাস্থ্য ভাইটাল, অ্যাপয়েন্টমেন্ট ও রিসিট' : 'Health Vitals, Appointments & Receipts',
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          // Notification Icon with Badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF475569), size: 24),
                onPressed: () {},
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFED1C24),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Patient Profile Header Card
            _buildPatientHeaderCard(isBangla),

            const SizedBox(height: 16),

            // 2. Live Health Vitals Tracker Card
            _buildHealthVitalsCard(isBangla),

            const SizedBox(height: 16),

            // 3. My Serials & Appointments Section
            _buildSerialsAndAppointmentsSection(isBangla),

            const SizedBox(height: 16),

            // 4. Digital Prescriptions Section
            _buildDigitalPrescriptionsSection(isBangla),

            const SizedBox(height: 16),

            // 5. Medical Records & Lab Reports Section
            _buildMedicalRecordsSection(isBangla),

            const SizedBox(height: 16),

            // 6. Payment History & Receipts Section
            _buildPaymentHistorySection(isBangla),

            const SizedBox(height: 16),

            // 7. Activity History Log Section
            _buildActivityLogSection(isBangla),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // 1. Patient Profile Banner Card
  Widget _buildPatientHeaderCard(bool isBangla) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4EA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFA8DADC), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F9D58).withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar with Edit Icon
              Stack(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F9D58),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'S',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_rounded, color: Color(0xFF0F9D58), size: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Patient Name & Badges
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        const Text(
                          'Samiul Islam',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        // Blood Group Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF10B981), width: 1),
                          ),
                          child: const Text(
                            'Blood: A+',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF047857),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Contact Info
                    const Row(
                      children: [
                        Icon(Icons.email_outlined, size: 12, color: Color(0xFF64748B)),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'patient1@mediseba.org',
                            style: TextStyle(fontSize: 11, color: Color(0xFF475569)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Row(
                      children: [
                        Icon(Icons.phone_outlined, size: 12, color: Color(0xFF64748B)),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '01710000001',
                            style: TextStyle(fontSize: 11, color: Color(0xFF475569)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: Color(0xFFC7E5D6), height: 1),
          const SizedBox(height: 10),

          // Action Button: + নতুন সিরিয়াল নিন
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DoctorListView()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F9D58),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(
                isBangla ? '+ নতুন সিরিয়াল নিন' : '+ Book New Serial',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Live Health Vitals Card & Graph
  Widget _buildHealthVitalsCard(bool isBangla) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Row
          Row(
            children: [
              const Icon(Icons.show_chart_rounded, color: Color(0xFF0F9D58), size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isBangla ? 'রক্তচাপ ও স্বাস্থ্য ভাইটাল হিস্ট্রি' : 'Health Vitals History',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),

              // Entry Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, size: 13, color: Color(0xFF0F9D58)),
                    const SizedBox(width: 2),
                    Text(
                      isBangla ? 'এন্ট্রি দিন' : 'Add Entry',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F9D58),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Vitals Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildVitalTabChip('রক্তচাপ (BP)', 0),
                const SizedBox(width: 8),
                _buildVitalTabChip('সুগার (Glucose)', 1),
                const SizedBox(width: 8),
                _buildVitalTabChip('পালস (Pulse)', 2),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 3 Metric Cards Row
          Row(
            children: [
              Expanded(
                child: _buildMetricMiniCard(
                  title: 'রক্তচাপ (BP)',
                  value: '123/83',
                  unit: 'mmHg',
                  status: 'পর্যবেক্ষণ (Good)',
                  statusColor: const Color(0xFF10B981),
                  bgColor: const Color(0xFFECFDF5),
                  borderColor: const Color(0xFFA7F3D0),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildMetricMiniCard(
                  title: 'ডায়াবেটিস',
                  value: '5.8',
                  unit: 'mmol/L',
                  status: 'নিয়ন্ত্রণ (Good)',
                  statusColor: const Color(0xFF0284C7),
                  bgColor: const Color(0xFFF0F9FF),
                  borderColor: const Color(0xFFBAE6FD),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildMetricMiniCard(
                  title: 'হার্ট রেট',
                  value: '74',
                  unit: 'BPM',
                  status: 'সুস্থ (Normal)',
                  statusColor: const Color(0xFFE11D48),
                  bgColor: const Color(0xFFFFF1F2),
                  borderColor: const Color(0xFFFECDD3),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Visual Vitals Trend Chart Representation
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: CustomPaint(
              painter: VitalsChartPainter(),
              child: Container(),
            ),
          ),
          const SizedBox(height: 6),

          // Chart Date Labels
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('01 Aug', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
              Text('02 Aug', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
              Text('03 Aug', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
              Text('04 Aug', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
              Text('05 Aug', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
              Text('06 Aug', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
              Text('07 Aug', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalTabChip(String title, int index) {
    final bool isSelected = _selectedVitalTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVitalTab = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F9D58) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF0F9D58) : const Color(0xFFCBD5E1),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricMiniCard({
    required String title,
    required String value,
    required String unit,
    required String status,
    required Color statusColor,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                ),
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: statusColor.withValues(alpha: 0.5)),
            ),
            child: Text(
              status,
              style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: statusColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // 3. My Serials & Appointments Section (Max 3 items cap with View All button)
  Widget _buildSerialsAndAppointmentsSection(bool isBangla) {
    final List<Widget> allAppointmentCards = [
      // Card 1
      _buildAppointmentCardItem(
        serialNo: 'SERIAL-20260804-99812',
        status: 'কনফার্মড',
        statusBg: const Color(0xFFE0F2FE),
        statusColor: const Color(0xFF0284C7),
        paymentStatus: 'পেমেন্ট: ভেরিফাইড',
        doctorName: 'অধ্যাপক ড. এ. কে. এম. ফজলে রাব্বি',
        specialty: 'হৃদরোগ ও মেডিসিন বিশেষজ্ঞ • পপুলার ডায়াগনস্টিক সেন্টার, ধানমন্ডি, ঢাকা',
        time: 'আজ, বিকাল ০৪:৩০ PM',
        buttonText: 'ডিজিটাল সিরিয়াল স্লিপ',
        buttonColor: const Color(0xFF0F9D58),
        icon: Icons.confirmation_number_outlined,
      ),
      // Card 2
      _buildAppointmentCardItem(
        serialNo: 'APT-20260804-88192',
        status: 'ডাক্তার প্রস্তুত আছেন (সিরিয়াল: #১)',
        statusBg: const Color(0xFFDCFCE7),
        statusColor: const Color(0xFF16A34A),
        doctorName: 'Dr. Tanvir Hasan',
        specialty: 'অর্থোপেডিক সার্জারি • মেডিসেবা ডিজিটাল চেম্বার (অনলাইন)',
        buttonText: 'HD ভিডিও কল',
        buttonColor: const Color(0xFFED1C24),
        icon: Icons.videocam_rounded,
      ),
      // Card 3
      _buildAppointmentCardItem(
        serialNo: 'SERIAL-20260802-77123',
        status: 'কনফার্মড',
        statusBg: const Color(0xFFE0F2FE),
        statusColor: const Color(0xFF0284C7),
        paymentStatus: 'পেমেন্ট: পেইড',
        doctorName: 'ডা. শারমিন আক্তার',
        specialty: 'স্ত্রী রোগ ও প্রসূতি বিদ্যা বিশেষজ্ঞ • ল্যাবএইড স্পেশালাইজড হাসপাতাল',
        time: 'আগামীকাল, সকাল ১১:০০ AM',
        buttonText: 'ডিজিটাল সিরিয়াল স্লিপ',
        buttonColor: const Color(0xFF0F9D58),
        icon: Icons.confirmation_number_outlined,
      ),
      // Card 4 (Extra item to test max 3 limit)
      _buildAppointmentCardItem(
        serialNo: 'APT-20260801-66512',
        status: 'সম্পন্ন',
        statusBg: const Color(0xFFF1F5F9),
        statusColor: const Color(0xFF64748B),
        doctorName: 'ডা. মোঃ আরিফুল ইসলাম',
        specialty: 'চর্ম ও যৌন রোগ বিশেষজ্ঞ • মেডিসেবা অনলাইন চেম্বার',
        buttonText: 'প্রেসক্রিপশন দেখুন',
        buttonColor: const Color(0xFF0284C7),
        icon: Icons.description_outlined,
      ),
    ];

    final int totalCount = allAppointmentCards.length;
    final displayedCards = _showAllAppointments
        ? allAppointmentCards
        : allAppointmentCards.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with dynamic count
        Row(
          children: [
            const Icon(Icons.calendar_month_rounded, color: Color(0xFF0F9D58), size: 20),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                isBangla
                    ? 'আমার সিরিয়াল ও অ্যাপয়েন্টমেন্ট ($totalCount)'
                    : 'My Serials & Appointments ($totalCount)',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // List items
        ...displayedCards.map((card) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: card,
            )),

        // View All / Show Less Button if > 3 items
        if (totalCount > 3)
          _buildViewAllButton(
            isBangla: isBangla,
            isExpanded: _showAllAppointments,
            totalItems: totalCount,
            onTap: () {
              setState(() {
                _showAllAppointments = !_showAllAppointments;
              });
            },
          ),
      ],
    );
  }

  Widget _buildAppointmentCardItem({
    required String serialNo,
    required String status,
    required Color statusBg,
    required Color statusColor,
    String? paymentStatus,
    required String doctorName,
    required String specialty,
    String? time,
    required String buttonText,
    required Color buttonColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
            runSpacing: 4,
            children: [
              Text(
                serialNo,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
              ),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                  ),
                  if (paymentStatus != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        paymentStatus,
                        style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            doctorName,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 3),
          Text(
            specialty,
            style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
          ),
          if (time != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF0F9D58)),
                const SizedBox(width: 4),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F9D58)),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              icon: Icon(icon, size: 16),
              label: Text(buttonText, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Digital Prescriptions Section (Max 3 items cap)
  Widget _buildDigitalPrescriptionsSection(bool isBangla) {
    final List<Widget> allPrescriptionItems = [
      _buildPrescriptionItemCard(
        rxId: 'RX-20260804-8819',
        doctorName: 'Dr. Tanvir Hasan',
        disease: 'Acute Knee Joint Inflammation',
        date: '04 Aug 2026',
      ),
      _buildPrescriptionItemCard(
        rxId: 'RX-20260728-4412',
        doctorName: 'অধ্যাপক ড. এ. কে. এম. ফজলে রাব্বি',
        disease: 'Hypertension & Cardiac Care Routine',
        date: '28 Jul 2026',
      ),
      _buildPrescriptionItemCard(
        rxId: 'RX-20260715-3398',
        doctorName: 'ডা. শারমিন আক্তার',
        disease: 'Antenatal Routine Medication',
        date: '15 Jul 2026',
      ),
      _buildPrescriptionItemCard(
        rxId: 'RX-20260630-1102',
        doctorName: 'ডা. মোঃ আরিফুল ইসলাম',
        disease: 'Allergic Dermatitis Treatment',
        date: '30 Jun 2026',
      ),
    ];

    final int totalCount = allPrescriptionItems.length;
    final displayedItems = _showAllPrescriptions
        ? allPrescriptionItems
        : allPrescriptionItems.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_outlined, color: Color(0xFF0F9D58), size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isBangla ? 'ডিজিটাল প্রেসক্রিপশন ($totalCount)' : 'Digital Prescriptions ($totalCount)',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...displayedItems.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: item,
              )),

          if (totalCount > 3)
            _buildViewAllButton(
              isBangla: isBangla,
              isExpanded: _showAllPrescriptions,
              totalItems: totalCount,
              onTap: () {
                setState(() {
                  _showAllPrescriptions = !_showAllPrescriptions;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionItemCard({
    required String rxId,
    required String doctorName,
    required String disease,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rxId,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
              ),
              Text(date, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            doctorName,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 2),
          Text(
            disease,
            style: const TextStyle(fontSize: 12, color: Color(0xFFD97706), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    side: const BorderSide(color: Color(0xFF0F9D58)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.print_outlined, size: 14, color: Color(0xFF0F9D58)),
                  label: const Text('প্রিন্ট / A4', style: TextStyle(fontSize: 11, color: Color(0xFF0F9D58), fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F9D58),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.download_rounded, size: 14),
                  label: const Text('১-ক্লিক PDF', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 5. Medical Records & Lab Reports Section (Max 3 items cap)
  Widget _buildMedicalRecordsSection(bool isBangla) {
    final List<Widget> allReports = [
      _buildLabReportItem(
        category: 'Blood Test',
        title: 'CBC & Blood Sugar Lab Report',
        fileName: 'CBC_Report_Aug2026.pdf',
        date: '02 Aug 2026',
        bgColor: const Color(0xFFE0F2FE),
        textColor: const Color(0xFF0284C7),
      ),
      _buildLabReportItem(
        category: 'X-Ray',
        title: 'Chest X-Ray Digital Scan',
        fileName: 'Chest_XRay_July2026.png',
        date: '28 Jul 2026',
        bgColor: const Color(0xFFF3E8FF),
        textColor: const Color(0xFF7E22CE),
      ),
      _buildLabReportItem(
        category: 'ECG Test',
        title: 'Cardiac Rhythm & ECG Report',
        fileName: 'ECG_July2026.pdf',
        date: '15 Jul 2026',
        bgColor: const Color(0xFFDCFCE7),
        textColor: const Color(0xFF16A34A),
      ),
      _buildLabReportItem(
        category: 'Ultrasound',
        title: 'USG Abdomen Scan Report',
        fileName: 'USG_Report_June2026.pdf',
        date: '10 Jun 2026',
        bgColor: const Color(0xFFFEF3C7),
        textColor: const Color(0xFFD97706),
      ),
    ];

    final int totalCount = allReports.length;
    final displayedReports = _showAllReports
        ? allReports
        : allReports.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.folder_shared_outlined, color: Color(0xFF0F9D58), size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isBangla ? 'মেডিকেল রেকর্ডস & ল্যাব রিপোর্টস ($totalCount)' : 'Lab Reports ($totalCount)',
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...displayedReports.map((report) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: report,
              )),

          if (totalCount > 3)
            _buildViewAllButton(
              isBangla: isBangla,
              isExpanded: _showAllReports,
              totalItems: totalCount,
              onTap: () {
                setState(() {
                  _showAllReports = !_showAllReports;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildLabReportItem({
    required String category,
    required String title,
    required String fileName,
    required String date,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(category, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor)),
                ),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                const SizedBox(height: 2),
                Text('$fileName • $date', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Color(0xFF0F9D58), size: 22),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // 6. Payment History Section (Max 3 items cap)
  Widget _buildPaymentHistorySection(bool isBangla) {
    final List<Widget> allPayments = [
      _buildPaymentItem(
        txnId: 'BKASH-99120491',
        title: 'চেম্বার সিরিয়াল ফি (ডা. ফজলে রাব্বি)',
        amount: '৳ 1500 • bKash Merchant',
        isPaid: true,
      ),
      _buildPaymentItem(
        txnId: 'NAGAD-88492019',
        title: 'ভিডিও কনসালটেশন ফি (Dr. Tanvir)',
        amount: '৳ 1000 • Nagad Online',
        isPaid: true,
      ),
      _buildPaymentItem(
        txnId: 'BKASH-77129034',
        title: 'মেডিসিন শপ ও প্রেসক্রিপশন অর্ডার',
        amount: '৳ 850 • MediShop Express',
        isPaid: true,
      ),
      _buildPaymentItem(
        txnId: 'BKASH-66364798',
        title: 'ল্যাব টেস্ট হোম কালেকশন',
        amount: '৳ 1200 • bKash Merchant',
        isPaid: true,
      ),
    ];

    final int totalCount = allPayments.length;
    final displayedPayments = _showAllPayments
        ? allPayments
        : allPayments.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_outlined, color: Color(0xFF0F9D58), size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isBangla ? 'পেমেন্ট হিস্ট্রি ও রিসিট ($totalCount)' : 'Payment History & Receipts ($totalCount)',
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...displayedPayments.map((payment) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: payment,
              )),

          if (totalCount > 3)
            _buildViewAllButton(
              isBangla: isBangla,
              isExpanded: _showAllPayments,
              totalItems: totalCount,
              onTap: () {
                setState(() {
                  _showAllPayments = !_showAllPayments;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem({
    required String txnId,
    required String title,
    required String amount,
    required bool isPaid,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(txnId, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Paid', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                const SizedBox(height: 2),
                Text(amount, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.receipt_outlined, size: 14, color: Color(0xFF0F9D58)),
            label: const Text('মেমো', style: TextStyle(fontSize: 11, color: Color(0xFF0F9D58), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // 7. Activity History Log Section (Max 3 items cap)
  Widget _buildActivityLogSection(bool isBangla) {
    final List<Widget> allLogs = [
      _buildActivityLogTile(
        icon: Icons.check_circle_outline,
        iconColor: const Color(0xFF10B981),
        title: 'BKASH পেমেন্ট সম্পন্ন হয়েছে',
        subtitle: '৳ 1000 (TxnID: BKASH-66364798)',
        time: '০৭:৫২ PM',
      ),
      _buildActivityLogTile(
        icon: Icons.calendar_today_outlined,
        iconColor: const Color(0xFF0284C7),
        title: 'চেম্বার সিরিয়াল বুক করা হয়েছে',
        subtitle: 'অধ্যাপক ড. এ. কে. এম. ফজলে রাব্বি (ধানমন্ডি)',
        time: '০৪:৫০ PM',
      ),
      _buildActivityLogTile(
        icon: Icons.payment_rounded,
        iconColor: const Color(0xFF6366F1),
        title: 'bKash পেমেন্ট সম্পন্ন হয়েছে',
        subtitle: '৳ ১,৫০০ (TxnID: BKASH-99120491)',
        time: '০৭:১৮ PM',
      ),
      _buildActivityLogTile(
        icon: Icons.upload_file_rounded,
        iconColor: const Color(0xFF8B5CF6),
        title: 'ল্যাব রিপোর্ট আপলোড করা হয়েছে',
        subtitle: 'CBC & Blood Sugar Lab Report.pdf',
        time: 'সকাল ১১:৪৫ AM',
      ),
      _buildActivityLogTile(
        icon: Icons.assignment_outlined,
        iconColor: const Color(0xFFEC4899),
        title: 'নতুন প্রেসক্রিপশন গ্রহণ করা হয়েছে',
        subtitle: 'Dr. Tanvir Hasan (Acute Knee Joint)',
        time: 'গতকাল',
      ),
    ];

    final int totalCount = allLogs.length;
    final displayedLogs = _showAllLogs
        ? allLogs
        : allLogs.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history_rounded, color: Color(0xFF0F9D58), size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isBangla ? 'অ্যাক্টিভিটি ও একশন হিস্ট্রি লগ ($totalCount)' : 'Activity Log ($totalCount)',
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...List.generate(displayedLogs.length, (index) {
            final isLast = index == displayedLogs.length - 1;
            return Column(
              children: [
                displayedLogs[index],
                if (!isLast) const Divider(height: 12, color: Color(0xFFF1F5F9)),
              ],
            );
          }),

          if (totalCount > 3) ...[
            const SizedBox(height: 6),
            _buildViewAllButton(
              isBangla: isBangla,
              isExpanded: _showAllLogs,
              totalItems: totalCount,
              onTap: () {
                setState(() {
                  _showAllLogs = !_showAllLogs;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActivityLogTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            ],
          ),
        ),
        Text(time, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
      ],
    );
  }

  // Reusable View All / Show Less Button Widget
  Widget _buildViewAllButton({
    required bool isBangla,
    required bool isExpanded,
    required int totalItems,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isExpanded
                  ? (isBangla ? 'সংক্ষিপ্ত করুন' : 'Show Less')
                  : (isBangla ? 'সব দেখুন ($totalItems টি)' : 'View All ($totalItems Items)'),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F9D58),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              color: const Color(0xFF0F9D58),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Vitals Trend Wave Line Chart Painter
class VitalsChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF10B981).withValues(alpha: 0.25),
          const Color(0xFF10B981).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final paintLine = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.cubicTo(size.width * 0.2, size.height * 0.2, size.width * 0.4, size.height * 0.6, size.width * 0.6, size.height * 0.3);
    path.cubicTo(size.width * 0.8, size.height * 0.1, size.width * 0.9, size.height * 0.5, size.width, size.height * 0.35);

    final pathFill = Path.from(path);
    pathFill.lineTo(size.width, size.height);
    pathFill.lineTo(0, size.height);
    pathFill.close();

    canvas.drawPath(pathFill, paintFill);
    canvas.drawPath(path, paintLine);

    // Baseline Line
    final paintBase = Paint()
      ..color = const Color(0xFF0284C7)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final basePath = Path();
    basePath.moveTo(0, size.height * 0.75);
    basePath.cubicTo(size.width * 0.25, size.height * 0.7, size.width * 0.6, size.height * 0.85, size.width, size.height * 0.78);
    canvas.drawPath(basePath, paintBase);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
