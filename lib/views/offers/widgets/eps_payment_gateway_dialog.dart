import 'dart:async';
import 'package:flutter/material.dart';

class EpsPaymentGatewayDialog extends StatefulWidget {
  final String packageName;
  final int price;
  final int points;
  final String? initialPhone;
  final String? hbpReferralCode;

  const EpsPaymentGatewayDialog({
    super.key,
    required this.packageName,
    required this.price,
    required this.points,
    this.initialPhone,
    this.hbpReferralCode,
  });

  static Future<void> show({
    required BuildContext context,
    required String packageName,
    required int price,
    required int points,
    String? initialPhone,
    String? hbpReferralCode,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EpsPaymentGatewayDialog(
        packageName: packageName,
        price: price,
        points: points,
        initialPhone: initialPhone,
        hbpReferralCode: hbpReferralCode,
      ),
    );
  }

  @override
  State<EpsPaymentGatewayDialog> createState() => _EpsPaymentGatewayDialogState();
}

class _EpsPaymentGatewayDialogState extends State<EpsPaymentGatewayDialog> {
  late TextEditingController _phoneController;
  late TextEditingController _referralController;
  late TextEditingController _txnController;

  String _selectedMethod = 'bKash';
  bool _isLoading = false;

  // Countdown timer (15 minutes)
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.initialPhone ?? '01710000001');
    _referralController = TextEditingController(text: widget.hbpReferralCode ?? 'MSB-1101');
    _txnController = TextEditingController(
      text: 'EPS-PKG-${DateTime.now().millisecondsSinceEpoch}',
    );

    _remainingSeconds = 15 * 60 - 31; // Starts around 14:29 like screenshot
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

  void _processPayment() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('অনুগ্রহ করে কাস্টমার মোবাইল নম্বর প্রদান করুন'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pop(context);

    // Show Success Alert
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Color(0xFF0F9D58), size: 28),
            SizedBox(width: 10),
            Text(
              'পেমেন্ট সফল হয়েছে!',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'প্যাকেজ: ${widget.packageName}',
              style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'মোট প্রদেয়: ৳ ${widget.price}',
              style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              'অর্জিত হেলথ পয়েন্ট: +${widget.points} Pts',
              style: const TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'TxnID: ${_txnController.text}',
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ঠিক আছে', style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFF0B132B), // Dark Navy Background matching screenshot
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF334155),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Top Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 24,
                      errorBuilder: (context, error, stackTrace) => const Text(
                        'মেডিসেবা',
                        style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.w900, fontSize: 17),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF062D24),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF0F9D58), width: 1),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified_user_rounded, color: Color(0xFF00E676), size: 14),
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
          ),

          const Divider(color: Color(0xFF1E293B), height: 20),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Subscribed Package Summary Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16223B),
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
                                'সাবস্ক্রাইবকৃত স্বাস্থ্য প্যাকেজ',
                                style: TextStyle(fontSize: 11, color: Color(0xFF38BDF8), fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.packageName,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Text('🎁 ', style: TextStyle(fontSize: 12)),
                                  Text(
                                    'অর্জিত হেলথ পয়েন্ট: ${widget.points} Points',
                                    style: const TextStyle(fontSize: 11.5, color: Color(0xFFFBBF24), fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'মোট প্রদেয়',
                              style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '৳ ${widget.price}',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF00E676)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. Payment Gateway Channel Selection Title
                  const Text(
                    'পেমেন্ট গেটওয়ে চ্যানেল নির্বাচন করুন:',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Colors.white),
                  ),

                  const SizedBox(height: 12),

                  // 4 Payment Methods Grid
                  Row(
                    children: [
                      Expanded(child: _buildPaymentMethodCard('bKash', Icons.account_balance_wallet_rounded, const Color(0xFFEC4899))),
                      const SizedBox(width: 10),
                      Expanded(child: _buildPaymentMethodCard('Nagad', Icons.account_balance_wallet_outlined, const Color(0xFFF97316))),
                      const SizedBox(width: 10),
                      Expanded(child: _buildPaymentMethodCard('Rocket', Icons.account_balance_rounded, const Color(0xFFA855F7))),
                      const SizedBox(width: 10),
                      Expanded(child: _buildPaymentMethodCard('Cards', Icons.credit_card_rounded, const Color(0xFF38BDF8))),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 3. Customer Mobile Number
                  _buildInputLabel('কাস্টমার মোবাইল নম্বর (Mobile Number) *'),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF16223B),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF2A3B5C)),
                    ),
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.phone_rounded, color: Color(0xFF64748B), size: 20),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 4. HBP Referral Code / Agent ID (Optional)
                  _buildInputLabel('HBP রেফারেল কোড / এজেন্ট আইডি (ঐচ্ছিক / Optional)'),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF16223B),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF2A3B5C)),
                    ),
                    child: TextField(
                      controller: _referralController,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13.5),
                      decoration: const InputDecoration(
                        hintText: 'উদাহরণ: HBP-0170000010 (যদি থাকে)',
                        hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 12.5),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 5. EPS TxnID Field
                  _buildInputLabel('EPS মার্চেন্ট ট্রানজেকশন আইডি (TxnID)'),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF16223B),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF2A3B5C)),
                    ),
                    child: TextField(
                      controller: _txnController,
                      readOnly: true,
                      style: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w600, fontSize: 13),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Security & Session Timer Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1A30),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(Icons.lock_rounded, color: Color(0xFF00E676), size: 15),
                                SizedBox(width: 5),
                                Text(
                                  '256-bit SSL Encrypted EPS Gateway',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF00E676)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF451A03),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF97316)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('⏰ ', style: TextStyle(fontSize: 10)),
                              Text(
                                _formattedTime,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFFF97316)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 6. Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A870),
                        elevation: 4,
                        shadowColor: const Color(0xFF00A870).withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'EPS গেটওয়ে দিয়ে পেমেন্ট করুন (৳ ${widget.price})',
                                    style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: Colors.white),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                                ],
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Footer Disclaimer
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'Verified & Powered by Easy Payment System (EPS) Limited',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'পেমেন্ট সম্পন্ন হওয়ার সাথে সাথেই আপনার হেলথ ওয়ালেটে পয়েন্ট যুক্ত হবে',
                          style: TextStyle(fontSize: 10.5, color: Color(0xFF475569)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(String title, IconData icon, Color activeColor) {
    final isSelected = _selectedMethod == title;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B1527) : const Color(0xFF16223B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFEC4899) : const Color(0xFF2A3B5C),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFFEC4899) : const Color(0xFF94A3B8), size: 22),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFFCBD5E1)),
      ),
    );
  }
}
