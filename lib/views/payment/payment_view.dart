import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/doctor_model.dart';
import '../shared_widgets/custom_button.dart';
import '../shared_widgets/custom_textfield.dart';
import 'payment_success_view.dart';

class PaymentView extends StatefulWidget {
  final DoctorModel doctor;

  const PaymentView({super.key, required this.doctor});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '01710000001');
  final _trxIdController = TextEditingController(text: 'TRX9920184');

  String _selectedMethod = 'bKash';
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 'bKash', 'name': 'bKash', 'color': const Color(0xFFE2136E)},
    {'id': 'Nagad', 'name': 'Nagad', 'color': const Color(0xFFF7931E)},
    {'id': 'Rocket', 'name': 'Rocket', 'color': const Color(0xFF8C3494)},
    {'id': 'Card', 'name': 'Card', 'color': AppColors.primary},
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _trxIdController.dispose();
    super.dispose();
  }

  void _handleConfirmPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isProcessing = true);

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      setState(() => _isProcessing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('পেমেন্ট সফলভাবে সম্পন্ন হয়েছে! অ্যাপয়েন্টমেন্ট নিশ্চিত করা হয়েছে।'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessView(doctor: widget.doctor),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fee = widget.doctor.consultationFee.toInt();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('পেমেন্ট প্যানেল', style: AppTextStyles.heading2),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Security Header Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              border: Border(
                bottom: BorderSide(color: AppColors.primary.withValues(alpha: 0.12)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.shield_rounded, color: AppColors.primary, size: 16),
                    SizedBox(width: 6),
                    Text(
                      '256-Bit SSL Encrypted',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'PAYMENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Consultation Summary Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.videocam_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ইনস্ট্যান্ট ভিডিও কনসালটেশন',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.doctor.name,
                                  style: AppTextStyles.heading2.copyWith(fontSize: 17),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'মোট প্রদেয়',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  '৳ $fee',
                                  style: AppTextStyles.heading2.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Payment Method Selection
                    Text('পেমেন্ট মেথড নির্বাচন করুন', style: AppTextStyles.heading3),
                    const SizedBox(height: 12),
                    Row(
                      children: _paymentMethods.map((method) {
                        final isSelected = _selectedMethod == method['id'];
                        final color = method['color'] as Color;

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: InkWell(
                              onTap: () {
                                setState(() => _selectedMethod = method['id'] as String);
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected ? color.withValues(alpha: 0.1) : AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? color : AppColors.cardBg,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: color.withValues(alpha: 0.2),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          )
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    method['name'] as String,
                                    style: TextStyle(
                                      color: isSelected ? color : AppColors.textPrimary,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Form Fields Card Container
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Account Mobile Number Field
                          CustomTextField(
                            label: '$_selectedMethod অ্যাকাউন্ট নম্বর',
                            hint: '017XXXXXXXX',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icons.phone_android_rounded,
                            validator: (val) => val == null || val.isEmpty ? 'মোবাইল নম্বর প্রদান করুন' : null,
                          ),

                          const SizedBox(height: 16),

                          // Transaction ID Field
                          CustomTextField(
                            label: 'ট্রানজেকশন আইডি (Transaction ID)',
                            hint: 'TRX9920184',
                            controller: _trxIdController,
                            prefixIcon: Icons.receipt_long_rounded,
                            validator: (val) => val == null || val.isEmpty ? 'ট্রানজেকশন আইডি প্রদান করুন' : null,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Confirm Payment Button
                    CustomButton(
                      text: 'পেমেন্ট নিশ্চিত করুন (৳ $fee)',
                      icon: Icons.arrow_forward_rounded,
                      isLoading: _isProcessing,
                      onPressed: _handleConfirmPayment,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
