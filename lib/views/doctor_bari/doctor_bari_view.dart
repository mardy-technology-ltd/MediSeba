import 'package:flutter/material.dart';
import '../../controllers/doctor_controller.dart';
import '../../controllers/language_controller.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../appointments/book_appointment_view.dart';
import '../offers/widgets/eps_payment_gateway_dialog.dart';
import '../doctors/doctor_details_view.dart';
import '../doctors/widgets/doctor_card.dart';
import 'widgets/famous_doctor_serial_sheet.dart';

class DoctorBariView extends StatefulWidget {
  final LanguageController? languageController;

  const DoctorBariView({super.key, this.languageController});

  @override
  State<DoctorBariView> createState() => _DoctorBariViewState();
}

class _DoctorBariViewState extends State<DoctorBariView> {
  static const brandGreen = Color(0xFF0F9D58);
  static const darkGreen = Color(0xFF006B4A);
  
  final DoctorController _doctorController = DoctorController();
  final TextEditingController _searchController = TextEditingController();
  late final LanguageController _langController;

  // Selected tab (0: Instant Doctor List, 1: Chamber Serial Request Form)
  int _selectedTab = 0;

  // Chamber Serial Request Form Controllers & State
  final TextEditingController _serialNameController = TextEditingController();
  final TextEditingController _serialPhoneController = TextEditingController();
  final TextEditingController _serialHospitalController = TextEditingController();
  DoctorOptionItem? _serialSelectedDoctor;
  DateTime? _serialSelectedDate;

