import 'package:flutter/material.dart';
import 'admin_dashboard_view.dart';
import 'admin_inbox_view.dart';
import 'admin_doctors_management_view.dart';
import 'admin_patient_records_view.dart';
import 'admin_appointments_management_view.dart';

class AdminJobCircularsView extends StatefulWidget {
  const AdminJobCircularsView({super.key});

  @override
  State<AdminJobCircularsView> createState() => _AdminJobCircularsViewState();
}

class _AdminJobCircularsViewState extends State<AdminJobCircularsView> {
  static const brandGreen = Color(0xFF0F9D58);
  static const darkGreen = Color(0xFF006B4A);
  static const textDark = Color(0xFF0F172A);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Initial Mock Data Matching Web Screenshot (Image 2)
  final List<Map<String, dynamic>> _jobCirculars = [
    {
      'id': 'job_101',
      'category': 'ক্লিনিক্যাল সার্ভিসেস',
      'title': 'মেডিকেল অফিসার (Telemedicine Medical Officer)',
      'location': 'উত্তরা হেড অফিস, ঢাকা',
      'jobType': 'Full-Time (Rotational Shift)',
      'salary': '৳ ৪৫,০০০ - ৳ ৬৫,০০০',
      'applicantsCount': 14,
      'isActive': true,
      'description': 'মেডিসেবা ডিজিটাল চেম্বার দ্বারা রোগীদের অনলাইন কনসালটেশন ও প্রেসক্রিপশন প্রদান করা।',
    },
    {
      'id': 'job_102',
      'category': 'সাপোর্ট ও পেশেন্ট কেয়ার',
      'title': 'কাস্টমার সাপোর্ট ও হেল্পডেস্ক এক্সিকিউটিভ',
      'location': 'তালাইমারী অফিস, রাজশাহী / ঢাকা',
      'jobType': 'Full-Time / Shift',
      'salary': '৳ ২০,০০০ - ৳ ৩০,০০০',
      'applicantsCount': 28,
      'isActive': true,
      'description': 'ক্লায়েন্টদের ইনকামিং ফোন কল, হোয়াটসঅ্যাপ চ্যাট ও অ্যাপয়েন্টমেন্ট সিরিয়াল বুকিংয়ে সহায়তা দেওয়া।',
    },
    {
      'id': 'job_103',
      'category': 'মার্কেটিং ও বিজনেস ডেভেলপমেন্ট',
      'title': 'রিজিওনাল সেলস ও ডিলারশিপ ম্যানেজার',
      'location': 'রাজশাহী / বগুড়া / চট্টগ্রাম / ঢাকা',
      'jobType': 'Full-Time',
      'salary': '৳ ৩৫,০০০ - ৳ ৫০,০০০ + কমিশন',
      'applicantsCount': 9,
      'isActive': true,
      'description': 'উপজেলা ও জেলা পর্যায়ে হাসপাতাল, ক্লিনিক এবং ডিলারদের সাথে মেডিসেবা ডিলার পার্টনারশিপ বৃদ্ধি করা।',
    },
    {
      'id': 'job_104',
      'category': 'নার্সিং ও হোম কেয়ার',
      'title': 'নিবন্ধিত নার্স ও হোম হেলথকেয়ার এসিস্ট্যান্ট',
      'location': 'ঢাকা ও রাজশাহী মেট্রো এলাকা',
      'jobType': 'Full-Time / Part-Time',
      'salary': '৳ ২৫,০০০ - ৳ ৩৫,০০০',
      'applicantsCount': 17,
      'isActive': true,
      'description': 'রোগীদের বাসায় গিয়ে জরুরি ইনজেকশন, ড্রেসিং, ডায়াবেটিস ও প্রেশার চেক এবং হোম কেয়ার সাপোর্ট দেওয়া।',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredCirculars {
    if (_searchQuery.trim().isEmpty) {
      return _jobCirculars;
    }
    final q = _searchQuery.toLowerCase().trim();
    return _jobCirculars.where((item) {
      return item['title'].toString().toLowerCase().contains(q) ||
          item['category'].toString().toLowerCase().contains(q) ||
          item['location'].toString().toLowerCase().contains(q) ||
          item['jobType'].toString().toLowerCase().contains(q);
    }).toList();
  }

  void _toggleJobStatus(int index) {
    setState(() {
      _jobCirculars[index]['isActive'] = !(_jobCirculars[index]['isActive'] as bool);
    });
    final bool active = _jobCirculars[index]['isActive'];
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          active
              ? 'সার্কুলারটি পুনরায় সক্রিয় (Active) করা হয়েছে!'
              : 'সার্কুলারটি বন্ধ (Inactive) করা হয়েছে।',
        ),
        backgroundColor: active ? brandGreen : const Color(0xFFDC2626),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCreateJobModal() {
    final titleController = TextEditingController();
    final categoryController = TextEditingController(text: 'ক্লিনিক্যাল সার্ভিসেস');
    final locationController = TextEditingController();
    final jobTypeController = TextEditingController(text: 'Full-Time');
    final salaryController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                        Icon(Icons.add_business_rounded, color: brandGreen, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'নতুন চাকরির পোস্ট তৈরি করুন',
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

                _buildInputField('চাকরির পদবি (Job Title) *', titleController, 'যেমন: সিনিয়র মেডিকেল অফিসার'),
                const SizedBox(height: 12),

                _buildInputField('ডিপার্টমেন্ট / ক্যাটাগরি *', categoryController, 'যেমন: ক্লিনিক্যাল সার্ভিসেস'),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(child: _buildInputField('কর্মস্থল / লোকেশন *', locationController, 'যেমন: ঢাকা হেড অফিস')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildInputField('চাকরির ধরণ / শিফট *', jobTypeController, 'Full-Time / Shift')),
                  ],
                ),
                const SizedBox(height: 12),

                _buildInputField('বেতন স্কেল (Salary Range) *', salaryController, 'যেমন: ৳ ৩০,০০০ - ৳ ৪৫,০০০'),
                const SizedBox(height: 12),

                _buildInputField('সার্কুলার বিবরণ (Description)', descController, 'চাকরির দায়িত্ব ও শিক্ষাগত যোগ্যতা...', maxLines: 3),
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
                      if (titleController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('দয়া করে চাকরির পদবি লিখুন')),
                        );
                        return;
                      }

