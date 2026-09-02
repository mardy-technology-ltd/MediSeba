import 'package:flutter/material.dart';

class HbpRegisterCustomerDialog extends StatefulWidget {
  final Function(Map<String, dynamic> newCustomer) onCustomerAdded;

  const HbpRegisterCustomerDialog({
    super.key,
    required this.onCustomerAdded,
  });

  @override
  State<HbpRegisterCustomerDialog> createState() => _HbpRegisterCustomerDialogState();
}

class _HbpRegisterCustomerDialogState extends State<HbpRegisterCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedPackageId = '1';
  String _selectedPackageName = 'প্রথমা প্যাকেজ (Prothoma) — ৳99';
  int _packagePrice = 99;
  String _selectedPaymentMethodId = 'cash';
  String _selectedPaymentMethodLabel = '💵 ইনস্ট্যান্ট হ্যান্ড ক্যাশ (Hand Cash Receive - স্পটে সাথে সাথে একটিভ)';
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _packages = [
    {
      'id': 'none',
      'name': '🆓 ফ্রি পেশেন্ট অ্যাকাউন্ট (প্যাকেজ ছাড়া সাইন-আপ)',
      'shortName': '🆓 ফ্রি পেশেন্ট অ্যাকাউন্ট',
      'price': 0,
      'points': 0,
    },
    {
      'id': '1',
      'name': 'প্রথমা প্যাকেজ (Prothoma) — ৳99 (999 Points)',
      'shortName': 'প্রথমা প্যাকেজ (Prothoma) — ৳99',
      'price': 99,
      'points': 999,
    },
    {
      'id': '2',
      'name': 'আস্থা প্যাকেজ (Astha) — ৳199 (1499 Points)',
      'shortName': 'আস্থা প্যাকেজ (Astha) — ৳199',
      'price': 199,
      'points': 1499,
    },
    {
      'id': '3',
      'name': 'সহযাত্রা প্যাকেজ (Sohojatra) — ৳299 (2000 Points)',
      'shortName': 'সহযাত্রা প্যাকেজ (Sohojatra) — ৳299',
      'price': 299,
      'points': 2000,
    },
    {
      'id': '4',
      'name': 'মাতৃমমতা প্যাকেজ (Matrumomota) — ৳499 (2500 Points)',
      'shortName': 'মাতৃমমতা প্যাকেজ (Matrumomota) — ৳499',
      'price': 499,
      'points': 2500,
    },
    {
      'id': '5',
      'name': 'আপনজন প্যাকেজ (Aponjon) — ৳999 (5500 Points)',
      'shortName': 'আপনজন প্যাকেজ (Aponjon) — ৳999',
      'price': 999,
      'points': 5500,
    },
  ];

  final List<Map<String, String>> _paymentMethods = [
    {
      'id': 'cash',
      'label': '💵 ইনস্ট্যান্ট হ্যান্ড ক্যাশ (Hand Cash Receive - স্পটে সাথে সাথে একটিভ)',
      'shortLabel': '💵 ইনস্ট্যান্ট হ্যান্ড ক্যাশ (Hand Cash)',
    },
    {
      'id': 'qr',
      'label': '📱 ইনস্ট্যান্ট বিকাশ / নগদ QR (Instant bKash/Nagad Merchant QR)',
      'shortLabel': '📱 ইনস্ট্যান্ট বিকাশ / নগদ QR',
    },
    {
      'id': 'eps',
      'label': '🔗 পেমেন্ট লিংক ও হোয়াটসঅ্যাপ (Family Share / Online Pay / Pay Later)',
      'shortLabel': '🔗 পেমেন্ট লিংক ও হোয়াটসঅ্যাপ',
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    final newCustomer = {
      'id': 'REG-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      'name': name,
      'phone': phone,
      'email': _emailController.text.trim(),
      'package': _selectedPackageName,
      'price': _packagePrice,
      'paymentMethod': _selectedPaymentMethodLabel.contains('ক্যাশ')
          ? 'ক্যাশ কালেকশন'
          : (_selectedPaymentMethodId == 'qr' ? 'বিকাশ QR' : 'ডিজিটাল গেটওয়ে'),
      'status': 'সক্রিয় (Active)',
      'date': 'আজ, ${_formatCurrentTime()}',
    };

    widget.onCustomerAdded(newCustomer);

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text('$name সফলভাবে নিবন্ধিত হয়েছেন!')),
            ],
          ),
          backgroundColor: const Color(0xFF0F9D58),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final min = now.minute.toString().padLeft(2, '0');
    return '$hour:$min $period';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 580),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Modal Header (Clean White with Title & Close Icon)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 16, 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_add_alt_1_rounded,
                    color: Color(0xFF00796B),
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'নতুন কাস্টমার অ্যাকাউন্ট ও প্যাকেজ একটিভ',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Modal Form Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Field 1: Customer Name
                      _buildInputLabel('কাস্টমার / রোগীর নাম *'),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                        decoration: _buildInputDecoration(
                          hint: 'যেমন: মোঃ রফিকুল ইসলাম',
                        ),
                        validator: (value) => value == null || value.trim().isEmpty ? 'কাস্টমারের নাম প্রদান করুন' : null,
                      ),
                      const SizedBox(height: 14),

                      // Field 2: Phone Number
                      _buildInputLabel('মোবাইল নম্বর (সুপারভাইজার অডিট ও ভেরিফিকেশন কলের জন্য আবশ্যক) *'),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                        decoration: _buildInputDecoration(
                          hint: 'যেমন: 01712345678',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'মোবাইল নম্বর প্রদান করুন';
                          if (value.trim().length < 11) return 'সঠিক ১১ ডিজিটের মোবাইল নম্বর দিন';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Field 3: Email Address (Optional)
                      _buildInputLabel('ইমেইল অ্যাড্রেস (ঐচ্ছিক)'),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                        decoration: _buildInputDecoration(
                          hint: 'patient@example.com',
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Field 4: Password
                      _buildInputLabel('পেশেন্ট অ্যাকাউন্টের পাসওয়ার্ড (রোগীর পছন্দ অনুযায়ী টাইপ করুন) *'),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                        decoration: _buildInputDecoration(
                          hint: 'যেমন: 123456 (সর্বনিম্ন ৬ অক্ষরের পাসওয়ার্ড দিন)',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'রোগীর জন্য একটি পাসওয়ার্ড তৈরি করুন';
                          if (value.trim().length < 6) return 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Field 5 & 6: Package & Payment Method (Responsive Layout)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 420;

                          final packageWidget = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInputLabel('প্যাকেজ নির্বাচন *'),
                              Container(
                                height: 48,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: const Color(0xFF00796B), width: 1.2),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedPackageId,
                                    isExpanded: true,
                                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF0F172A)),
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                                    items: _packages.map((pkg) {
                                      return DropdownMenuItem<String>(
                                        value: pkg['id'] as String,
                                        child: Text(
                                          pkg['shortName'] as String,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        final matched = _packages.firstWhere((element) => element['id'] == val);
                                        setState(() {
                                          _selectedPackageId = val;
                                          _selectedPackageName = matched['shortName'] as String;
                                          _packagePrice = matched['price'] as int;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );

                          final paymentWidget = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInputLabel('পেমেন্ট সংগ্রহের পদ্ধতি *'),
                              Container(
                                height: 48,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: const Color(0xFF81C784), width: 1.2),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedPaymentMethodId,
                                    isExpanded: true,
                                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF0F172A)),
                                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                                    items: _paymentMethods.map((method) {
                                      return DropdownMenuItem<String>(
                                        value: method['id']!,
                                        child: Text(
                                          method['shortLabel']!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        final matched = _paymentMethods.firstWhere((element) => element['id'] == val);
                                        setState(() {
                                          _selectedPaymentMethodId = val;
                                          _selectedPaymentMethodLabel = matched['label']!;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );

                          if (isNarrow) {
                            return Column(
                              children: [
                                packageWidget,
                                const SizedBox(height: 14),
                                paymentWidget,
                              ],
                            );
                          } else {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: packageWidget),
                                const SizedBox(width: 12),
                                Expanded(child: paymentWidget),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Action Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'বাতিল',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00695C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            'অ্যাকাউন্ট ও প্যাকেজ নিশ্চিত করুন',
                            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
      filled: true,
      fillColor: const Color(0xFFFFFFFF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Color(0xFF00796B), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
    );
  }
}
