import 'package:flutter/material.dart';
import 'admin_dashboard_view.dart';
import 'admin_inbox_view.dart';
import 'admin_job_circulars_view.dart';
import 'admin_doctors_management_view.dart';
import 'admin_patient_records_view.dart';
import 'admin_appointments_management_view.dart';
import 'admin_drawer.dart';

class AdminMedicineInventoryView extends StatefulWidget {
  const AdminMedicineInventoryView({super.key});

  @override
  State<AdminMedicineInventoryView> createState() => _AdminMedicineInventoryViewState();
}

class _AdminMedicineInventoryViewState extends State<AdminMedicineInventoryView> {
  static const brandGreen = Color(0xFF0F9D58);
  static const darkGreen = Color(0xFF006B4A);
  static const textDark = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  int _selectedTabIndex = 0; // 0: Medicines, 1: Orders
  String _selectedCategoryFilter = 'সবকটি';
  bool _isRefreshing = false;

  // Mock Medicine Data matching Web View
  final List<Map<String, dynamic>> _medicines = [
    {
      'id': 'med_101',
      'brandName': 'Napa Extra 500mg',
      'genericName': 'Paracetamol + Caffeine',
      'manufacturer': 'Beximco Pharma',
      'dosageForm': 'Tablet',
      'strength': '500mg',
      'price': 2.5,
      'stock': 1250,
      'isActive': true,
    },
    {
      'id': 'med_102',
      'brandName': 'Seclo 20mg',
      'genericName': 'Omeprazole',
      'manufacturer': 'Square Pharmaceuticals',
      'dosageForm': 'Capsule',
      'strength': '20mg',
      'price': 6.0,
      'stock': 800,
      'isActive': true,
    },
    {
      'id': 'med_103',
      'brandName': 'Sergel 20mg',
      'genericName': 'Esomeprazole',
      'manufacturer': 'Incepta Pharmaceuticals',
      'dosageForm': 'Capsule',
      'strength': '20mg',
      'price': 7.0,
      'stock': 650,
      'isActive': true,
    },
  ];

  // Mock Customer Orders Data
  final List<Map<String, dynamic>> _customerOrders = [
    {
      'id': 'ORD-20260822-4920',
      'patientName': 'মোহাম্মদ আলী',
      'phone': '01711223344',
      'dateTime': 'আজ, ১২:৩০ PM',
      'items': 'Napa Extra 500mg (20 Pcs), Seclo 20mg (14 Pcs)',
      'totalBill': 134.0,
      'status': 'পেন্ডিং',
      'statusColor': Color(0xFFD97706),
      'statusBg': Color(0xFFFEF3C7),
    },
    {
      'id': 'ORD-20260822-1042',
      'patientName': 'তানিয়া রহমান',
      'phone': '01811223344',
      'dateTime': 'আজ, ১১:১৫ AM',
      'items': 'Sergel 20mg (30 Pcs)',
      'totalBill': 210.0,
      'status': 'প্রসেসিং',
      'statusColor': Color(0xFF2563EB),
      'statusBg': Color(0xFFEFF6FF),
    },
    {
      'id': 'ORD-20260822-0987',
      'patientName': 'কবির হোসেন',
      'phone': '01911223344',
      'dateTime': 'গতকাল, বিকাল ০৪:১০ PM',
      'items': 'Napa Extra 500mg (10 Pcs), Sergel 20mg (10 Pcs)',
      'totalBill': 95.0,
      'status': 'ডেলিভারড',
      'statusColor': Color(0xFF10B981),
      'statusBg': Color(0xFFECFDF5),
    },
  ];

