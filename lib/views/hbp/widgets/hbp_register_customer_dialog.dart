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
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedGender = 'পুরুষ';
  String _selectedPackage = 'সাধারণ স্বাস্থ্য প্যাকেজ (৳ ৩৫০)';
  int _packagePrice = 350;
  String _selectedPaymentMethod = 'ক্যাশ কালেকশন (Cash)';
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _packages = [
    {'name': 'সাধারণ স্বাস্থ্য প্যাকেজ (৳ ৩৫০)', 'price': 350},
    {'name': 'মা ও শিশু কেয়ার প্যাকেজ (৳ ৫৫০)', 'price': 550},
    {'name': 'গোল্ড ফ্যামিলি হেলথ প্যাকেজ (৳ ৯৯৯)', 'price': 999},
    {'name': 'প্রিমিয়াম ডায়াবেটিক কেয়ার (৳ ১২৫০)', 'price': 1250},
  ];

  final List<String> _paymentMethods = [
    'ক্যাশ কালেকশন (Cash)',
    'বিকাশ / নগদ (QR Scan)',
    'ডিজিটাল পেমেন্ট গেটওয়ে (EPS/Online)',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final newCustomer = {
      'id': 'CUST-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'age': _ageController.text.trim().isEmpty ? 'N/A' : _ageController.text.trim(),
      'gender': _selectedGender,
      'address': _addressController.text.trim().isEmpty ? 'মাঠ পর্যায়' : _addressController.text.trim(),
      'package': _selectedPackage.split(' (')[0],
      'price': _packagePrice,
      'paymentMethod': _selectedPaymentMethod.split(' (')[0],
      'status': 'সক্রিয় (Active)',
      'date': 'আজ, ${_formatCurrentTime()}',
    };

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        widget.onCustomerAdded(newCustomer);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text('${newCustomer['name']} সফলভাবে নিবন্ধিত হয়েছেন!')),
              ],
            ),
            backgroundColor: const Color(0xFF0F9D58),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    });
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
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
            // Top Modal Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF005A36), Color(0xFF0F9D58)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'নতুন কাস্টমার ও প্যাকেজ রেজিস্ট্রেশন',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'মাঠ পর্যায়ে তাত্ক্ষণিক কাস্টমার অনবোর্ডিং',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Modal Form Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Customer Name Field
                      _buildInputLabel('কাস্টমার / রোগীর নাম *'),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                        decoration: _buildInputDecoration(
                          hint: 'যেমন: রফিকুল ইসলাম',
                          icon: Icons.person_outline_rounded,
                        ),
                        validator: (value) => value == null || value.trim().isEmpty ? 'কাস্টমারের নাম প্রদান করুন' : null,
                      ),
                      const SizedBox(height: 14),

                      // Phone Number Field
                      _buildInputLabel('মোবাইল নম্বর *'),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                        decoration: _buildInputDecoration(
                          hint: '01700000000',
                          icon: Icons.phone_iphone_rounded,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'মোবাইল নম্বর প্রদান করুন';
                          if (value.trim().length < 11) return 'সঠিক ১১ ডিজিটের মোবাইল নম্বর দিন';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Age & Gender Row
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInputLabel('বয়স'),
                                TextFormField(
                                  controller: _ageController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                                  decoration: _buildInputDecoration(
                                    hint: 'যেমন: ৩২',
                                    icon: Icons.cake_outlined,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInputLabel('লিঙ্গ'),
                                Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedGender,
                                      isExpanded: true,
                                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                                      items: ['পুরুষ', 'মহিলা', 'অন্যান্য'].map((gender) {
                                        return DropdownMenuItem(value: gender, child: Text(gender));
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setState(() => _selectedGender = val);
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

                      // Package Selection
                      _buildInputLabel('হেলথ প্যাকেজ নির্বাচন *'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPackage,
                            isExpanded: true,
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                            items: _packages.map((pkg) {
                              return DropdownMenuItem<String>(
                                value: pkg['name'] as String,
                                child: Text(pkg['name'] as String),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                final matched = _packages.firstWhere((element) => element['name'] == val);
                                setState(() {
                                  _selectedPackage = val;
                                  _packagePrice = matched['price'] as int;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Payment Method Selection
                      _buildInputLabel('পেমেন্ট মেথড *'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPaymentMethod,
                            isExpanded: true,
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                            items: _paymentMethods.map((method) {
                              return DropdownMenuItem<String>(
                                value: method,
                                child: Text(method),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedPaymentMethod = val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Location / Notes
                      _buildInputLabel('ঠিকানা / এলাকা'),
                      TextFormField(
                        controller: _addressController,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                        decoration: _buildInputDecoration(
                          hint: 'যেমন: বোয়ালিয়া, রাজশাহী',
                          icon: Icons.location_on_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Action Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      child: const Text(
                        'বাতিল',
                        style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F9D58),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_rounded, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  'নিবন্ধন সম্পন্ন করুন',
                                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
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
          fontWeight: FontWeight.w700,
          color: Color(0xFF334155),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
      prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF0F9D58), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
    );
  }
}
