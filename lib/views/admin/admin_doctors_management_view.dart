import 'package:flutter/material.dart';
import 'admin_dashboard_view.dart';
import 'admin_inbox_view.dart';
import 'admin_job_circulars_view.dart';
import 'admin_patient_records_view.dart';

class AdminDoctorsManagementView extends StatefulWidget {
  const AdminDoctorsManagementView({super.key});

  @override
  State<AdminDoctorsManagementView> createState() => _AdminDoctorsManagementViewState();
}

class _AdminDoctorsManagementViewState extends State<AdminDoctorsManagementView> {
  static const brandGreen = Color(0xFF0F9D58);
  static const darkGreen = Color(0xFF006B4A);
  static const textDark = Color(0xFF0F172A);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Initial Mock Data Matching Web Screenshot Precisely
  final List<Map<String, dynamic>> _doctors = [
    {
      'id': 'doc_101',
      'name': 'Dr. Ahmed Rahman',
      'specialty': 'Cardiology • Consultant',
      'bmdc': 'BMDC-590025',
      'fee': 800,
      'email': 'ahmed@mediseba.test',
      'phone': '01710000001',
      'isActive': false,
      'isVerified': true,
      'initial': 'R',
      'avatarBg': const Color(0xFFDCFCE7),
      'avatarColor': const Color(0xFF15803D),
    },
    {
      'id': 'doc_102',
      'name': 'Dr. Farzana Islam',
      'specialty': 'Medicine • Consultant',
      'bmdc': 'BMDC-559743',
      'fee': 800,
      'email': 'farzana@mediseba.test',
      'phone': '01710000002',
      'isActive': true,
      'isVerified': false,
      'initial': 'I',
      'avatarBg': const Color(0xFFDCFCE7),
      'avatarColor': const Color(0xFF15803D),
    },
    {
      'id': 'doc_103',
      'name': 'Dr. Imran Kabir',
      'specialty': 'Neurology • Consultant',
      'bmdc': 'BMDC-950496',
      'fee': 800,
      'email': 'imran@mediseba.test',
      'phone': '01710000003',
      'isActive': true,
      'isVerified': true,
      'initial': 'K',
      'avatarBg': const Color(0xFFDCFCE7),
      'avatarColor': const Color(0xFF15803D),
    },
    {
      'id': 'doc_104',
      'name': 'Dr. Nusrat Jahan',
      'specialty': 'Gynecology & Obstetrics • Consultant',
      'bmdc': 'BMDC-386513',
      'fee': 800,
      'email': 'nusrat@mediseba.test',
      'phone': '01710000004',
      'isActive': true,
      'isVerified': true,
      'initial': 'J',
      'avatarBg': const Color(0xFFDCFCE7),
      'avatarColor': const Color(0xFF15803D),
    },
    {
      'id': 'doc_105',
      'name': 'Dr. Tanvir Hasan',
      'specialty': 'Orthopedics • Consultant',
      'bmdc': 'BMDC-594863',
      'fee': 800,
      'email': 'tanvir@mediseba.test',
      'phone': '01710000005',
      'isActive': true,
      'isVerified': true,
      'initial': 'H',
      'avatarBg': const Color(0xFFDCFCE7),
      'avatarColor': const Color(0xFF15803D),
    },
    {
      'id': 'doc_106',
      'name': 'Dr. Samiul Sajib',
      'specialty': 'Chest Specialist • Consultant',
      'bmdc': 'BMDC-138505',
      'fee': 800,
      'email': 'sajib@mediseba.test',
      'phone': '01710000006',
      'isActive': true,
      'isVerified': true,
      'initial': 'S',
      'avatarBg': const Color(0xFFDCFCE7),
      'avatarColor': const Color(0xFF15803D),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredDoctors {
    if (_searchQuery.trim().isEmpty) {
      return _doctors;
    }
    final q = _searchQuery.toLowerCase().trim();
    return _doctors.where((doc) {
      return doc['name'].toString().toLowerCase().contains(q) ||
          doc['specialty'].toString().toLowerCase().contains(q) ||
          doc['bmdc'].toString().toLowerCase().contains(q) ||
          doc['phone'].toString().toLowerCase().contains(q);
    }).toList();
  }

  void _toggleDoctorStatus(int index) {
    setState(() {
      _doctors[index]['isActive'] = !(_doctors[index]['isActive'] as bool);
    });
    final bool active = _doctors[index]['isActive'];
    final String name = _doctors[index]['name'];

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          active
              ? '$name এর প্রোফাইল সক্রিয় (Active) করা হয়েছে!'
              : '$name এর প্রোফাইল ইন-এক্টিভ (Inactive) করা হয়েছে।',
        ),
        backgroundColor: active ? brandGreen : const Color(0xFFDC2626),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleDoctorVerification(int index) {
    setState(() {
      _doctors[index]['isVerified'] = !(_doctors[index]['isVerified'] as bool);
    });
    final bool verified = _doctors[index]['isVerified'];
    final String name = _doctors[index]['name'];

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          verified
              ? '$name এর BMDC লাইসেন্স সফলভাবে ভেরিফাইড করা হয়েছে!'
              : '$name এর BMDC ভেরিফিকেশন পেন্ডিং অবস্থায় রাখা হয়েছে।',
        ),
        backgroundColor: verified ? brandGreen : const Color(0xFFD97706),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCreateDoctorModal() {
    final nameController = TextEditingController();
    final specialtyController = TextEditingController();
    final bmdcController = TextEditingController();
    final feeController = TextEditingController(text: '800');
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    bool isVerified = true;
    bool isActive = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.person_add_alt_1_rounded, color: brandGreen, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'নতুন ডাক্তার প্রোফাইল যুক্ত করুন',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textDark),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    _buildInputField('ডাক্তারের পূর্ণ নাম *', nameController, 'যেমন: Dr. Md. Rafiqul Islam'),
                    const SizedBox(height: 12),

                    _buildInputField('স্পেশালিটি ও পদবি *', specialtyController, 'যেমন: Cardiology • Consultant'),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(child: _buildInputField('BMDC নম্বর *', bmdcController, 'BMDC-590000')),
                        const SizedBox(width: 10),
                        Expanded(child: _buildInputField('কনসালটেশন ফি (৳) *', feeController, '800', keyboardType: TextInputType.number)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(child: _buildInputField('ইমেইল ঠিকানা', emailController, 'doctor@mediseba.test', keyboardType: TextInputType.emailAddress)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildInputField('মোবাইল নম্বর *', phoneController, '01710000000', keyboardType: TextInputType.phone)),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Verification & Active Checkboxes
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('BMDC ভেরিফাইড', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            value: isVerified,
                            activeColor: brandGreen,
                            onChanged: (val) {
                              setModalState(() {
                                isVerified = val ?? true;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('এক্টিভ প্রোফাইল', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            value: isActive,
                            activeColor: brandGreen,
                            onChanged: (val) {
                              setModalState(() {
                                isActive = val ?? true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (nameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('দয়া করে ডাক্তারের নাম লিখুন')),
                            );
                            return;
                          }

                          final initialName = nameController.text.trim().replaceAll('Dr.', '').trim();
                          final initialChar = initialName.isNotEmpty ? initialName[0].toUpperCase() : 'D';

                          setState(() {
                            _doctors.insert(0, {
                              'id': 'doc_${DateTime.now().millisecondsSinceEpoch}',
                              'name': nameController.text.trim(),
                              'specialty': specialtyController.text.trim().isEmpty ? 'General Physician' : specialtyController.text.trim(),
                              'bmdc': bmdcController.text.trim().isEmpty ? 'BMDC-PENDING' : bmdcController.text.trim(),
                              'fee': int.tryParse(feeController.text.trim()) ?? 800,
                              'email': emailController.text.trim().isEmpty ? 'doctor@mediseba.test' : emailController.text.trim(),
                              'phone': phoneController.text.trim().isEmpty ? '01700000000' : phoneController.text.trim(),
                              'isActive': isActive,
                              'isVerified': isVerified,
                              'initial': initialChar,
                              'avatarBg': const Color(0xFFDCFCE7),
                              'avatarColor': const Color(0xFF15803D),
                            });
                          });

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('নতুন ডাক্তার প্রোফাইল সফলভাবে তৈরি হয়েছে!'),
                              backgroundColor: brandGreen,
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle_rounded, size: 18),
                        label: const Text(
                          'ডাক্তার যুক্ত করুন',
                          style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditDoctorModal(Map<String, dynamic> item, int index) {
    String rawSpecialty = item['specialty'] as String;
    String initialSpecialty = rawSpecialty;
    String initialDesignation = 'Consultant';
    if (rawSpecialty.contains('•')) {
      final parts = rawSpecialty.split('•');
      initialSpecialty = parts[0].trim();
      initialDesignation = parts[1].trim();
    }

    final nameController = TextEditingController(text: item['name']);
    final phoneController = TextEditingController(text: item['phone']);
    final bmdcController = TextEditingController(text: item['bmdc']);
    final specialtyController = TextEditingController(text: initialSpecialty);
    final designationController = TextEditingController(text: initialDesignation);
    final feeController = TextEditingController(text: item['fee'].toString());

    bool currentActive = item['isActive'] as bool;
    bool currentVerified = item['isVerified'] as bool;

    showDialog(
      context: context,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 550;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 580),
                padding: const EdgeInsets.all(18),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row matching Web Pop-up (Fully un-overflowable)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFA7F3D0)),
                            ),
                            child: const Icon(Icons.edit_note_rounded, color: brandGreen, size: 20),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'ডাক্তার প্রোফাইল ও স্ট্যাটাস এডিট',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel_outlined, color: Color(0xFF94A3B8), size: 22),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Form Grid (Responsive: 1 column on Mobile, 2 column on Desktop)
                      if (isMobile) ...[
                        _buildWebStyledInput('ডাক্তারের নাম', nameController),
                        const SizedBox(height: 10),
                        _buildWebStyledInput('মোবাইল নম্বর', phoneController, keyboardType: TextInputType.phone),
                        const SizedBox(height: 10),
                        _buildWebStyledInput('বিএমডিসি নম্বর', bmdcController),
                        const SizedBox(height: 10),
                        _buildWebStyledInput('স্পেশালিটি', specialtyController),
                        const SizedBox(height: 10),
                        _buildWebStyledInput('পদবী (Designation)', designationController),
                        const SizedBox(height: 10),
                        _buildWebStyledInput('কনসালটেশন ফি (BDT)', feeController, keyboardType: TextInputType.number),
                        const SizedBox(height: 10),
                        _buildDropdownField(
                          label: 'অ্যাকাউন্ট স্ট্যাটাস',
                          value: currentActive,
                          items: const [
                            DropdownMenuItem(value: true, child: Text('এক্টিভ (Active)')),
                            DropdownMenuItem(value: false, child: Text('ইন-এক্টিভ (Inactive)')),
                          ],
                          onChanged: (val) {
                            if (val != null) setModalState(() => currentActive = val);
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildDropdownField(
                          label: 'BMDC ভেরিফিকেশন',
                          value: currentVerified,
                          items: const [
                            DropdownMenuItem(value: true, child: Text('ভেরিফাইড (Verified)')),
                            DropdownMenuItem(value: false, child: Text('পেন্ডিং (Pending Verification)')),
                          ],
                          onChanged: (val) {
                            if (val != null) setModalState(() => currentVerified = val);
                          },
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(child: _buildWebStyledInput('ডাক্তারের নাম', nameController)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildWebStyledInput('মোবাইল নম্বর', phoneController, keyboardType: TextInputType.phone)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _buildWebStyledInput('বিএমডিসি নম্বর', bmdcController)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildWebStyledInput('স্পেশালিটি', specialtyController)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _buildWebStyledInput('পদবী (Designation)', designationController)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildWebStyledInput('কনসালটেশন ফি (BDT)', feeController, keyboardType: TextInputType.number)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdownField(
                                label: 'অ্যাকাউন্ট স্ট্যাটাস',
                                value: currentActive,
                                items: const [
                                  DropdownMenuItem(value: true, child: Text('এক্টিভ (Active)')),
                                  DropdownMenuItem(value: false, child: Text('ইন-এক্টিভ (Inactive)')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setModalState(() => currentActive = val);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDropdownField(
                                label: 'BMDC ভেরিফিকেশন',
                                value: currentVerified,
                                items: const [
                                  DropdownMenuItem(value: true, child: Text('ভেরিফাইড (Verified)')),
                                  DropdownMenuItem(value: false, child: Text('পেন্ডিং (Pending Verification)')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setModalState(() => currentVerified = val);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Action Buttons Row matching Web Screenshot
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Cancel Button (বাতিল)
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFF1F5F9),
                              foregroundColor: const Color(0xFF475569),
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('বাতিল', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),

                          // Save Button (তথ্য আপডেট করুন) matching Web Screenshot button
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: brandGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              final spec = specialtyController.text.trim();
                              final desig = designationController.text.trim();
                              final fullSpecialty = desig.isNotEmpty ? '$spec • $desig' : spec;

                              setState(() {
                                _doctors[index]['name'] = nameController.text.trim();
                                _doctors[index]['phone'] = phoneController.text.trim();
                                _doctors[index]['bmdc'] = bmdcController.text.trim();
                                _doctors[index]['specialty'] = fullSpecialty;
                                _doctors[index]['fee'] = int.tryParse(feeController.text.trim()) ?? 800;
                                _doctors[index]['isActive'] = currentActive;
                                _doctors[index]['isVerified'] = currentVerified;
                              });

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ডাক্তার প্রোফাইল ও স্ট্যাটাস সফলভাবে আপডেট করা হয়েছে!'),
                                  backgroundColor: brandGreen,
                                ),
                              );
                            },
                            icon: const Icon(Icons.save_outlined, size: 18),
                            label: const Text(
                              'তথ্য আপডেট করুন',
                              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdownField({
    required String label,
    required bool value,
    required List<DropdownMenuItem<bool>> items,
    required ValueChanged<bool?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: value ? brandGreen : const Color(0xFFE2E8F0),
              width: value ? 1.5 : 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<bool>(
              value: value,
              isExpanded: true,
              isDense: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF475569)),
              style: const TextStyle(fontSize: 12.5, color: textDark, fontWeight: FontWeight.w600),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWebStyledInput(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 13, color: textDark, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: brandGreen, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, String hint, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 13, color: textDark, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: brandGreen, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredDoctors;
    final activeCount = _doctors.where((d) => d['isActive'] == true).length;

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
          children: const [
            Text(
              'ডাক্তার ম্যানেজমেন্ট',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),
            Text(
              'ADMIN CONTROL PANEL',
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: brandGreen,
                letterSpacing: 0.5,
              ),
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
                  content: Text('ডাক্তার ডাটা ক্যাশ রিফ্রেশ করা হয়েছে'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'ক্যাশ রিফ্রেশ',
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
              // 1. TOP HEADER BANNER matching Web Visual
              _buildHeaderPanel(),

              const SizedBox(height: 16),

              // 2. SEARCH BAR matching Web Visual
              _buildSearchBar(),

              const SizedBox(height: 16),

              // 3. DOCTOR CARDS GRID / LIST
              if (filtered.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.person_search_rounded, size: 44, color: Color(0xFF94A3B8)),
                      const SizedBox(height: 10),
                      const Text(
                        'কোনো ডাক্তার খুঁজে পাওয়া যায়নি',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '"$_searchQuery" শব্দ দিয়ে কোনো ডাক্তার নিবন্ধিত নেই।',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final realIndex = _doctors.indexOf(item);
                    return _buildDoctorCard(item, realIndex);
                  },
                ),

              const SizedBox(height: 16),

              // Footer Counter matching Screenshot: "দেখাচ্ছে ১ - ৬ জন (মোট ৬ জন সক্রিয় ডাক্তার রেকর্ডস)"
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'দেখাচ্ছে ১ - ${filtered.length} জন (মোট $activeCount জন সক্রিয় ডাক্তার রেকর্ডস)',
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// 1. Build Header Panel matching Web Screenshot
  Widget _buildHeaderPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
              Icon(Icons.medical_services_rounded, color: brandGreen, size: 22),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ডাক্তার ম্যানেজমেন্ট (Doctor Management)',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'ডাক্তার তথ্য এডিট, এক্টিভ/ইন-এক্টিভ মোড, বিএমডিসি লাইসেন্স ভেরিফাই ও ফি নিয়ন্ত্রণ করুন।',
            style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B), height: 1.4),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF334155),
                  side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ক্যাশ রিফ্রেশ সম্পন্ন হয়েছে')),
                  );
                },
                icon: const Icon(Icons.sync_rounded, size: 16, color: brandGreen),
                label: const Text('ক্যাশ রিফ্রেশ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _showCreateDoctorModal,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('+ নতুন ডাক্তার যুক্ত করুন', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 2. Build Search Bar
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
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
        style: const TextStyle(fontSize: 13, color: textDark, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: 'ডাক্তারের নাম, স্পেশালিটি বা বিএমডিসি নম্বর দিয়ে খুঁজুন...',
          hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18, color: Color(0xFF94A3B8)),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  /// 3. Build Doctor Card matching Screenshot
  Widget _buildDoctorCard(Map<String, dynamic> item, int index) {
    final bool isActive = item['isActive'] as bool;
    final bool isVerified = item['isVerified'] as bool;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isActive ? const Color(0xFFE2E8F0) : const Color(0xFFFCA5A5),
          width: 1.2,
        ),
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
          // Header Row: Avatar + Name & Specialty + Active/Inactive Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Circle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item['avatarBg'] as Color? ?? const Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    item['initial'] as String? ?? 'D',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: item['avatarColor'] as Color? ?? const Color(0xFF15803D),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Doctor Name & Specialty
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item['name'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded, color: brandGreen, size: 16),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['specialty'] as String,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F766E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              // Active / Inactive Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? const Color(0xFF86EFAC) : const Color(0xFFFCA5A5),
                  ),
                ),
                child: Text(
                  isActive ? 'এক্টিভ (Active)' : 'ইন-এক্টিভ (Inactive)',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: isActive ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Meta Info Table: BMDC, Fee, Email, Phone matching screenshot layout
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'BMDC: ',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                        children: [
                          TextSpan(
                            text: item['bmdc'] as String,
                            style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'ফি: ',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                        children: [
                          TextSpan(
                            text: '৳ ${item['fee']}',
                            style: const TextStyle(color: brandGreen, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'ইমেইল: ',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                          children: [
                            TextSpan(
                              text: item['email'] as String,
                              style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text.rich(
                      TextSpan(
                        text: 'ফোন: ',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                        children: [
                          TextSpan(
                            text: item['phone'] as String,
                            style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // 3 Action Buttons Row: Verify (ভেরিফাইড / এপ্রুভ করুন), Edit (এডিট), Status Toggle (ইন-এক্টিভ করুন / এক্টিভ করুন)
          Row(
            children: [
              // 1. Verify Toggle Button
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isVerified ? brandGreen : const Color(0xFFD97706),
                    backgroundColor: isVerified ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7),
                    side: BorderSide(
                      color: isVerified ? const Color(0xFFA7F3D0) : const Color(0xFFFDE68A),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _toggleDoctorVerification(index),
                  icon: Icon(
                    isVerified ? Icons.verified_user_rounded : Icons.gpp_maybe_rounded,
                    size: 13,
                  ),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      isVerified ? 'ভেরিফাইড' : 'এপ্রুভ করুন',
                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),

              // 2. Edit Button
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0284C7),
                    backgroundColor: const Color(0xFFF0F9FF),
                    side: const BorderSide(color: Color(0xFFBAE6FD)),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _showEditDoctorModal(item, index),
                  icon: const Icon(Icons.edit_outlined, size: 13),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'এডিট',
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),

              // 3. Active/Inactive Toggle Button (Single-line fitted text)
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isActive ? const Color(0xFFDC2626) : brandGreen,
                    backgroundColor: isActive ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
                    side: BorderSide(
                      color: isActive ? const Color(0xFFFECACA) : const Color(0xFFA7F3D0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _toggleDoctorStatus(index),
                  icon: Icon(
                    isActive ? Icons.power_settings_new_rounded : Icons.flash_on_rounded,
                    size: 13,
                  ),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      isActive ? 'ইন-এক্টিভ করুন' : 'এক্টিভ করুন',
                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build Navigation Drawer matching Image 1
  Widget _buildAdminDrawer(BuildContext context) {
    final menuItems = [
      {'title': 'ড্যাশবোর্ড (Overview)', 'icon': Icons.dashboard_rounded, 'selected': false},
      {'title': 'ইনবক্স ও অ্যাপ্লিকেশন', 'icon': Icons.mail_outline_rounded, 'selected': false},
      {'title': 'চাকরি ও নিয়োগ সার্কুলার', 'icon': Icons.work_outline_rounded, 'selected': false},
      {'title': 'ডাক্তার ম্যানেজমেন্ট', 'icon': Icons.medical_services_outlined, 'selected': true},
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
          // Drawer Header matching Image 1
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
                        if (index == 0) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminDashboardView(),
                            ),
                          );
                        } else if (index == 1) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminInboxView(),
                            ),
                          );
                        } else if (index == 2) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminJobCircularsView(),
                            ),
                          );
                        } else if (index == 4) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminPatientRecordsView(),
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

          // Admin User Profile Footer matching Image 1
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
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textDark),
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
                      Navigator.pop(context); // Exit admin panel back to app
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