                      setState(() {
                        _jobCirculars.insert(0, {
                          'id': 'job_${DateTime.now().millisecondsSinceEpoch}',
                          'category': categoryController.text.trim().isEmpty ? 'জেনারেল' : categoryController.text.trim(),
                          'title': titleController.text.trim(),
                          'location': locationController.text.trim().isEmpty ? 'ঢাকা' : locationController.text.trim(),
                          'jobType': jobTypeController.text.trim().isEmpty ? 'Full-Time' : jobTypeController.text.trim(),
                          'salary': salaryController.text.trim().isEmpty ? 'আলোচনা সাপেক্ষে' : salaryController.text.trim(),
                          'applicantsCount': 0,
                          'isActive': true,
                          'description': descController.text.trim().isEmpty ? 'মেডিসেবা টিমের সাথে নতুন নিয়োগ বিজ্ঞপ্তি।' : descController.text.trim(),
                        });
                      });

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('নতুন চাকরির পোস্ট সফলভাবে তৈরি করা হয়েছে!'),
                          backgroundColor: brandGreen,
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle_rounded, size: 18),
                    label: const Text(
                      'পোস্ট প্রকাশ করুন',
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
  }

  void _showEditJobModal(Map<String, dynamic> item, int index) {
    final titleController = TextEditingController(text: item['title']);
    final categoryController = TextEditingController(text: item['category']);
    final locationController = TextEditingController(text: item['location']);
    final jobTypeController = TextEditingController(text: item['jobType']);
    final salaryController = TextEditingController(text: item['salary']);
    final descController = TextEditingController(text: item['description']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                        Icon(Icons.edit_note_rounded, color: brandGreen, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'সার্কুলার সম্পাদনা করুন',
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

                _buildInputField('চাকরির পদবি', titleController, ''),
                const SizedBox(height: 12),

                _buildInputField('ডিপার্টমেন্ট / ক্যাটাগরি', categoryController, ''),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(child: _buildInputField('কর্মস্থল / লোকেশন', locationController, '')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildInputField('চাকরির ধরণ / শিফট', jobTypeController, '')),
                  ],
                ),
                const SizedBox(height: 12),

                _buildInputField('বেতন স্কেল', salaryController, ''),
                const SizedBox(height: 12),

                _buildInputField('সার্কুলার বিবরণ', descController, '', maxLines: 3),
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
                      setState(() {
                        _jobCirculars[index]['title'] = titleController.text.trim();
                        _jobCirculars[index]['category'] = categoryController.text.trim();
                        _jobCirculars[index]['location'] = locationController.text.trim();
                        _jobCirculars[index]['jobType'] = jobTypeController.text.trim();
                        _jobCirculars[index]['salary'] = salaryController.text.trim();
                        _jobCirculars[index]['description'] = descController.text.trim();
                      });

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('চাকরির বিবরণ সফলভাবে আপডেট করা হয়েছে!'),
                          backgroundColor: brandGreen,
                        ),
                      );
                    },
                    icon: const Icon(Icons.save_rounded, size: 18),
                    label: const Text(
                      'আপডেট সেভ করুন',
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
  }

  Widget _buildInputField(String label, TextEditingController controller, String hint, {int maxLines = 1}) {
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
          maxLines: maxLines,
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
    final filtered = _filteredCirculars;

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
              'চাকরি ও নিয়োগ সার্কুলার',
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
                  content: Text('সার্কুলার ডাটা রিফ্রেশ করা হয়েছে'),
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
              // 1. TOP HEADER BANNER matching Web Visual (Image 2)
              _buildHeaderPanel(),

              const SizedBox(height: 16),

              // 2. DEBOUNCED SEARCH BAR matching Web Visual
              _buildSearchBar(),

              const SizedBox(height: 16),

              // 3. JOB CIRCULAR CARDS GRID / LIST
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
                      const Icon(Icons.search_off_rounded, size: 44, color: Color(0xFF94A3B8)),
                      const SizedBox(height: 10),
                      const Text(
                        'কোনো সার্কুলার খুঁজে পাওয়া যায়নি',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '"$_searchQuery" শব্দ দিয়ে কোনো চাকরির পদ নিবন্ধিত নেই।',
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
                    final realIndex = _jobCirculars.indexOf(item);
                    return _buildJobCard(item, realIndex);
                  },
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// 1. Build Header Panel matching Web Screenshot Title & Action Buttons
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
              Icon(Icons.work_rounded, color: brandGreen, size: 22),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'চাকরি ও নিয়োগ সার্কুলার এপিআই প্যানেল (Full CRUD & API Connected)',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'এপিআই ব্যাকএন্ডের সাথে কানেক্টেড নিয়োগ বিজ্ঞপ্তি পোস্ট, এডিট, বেতন পরিবর্তন ও স্ট্যাটাস সক্রিয়/বন্ধ করুন।',
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
                onPressed: _showCreateJobModal,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('+ নতুন চাকরির পোস্ট তৈরি করুন', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 2. Build Debounced Search Bar
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
          hintText: 'চাকরির পদবি, ডিপার্টমেন্ট বা লোকেশন দিয়ে খুঁজুন...',
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

  /// 3. Build Job Card matching Web Screenshot (Image 2)
  Widget _buildJobCard(Map<String, dynamic> item, int index) {
    final bool isActive = item['isActive'] as bool;
    final int applicants = item['applicantsCount'] as int;

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
          // Top Row: Category Tag Pill + Active/Inactive Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item['category'] as String,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF047857),
                  ),
                ),
              ),
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
                  isActive ? 'সক্রিয় (Active)' : 'বন্ধ (Inactive)',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: isActive ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Title
          Text(
            item['title'] as String,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w900,
              color: textDark,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 10),

          // Meta Info List: Location, Job Type, Salary
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _buildMetaIconText(Icons.location_on_outlined, item['location'] as String),
              _buildMetaIconText(Icons.access_time_rounded, item['jobType'] as String),
              _buildMetaIconText(Icons.payments_outlined, item['salary'] as String, isHighlight: true),
            ],
          ),

          const SizedBox(height: 12),

          // Applicant Count Bar / Badge matching Image 2
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.people_alt_outlined, size: 15, color: Color(0xFF64748B)),
                    SizedBox(width: 6),
                    Text(
                      'মোট আবেদনকারী সিভি:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$applicants জন',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0369A1),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // Action Buttons: Edit (এডিট করুন) & Toggle Status (সার্কুলার বন্ধ করুন / সক্রিয় করুন)
          Row(
            children: [
              // Edit Button
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0284C7),
                    backgroundColor: const Color(0xFFF0F9FF),
                    side: const BorderSide(color: Color(0xFFBAE6FD)),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _showEditJobModal(item, index),
                  icon: const Icon(Icons.edit_outlined, size: 15),
                  label: const Text('এডিট করুন', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),

              // Active/Inactive Toggle Button matching Web visual
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isActive ? const Color(0xFFDC2626) : brandGreen,
                    backgroundColor: isActive ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
                    side: BorderSide(
                      color: isActive ? const Color(0xFFFECACA) : const Color(0xFFA7F3D0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _toggleJobStatus(index),
                  icon: Icon(
                    isActive ? Icons.power_settings_new_rounded : Icons.check_circle_outline_rounded,
                    size: 15,
                  ),
                  label: Text(
                    isActive ? 'সার্কুলার বন্ধ করুন' : 'সক্রিয় করুন',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaIconText(IconData icon, String text, {bool isHighlight = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 13.5,
          color: isHighlight ? brandGreen : const Color(0xFF64748B),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
            color: isHighlight ? brandGreen : const Color(0xFF475569),
          ),
        ),
      ],
    );
  }

  /// Build Navigation Drawer matching Image 1
  Widget _buildAdminDrawer(BuildContext context) {
    final menuItems = [
      {'title': 'ড্যাশবোর্ড (Overview)', 'icon': Icons.dashboard_rounded, 'selected': false},
      {'title': 'ইনবক্স ও অ্যাপ্লিকেশন', 'icon': Icons.mail_outline_rounded, 'selected': false},
      {'title': 'চাকরি ও নিয়োগ সার্কুলার', 'icon': Icons.work_outline_rounded, 'selected': true},
      {'title': 'ডাক্তার ম্যানেজমেন্ট', 'icon': Icons.medical_services_outlined, 'selected': false},
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
                        } else if (index == 3) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminDoctorsManagementView(),
                            ),
                          );
                        } else if (index == 4) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminPatientRecordsView(),
                            ),
                          );
                        } else if (index == 5) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminAppointmentsManagementView(),
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
