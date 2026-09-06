import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/doctor_model.dart';
import 'payment_success_view.dart';

import '../offers/widgets/eps_payment_gateway_dialog.dart';

class PaymentView extends StatefulWidget {
  final DoctorModel doctor;

  const PaymentView({super.key, required this.doctor});

  static Future<void> show({
    required BuildContext context,
    required DoctorModel doctor,
  }) {
    return EpsPaymentGatewayDialog.show(
      context: context,
      packageName: doctor.name.isEmpty ? 'Instant Medicine Doctor Consultation' : doctor.name,
      price: doctor.consultationFee.toInt() > 0 ? doctor.consultationFee.toInt() : 800,
      points: 999,
    );
  }

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  late TextEditingController _referralController;
  late TextEditingController _txnController;

  String _selectedMethod = 'bKash';
  bool _isProcessing = false;

  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: '01710000001');
    _referralController = TextEditingController();
    _txnController = TextEditingController(
      text: 'EPS-PKG-${DateTime.now().millisecondsSinceEpoch}',
    );

    _remainingSeconds = 15 * 60 - 21;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        if (mounted) {
          setState(() => _remainingSeconds--);
        }
      } else {
        _timer?.cancel();
      }
    });
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    _referralController.dispose();
    _txnController.dispose();
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
          backgroundColor: Color(0xFF00E676),
          behavior: SnackBarBehavior.floating,
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

  Widget _buildPaymentMethodCard(String id, String label, IconData icon, Color color) {
    final isSelected = _selectedMethod == id;
    return InkWell(
      onTap: () => setState(() => _selectedMethod = id),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2A1B30) : const Color(0xFF131D31),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFEC4899) : const Color(0xFF2A3B5C),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFFEC4899) : color, size: 20),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fee = widget.doctor.consultationFee.toInt();

    return Scaffold(
      backgroundColor: const Color(0xFF0A1120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1120),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 28,
              errorBuilder: (context, error, stackTrace) => const Text(
                'মেডিসেবা',
                style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.w900, fontSize: 18),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF062D24),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF0F9D58), width: 1),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: Color(0xFF00E676), size: 14),
                SizedBox(width: 5),
                Text(
                  'Official EPS Gateway',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF00E676)),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Service Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131D31),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF2A3B5C)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ইনস্ট্যান্ট ডাক্তার কনসালটেশন সার্ভিস ফি',
                              style: TextStyle(fontSize: 11.5, color: Color(0xFF38BDF8), fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.doctor.name.isEmpty ? 'Instant Medicine Doctor Consultation' : widget.doctor.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            const Row(
                              children: [
                                Text('⚡ ', style: TextStyle(fontSize: 12)),
                                Expanded(
                                  child: Text(
                                    'বিএমডিসি রেজিস্টার্ড ডাক্তারের সাথে সরাসরি ইনস্ট্যান্ট ভিডিও কল',
                                    style: TextStyle(fontSize: 11, color: Color(0xFF38BDF8), fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'মোট প্রদেয়',
                            style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '৳ $fee',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF00E676)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 2. Gateway Channel Title
                const Text(
                  'পেমেন্ট গেটওয়ে চ্যানেল নির্বাচন করুন:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                ),

                const SizedBox(height: 12),

                // 4 Payment Methods Grid
                Row(
                  children: [
                    Expanded(child: _buildPaymentMethodCard('bKash', 'bKash', Icons.account_balance_wallet_rounded, const Color(0xFFEC4899))),
                    const SizedBox(width: 10),
                    Expanded(child: _buildPaymentMethodCard('Nagad', 'Nagad', Icons.account_balance_wallet_outlined, const Color(0xFFF97316))),
                    const SizedBox(width: 10),
                    Expanded(child: _buildPaymentMethodCard('Rocket', 'Rocket', Icons.account_balance_rounded, const Color(0xFFA855F7))),
                    const SizedBox(width: 10),
                    Expanded(child: _buildPaymentMethodCard('Cards', 'Cards', Icons.credit_card_rounded, const Color(0xFF38BDF8))),
                  ],
                ),

                const SizedBox(height: 20),

                // 3. Form Fields
                _buildInputLabel('কাস্টমার মোবাইল নম্বর (Mobile Number) *'),
                _buildInputField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  suffixIcon: const Icon(Icons.phone_rounded, color: Color(0xFF64748B), size: 20),
                ),

                const SizedBox(height: 14),

                _buildInputLabel('HBP রেফারেল কোড / এজেন্ট আইডি (ঐচ্ছিক / Optional)'),
                _buildInputField(
                  controller: _referralController,
                  hintText: 'উদাহরণ: HBP-01700000010 (যদি থাকে)',
                ),

                const SizedBox(height: 14),

                _buildInputLabel('EPS মার্চেন্ট ট্রানজেকশন আইডি (TxnID)'),
                _buildInputField(
                  controller: _txnController,
                ),

                const SizedBox(height: 18),

                // 4. Security & Timer Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1B2E),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF1E2D4A)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lock_outline_rounded, color: Color(0xFF00E676), size: 16),
                          SizedBox(width: 8),
                          Text(
                            '256-bit SSL Encrypted EPS Gateway',
                            style: TextStyle(color: Color(0xFF00E676), fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B1E08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFEA580C), width: 1),
                        ),
                        child: Row(
                          children: [
                            const Text('⏰ ', style: TextStyle(fontSize: 10)),
                            Text(
                              _formattedTime,
                              style: const TextStyle(color: Color(0xFFFB923C), fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 5. Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _handleConfirmPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A884),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'EPS গেটওয়ে দিয়ে পেমেন্ট করুন (৳ $fee)',
                                style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Footer Text
                const Center(
                  child: Column(
                    children: [
                      Text(
                        'Verified & Powered by Easy Payment System (EPS) Limited',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'পেমেন্ট সম্পন্ন হওয়ার সাথে সাথেই আপনার হেলথ ওয়ালেটে পয়েন্ট যুক্ত হবে',
                        style: TextStyle(color: Color(0xFF475569), fontSize: 10.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12.5, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131D31),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A3B5C)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 13, fontWeight: FontWeight.w400),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
