import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/api_service.dart';

class DoctorOptionItem {
  final String name;
  final String degree;
  final String specialty;
  final String hospital;
  final String experience;
  final double rating;
  final String consultationCount;
  final int fee;

  const DoctorOptionItem({
    required this.name,
    required this.degree,
    required this.specialty,
    required this.hospital,
    required this.experience,
    this.rating = 4.9,
    this.consultationCount = '700+',
    this.fee = 800,
  });
}

class FamousDoctorSerialSheet extends StatefulWidget {
  const FamousDoctorSerialSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FamousDoctorSerialSheet(),
    );
  }

  @override
  State<FamousDoctorSerialSheet> createState() => _FamousDoctorSerialSheetState();
}

class _FamousDoctorSerialSheetState extends State<FamousDoctorSerialSheet> {
  static const brandGreen = Color(0xFF0F9D58);
  static const darkGreen = Color(0xFF006B4A);
  static const textDark = Color(0xFF0F172A);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _hospitalController = TextEditingController();
  DoctorOptionItem? _selectedDoctor;
  DateTime? _selectedDate;

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
                              final isSelected = _selectedDoctor?.name == item.name;

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedDoctor = item;
                                    if (item.hospital.isNotEmpty) {
                                      _hospitalController.text = item.hospital;
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
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _hospitalController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: brandGreen,
              onPrimary: Colors.white,
              onSurface: textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _makeCall() async {
    final Uri launchUri = Uri(scheme: 'tel', path: '09647111666');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _submit() async {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _selectedDoctor == null ||
        _selectedDate == null) {
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
        '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';

    // Trigger API call (logs request & response details to terminal)
    final responseData = await ApiService.bookDoctorSerial(
      patientName: _nameController.text.trim(),
      patientPhone: _phoneController.text.trim(),
      doctorName: _selectedDoctor!.name,
      hospital: _hospitalController.text.trim().isEmpty ? _selectedDoctor!.hospital : _hospitalController.text.trim(),
      preferredDate: formattedDate,
      degree: _selectedDoctor!.degree,
      specialty: _selectedDoctor!.specialty,
      fee: _selectedDoctor!.fee,
      screen: 'Famous Doctor Serial Sheet Modal',
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
    Navigator.pop(context); // Close form sheet

    // Show Success Confirmation Sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: brandGreen, size: 44),
              ),
              const SizedBox(height: 16),
              const Text(
                'চেম্বার সিরিয়াল রিকোয়েস্ট জমা হয়েছে!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'টিকেট আইডি: $ticketId',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: darkGreen),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'মেডিসেবা প্রতিনিধি শীঘ্রই আপনার প্রদত্ত মোবাইল নম্বরে কল করে প্রফেসরের চেম্বার সিরিয়াল কনফার্ম করবে।',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _makeCall,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 18),
                  label: const Text(
                    'জরুরি হটলাইনে কল দিন (09647111666)',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.5),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('বন্ধ করুন', style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600)),
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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final dateText = _selectedDate == null
        ? 'তারিখ নির্বাচন করুন'
        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header Badge & Title
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

              const SizedBox(height: 10),

              const Text(
                'দেশের বিখ্যাত ডাক্তারের সিরিয়াল নিন সহজে',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textDark),
              ),
              const SizedBox(height: 4),
              const Text(
                'ঢাকা, রাজশাহী বা যেকোনো শহরের প্রফেসরের চেম্বার সিরিয়াল বুক করতে নিচের ফর্ম সাবমিট করুন।',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.35),
              ),

              const SizedBox(height: 18),

              // Field 1: Patient Name
              _buildFieldLabel('রোগীর নাম *'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _nameController,
                hint: 'রোগীর পূর্ণ নাম লিখুন...',
                icon: Icons.person_outline_rounded,
              ),

              const SizedBox(height: 14),

              // Field 2: Mobile Number
              _buildFieldLabel('মোবাইল নম্বর *'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _phoneController,
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
                      color: _selectedDoctor != null ? brandGreen : const Color(0xFFCBD5E1),
                      width: _selectedDoctor != null ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: _selectedDoctor != null ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.medical_services_outlined,
                          size: 18,
                          color: _selectedDoctor != null ? brandGreen : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _selectedDoctor != null
                            ? Text(
                                _selectedDoctor!.name,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textDark),
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
              _buildTextField(
                controller: _hospitalController,
                hint: 'যেমন: ল্যাবএইড হাসপাতাল / পপুলার হাসপাতাল',
                icon: Icons.local_hospital_outlined,
              ),

              const SizedBox(height: 14),

              // Field 5: Preferred Date Picker
              _buildFieldLabel('পছন্দের তারিখ *'),
              const SizedBox(height: 6),
              InkWell(
                onTap: _pickDate,
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
                          color: _selectedDate == null ? const Color(0xFF94A3B8) : textDark,
                          fontWeight: _selectedDate == null ? FontWeight.normal : FontWeight.w600,
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
                  onPressed: _submit,
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
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: textDark),
    );
  }

  Widget _buildTextField({
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
        style: const TextStyle(fontSize: 13, color: textDark),
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
}