  final List<DoctorOptionItem> _doctorOptionsList = const [
    DoctorOptionItem(
      name: 'ডা. ফারজানা বেবি',
      degree: 'MBBS, FCPS (Medicine)',
      specialty: 'মেডিসিন ও প্রফেশনাল স্বাস্থ্য বিশেষজ্ঞ',
      hospital: 'Popular Diagnostic Center, Dhanmondi',
      experience: '১২+ বছরের অভিজ্ঞতা',
      rating: 4.9,
      consultationCount: '720+',
      fee: 800,
    ),
    DoctorOptionItem(
      name: 'ডা. আহমেদ রহমান',
      degree: 'MBBS, MD (Cardiology)',
      specialty: 'হৃদরোগ ও ইন্টারভেনশনাল কার্ডিওলজি',
      hospital: 'Labaid Specialized Hospital, Dhaka',
      experience: '১৫+ বছরের অভিজ্ঞতা',
      rating: 4.9,
      consultationCount: '850+',
      fee: 800,
    ),
    DoctorOptionItem(
      name: 'ডা. ইমরান কবির',
      degree: 'MBBS, FCPS (Neurology)',
      specialty: 'ব্রেইন, স্নায়ুরোগ ও নিউরোমেডিসিন',
      hospital: 'Square Hospital, Panthapath',
      experience: '১০+ বছরের অভিজ্ঞতা',
      rating: 4.8,
      consultationCount: '650+',
      fee: 800,
    ),
    DoctorOptionItem(
      name: 'ডা. নুসরাত জাহান',
      degree: 'MBBS, FCPS (Gynecology & Obstetrics)',
      specialty: 'গাইনি, মা ও শিশু রোগ বিশেষজ্ঞ',
      hospital: 'Central Hospital, Green Road',
      experience: '১৪+ বছরের অভিজ্ঞতা',
      rating: 4.9,
      consultationCount: '900+',
      fee: 600,
    ),
    DoctorOptionItem(
      name: 'ডা. তানভীর হাসান',
      degree: 'MBBS, MS (Orthopedics)',
      specialty: 'হাড়, জয়েন্ট ও অর্থোপেডিক সার্জন',
      hospital: 'Ibn Sina Diagnostic Center, Rajshahi',
      experience: '১২+ বছরের অভিজ্ঞতা',
      rating: 4.9,
      consultationCount: '550+',
      fee: 700,
    ),
    DoctorOptionItem(
      name: 'ডা. সামিউল সজিব',
      degree: 'MBBS, FCPS (Pediatrics)',
      specialty: 'নবজাতক ও শিশু রোগ বিশেষজ্ঞ',
      hospital: 'Dhaka Shishu Hospital, Agargaon',
      experience: '৮+ বছরের অভিজ্ঞতা',
      rating: 4.8,
      consultationCount: '600+',
      fee: 600,
    ),
    DoctorOptionItem(
      name: 'অন্যান্য প্রফেসরের সিরিয়াল',
      degree: 'বিশেষজ্ঞ কনসালট্যান্ট প্রফেসরস',
      specialty: 'দেশের যেকোনো প্রখ্যাত প্রফেসর / সিনিয়র সার্জন',
      hospital: 'যেকোনো স্বনামধন্য হাসপাতাল ও চেম্বার',
      experience: 'মেডিসেবা টিমের কাস্টম সিরিয়াল সার্ভিস',
      rating: 5.0,
      consultationCount: '1000+',
      fee: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
  }

  final List<String> _categories = [
    'সকল (All)',
    'মেডিসিন (Medicine)',
    'হৃদরোগ (Cardiology)',
    'শিশু রোগ (Pediatrics)',
    'গাইনি ও স্ত্রী রোগ (Gynecology)',
    'চর্ম ও যৌন (Dermatology)',
    'নিউরোমেডিসিন (Neurology)',
    'অর্থোপেডিক্স (Orthopedics)',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _doctorController.dispose();
    _serialNameController.dispose();
    _serialPhoneController.dispose();
    _serialHospitalController.dispose();
    super.dispose();
  }

  Future<void> _pickSerialDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _serialSelectedDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: brandGreen,
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _serialSelectedDate = picked);
    }
  }

  void _openDoctorPickerModal() {
    final searchCtrl = TextEditingController();
    List<DoctorOptionItem> filteredList = List.from(_doctorOptionsList);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.72,
              padding: EdgeInsets.only(
                top: 16,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Pill Bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4.5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header Title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.medical_services_rounded, color: brandGreen, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'ডাক্তার বা স্পেশালিস্ট নির্বাচন করুন',
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Search Box
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
                    ),
                    child: TextField(
                      controller: searchCtrl,
                      autofocus: false,
                      style: const TextStyle(fontSize: 13.5, color: Color(0xFF0F172A)),
                      onChanged: (query) {
                        setModalState(() {
                          filteredList = _doctorOptionsList.where((doc) {
                            final q = query.toLowerCase().trim();
                            return doc.name.toLowerCase().contains(q) ||
                                doc.specialty.toLowerCase().contains(q) ||
                                doc.degree.toLowerCase().contains(q) ||
                                doc.hospital.toLowerCase().contains(q);
                          }).toList();
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'ডাক্তারের নাম, ডিগ্রি বা হাসপাতাল খুঁজুন...',
                        hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        prefixIcon: Icon(Icons.search_rounded, color: brandGreen, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Doctor List Items
                  Expanded(
                    child: filteredList.isEmpty
                        ? const Center(
                            child: Text(
                              'কোনো ডাক্তার বা স্পেশালিস্ট পাওয়া যায়নি',
                              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                            ),
                          )
                        : ListView.separated(
                            itemCount: filteredList.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 6),
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              final isSelected = _serialSelectedDoctor?.name == item.name;

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _serialSelectedDoctor = item;
                                    if (item.hospital.isNotEmpty) {
                                      _serialHospitalController.text = item.hospital;
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFFECFDF5) : const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isSelected ? brandGreen : const Color(0xFFE2E8F0),
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 22,
                                        backgroundColor: isSelected ? brandGreen : const Color(0xFFE2E8F0),
                                        child: Text(
                                          item.name.startsWith('ডা.')
                                              ? item.name.replaceAll('ডা.', '').trim().substring(0, 1)
                                              : item.name.substring(0, 1),
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : const Color(0xFF0F172A),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    item.name,
                                                    style: TextStyle(
                                                      fontSize: 14.5,
                                                      fontWeight: FontWeight.bold,
                                                      color: isSelected ? brandGreen : const Color(0xFF0F172A),
                                                    ),
                                                  ),
                                                ),
                                                if (item.fee > 0)
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFFFEF3C7),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Text(
                                                      '৳${item.fee}',
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(0xFFB45309),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              item.degree,
                                              style: const TextStyle(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF475569),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: isSelected ? const Color(0xFFD1FAE5) : const Color(0xFFF1F5F9),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                item.specialty,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: isSelected ? const Color(0xFF047857) : const Color(0xFF334155),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                const Icon(Icons.business_rounded, size: 13, color: Color(0xFF64748B)),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    item.hospital,
                                                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                                                const SizedBox(width: 2),
                                                Text(
                                                  '${item.rating} (${item.consultationCount})',
                                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                                                ),
                                                const SizedBox(width: 10),
                                                const Icon(Icons.work_history_outlined, size: 12, color: Color(0xFF64748B)),
                                                const SizedBox(width: 3),
                                                Expanded(
                                                  child: Text(
                                                    item.experience,
                                                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected) ...[
                                        const SizedBox(width: 8),
                                        const Icon(Icons.check_circle_rounded, color: brandGreen, size: 22),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
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

  Future<void> _submitSerialForm() async {
    if (_serialNameController.text.trim().isEmpty ||
        _serialPhoneController.text.trim().isEmpty ||
        _serialSelectedDoctor == null ||
        _serialSelectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('অনুগ্রহ করে সকল প্রয়োজনীয় তথ্য (ডাক্তার ও তারিখ সহ) পূরণ করুন।'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final formattedDate =
        '${_serialSelectedDate!.year}-${_serialSelectedDate!.month.toString().padLeft(2, '0')}-${_serialSelectedDate!.day.toString().padLeft(2, '0')}';

    // Trigger API call (logs request & response details to terminal)
    final responseData = await ApiService.bookDoctorSerial(
      patientName: _serialNameController.text.trim(),
      patientPhone: _serialPhoneController.text.trim(),
      doctorName: _serialSelectedDoctor!.name,
      hospital: _serialHospitalController.text.trim().isEmpty ? _serialSelectedDoctor!.hospital : _serialHospitalController.text.trim(),
      preferredDate: formattedDate,
      degree: _serialSelectedDoctor!.degree,
      specialty: _serialSelectedDoctor!.specialty,
      fee: _serialSelectedDoctor!.fee,
      screen: 'Doctor Bari View (Chamber Serial Tab)',
    );

    // Check if device is offline
    if (responseData['is_offline'] == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  responseData['message'] ?? 'কোনো ইন্টারনেট সংযোগ নেই! অনুগ্রহ করে কানেকশন চেক করুন।',
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    final ticketId = responseData['ticket_id'] as String? ?? '#MS-84920';

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: brandGreen, size: 38),
              ),
              const SizedBox(height: 16),
              const Text(
                'সিরিয়াল রিকোয়েস্ট জমা হয়েছে!',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'টিকেট আইডি: $ticketId',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: darkGreen),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'মেডিসেবা প্রতিনিধি শীঘ্রই আপনার প্রদত্ত নম্বরে কল করে প্রফেসরের সিরিয়াল নিশ্চিত করবেন।',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.35),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _serialNameController.clear();
                      _serialPhoneController.clear();
                      _serialHospitalController.clear();
                      _serialSelectedDoctor = null;
                      _serialSelectedDate = null;
                      _selectedTab = 0; // Return to doctor list
                    });
                  },
                  child: const Text('ঠিক আছে', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        title: _langController.tr('ডাক্তার ঘর', 'Doctor Ghar Portal'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: brandGreen,
                onRefresh: () => _doctorController.fetchDoctors(forceRefresh: true),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Hero Gradient Banner (Matching Web Portal)
                      _buildHeroBanner(),

                      // 2. In-place Dynamic Content Area based on Selected Tab
                      _selectedTab == 0
                          ? _buildDoctorListContent()
                          : _buildChamberSerialInlineForm(),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Hero Gradient Banner matching Web Portal with Tab Buttons
  Widget _buildHeroBanner() {
    final isTab0 = _selectedTab == 0;
    final isTab1 = _selectedTab == 1;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [darkGreen, Color(0xFF008536), Color(0xFF05583D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Pill Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.health_and_safety_rounded, color: Colors.white, size: 15),
                SizedBox(width: 6),
                Text(
                  'ডাক্তার ঘর (Doctor Ghar Portal)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Banner Title
          const Text(
            'অনলাইন ভিডিও কনসালটেশন ও খ্যাতনামা ডাক্তারের সিরিয়াল বুকিং',
            style: TextStyle(
              fontSize: 18.5,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),

          // Banner Subtitle
          Text(
            'মেডিসেবা প্ল্যাটফর্মে অনলাইন বিএমডিসি রেজিস্টার্ড ডাক্তার দেখান অথবা দেশের খ্যাতনামা প্রফেসরের চেম্বার সিরিয়াল নেওয়ার দায়িত্ব মেডিসেবা-কে দিন।',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.92),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),

          // Action Tab Buttons Row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Button 1: Instant Online Doctor (Tab 0)
              GestureDetector(
                onTap: () => setState(() => _selectedTab = 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isTab0 ? Colors.white : Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isTab0 ? Colors.white : Colors.white.withValues(alpha: 0.5),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.videocam_rounded,
                        size: 16,
                        color: isTab0 ? darkGreen : Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'অনলাইন ডাক্তার ইনস্ট্যান্ট',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isTab0 ? FontWeight.w800 : FontWeight.w600,
                          color: isTab0 ? darkGreen : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Button 2: Chamber Serial Request (Tab 1)
              GestureDetector(
                onTap: () => setState(() => _selectedTab = 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isTab1 ? Colors.white : Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isTab1 ? Colors.white : Colors.white.withValues(alpha: 0.5),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        size: 16,
                        color: isTab1 ? darkGreen : Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'বিখ্যাত ডাক্তারের চেম্বার সিরিয়াল রিকোয়েস্ট',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isTab1 ? FontWeight.w800 : FontWeight.w600,
                          color: isTab1 ? darkGreen : Colors.white,
                        ),
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

  /// Content 0: Online Doctors List with Search & Filters
  Widget _buildDoctorListContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Search Box
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => _doctorController.searchDoctors(val),
              decoration: InputDecoration(
                hintText: 'ডাক্তারের নাম, বিশেষজ্ঞ বা হাসপাতাল দিয়ে খুঁজুন...',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
                prefixIcon: const Icon(Icons.search_rounded, color: brandGreen, size: 22),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, color: Color(0xFF94A3B8), size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _doctorController.searchDoctors('');
                          setState(() {});
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),

        // 2. Specialty Categories Chips Carousel
        ListenableBuilder(
          listenable: _doctorController,
          builder: (context, child) {
            return SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _doctorController.selectedSpecialty == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () => _doctorController.filterBySpecialty(cat),
                      child: _buildCategoryChip(cat, isSelected: isSelected),
                    ),
                  );
                },
              ),
            );
          },
        ),

        const SizedBox(height: 14),

        // 3. Results Stats & Sort Header Bar
        ListenableBuilder(
          listenable: _doctorController,
          builder: (context, child) {
            final count = _doctorController.doctors.length;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: brandGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$count জন বিশেষজ্ঞ ডাক্তার',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF15803D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.tune_rounded, size: 16, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        'প্রাসঙ্গিকতা',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 10),

        // 4. Doctors List Cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListenableBuilder(
            listenable: _doctorController,
            builder: (context, child) {
              if (_doctorController.isLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(
                    child: CircularProgressIndicator(color: brandGreen),
                  ),
                );
              }

              if (_doctorController.errorMessage != null && _doctorController.doctors.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off_rounded, size: 50, color: Colors.grey),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            _doctorController.errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandGreen,
                          ),
                          onPressed: () => _doctorController.fetchDoctors(),
                          icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
                          label: const Text('পুনরায় চেষ্টা করুন', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (_doctorController.doctors.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 50.0),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded, size: 54, color: Color(0xFFCBD5E1)),
                        SizedBox(height: 10),
                        Text(
                          'কোনো ডাক্তার পাওয়া যায়নি',
                          style: TextStyle(color: Color(0xFF475569), fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'অন্য কোনো ফিল্টার বা সার্চ দিয়ে চেষ্টা করুন',
                          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _doctorController.doctors.length,
                itemBuilder: (context, index) {
                  final doctor = _doctorController.doctors[index];
                  return DoctorCard(
                    doctor: doctor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorDetailsView(
                            doctor: doctor,
                            languageController: widget.languageController,
                          ),
                        ),
                      );
                    },
                    onBookTap: () {
                      if (doctor.isAvailableToday) {
                        EpsPaymentGatewayDialog.show(
                          context: context,
                          packageName: doctor.name.isEmpty ? 'Instant Medicine Doctor Consultation' : doctor.name,
                          price: doctor.consultationFee.toInt() > 0 ? doctor.consultationFee.toInt() : 800,
                          points: 999,
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookAppointmentView(doctor: doctor),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Content 1: Famous Doctor Chamber Serial Request Form Card (In-place)
  Widget _buildChamberSerialInlineForm() {
    final dateText = _serialSelectedDate == null
        ? 'তারিখ নির্বাচন করুন'
        : '${_serialSelectedDate!.day}/${_serialSelectedDate!.month}/${_serialSelectedDate!.year}';

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.stars_rounded, color: brandGreen, size: 14),
                SizedBox(width: 5),
                Text(
                  'বিখ্যাত সিরিয়াল সার্ভিস (Famous Doctor Serial)',
                  style: TextStyle(color: darkGreen, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'দেশের বিখ্যাত ডাক্তারের সিরিয়াল নিন সহজে',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 4),
          const Text(
            'ঢাকা, রাজশাহী বা যেকোনো শহরের প্রফেসরের সিরিয়াল নিতে নিচের ফর্ম সাবমিট করুন। মেডিসেবা টিম সিরিয়াল নিয়ে আপনাকে কনফার্ম করবে।',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
          ),

          const SizedBox(height: 20),

          // Field 1: Patient Name
          _buildFieldLabel('রোগীর নাম *'),
          const SizedBox(height: 6),
          _buildFormTextField(
            controller: _serialNameController,
            hint: 'রোগীর পূর্ণ নাম লিখুন...',
            icon: Icons.person_outline_rounded,
          ),

          const SizedBox(height: 14),

          // Field 2: Mobile Number
          _buildFieldLabel('মোবাইল নম্বর *'),
          const SizedBox(height: 6),
          _buildFormTextField(
            controller: _serialPhoneController,
            hint: '017XXXXXXXX',
            icon: Icons.phone_android_rounded,
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 14),

          // Field 3: Desired Doctor / Specialty (Searchable UI/UX Picker)
          _buildFieldLabel('কাঙ্ক্ষিত ডাক্তারের নাম / স্পেশালিস্ট *'),
          const SizedBox(height: 6),
          InkWell(
            onTap: _openDoctorPickerModal,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _serialSelectedDoctor != null ? brandGreen : const Color(0xFFCBD5E1),
                  width: _serialSelectedDoctor != null ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: _serialSelectedDoctor != null ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.medical_services_outlined,
                      size: 18,
                      color: _serialSelectedDoctor != null ? brandGreen : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _serialSelectedDoctor != null
                        ? Text(
                            _serialSelectedDoctor!.name,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          )
                        : const Text(
                            'ডাক্তার বা স্পেশালিস্ট নির্বাচন করুন...',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                          ),
                  ),
                  const Icon(Icons.unfold_more_rounded, color: Color(0xFF64748B), size: 20),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Field 4: Hospital / Chamber (Optional)
          _buildFieldLabel('হাসপাতাল / চেম্বার (Optional)'),
          const SizedBox(height: 6),
          _buildFormTextField(
            controller: _serialHospitalController,
            hint: 'যেমন: ল্যাবএইড হাসপাতাল / পপুলার হাসপাতাল',
            icon: Icons.local_hospital_outlined,
          ),

          const SizedBox(height: 14),

          // Field 5: Preferred Date Picker
          _buildFieldLabel('পছন্দের তারিখ *'),
          const SizedBox(height: 6),
          InkWell(
            onTap: _pickSerialDate,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 18, color: brandGreen),
                  const SizedBox(width: 10),
                  Text(
                    dateText,
                    style: TextStyle(
                      fontSize: 13,
                      color: _serialSelectedDate == null ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                      fontWeight: _serialSelectedDate == null ? FontWeight.normal : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 22),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _submitSerialForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: brandGreen,
                elevation: 2,
                shadowColor: brandGreen.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              label: const Text(
                'সিরিয়াল রিকোয়েস্ট পাঠান',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
    );
  }

  Widget _buildFormTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
          prefixIcon: Icon(icon, size: 18, color: const Color(0xFF64748B)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  /// Build Specialty Filter Chip
  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? brandGreen : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? brandGreen : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: brandGreen.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected) ...[
            const Icon(Icons.check_rounded, color: Colors.white, size: 15),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}
