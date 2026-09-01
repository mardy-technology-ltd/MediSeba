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
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedGender = 'পুরুষ';
  String _selectedPackageId = '1';
  String _selectedPackageName = 'প্রথমা প্যাকেজ (Prothoma - ৳99)';
  int _packagePrice = 99;
  String _selectedPaymentMethodId = 'cash';
  String _selectedPaymentMethodLabel = 'ক্যাশ কালেকশন (Cash)';
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _packages = [
    {'id': '1', 'name': 'প্রথমা প্যাকেজ (Prothoma - ৳99)', 'price': 99, 'points': 999},
    {'id': '2', 'name': 'আস্থা প্যাকেজ (Astha - ৳199)', 'price': 199, 'points': 1499},
    {'id': '3', 'name': 'সহযাত্রা প্যাকেজ (Sohojatra - ৳299)', 'price': 299, 'points': 2000},
    {'id': '4', 'name': 'মাতৃমমতা প্যাকেজ (Matrumomota - ৳499)', 'price': 499, 'points': 2500},
    {'id': '5', 'name': 'আপনজন প্যাকেজ (Aponjon - ৳999)', 'price': 999, 'points': 5500},
    {'id': 'none', 'name': 'ফ্রি অ্যাকাউন্ট (প্যাকেজ ছাড়া - ৳0)', 'price': 0, 'points': 0},
  ];

  final List<Map<String, String>> _paymentMethods = [
    {'id': 'cash', 'label': 'ক্যাশ কালেকশন (Cash)'},
    {'id': 'qr', 'label': 'বিকাশ / নগদ (Merchant QR)'},
    {'id': 'eps', 'label': 'ডিজিটাল পেমেন্ট (EPS Gateways)'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final address = _addressController.text.trim().isEmpty ? 'মাঠ পর্যায়' : _addressController.text.trim();

    final newCustomer = {
      'id': 'REG-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      'name': name,
      'phone': phone,
      'age': _ageController.text.trim().isEmpty ? 'N/A' : _ageController.text.trim(),
      'gender': _selectedGender,
      'address': address,
      'package': _selectedPackageName.split(' (')[0],
      'price': _packagePrice,
      'paymentMethod': _selectedPaymentMethodLabel.split(' (')[0],
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

                      // Password Field (Required by Backend API Note #3)
                      _buildInputLabel('পাসওয়ার্ড (রোগীর অ্যাকাউন্টের জন্য) *'),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                        decoration: _buildInputDecoration(
                          hint: 'সর্বনিম্ন ৬ অক্ষরের পাসওয়ার্ড',
                          icon: Icons.lock_outline_rounded,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'রোগীর জন্য একটি পাসওয়ার্ড তৈরি করুন';
                          if (value.trim().length < 6) return 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে';
                          return null;
                        },
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
                            value: _selectedPackageId,
                            isExpanded: true,
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                            items: _packages.map((pkg) {
                              return DropdownMenuItem<String>(
                                value: pkg['id'] as String,
                                child: Text(pkg['name'] as String),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                final matched = _packages.firstWhere((element) => element['id'] == val);
                                setState(() {
                                  _selectedPackageId = val;
                                  _selectedPackageName = matched['name'] as String;
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
                            value: _selectedPaymentMethodId,
                            isExpanded: true,
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                            items: _paymentMethods.map((method) {
                              return DropdownMenuItem<String>(
                                value: method['id']!,
                                child: Text(method['label']!),
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
