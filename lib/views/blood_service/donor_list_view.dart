import 'package:flutter/material.dart';

class BloodDonor {
  final String name;
  final String bloodGroup;
  final String contactNumber;
  final String imageUrl;
  final String location;

  const BloodDonor({
    required this.name,
    required this.bloodGroup,
    required this.contactNumber,
    required this.imageUrl,
    this.location = 'Dhaka, Bangladesh',
  });
}

class DonorListView extends StatefulWidget {
  const DonorListView({super.key});

  @override
  State<DonorListView> createState() => _DonorListViewState();
}

class _DonorListViewState extends State<DonorListView> {
  final List<BloodDonor> _allDonors = const [
    BloodDonor(
      name: 'Angela',
      bloodGroup: 'A+',
      contactNumber: '01753227645',
      imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80',
    ),
    BloodDonor(
      name: 'Angela',
      bloodGroup: 'A-',
      contactNumber: '01753227645',
      imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80',
    ),
    BloodDonor(
      name: 'Angela',
      bloodGroup: 'O+',
      contactNumber: '01753227645',
      imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80',
    ),
    BloodDonor(
      name: 'Angela',
      bloodGroup: 'AB+',
      contactNumber: '01753227645',
      imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80',
    ),
    BloodDonor(
      name: 'Angela',
      bloodGroup: 'B+',
      contactNumber: '01753227645',
      imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80',
    ),
    BloodDonor(
      name: 'Angela',
      bloodGroup: 'A+',
      contactNumber: '01753227645',
      imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80',
    ),
    BloodDonor(
      name: 'Angela',
      bloodGroup: 'O+',
      contactNumber: '01753227645',
      imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80',
    ),
  ];

  late List<BloodDonor> _filteredDonors;
  String _searchQuery = '';
  String? _selectedFilterBloodGroup;

  @override
  void initState() {
    super.initState();
    _filteredDonors = List.from(_allDonors);
  }

  void _filterDonors(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _applyFilters();
    });
  }

  void _applyFilters() {
    _filteredDonors = _allDonors.where((donor) {
      final matchesSearch = donor.name.toLowerCase().contains(_searchQuery) ||
          donor.bloodGroup.toLowerCase().contains(_searchQuery) ||
          donor.contactNumber.contains(_searchQuery);

      final matchesGroup = _selectedFilterBloodGroup == null ||
          donor.bloodGroup == _selectedFilterBloodGroup;

      return matchesSearch && matchesGroup;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Color(0xFF64748B),
                size: 28,
              ),
            ),
          ),
        ),
        title: const Text(
          'রক্তদাতার লিস্ট',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF222222),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children: [
              // Search & Filter Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            color: Color(0xFF94A3B8),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              onChanged: _filterDonors,
                              style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
                              decoration: const InputDecoration(
                                hintText: 'Search Donor',
                                hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Filter Button
                  GestureDetector(
                    onTap: _showFilterBottomSheet,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: _selectedFilterBloodGroup != null
                            ? const Color(0xFF008744)
                            : const Color(0xFF64748B),
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Donor Cards List
              Expanded(
                child: _filteredDonors.isEmpty
                    ? const Center(
                        child: Text(
                          'কোন রক্তদাতা পাওয়া যায়নি',
                          style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _filteredDonors.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final donor = _filteredDonors[index];
                          return _buildDonorCard(donor);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonorCard(BloodDonor donor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              donor.imageUrl,
              width: 76,
              height: 76,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 76,
                height: 76,
                color: const Color(0xFFF1F5F9),
                child: const Icon(
                  Icons.person_rounded,
                  color: Color(0xFF008744),
                  size: 36,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donor.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Blood Group: ${donor.bloodGroup}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF008744),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Contact Number: ${donor.contactNumber}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          // View Button
          GestureDetector(
            onTap: () => _showDonorDetail(donor),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF008744),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'View',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final groups = ['All', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Blood Group',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: groups.map((g) {
                  final isSelected = (g == 'All' && _selectedFilterBloodGroup == null) ||
                      _selectedFilterBloodGroup == g;
                  return ChoiceChip(
                    label: Text(g),
                    selected: isSelected,
                    selectedColor: const Color(0xFF008744),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF334155),
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilterBloodGroup = g == 'All' ? null : g;
                        _applyFilters();
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDonorDetail(BloodDonor donor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(donor.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('রক্তের গ্রুপ: ${donor.bloodGroup}', style: const TextStyle(color: Color(0xFF008744), fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('যোগাযোগ: ${donor.contactNumber}'),
            const SizedBox(height: 8),
            Text('লোকেশন: ${donor.location}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বন্ধ করুন', style: TextStyle(color: Color(0xFF008744))),
          ),
        ],
      ),
    );
  }
}
