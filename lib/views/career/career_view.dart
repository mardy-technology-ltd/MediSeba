import 'package:flutter/material.dart';
import '../../controllers/language_controller.dart';

class CareerView extends StatefulWidget {
  final LanguageController? languageController;

  const CareerView({super.key, this.languageController});

  @override
  State<CareerView> createState() => _CareerViewState();
}

class _CareerViewState extends State<CareerView> {
  late final LanguageController _langController;

  static const brandGreen = Color(0xFF0F9D58);
  static const textDark = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
  }

  void _showApplyModal(String jobTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ApplyJobBottomSheet(
        jobTitle: jobTitle,
        languageController: _langController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _langController,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              _langController.tr('ক্যারিয়ার', 'Career'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HERO BANNER CARD
                _buildHeroCard(),

                const SizedBox(height: 20),

                // 2. SECTION HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _langController.tr('বর্তমান চাকরির সার্কুলারসমূহ (৪টি সক্রিয় পদ)', 'Current Job Circulars (4 Active)'),
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _langController.tr('সরাসরি সিভি লিংক', 'Direct CV Link'),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: brandGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 3. JOB CIRCULAR CARDS LIST
                _buildJobCard(
                  badges: [
                    _langController.tr('টেলিমেডিসিন সার্ভিসেস', 'Telemedicine'),
                    _langController.tr('চিকিৎসক টিম', 'Doctor Team'),
                  ],
                  title: _langController.tr('মেডিক্যাল অফিসার (Telemedicine Medical Officer)', 'Medical Officer (Telemedicine)'),
                  location: _langController.tr('উত্তরা হেড অফিস, ঢাকা', 'Uttara Head Office, Dhaka'),
                  jobType: 'Full-Time (Rotational Shift)',
                  salary: _langController.tr('৳ ৪৫,০০০ - ৳ ৬৫,০০০', '৳ 45,000 - ৳ 65,000'),
                  description: _langController.tr(
                    'মেডিসেবা ডিজিটাল চেম্বার দ্বারা রোগীদের অনলাইন কনসালটেশন ও প্রেসক্রিপশন প্রদান করা।',
                    'Providing online consultation & prescription to patients via MediSeba digital chamber.',
                  ),
                  onApplyTap: () => _showApplyModal(_langController.tr('মেডিক্যাল অফিসার', 'Medical Officer')),
                ),

                const SizedBox(height: 14),

                _buildJobCard(
                  badges: [
                    _langController.tr('কলসেন্টার ও পেশেন্ট কেয়ার', 'Call Center'),
                    _langController.tr('সাপোর্ট এক্সিকিউটিভ', 'Support Exec.'),
                  ],
                  title: _langController.tr('কাস্টমার সাপোর্ট ও হেল্পডেস্ক এক্সিকিউটিভ', 'Customer Support & Helpdesk Executive'),
                  location: _langController.tr('তালাইমারী অফিস, রাজশাহী / ঢাকা', 'Talaimari Office, Rajshahi / Dhaka'),
                  jobType: 'Full-Time / Shift',
                  salary: _langController.tr('৳ ২০,০০০ - ৳ ৩০,০০০', '৳ 20,000 - ৳ 30,000'),
                  description: _langController.tr(
                    'ক্লায়েন্টদের ইনকামিং ফোন কল, হোয়াটসঅ্যাপ চ্যাট ও অ্যাপয়েন্টমেন্ট সিরিয়াল বুকিংয়ে সহায়তা দেওয়া।',
                    'Assisting clients with incoming calls, WhatsApp chat & appointment serial booking.',
                  ),
                  onApplyTap: () => _showApplyModal(_langController.tr('কাস্টমার সাপোর্ট এক্সিকিউটিভ', 'Customer Support Executive')),
                ),

                const SizedBox(height: 14),

                _buildJobCard(
                  badges: [
                    _langController.tr('মার্কেটিং ও বিজনেস ডেভেলপমেন্ট', 'Marketing & Sales'),
                    _langController.tr('পার্টনারশিপ ম্যানেজমেন্ট', 'Partnerships'),
                  ],
                  title: _langController.tr('রিজিওনাল সেলস ও ডিলারশিপ ম্যানেজার', 'Regional Sales & Dealership Manager'),
                  location: _langController.tr('রাজশাহী / বগুড়া / চট্টগ্রাম / ঢাকা', 'Rajshahi / Bogura / Chattogram / Dhaka'),
                  jobType: 'Full-Time',
                  salary: _langController.tr('৳ ৩৫,০০০ - ৳ ৫০,০০০ + কমিশন', '৳ 35,000 - ৳ 50,000 + Comm.'),
                  description: _langController.tr(
                    'উপজেলা ও জেলা পর্যায়ে হাসপাতাল, ক্লিনিক এবং ডিলারদের সাথে মেডিসেবা ডিলার পার্টনারশিপ বৃদ্ধি করা।',
                    'Expanding MediSeba dealer partnerships with hospitals, clinics & dealers at district levels.',
                  ),
                  onApplyTap: () => _showApplyModal(_langController.tr('ডিলারশিপ ম্যানেজার', 'Dealership Manager')),
                ),

                const SizedBox(height: 14),

                _buildJobCard(
                  badges: [
                    _langController.tr('নার্সিং ও হোম কেয়ার', 'Nursing & Homecare'),
                    _langController.tr('হেলথকেয়ার অ্যাসিস্ট্যান্ট', 'Healthcare Asst.'),
                  ],
                  title: _langController.tr('নিবন্ধিত নার্স ও হোম হেলথকেয়ার অ্যাসিস্ট্যান্ট', 'Registered Nurse & Home Care Assistant'),
                  location: _langController.tr('ঢাকা ও রাজশাহী মেট্রো এলাকা', 'Dhaka & Rajshahi Metro Area'),
                  jobType: 'Full-Time / Part-Time',
                  salary: _langController.tr('৳ ২৫,০০০ - ৳ ৩৫,০০০', '৳ 25,000 - ৳ 35,000'),
                  description: _langController.tr(
                    'রোগীদের বাসায় গিয়ে জরুরি ইনজেকশন, ড্রেসিং, ডায়াবেটিস ও প্রেশার চেক এবং হোম কেয়ার সাপোর্ট দেওয়া।',
                    'Providing home care support, injections, dressing, diabetes & pressure checks at patients home.',
                  ),
                  onApplyTap: () => _showApplyModal(_langController.tr('নিবন্ধিত নার্স', 'Registered Nurse')),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // 1. HERO BANNER CARD
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F9D58), Color(0xFF047857)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F9D58).withValues(alpha: 0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 15,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _langController.tr(' ক্যারিয়ার ও পার্ট টাইমার চাকরির পোর্টাল', 'Career & Part-time Job Portal'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Main Heading
          Text(
            _langController.tr(
              'মেডিসেবা টিমের সাথে গড়ুন আগামী দিনের ডিজিটাল স্বাস্থ্যসেবা',
              'Build the Future of Digital Healthcare with MediSeba Team',
            ),
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),

          // Subtitle Description
          Text(
            _langController.tr(
              'আপনি কি স্বাস্থ্যপ্রযুক্তি, পেশেন্ট কেয়ার ও ডিজিটাল মেডিকেল ইন্ডাস্ট্রিতে ক্যারিয়ার গড়তে চান? আমাদের ওপেন সার্কুলারগুলোতে এখনই আপনার সিভি জমা দিন।',
              'Do you want to build a career in health tech & digital medical industry? Submit your CV to our open circulars today.',
            ),
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // 3. JOB CIRCULAR CARD
  Widget _buildJobCard({
    required List<String> badges,
    required String title,
    required String location,
    required String jobType,
    required String salary,
    required String description,
    required VoidCallback onApplyTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Badges Row
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: badges.map((bText) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  bText,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: brandGreen,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          // Title & Apply Button Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: onApplyTap,
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                label: Text(
                  _langController.tr('আবেদন করুন', 'Apply'),
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Meta Info Items: Location, Job Type, Salary
          Wrap(
            spacing: 14,
            runSpacing: 8,
            children: [
              _buildMetaIconText(Icons.location_on_outlined, location),
              _buildMetaIconText(Icons.access_time_rounded, jobType),
              _buildMetaIconText(Icons.payments_outlined, salary, isHighlight: true),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),

          // Description
          Text(
            description,
            style: const TextStyle(
              fontSize: 12.5,
              color: textMuted,
              height: 1.4,
            ),
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
          size: 14,
          color: isHighlight ? brandGreen : const Color(0xFF64748B),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
            color: isHighlight ? brandGreen : const Color(0xFF475569),
          ),
        ),
      ],
    );
  }
}

class _ApplyJobBottomSheet extends StatefulWidget {
  final String jobTitle;
  final LanguageController languageController;

  const _ApplyJobBottomSheet({
    required this.jobTitle,
    required this.languageController,
  });

  @override
  State<_ApplyJobBottomSheet> createState() => _ApplyJobBottomSheetState();
}

class _ApplyJobBottomSheetState extends State<_ApplyJobBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cvLinkController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cvLinkController.dispose();
    super.dispose();
  }

  void _submitApplication() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.construction_rounded, color: Color(0xFFFBBF24), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.languageController.tr(
                  'এই ফিচারটি বর্তমানে ডেভেলপমেন্টাধীন রয়েছে (Under Development)।',
                  'This feature is currently under development.',
                ),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.languageController;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${lang.tr('আবেদন করুন', 'Apply for')}: ${widget.jobTitle}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Name Field
            _buildLabel(lang.tr('আপনার পূর্ণ নাম', 'Full Name'), isRequired: true),
            _buildInput(_nameController, lang.tr('যেমন: Md. Rafiqul Islam', 'e.g. Md. Rafiqul Islam')),

            const SizedBox(height: 12),

            // Mobile Field
            _buildLabel(lang.tr('মোবাইল নম্বর', 'Mobile Number'), isRequired: true),
            _buildInput(_phoneController, '01710000000', keyboardType: TextInputType.phone),

            const SizedBox(height: 12),

            // Email Field
            _buildLabel(lang.tr('ইমেইল ঠিকানা', 'Email Address')),
            _buildInput(_emailController, 'applicant@gmail.com', keyboardType: TextInputType.emailAddress),

            const SizedBox(height: 12),

            // CV / Google Drive Link Field
            _buildLabel(lang.tr('সিভি লিংক / গুগল ড্রাইভ লিংক', 'CV / Drive Link'), isRequired: true),
            _buildInput(_cvLinkController, 'https://drive.google.com/...'),

            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F9D58),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _submitApplication,
                icon: const Icon(Icons.send_rounded, size: 18),
                label: Text(
                  lang.tr('আবেদন জমা দিন', 'Submit Application'),
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text.rich(
        TextSpan(
          text: label,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
          children: isRequired
              ? const [TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))]
              : null,
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0F9D58), width: 1.5),
        ),
      ),
    );
  }
}
