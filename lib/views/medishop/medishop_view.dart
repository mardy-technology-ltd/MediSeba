import 'dart:async';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/language_controller.dart';
import '../../models/medicine_model.dart';
import '../../services/api_service.dart';

class MediShopView extends StatefulWidget {
  final LanguageController? languageController;

  const MediShopView({super.key, this.languageController});

  @override
  State<MediShopView> createState() => _MediShopViewState();
}

class _MediShopViewState extends State<MediShopView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  late final LanguageController _langController;

  List<MedicineModel> _allMedicines = [];
  List<MedicineModel> _filteredMedicines = [];
  bool _isLoading = true;
  String _selectedCategory = 'সবকটি';

  final List<String> _categories = [
    'সবকটি',
    'Tablet',
    'Syrup',
    'Capsule',
    'Injection',
    'Drops',
  ];

  @override
  void initState() {
    super.initState();
    _langController = widget.languageController ?? LanguageController();
    _fetchMedicines();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchMedicines({String query = '', bool forceRefresh = false}) async {
    setState(() => _isLoading = true);

    try {
      final list = await ApiService.searchMedicines(query: query, forceRefresh: forceRefresh);
      if (mounted) {
        setState(() {
          _allMedicines = list;
          _applyFilters();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (query.trim().length >= 2 || query.isEmpty) {
        _fetchMedicines(query: query);
      } else {
        _applyFilters();
      }
    });
  }

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredMedicines = _allMedicines.where((med) {
        final matchesQuery = query.isEmpty ||
            med.brandName.toLowerCase().contains(query) ||
            med.genericName.toLowerCase().contains(query) ||
            med.manufacturer.toLowerCase().contains(query);

        final matchesCategory = _selectedCategory == 'সবকটি' ||
            med.dosageForm.toLowerCase() == _selectedCategory.toLowerCase();

        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  IconData _getDosageIcon(String dosageForm) {
    final form = dosageForm.toLowerCase();
    if (form.contains('syrup') || form.contains('liquid') || form.contains('solution')) {
      return Icons.local_drink_rounded;
    } else if (form.contains('injection') || form.contains('vial')) {
      return Icons.vaccines_rounded;
    } else if (form.contains('drop') || form.contains('lotion')) {
      return Icons.water_drop_rounded;
    } else if (form.contains('capsule')) {
      return Icons.grain_rounded;
    }
    return Icons.medication_rounded;
  }

  void _handleOrderMedicine(MedicineModel med) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${med.brandName} (${med.strength}) আপনার কার্টে যুক্ত করা হয়েছে!',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_langController.tr('মেডিশপ (MediShop)', 'MediShop Pharmacy'), style: AppTextStyles.heading2.copyWith(fontSize: 18)),
            Text(
              _langController.tr('১১,৯৯৯+ অরিজিনাল ওষুধ ক্যাটালগ', '11,999+ Genuine Medicine Catalog'),
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('কার্ট ফিচারটি বর্তমানে ডেভলপমেন্টের অধীনে রয়েছে।'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchMedicines(query: _searchController.text, forceRefresh: true),
        color: AppColors.primary,
        child: Column(
          children: [
            // Search Bar & Filter Section
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: [
                  // Search Input Field
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'ওষুধের নাম, জেনেটিক বা কোম্পানি লিখুন (যেমন: Napa, Ace)...',
                      hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                _fetchMedicines(query: '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.15)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Category Filter Chips
                  SizedBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = _selectedCategory == cat;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.background,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedCategory = cat;
                                  _applyFilters();
                                });
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Medicine List Stream
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  : _filteredMedicines.isEmpty
                      ? ListView(
                          children: [
                            const SizedBox(height: 60),
                            Icon(Icons.medication_liquid_rounded, size: 64, color: AppColors.textLight.withValues(alpha: 0.5)),
                            const SizedBox(height: 16),
                            const Center(
                              child: Text(
                                'কোনো ওষুধ পাওয়া যায়নি',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Center(
                              child: Text(
                                'অন্য কোনো নাম বা ব্র্যান্ড দিয়ে সার্চ করে দেখুন',
                                style: TextStyle(color: AppColors.textLight, fontSize: 13),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredMedicines.length,
                          itemBuilder: (context, index) {
                            final med = _filteredMedicines[index];
                            final iconData = _getDosageIcon(med.dosageForm);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                              ),
                              child: Row(
                                children: [
                                  // Medicine Avatar Icon
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.08),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      iconData,
                                      color: AppColors.primary,
                                      size: 24,
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  // Medicine Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                med.brandName,
                                                style: AppTextStyles.heading3.copyWith(
                                                  fontSize: 16,
                                                  color: AppColors.textPrimary,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (med.strength.isNotEmpty)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  med.strength,
                                                  style: const TextStyle(
                                                    color: AppColors.primary,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),

                                        const SizedBox(height: 4),

                                        // Generic Name
                                        Text(
                                          med.genericName,
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 6),

                                        // Dosage Form & Manufacturer Row
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                              decoration: BoxDecoration(
                                                color: AppColors.cardBg,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                med.dosageForm,
                                                style: const TextStyle(
                                                  color: AppColors.textSecondary,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(Icons.business_rounded, size: 12, color: AppColors.textLight),
                                            const SizedBox(width: 3),
                                            Expanded(
                                              child: Text(
                                                med.manufacturer,
                                                style: const TextStyle(
                                                  color: AppColors.textLight,
                                                  fontSize: 11,
                                                ),
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

                                  // Order Action Button
                                  InkWell(
                                    onTap: () => _handleOrderMedicine(med),
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.add_shopping_cart_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