  final List<String> _categories = ['সবকটি', 'Tablet', 'Capsule', 'Syrup', 'Injection', 'Drops'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtered lists
  List<Map<String, dynamic>> get _filteredMedicines {
    return _medicines.where((med) {
      final matchesSearch = _searchQuery.isEmpty ||
          med['brandName'].toString().toLowerCase().contains(_searchQuery) ||
          med['genericName'].toString().toLowerCase().contains(_searchQuery) ||
          med['manufacturer'].toString().toLowerCase().contains(_searchQuery);

      final matchesCategory = _selectedCategoryFilter == 'সবকটি' ||
          med['dosageForm'].toString().toLowerCase() == _selectedCategoryFilter.toLowerCase();

      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<Map<String, dynamic>> get _filteredOrders {
    if (_searchQuery.isEmpty) return _customerOrders;
    return _customerOrders.where((order) {
      return order['id'].toString().toLowerCase().contains(_searchQuery) ||
          order['patientName'].toString().toLowerCase().contains(_searchQuery) ||
          order['phone'].toString().contains(_searchQuery) ||
          order['status'].toString().toLowerCase().contains(_searchQuery);
    }).toList();
  }

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ইনভেন্টরি ও অর্ডার ডাটা সফলভাবে রিফ্রেশ করা হয়েছে।'),
          backgroundColor: brandGreen,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _toggleMedicineStatus(int index) {
    setState(() {
      _medicines[index]['isActive'] = !(_medicines[index]['isActive'] as bool);
    });
    final active = _medicines[index]['isActive'] as bool;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          active
              ? '${_medicines[index]['brandName']} ইনভেন্টরিতে সক্রিয় করা হয়েছে।'
              : '${_medicines[index]['brandName']} ইনভেন্টরিতে ইন-এক্টিভ করা হয়েছে।',
        ),
        backgroundColor: active ? brandGreen : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddMedicineModal() {
    final brandController = TextEditingController();
    final genericController = TextEditingController();
    final companyController = TextEditingController();
    final strengthController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    String selectedForm = 'Tablet';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                      children: const [
                        Icon(Icons.add_circle_outline_rounded, color: brandGreen, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'নতুন ওষুধ যুক্ত করুন',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: brandController,
                      label: 'ওষুধের নাম (Brand Name)',
                      hint: 'যেমন: Napa Extra',
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: genericController,
                      label: 'জেনেরিক নাম (Generic Name)',
                      hint: 'যেমন: Paracetamol + Caffeine',
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: companyController,
                      label: 'প্রস্তুতকারক কোম্পানি (Manufacturer)',
                      hint: 'যেমন: Beximco Pharma',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Dosage Form',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textDark),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFCBD5E1)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedForm,
                                    isExpanded: true,
                                    items: _categories.skip(1).map((String val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text(val),
                                      );
                                    }).toList(),
                                    onChanged: (newVal) {
                                      if (newVal != null) {
                                        setModalState(() {
                                          selectedForm = newVal;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: strengthController,
                            label: 'শক্তির মাত্রা (Strength)',
                            hint: 'যেমন: 500mg',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: priceController,
                            label: 'খুচরা মূল্য (৳)',
                            hint: 'যেমন: 2.50',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: stockController,
                            label: 'স্টক সংখ্যা (Pcs)',
                            hint: 'যেমন: 1000',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandGreen,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (brandController.text.isEmpty ||
                              priceController.text.isEmpty ||
                              stockController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('দয়া করে প্রয়োজনীয় ফিল্ডগুলো পূরণ করুন।')),
                            );
                            return;
                          }
                          setState(() {
                            _medicines.insert(0, {
                              'id': 'med_${DateTime.now().millisecondsSinceEpoch}',
                              'brandName': brandController.text.trim(),
                              'genericName': genericController.text.trim(),
                              'manufacturer': companyController.text.trim(),
                              'dosageForm': selectedForm,
                              'strength': strengthController.text.trim(),
                              'price': double.tryParse(priceController.text.trim()) ?? 1.0,
                              'stock': int.tryParse(stockController.text.trim()) ?? 0,
                              'isActive': true,
                            });
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('নতুন ওষুধ ইনভেন্টরিতে যুক্ত হয়েছে!'),
                              backgroundColor: brandGreen,
                            ),
                          );
                        },
                        child: const Text(
                          'নিশ্চিত করুন',
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditStockModal(int index) {
    final med = _medicines[index];
    final priceController = TextEditingController(text: med['price'].toString());
    final stockController = TextEditingController(text: med['stock'].toString());

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
                children: const [
                  Icon(Icons.edit_note_rounded, color: brandGreen, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'স্টক ও মূল্য এডিট করুন',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'ওষুধ: ${med['brandName']} (${med['dosageForm']})',
                style: const TextStyle(fontSize: 13, color: textMuted),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: priceController,
                      label: 'খুচরা মূল্য (৳)',
                      hint: '৳',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: stockController,
                      label: 'বর্তমান স্টক (Pcs)',
                      hint: 'Pcs',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    final newPrice = double.tryParse(priceController.text.trim()) ?? med['price'];
                    final newStock = int.tryParse(stockController.text.trim()) ?? med['stock'];
                    setState(() {
                      _medicines[index]['price'] = newPrice;
                      _medicines[index]['stock'] = newStock;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('স্টক ও মূল্য সফলভাবে আপডেট করা হয়েছে।'),
                        backgroundColor: brandGreen,
                      ),
                    );
                  },
                  child: const Text(
                    'আপডেট নিশ্চিত করুন',
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUpdateOrderStatusModal(int index) {
    final order = _customerOrders[index];
    final statuses = ['পেন্ডিং', 'প্রসেসিং', 'ডেলিভারড', 'বাতিল'];
    final colors = [
      Color(0xFFD97706),
      Color(0xFF2563EB),
      Color(0xFF10B981),
      Color(0xFFEF4444),
    ];
    final bgs = [
      Color(0xFFFEF3C7),
      Color(0xFFEFF6FF),
      Color(0xFFECFDF5),
      Color(0xFFFEF2F2),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
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
              const Text(
                'অর্ডার স্ট্যাটাস পরিবর্তন',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark),
              ),
              const SizedBox(height: 4),
              Text(
                'অর্ডার আইডি: #${order['id']}',
                style: const TextStyle(fontSize: 13, color: textMuted),
              ),
              const SizedBox(height: 16),
              Column(
                children: List.generate(statuses.length, (idx) {
                  return ListTile(
                    dense: true,
                    leading: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: bgs[idx],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        statuses[idx],
                        style: TextStyle(color: colors[idx], fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: const Text('এই স্ট্যাটাসে পরিবর্তন করুন'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      setState(() {
                        _customerOrders[index]['status'] = statuses[idx];
                        _customerOrders[index]['statusColor'] = colors[idx];
                        _customerOrders[index]['statusBg'] = bgs[idx];
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('অর্ডার স্ট্যাটাস সফলভাবে "${statuses[idx]}" এ পরিবর্তন করা হয়েছে।'),
                          backgroundColor: colors[idx],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textDark),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14, color: textDark),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AdminDrawer(selectedIndex: 8),
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: brandGreen, size: 26),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'মেডিসিন ইনভেন্টরি',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textDark),
            ),
            Text(
              'MEDISHOP INVENTORY & ORDERS',
              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: brandGreen, letterSpacing: 0.5),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: brandGreen),
                  )
                : const Icon(Icons.refresh_rounded, color: brandGreen, size: 24),
            onPressed: _isRefreshing ? null : _refreshData,
            tooltip: 'ডাটা রিফ্রেশ করুন',
          ),
        ],
      ),
      floatingActionButton: _selectedTabIndex == 0
          ? FloatingActionButton(
              onPressed: _showAddMedicineModal,
              backgroundColor: brandGreen,
              tooltip: 'নতুন ওষুধ যুক্ত করুন',
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Web Preview Replication Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.medication_rounded, color: brandGreen, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'মেডিশপ ইনভেন্টরি ও কাস্টমার অর্ডার কন্ট্রোল',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textDark),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'ওষুধের তালিকা, স্টক, মূল্য আপডেট এবং অনলাইন কাস্টমার অর্ডার পরিচালনা করুন।',
                          style: TextStyle(fontSize: 11, color: textMuted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 2. Custom Tabs matching Web Screen Pills style
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabPill(
                        index: 0,
                        icon: Icons.inventory_2_outlined,
                        title: 'ওষুধের স্টক (${_filteredMedicines.length})',
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _buildTabPill(
                        index: 1,
                        icon: Icons.shopping_bag_outlined,
                        title: 'গ্রাহক অর্ডারস (${_filteredOrders.length})',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 3. Search and Category Filter chips (Category chips only show in Tab 0: Medicines)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.015),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val.trim().toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: _selectedTabIndex == 0
                            ? 'ওষুধের নাম, জেনেরিক বা কোম্পানি দিয়ে খুঁজুন...'
                            : 'অর্ডার আইডি বা রোগীর নাম দিয়ে খুঁজুন...',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
                        prefixIcon: const Icon(Icons.search_rounded, color: brandGreen, size: 20),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, color: Color(0xFF94A3B8), size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                      ),
                    ),
                  ),
                  if (_selectedTabIndex == 0) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 34,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          final isSelected = _selectedCategoryFilter == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: FilterChip(
                              label: Text(
                                cat == 'সবকটি' ? 'সকল' : cat,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF475569),
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: darkGreen,
                              checkmarkColor: Colors.white,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected ? darkGreen : const Color(0xFFE2E8F0),
                                ),
                              ),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategoryFilter = cat;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 4. Tab Contents list
            Expanded(
              child: _selectedTabIndex == 0 ? _buildMedicinesTab() : _buildOrdersTab(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabPill({required int index, required IconData icon, required String title}) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
          _searchController.clear();
          _searchQuery = '';
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? darkGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF475569),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicinesTab() {
    final list = _filteredMedicines;
    if (list.isEmpty) {
      return const Center(
        child: Text(
          'কোনো ওষুধ পাওয়া যায়নি।',
          style: TextStyle(color: textMuted, fontSize: 13.5),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final med = list[index];
        final isMedActive = med['isActive'] as bool;
        final actualIndex = _medicines.indexOf(med);

        Color badgeColor;
        Color badgeBg;
        if (med['dosageForm'] == 'Tablet') {
          badgeColor = const Color(0xFF0284C7);
          badgeBg = const Color(0xFFF0F9FF);
        } else if (med['dosageForm'] == 'Capsule') {
          badgeColor = const Color(0xFF0F766E);
          badgeBg = const Color(0xFFF0FDFA);
        } else {
          badgeColor = const Color(0xFF8B5CF6);
          badgeBg = const Color(0xFFF5F3FF);
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isMedActive ? Colors.white : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isMedActive ? const Color(0xFFE2E8F0) : const Color(0xFFCBD5E1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.01),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      med['dosageForm'],
                      style: TextStyle(
                        color: badgeColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '৳ ${med['price']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: brandGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                med['brandName'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isMedActive ? textDark : textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'জেনেরিক: ${med['genericName']}',
                style: const TextStyle(fontSize: 12.5, color: textMuted),
              ),
              Text(
                'কোম্পানি: ${med['manufacturer']}',
                style: const TextStyle(fontSize: 12.5, color: textMuted),
              ),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.inventory_rounded, size: 14, color: textMuted),
                      const SizedBox(width: 4),
                      Text(
                        'বর্তমান স্টক: ',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isMedActive ? textDark : textMuted,
                        ),
                      ),
                      Text(
                        '${med['stock']} Pcs',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: med['stock'] < 100
                              ? Colors.red
                              : (isMedActive ? brandGreen : textMuted),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_rounded, color: Color(0xFF64748B), size: 18),
                        onPressed: () => _showEditStockModal(actualIndex),
                        tooltip: 'মূল্য ও স্টক পরিবর্তন করুন',
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFF1F5F9),
                          padding: const EdgeInsets.all(6),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Switch(
                        value: isMedActive,
                        activeThumbColor: brandGreen,
                        activeTrackColor: brandGreen.withValues(alpha: 0.3),
                        onChanged: (val) => _toggleMedicineStatus(actualIndex),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrdersTab() {
    final list = _filteredOrders;
    if (list.isEmpty) {
      return const Center(
        child: Text(
          'কোনো কাস্টমার অর্ডার পাওয়া যায়নি।',
          style: TextStyle(color: textMuted, fontSize: 13.5),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final order = list[index];
        final actualIndex = _customerOrders.indexOf(order);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.01),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID: #${order['id']}',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: order['statusBg'],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order['status'],
                      style: TextStyle(
                        color: order['statusColor'],
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.person_outline_rounded, size: 14, color: textMuted),
                  const SizedBox(width: 4),
                  Text(
                    'ক্রেতা: ${order['patientName']}',
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: textDark),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.phone_iphone_rounded, size: 14, color: textMuted),
                  const SizedBox(width: 4),
                  Text(
                    'মোবাইল: ${order['phone']}',
                    style: const TextStyle(fontSize: 12.5, color: textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 14, color: textMuted),
                  const SizedBox(width: 4),
                  Text(
                    'তারিখ: ${order['dateTime']}',
                    style: const TextStyle(fontSize: 12.5, color: textMuted),
                  ),
                ],
              ),
              const Divider(height: 18, color: Color(0xFFF1F5F9)),
              const Text(
                'ক্রয়কৃত ওষুধসমূহ:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textDark),
              ),
              const SizedBox(height: 4),
              Text(
                order['items'],
                style: const TextStyle(fontSize: 12.5, color: textMuted, height: 1.3),
              ),
              const Divider(height: 18, color: Color(0xFFF1F5F9)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'মোট বিল: ৳ ${order['totalBill']}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: brandGreen,
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF1F5F9),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => _showUpdateOrderStatusModal(actualIndex),
                        icon: const Icon(Icons.change_circle_rounded, size: 14, color: Color(0xFF475569)),
                        label: const Text(
                          'স্ট্যাটাস পরিবর্তন',
                          style: TextStyle(fontSize: 11, color: Color(0xFF334155), fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (order['status'] != 'বাতিল' && order['status'] != 'ডেলিভারড') ...[
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined, color: Colors.red, size: 18),
                          onPressed: () {
                            setState(() {
                              _customerOrders[actualIndex]['status'] = 'বাতিল';
                              _customerOrders[actualIndex]['statusColor'] = Color(0xFFEF4444);
                              _customerOrders[actualIndex]['statusBg'] = Color(0xFFFEF2F2);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('অर्डरটি বাতিল করা হয়েছে।'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          tooltip: 'অर्डर বাতিল করুন',
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFFEF2F2),
                            padding: const EdgeInsets.all(6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build Navigation Drawer matching other screens
  Widget _buildAdminDrawer(BuildContext context) {
    return const AdminDrawer(selectedIndex: 7);
  }

  Widget _ignored_buildAdminDrawer(BuildContext context) {
    final menuItems = [
      {'title': 'ড্যাশবোর্ড (Overview)', 'icon': Icons.dashboard_rounded, 'selected': false},
      {'title': 'ইনবক্স ও অ্যাপ্লিকেশন', 'icon': Icons.mail_outline_rounded, 'selected': false},
      {'title': 'চাকরি ও নিয়োগ সার্কুলার', 'icon': Icons.work_outline_rounded, 'selected': false},
      {'title': 'ডাক্তার ম্যানেজমেন্ট', 'icon': Icons.medical_services_outlined, 'selected': false},
      {'title': 'রোগীর রেকর্ডস', 'icon': Icons.people_outline_rounded, 'selected': false},
      {'title': 'সিরিয়াল ও অ্যাপয়েন্টমেন্ট', 'icon': Icons.calendar_month_outlined, 'selected': false},
      {'title': 'মেডিসিন ইনভেন্টরি', 'icon': Icons.medication_outlined, 'selected': true},
      {'title': 'ডিজিটাল প্রেসক্রিপশন', 'icon': Icons.description_outlined, 'selected': false},
      {'title': 'সিস্টেম সেটিং ও কন্ট্রোল', 'icon': Icons.settings_outlined, 'selected': false},
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
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
                        } else if (index == 2) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminJobCircularsView(),
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
        ],
      ),
    );
  }
}
