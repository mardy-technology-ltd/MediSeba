import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/doctor_model.dart';
import '../../controllers/appointment_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../shared_widgets/custom_button.dart';
import '../shared_widgets/custom_textfield.dart';
import 'appointment_history_view.dart';

class BookAppointmentView extends StatefulWidget {
  final DoctorModel doctor;

  const BookAppointmentView({super.key, required this.doctor});

  @override
  State<BookAppointmentView> createState() => _BookAppointmentViewState();
}

class _BookAppointmentViewState extends State<BookAppointmentView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'আহমেদ হাসান');
  final _phoneController = TextEditingController(text: '01712345678');
  final AppointmentController _appointmentController = AppointmentController();

  String _selectedDate = 'আজ (2026-07-26)';
  String _selectedTime = '০৬:০০ PM';

  final List<String> _availableDates = [
    'আজ (2026-07-26)',
    'আগামীকাল (2026-07-27)',
    'পরশু (2026-07-28)',
  ];

  final List<String> _availableTimes = [
    '০৫:৩০ PM',
    '০৬:০০ PM',
    '০৬:৩০ PM',
    '০৭:০০ PM',
    '০৭:৩০ PM',
    '০৮:০০ PM',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleBooking() {
    if (_formKey.currentState!.validate()) {
      _appointmentController.bookAppointment(
        doctorId: widget.doctor.id,
        doctorName: widget.doctor.name,
        doctorSpecialty: widget.doctor.specialty,
        patientName: _nameController.text,
        patientPhone: _phoneController.text,
        date: _selectedDate,
        time: _selectedTime,
        fee: widget.doctor.consultationFee,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('আপনার অ্যাপয়েন্টমেন্ট সফলভাবে বুক করা হয়েছে!'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AppointmentHistoryView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'অ্যাপয়েন্টমেন্ট বুকিং',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Summary Bar
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.medical_information_rounded, color: AppColors.primary, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.doctor.name, style: AppTextStyles.heading3),
                          Text(widget.doctor.specialty, style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    Text(
                      '৳${widget.doctor.consultationFee.toInt()}',
                      style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Date Selection
              Text('তারিখ নির্বাচন করুন', style: AppTextStyles.heading2),
              const SizedBox(height: 10),
              SizedBox(
                height: 42,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableDates.length,
                  itemBuilder: (context, index) {
                    final date = _availableDates[index];
                    final isSelected = _selectedDate == date;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ChoiceChip(
                        label: Text(date),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        onSelected: (val) {
                          setState(() => _selectedDate = date);
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Time Slot Selection
              Text('সময় নির্বাচন করুন', style: AppTextStyles.heading2),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _availableTimes.map((time) {
                  final isSelected = _selectedTime == time;
                  return ChoiceChip(
                    label: Text(time),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    onSelected: (val) {
                      setState(() => _selectedTime = time);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Patient Info Fields
              Text('রোগীর তথ্য', style: AppTextStyles.heading2),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'রোগীর পূর্ণ নাম',
                hint: 'আপনার নাম লিখুন',
                controller: _nameController,
                prefixIcon: Icons.person_outline_rounded,
                validator: (val) => val == null || val.isEmpty ? 'নাম প্রদান করুন' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'মোবাইল নম্বর',
                hint: '017XXXXXXXX',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_android_rounded,
                validator: (val) => val == null || val.isEmpty ? 'ফোন নম্বর প্রদান করুন' : null,
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: 'অ্যাপয়েন্টমেন্ট নিশ্চিত করুন',
                icon: Icons.check_circle_outline_rounded,
                onPressed: _handleBooking,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
