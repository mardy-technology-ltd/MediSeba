import 'package:flutter/material.dart';
import 'admin_drawer.dart';
import 'dart:async';
import '../../services/api_service.dart';
import '../../services/cache_service.dart';
import '../../controllers/auth_controller.dart';

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

  List<Map<String, dynamic>> _doctors = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _fetchDoctors(forceRefresh: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredDoctors => _doctors;

  Future<void> _fetchDoctors({bool forceRefresh = false}) async {
    if (_isLoading && !forceRefresh) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      if (forceRefresh) {
        _doctors = [];
        _currentPage = 1;
      }
    });

    try {
      final token = AuthController.instance?.token ?? CacheService.get('auth_token') as String?;
      if (token == null) {
        setState(() {
          _errorMessage = 'লগইন সেশন পাওয়া যায়নি। দয়া করে আবার লগইন করুন।';
          _isLoading = false;
        });
        return;
      }

      final list = await ApiService.getAdminDoctors(
        token: token,
        search: _searchQuery,
        page: _currentPage,
        perPage: 15,
      );

      setState(() {
        if (forceRefresh) {
          _doctors = list;
        } else {
          _doctors.addAll(list);
        }
        _isLoading = false;
        if (list.length >= 15) {
          _currentPage++;
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'তথ্য লোড করতে সমস্যা হয়েছে: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleDoctorStatus(int index) async {
    final item = _doctors[index];
    final currentActive = (item['isActive'] == true || item['status'] == 'active');
    final newActive = !currentActive;
    final String name = item['name'] ?? 'Doctor';

    final token = AuthController.instance?.token ?? CacheService.get('auth_token') as String?;
    if (token == null) return;

    setState(() {
      _isLoading = true;
    });

    final payload = {
      'id': int.tryParse(item['id'].toString()) ?? item['id'],
      'name': item['name'],
      'phone': item['phone'],
      'email': item['email'] ?? '',
      'bmdc_number': item['bmdc_number'] ?? item['bmdc'] ?? '',
      'qualification': item['qualification'] ?? item['specialty'] ?? '',
      'designation': item['designation'] ?? 'Consultant',
      'speciality': item['speciality'] ?? item['specialty'] ?? 'General Medicine',
      'consultation_fee': int.tryParse(item['consultation_fee']?.toString() ?? item['fee']?.toString() ?? '800') ?? 800,
      'status': newActive ? 'active' : 'inactive',
    };

    final success = await ApiService.updateAdminDoctor(token: token, payload: payload);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newActive
                ? '$name এর প্রোফাইল সক্রিয় (Active) করা হয়েছে!'
                : '$name এর প্রোফাইল ইন-এক্টিভ (Inactive) করা হয়েছে।',
          ),
          backgroundColor: newActive ? brandGreen : const Color(0xFFDC2626),
          duration: const Duration(seconds: 2),
        ),
      );
      _fetchDoctors(forceRefresh: true);
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('স্ট্যাটাস আপডেট করতে সমস্যা হয়েছে।')),
      );
    }
  }

  Future<void> _deleteDoctor(String idOrUuid) async {
    final token = AuthController.instance?.token ?? CacheService.get('auth_token') as String?;
    if (token == null) return;

    setState(() {
      _isLoading = true;
    });

    final success = await ApiService.deleteAdminDoctor(token: token, idOrUuid: idOrUuid);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ডাক্তার প্রোফাইল সফলভাবে মুছে ফেলা হয়েছে।'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      _fetchDoctors(forceRefresh: true);
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ডিলিট করতে সমস্যা হয়েছে।')),
      );
    }
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
                        onPressed: () async {
                          if (nameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('দয়া করে ডাক্তারের নাম লিখুন')),
                            );
                            return;
                          }
                          if (phoneController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('দয়া করে মোবাইল নম্বর লিখুন')),
                            );
                            return;
                          }

                          final token = AuthController.instance?.token ?? CacheService.get('auth_token') as String?;
                          if (token == null) return;

                          final String phone = phoneController.text.trim();
                          final String password = 'doc${phone.length > 6 ? phone.substring(phone.length - 6) : '123456'}';

                          final payload = {
                            'name': nameController.text.trim(),
                            'phone': phone,
                            'email': emailController.text.trim().isEmpty ? '$phone@mediseba.org' : emailController.text.trim(),
                            'password': password,
                            'bmdc_number': bmdcController.text.trim().isEmpty ? 'BMDC-PENDING' : bmdcController.text.trim(),
                            'qualification': specialtyController.text.trim().isEmpty ? 'MBBS' : specialtyController.text.trim(),
                            'designation': 'Consultant',
                            'speciality': specialtyController.text.trim().isEmpty ? 'General Medicine' : specialtyController.text.trim(),
                            'consultation_fee': int.tryParse(feeController.text.trim()) ?? 800,
                          };

                          final success = await ApiService.createAdminDoctor(token: token, payload: payload);

                          if (context.mounted) {
                            Navigator.pop(context);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('নতুন ডাক্তার প্রোফাইল সফলভাবে তৈরি হয়েছে!'),
                                  backgroundColor: brandGreen,
                                ),
                              );
                              _fetchDoctors(forceRefresh: true);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ডাক্তার যুক্ত করতে সমস্যা হয়েছে।'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
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
                physics: const BouncingScrollPhysics(),
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
                        Row(
                          children: const [
                            Icon(Icons.edit_note_rounded, color: brandGreen, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'ডাক্তার প্রোফাইল এডিট করুন',
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

                    _buildInputField('ডাক্তারের পূর্ণ নাম *', nameController, 'যেমন: Dr. Ahmed Rahman'),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(child: _buildInputField('স্পেশালিটি *', specialtyController, 'যেমন: Cardiology')),
                        const SizedBox(width: 10),
                        Expanded(child: _buildInputField('পদবী (Designation) *', designationController, 'যেমন: Senior Consultant')),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(child: _buildInputField('BMDC নম্বর *', bmdcController, 'BMDC-371154')),
                        const SizedBox(width: 10),
                        Expanded(child: _buildInputField('কনসালটেশন ফি (৳) *', feeController, '800', keyboardType: TextInputType.number)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(child: _buildInputField('মোবাইল নম্বর *', phoneController, '01800000002', keyboardType: TextInputType.phone)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'স্ট্যাটাস',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<bool>(
                                    value: currentActive,
                                    isExpanded: true,
                                    isDense: true,
                                    style: const TextStyle(fontSize: 12.5, color: textDark, fontWeight: FontWeight.w600),
                                    items: const [
                                      DropdownMenuItem(value: true, child: Text('Active')),
                                      DropdownMenuItem(value: false, child: Text('Inactive')),
                                    ],
                                    onChanged: (val) {
                                      if (val != null) {
                                        setModalState(() {
                                          currentActive = val;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Verification Checkbox
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('BMDC ভেরিফাইড', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      value: currentVerified,
                      activeColor: brandGreen,
                      onChanged: (val) {
                        setModalState(() {
                          currentVerified = val ?? true;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          if (nameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('দয়া করে ডাক্তারের নাম লিখুন')),
                            );
                            return;
                          }

                          final token = AuthController.instance?.token ?? CacheService.get('auth_token') as String?;
                          if (token == null) return;

                          final spec = specialtyController.text.trim();
                          final desig = designationController.text.trim();

                          final payload = {
                            'id': int.tryParse(item['id'].toString()) ?? item['id'],
                            'name': nameController.text.trim(),
                            'phone': phoneController.text.trim(),
                            'email': item['email'] ?? '',
                            'bmdc_number': bmdcController.text.trim(),
                            'qualification': desig.isNotEmpty ? '$spec • $desig' : spec,
                            'designation': desig.isEmpty ? 'Consultant' : desig,
                            'speciality': spec.isEmpty ? 'General Medicine' : spec,
                            'consultation_fee': int.tryParse(feeController.text.trim()) ?? 800,
                            'status': currentActive ? 'active' : 'inactive',
                          };

                          final success = await ApiService.updateAdminDoctor(token: token, payload: payload);

                          if (context.mounted) {
                            Navigator.pop(context);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ডাক্তার প্রোফাইল সফলভাবে আপডেট করা হয়েছে!'),
                                  backgroundColor: brandGreen,
                                ),
                              );
                              _fetchDoctors(forceRefresh: true);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('আপডেট করতে সমস্যা হয়েছে।'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.check_circle_rounded, size: 18),
                        label: const Text(
                          'তথ্য আপডেট করুন',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
    final activeCount = _doctors.where((d) => d['isActive'] == true || d['status'] == 'active').length;

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
              _fetchDoctors(forceRefresh: true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ডাক্তারদের তালিকা রিফ্রেশ করা হচ্ছে...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'ক্যাশ রিফ্রেশ',
          ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: const AdminDrawer(selectedIndex: 5),
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
              if (_isLoading && filtered.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(color: brandGreen),
                  ),
                )
              else if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFCA5A5)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.red, size: 36),
                      const SizedBox(height: 10),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else if (filtered.isEmpty)
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
    final activeCount = _doctors.where((d) => d['isActive'] == true || d['status'] == 'active').length;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [darkGreen, brandGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: brandGreen.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative background bubble
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Glowing Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.shield_rounded, color: Colors.amber, size: 13),
                      SizedBox(width: 4),
                      Text(
                        'MEDICAL PANEL & DIRECTORY',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'নিবন্ধিত ডাক্তার প্যানেল',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const Text(
                  '(Verified Doctors List)',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'BMDC ভেরিফাইড ডাক্তারদের প্রোফাইল, ফি ও টেলিমেডিসিন পারমিশন ফুল CRUD হাব।',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.88),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Metrics & Action Row
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Metrics Wrap
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'মোট ডাক্তার: ${_doctors.length} জন',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'সক্রিয়: $activeCount জন',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // Buttons Wrap
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // Refresh Button
                        Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
                            onPressed: () {
                              _fetchDoctors(forceRefresh: true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('এপিআই থেকে ডাক্তারদের তালিকা রিফ্রেশ করা হচ্ছে...')),
                              );
                            },
                          ),
                        ),
                        // Add Button
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: darkGreen,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _showCreateDoctorModal,
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text(
                            'যোগ করুন',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1).withValues(alpha: 0.6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: brandGreen.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
          _searchDebounce?.cancel();
          _searchDebounce = Timer(const Duration(milliseconds: 500), () {
            _fetchDoctors(forceRefresh: true);
          });
        },
        style: const TextStyle(fontSize: 13, color: textDark, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: 'ডাক্তারের নাম, স্পেশালিটি বা বিএমডিসি নম্বর দিয়ে খুঁজুন...',
          hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
          prefixIcon: const Icon(Icons.search_rounded, color: brandGreen, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18, color: Color(0xFF94A3B8)),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                    _fetchDoctors(forceRefresh: true);
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
    final bool isActive = item['status'] == 'active' || item['isActive'] == true;
    final bool isVerified = item['isVerified'] == true || item['status'] == 'active';

    final Color avatarBg = item['avatarBg'] as Color? ?? const Color(0xFFE0F2FE);
    final Color avatarColor = item['avatarColor'] as Color? ?? const Color(0xFF0369A1);

    final String name = item['name']?.toString() ?? 'Doctor';
    final String specialtyText = item['speciality']?.toString() ?? item['specialty']?.toString() ?? 'General Medicine';
    final String designationText = item['designation']?.toString() ?? '';
    final String bmdcCode = item['bmdc_number']?.toString() ?? item['bmdc']?.toString() ?? 'BMDC-PENDING';
    final String consultationFee = item['consultation_fee']?.toString() ?? item['fee']?.toString() ?? '800';
    final String emailAddr = item['email']?.toString() ?? '';
    final String phoneNum = item['phone']?.toString() ?? '';

    final String initialsName = name.replaceAll('Dr.', '').trim();
    final String initialChar = initialsName.isNotEmpty ? initialsName[0].toUpperCase() : 'D';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive 
              ? const Color(0xFFCBD5E1).withValues(alpha: 0.5) 
              : const Color(0xFFFCA5A5).withValues(alpha: 0.6),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: brandGreen.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [avatarBg, avatarBg.withValues(alpha: 0.65)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: avatarColor.withValues(alpha: 0.15), width: 1.5),
                ),
                child: Center(
                  child: Text(
                    initialChar,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: avatarColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Doctor Name & Specialty chips
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
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
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xFFECFDF5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.verified_rounded, color: brandGreen, size: 16),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            specialtyText,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                          ),
                        ),
                        if (designationText.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              designationText,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: brandGreen),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              // Active / Inactive Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  isActive ? 'ACTIVE' : 'INACTIVE',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: isActive ? const Color(0xFF047857) : const Color(0xFFDC2626),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Meta Info Table: BMDC, Fee, Email, Phone matching screenshot layout
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0).withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.badge_outlined, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 6),
                        const Text('BMDC: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFFBFDBFE), width: 0.5),
                          ),
                          child: Text(
                            bmdcCode,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF1D4ED8)),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.payments_outlined, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 6),
                        const Text('ভিজিট ফি: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                        Text(
                          '৳ $consultationFee',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: brandGreen),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.mail_outline_rounded, size: 14, color: Color(0xFF64748B)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              emailAddr,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF475569)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        const Icon(Icons.phone_outlined, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 6),
                        Text(
                          phoneNum,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                        ),
                      ],
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
              // 1. Delete Button
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFDC2626),
                    backgroundColor: const Color(0xFFFEF2F2),
                    side: const BorderSide(color: Color(0xFFFECACA)),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 9),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('নিশ্চিত করুন', style: TextStyle(fontWeight: FontWeight.bold)),
                        content: Text('${item['name'] ?? 'ডাক্তার'} এর প্রোফাইলটি মুছে ফেলতে চান?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('বাতিল', style: TextStyle(color: Color(0xFF64748B))),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _deleteDoctor(item['id'].toString());
                            },
                            child: const Text('মুছে ফেলুন', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 13,
                  ),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'মুছে ফেলুন',
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
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
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 9),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 9),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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


}
