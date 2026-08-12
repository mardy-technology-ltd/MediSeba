import 'package:flutter/material.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/helpline_bottom_sheet.dart';
import 'health_consultation_success_view.dart';

class HealthConsultationView extends StatefulWidget {
  final bool showBackBtn;
  final LanguageController? languageController;

  const HealthConsultationView({
    super.key,
    this.showBackBtn = true,
    this.languageController,
  });

  @override
  State<HealthConsultationView> createState() => _HealthConsultationViewState();
}

class _HealthConsultationViewState extends State<HealthConsultationView> {
  late final LanguageController _langController;

  String? selectedGender;
  String? selectedAge;
  final TextEditingController _questionController = TextEditingController();

  static const brandGreen = Color(0xFF008536);
  static const darkForest = Color(0xFF064E3B);
  static const textDark = Color(0xFF1E293B);

  // Popular Health Topics
  final List<Map<String, String>> _popularTopics = [
    {'bn': '🩸 রক্তচাপ ও ডায়াবেটিস', 'en': '🩸 BP & Diabetes'},
    {'bn': '👶 মা ও শিশু স্বাস্থ্য', 'en': '👶 Mother & Child Care'},
    {'bn': '🧠 মানসিক চাপ ও উদ্বেগ', 'en': '🧠 Stress & Mental Health'},
    {'bn': '💊 গ্যাস্ট্রিক ও অ্যাসিডিটি', 'en': '💊 Gastric & Acidity'},
    {'bn': '🦴 হাড় ও জয়েন্ট ব্যাথা', 'en': '🦴 Bone & Joint Pain'},
  ];

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_questionController.text.trim().isEmpty || 
        selectedGender == null || 
        selectedAge == null) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _langController.tr(
              'অনুগ্রহ করে সকল প্রয়োজনীয় তথ্য পূরণ করুন।',
              'Please fill all mandatory fields to proceed.',
            ),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // All fields are valid, navigate to success view
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HealthConsultationSuccessView(languageController: _langController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = _langController.isBangla;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        leading: widget.showBackBtn
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          _langController.tr('স্বাস্থ্য বিষয়ক পরামর্শ', 'Health Consultation'),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_in_talk_rounded, color: brandGreen),
            onPressed: () => showHelplineBottomSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Medical Header Card
              _buildHeroCard(isBangla),

              const SizedBox(height: 20),

              // 2. Popular Topics Pills
              Text(
                _langController.tr('জনপ্রিয় স্বাস্থ্য প্রশ্নসমূহ', 'Popular Health Topics'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _popularTopics.map((topic) {
                  final text = isBangla ? topic['bn']! : topic['en']!;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_questionController.text.isEmpty) {
                          _questionController.text = '$text সম্পর্কিত তথ্য জানতে চাই।';
                        } else {
                          _questionController.text += ' ($text)';
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 22),

              // 3. Question Input Form Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                    // Field 1: Question
                    _buildLabel(_langController.tr('আপনার প্রশ্ন / স্বাস্থ্য সমস্যা লিখুন *', 'Ask Your Question *')),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
                      ),
                      child: TextField(
                        controller: _questionController,
                        maxLines: 5,
                        style: const TextStyle(fontSize: 13.5, color: textDark),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(14),
                          hintText: _langController.tr(
                            'আপনার শারীরিক সমস্যা, উপসর্গ বা প্রশ্ন বিস্তারিত এখানে লিখুন...',
                            'Type your health question or symptoms here in detail...',
                          ),
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Field 2: Gender Selection (Modern Choice Chips)
                    _buildLabel(_langController.tr('লিঙ্গ নির্বাচন করুন *', 'Select Gender *')),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildGenderChip('Male', _langController.tr('পুরুষ', 'Male'), Icons.male_rounded),
                        const SizedBox(width: 10),
                        _buildGenderChip('Female', _langController.tr('নারী', 'Female'), Icons.female_rounded),
                        const SizedBox(width: 10),
                        _buildGenderChip('Other', _langController.tr('অন্যান্য', 'Other'), Icons.transgender_rounded),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Field 3: Age Dropdown
                    _buildLabel(_langController.tr('আপনার বয়স কত? *', 'Your Age *')),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedAge,
                          hint: Text(
                            _langController.tr('বয়স ক্যাটাগরি নির্বাচন করুন', 'Select your age category'),
                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: brandGreen),
                          items: [
                            {'val': 'Under 18', 'bn': '১৮ বছরের নিচে', 'en': 'Under 18'},
                            {'val': '18-25', 'bn': '১৮ - ২৫ বছর', 'en': '18 - 25 Years'},
                            {'val': '26-35', 'bn': '২৬ - ৩৫ বছর', 'en': '26 - 35 Years'},
                            {'val': '36-45', 'bn': '৩৬ - ৪৫ বছর', 'en': '36 - 45 Years'},
                            {'val': '46-60', 'bn': '৪৬ - ৬০ বছর', 'en': '46 - 60 Years'},
                            {'val': '60+', 'bn': '৬০+ বছর', 'en': '60+ Years'},
                          ].map((item) {
                            return DropdownMenuItem<String>(
                              value: item['val'],
                              child: Text(
                                isBangla ? item['bn']! : item['en']!,
                                style: const TextStyle(fontSize: 13.5, color: textDark, fontWeight: FontWeight.w600),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => selectedAge = val),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Confidential Guarantee Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFA7F3D0), width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: brandGreen, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _langController.tr(
                          '১০০% তথ্য গোপনীয়তা ও ডাক্তারের গোপনীয় মতামত নিশ্চিত করা হয়।',
                          '100% data privacy & doctor confidentiality guaranteed.',
                        ),
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: darkForest,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandGreen,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  label: Text(
                    _langController.tr('পরামর্শের জন্য প্রশ্ন সাবমিট করুন', 'Submit Health Question'),
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Hero Medical Header Card
  Widget _buildHeroCard(bool isBangla) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF064E3B), Color(0xFF008536), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: brandGreen.withValues(alpha: 0.3),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white30, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.psychology_rounded, color: Colors.white, size: 15),
                const SizedBox(width: 6),
                Text(
                  _langController.tr('ফ্রি হেলথ কনসালটেশন সার্ভিস', 'Free Health Consultation'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Text(
            _langController.tr('আপনার যেকোনো স্বাস্থ্য সমস্যা বা প্রশ্ন লিখুন', 'Ask Your Health Question or Symptoms'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              height: 1.25,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            _langController.tr(
              'মেডিসেবার অভিজ্ঞ ডাক্তারগণ গোপনীয়তা রক্ষা করে আপনার স্বাস্থ্য বিষয়ক প্রশ্নের সঠিক সমাধান প্রদান করবেন।',
              'Our experienced doctors at MediSeba will provide confidential and accurate advice for your health concerns.',
            ),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  // Gender Selection Chip
  Widget _buildGenderChip(String value, String label, IconData icon) {
    final isSelected = selectedGender == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedGender = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFDCFCE7) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? brandGreen : const Color(0xFFCBD5E1),
              width: isSelected ? 1.8 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? brandGreen : const Color(0xFF64748B),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? brandGreen : const Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
    );
  }
}
