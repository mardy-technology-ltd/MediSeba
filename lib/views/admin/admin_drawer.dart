import 'package:flutter/material.dart';
import 'admin_dashboard_view.dart';
import 'admin_doctors_management_view.dart';
import 'admin_patient_records_view.dart';
import 'admin_appointments_management_view.dart';
import 'admin_medicine_inventory_view.dart';
import 'admin_inbox_view.dart';

class AdminDrawer extends StatelessWidget {
  final int selectedIndex;

  const AdminDrawer({
    super.key,
    required this.selectedIndex,
  });

  static const brandGreen = Color(0xFF10B981);
  static const darkGreen = Color(0xFF005C45);
  static const textDark = Color(0xFF0F172A);

  @override
  Widget build(BuildContext context) {
    // Exact drawer list from screenshot (left phone screen)
    final menuItems = [
      {'title': 'ড্যাশবোর্ড', 'icon': Icons.grid_view_rounded, 'index': 0},
      {'title': 'ইনবক্স ও অ্যাপ্লিকেশন', 'icon': Icons.mail_outline_rounded, 'index': 1},
      {'title': 'প্যাকেজ ও ফাইনান্সিয়াল অডিট', 'icon': Icons.show_chart_rounded, 'index': 2},
      {'title': 'সেলস টিম ও হায়ারার্কি', 'icon': Icons.work_outline_rounded, 'index': 3},
      {'title': 'ডাক্তার ম্যানেজমেন্ট', 'icon': Icons.medical_services_outlined, 'index': 4},
      {'title': 'রোগীর রেকর্ড', 'icon': Icons.assignment_ind_outlined, 'index': 5},
      {'title': 'সিরিয়াল ও অ্যাপয়েন্টমেন্ট', 'icon': Icons.calendar_month_outlined, 'index': 6},
      {'title': 'মেডিসিন ইনভентরি', 'icon': Icons.medication_outlined, 'index': 7},
      {'title': 'ডিজিটাল প্রেসক্রিপশন', 'icon': Icons.description_outlined, 'index': 8},
      {'title': 'সিস্টেম সেটিংস ও কন্ট্রোল', 'icon': Icons.settings_outlined, 'index': 9},
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header matching design precisely (Dark Green box with profile card & hamburger icon)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 46, 16, 20),
            decoration: const BoxDecoration(
              color: darkGreen, // Color(0xFF005C45)
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white30, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white24,
                    child: ClipOval(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&q=80&w=200',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.person_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'System Admin',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'admin@mediseba.org',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.menu_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),

          // Drawer Navigation List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // Centered Logo in White Area with Bengali Tagline
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 42,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.favorite_rounded,
                              size: 28,
                              color: Color(0xFFED1B24),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'মেডি সেবা',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFFF1F5F9), height: 1),
                const SizedBox(height: 8),

                // Drawer items matching the screenshot
                ...menuItems.map((item) {
                  final int itemIndex = item['index'] as int;
                  final bool isSelected = selectedIndex == itemIndex;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    child: Material(
                      color: isSelected ? const Color(0xFFF1F5F9) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        dense: true,
                        horizontalTitleGap: 12,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        leading: Icon(
                          item['icon'] as IconData,
                          color: isSelected ? darkGreen : const Color(0xFF475569),
                          size: 21,
                        ),
                        title: Text(
                          item['title'] as String,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? textDark : const Color(0xFF334155),
                          ),
                        ),
                        trailing: isSelected
                            ? Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: brandGreen,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : null,
                        onTap: () {
                          Navigator.pop(context); // Close drawer
                          if (isSelected) return;

                          _handleNavigation(context, itemIndex);
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Bottom Logout Button matching "[<-] ওয়েবসাইটে ফিরে যান"
          Container(
            padding: const EdgeInsets.all(16),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.pop(context); // Exit admin panel back to login/home
                },
                icon: const Icon(Icons.logout_rounded, size: 16),
                label: const Text(
                  'ওয়েবসাইটে ফিরে যান',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    Widget? nextScreen;

    if (index == 0) {
      nextScreen = const AdminDashboardView();
    } else if (index == 1) {
      // Inbox & Applications is opened as sub-page, we can push it
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminInboxView()),
      );
      return;
    } else if (index == 4) {
      nextScreen = const AdminDoctorsManagementView();
    } else if (index == 5) {
      nextScreen = const AdminPatientRecordsView();
    } else if (index == 6) {
      nextScreen = const AdminAppointmentsManagementView();
    } else if (index == 7) {
      nextScreen = const AdminMedicineInventoryView();
    }

    if (nextScreen != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextScreen!),
      );
    } else {
      // Show snackbar for unimplemented pages (index 2, 3, 8, 9)
      String title = '';
      if (index == 2) title = 'প্যাকেজ ও ফাইন্যান্সিয়াল অডিট';
      if (index == 3) title = 'সেলস টিম ও হায়ারার্কি';
      if (index == 8) title = 'ডিজিটাল প্রেসক্রিপশন';
      if (index == 9) title = 'সিস্টেম সেটিংস ও কন্ট্রোল';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$title সেকশন নির্বাচন করা হয়েছে'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
