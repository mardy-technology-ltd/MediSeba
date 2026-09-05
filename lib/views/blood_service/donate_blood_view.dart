import 'package:flutter/material.dart';
import 'blood_request_success_view.dart';

class DonateBloodView extends StatefulWidget {
  const DonateBloodView({super.key});

  @override
  State<DonateBloodView> createState() => _DonateBloodViewState();
}

class _DonateBloodViewState extends State<DonateBloodView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedDivision;
  String? _selectedDistrict;
  String? _selectedBloodGroup;
  String? _selectedGender;

  DateTime? _lastDonationDate;
  bool _isDonateBloodActive = true;

  final List<String> _divisions = [
    'Dhaka', 'Chittagong', 'Rajshahi', 'Khulna', 'Barisal', 'Sylhet', 'Rangpur', 'Mymensingh'
  ];

  final List<String> _districts = [
    'Dhaka', 'Gazipur', 'Narayanganj', 'Tangail', 'Faridpur', 'Chittagong', 'Khulna'
  ];

  final List<String> _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'
  ];

  final List<String> _genders = [
    'Male', 'Female', 'Other'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
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
          'রক্ত দিতে চাই',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF222222),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              _buildLabel('Name'),
              _buildTextField(
                controller: _nameController,
                hint: 'Enter Full Name',
              ),

              // Select Division
              _buildLabel('Select Division'),
              _buildDropdownField(
                value: _selectedDivision,
                hint: 'Select Division',
                items: _divisions,
                onChanged: (val) => setState(() => _selectedDivision = val),
              ),

              // Select District
              _buildLabel('Select District'),
              _buildDropdownField(
                value: _selectedDistrict,
                hint: 'Select District',
                items: _districts,
                onChanged: (val) => setState(() => _selectedDistrict = val),
              ),

              // Contact Number
              _buildLabel('Contact Number'),
              _buildTextField(
                controller: _contactController,
                hint: 'Enter Contact Number',
                keyboardType: TextInputType.phone,
              ),

              // Address
              _buildLabel('Address'),
              _buildTextField(
                controller: _addressController,
                hint: 'Enter Address / Present Location',
              ),

              // Select Blood Group
              _buildLabel('Select Blood Group'),
              _buildDropdownField(
                value: _selectedBloodGroup,
                hint: 'Select Blood Group',
                items: _bloodGroups,
                onChanged: (val) => setState(() => _selectedBloodGroup = val),
              ),

              // Gender
              _buildLabel('Gender'),
              _buildDropdownField(
                value: _selectedGender,
                hint: 'Select Gender',
                items: _genders,
                onChanged: (val) => setState(() => _selectedGender = val),
              ),

              // Last Blood Donation Date
              _buildLabel('Last Blood Donation Date'),
              _buildDateField(),

              // Donate Blood Switch
              _buildSwitchRow(
                label: 'Donate Blood',
                value: _isDonateBloodActive,
                onChanged: (val) => setState(() => _isDonateBloodActive = val),
              ),

              // Submit Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF475569),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF94A3B8)),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B))),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDateField() {
    final dateStr = _lastDonationDate != null
        ? '${_lastDonationDate!.day.toString().padLeft(2, '0')}/${_lastDonationDate!.month.toString().padLeft(2, '0')}/${_lastDonationDate!.year}'
        : 'Select Date';

    return GestureDetector(
      onTap: _selectLastDonationDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateStr,
              style: TextStyle(
                fontSize: 14,
                color: _lastDonationDate != null ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
              ),
            ),
            const Icon(Icons.calendar_today_rounded, color: Color(0xFF94A3B8), size: 18),
          ],
        ),
      ),
    );
  }

  Future<void> _selectLastDonationDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 90)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF008744),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _lastDonationDate = picked);
    }
  }

  Widget _buildSwitchRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF008744),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF008744),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          onPressed: _handleSubmit,
          child: const Text(
            'Submit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    showBloodRequestSuccessDialog(context);
  }
}
