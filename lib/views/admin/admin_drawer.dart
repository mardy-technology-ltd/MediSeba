import 'package:flutter/material.dart';
import 'admin_dashboard_view.dart';
import 'admin_inbox_view.dart';
import 'admin_packages_audit_view.dart';
import 'admin_job_circulars_view.dart';
import 'admin_sales_team_view.dart';
import 'admin_doctors_management_view.dart';
import 'admin_patient_records_view.dart';
import 'admin_appointments_management_view.dart';
import 'admin_medicine_inventory_view.dart';

class AdminDrawer extends StatelessWidget {
  final int selectedIndex;

  const AdminDrawer({
    super.key,
    required this.selectedIndex,
  });

  static const brandGreen = Color(0xFF00A859);
  static const darkGreen = Color(0xFF005C45);
  static const textDark = Color(0xFF0F172A);

  @override
  Widget build(BuildContext context) {
    // Exact 11 items matching screenshot serial precisely
    final menuItems = [
      {'title': 'ড্যাশবোর্ড (Overview)', 'icon': Icons.grid_view_rounded, 'index': 0},
      {'title': 'ইনবক্স ও অ্যাপ্লিকেশন', 'icon': Icons.mail_outline_rounded, 'index': 1},
      {'title': 'প্যাকেজ ও ফাইন্যান্সিয়াল অডিট', 'icon': Icons.show_chart_rounded, 'index': 2},
      {'title': 'চাকরি ও নিয়োগ সার্কুলার', 'icon': Icons.business_center_outlined, 'index': 3},
      {'title': 'সেলস টিম ও হায়ারার্কি', 'icon': Icons.person_search_outlined, 'index': 4},
      {'title': 'ডাক্তার ম্যানেজমেন্ট', 'icon': Icons.medical_services_outlined, 'index': 5},
      {'title': 'রোগীর রেকর্ডস', 'icon': Icons.people_outline_rounded, 'index': 6},
      {'title': 'সিরিয়াল ও অ্যাপয়েন্টমেন্ট', 'icon': Icons.calendar_month_outlined, 'index': 7},
      {'title': 'মেডিসিন ইনভেন্টরি', 'icon': Icons.medication_outlined, 'index': 8},
      {'title': 'ডিজিটাল প্রেসক্রিপশন', 'icon': Icons.description_outlined, 'index': 9},
      {'title': 'সিস্টেম সেটিং ও কন্ট্রোল', 'icon': Icons.settings_outlined, 'index': 10},
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header with System Admin Info & Logo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 44, 16, 18),
            decoration: const BoxDecoration(
              color: darkGreen,
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white30, width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.person_rounded,
                      size: 26,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'System Admin',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'admin@mediseba.org',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.white70,
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

          // Navigation Menu List matching exact image style
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              children: [
                ...menuItems.map((item) {
                  final int itemIndex = item['index'] as int;
                  final bool isSelected = selectedIndex == itemIndex;
                  final String title = item['title'] as String;
                  final IconData icon = item['icon'] as IconData;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      decoration: BoxDecoration(
                        color: isSelected ? brandGreen : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: brandGreen.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            Navigator.pop(context); // Close drawer
                            _handleNavigation(context, itemIndex);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                            child: Row(
                              children: [
                                Icon(
                                  icon,
                                  color: isSelected ? Colors.white : brandGreen,
                                  size: 21,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                                      color: isSelected ? Colors.white : textDark,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Bottom Logout / Exit Option
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFEF4444),
                  backgroundColor: const Color(0xFFFEF2F2),
                  side: const BorderSide(color: Color(0xFFFCA5A5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout_rounded, size: 16),
                label: const Text(
                  'লগআউট করুন (Log Out)',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    if (index == selectedIndex) return;

    Widget? nextScreen;

    switch (index) {
      case 0:
        nextScreen = const AdminDashboardView();
        break;
      case 1:
        nextScreen = const AdminInboxView();
        break;
      case 2:
        nextScreen = const AdminPackagesAuditView();
        break;
      case 3:
        nextScreen = const AdminJobCircularsView();
        break;
      case 4:
        nextScreen = const AdminSalesTeamView();
        break;
      case 5:
        nextScreen = const AdminDoctorsManagementView();
        break;
      case 6:
        nextScreen = const AdminPatientRecordsView();
        break;
      case 7:
        nextScreen = const AdminAppointmentsManagementView();
        break;
      case 8:
        nextScreen = const AdminMedicineInventoryView();
        break;
    }

    if (nextScreen != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextScreen!),
      );
    } else {
      String title = '';
      if (index == 2) title = 'প্যাকেজ ও ফাইন্যান্সিয়াল অডিট';
      if (index == 4) title = 'সেলস টিম ও হায়ারার্কি';
      if (index == 9) title = 'ডিজিটাল প্রেসক্রিপশন';
      if (index == 10) title = 'সিস্টেম সেটিং ও কন্ট্রোল';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$title সেকশন নির্বাচন করা হয়েছে'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}
