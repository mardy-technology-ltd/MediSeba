import 'package:flutter/material.dart';
import 'request_blood_view.dart';
import 'donor_list_view.dart';

class RoktoSebaView extends StatelessWidget {
  const RoktoSebaView({super.key});

  static const List<_BloodServiceOption> _options = [
    _BloodServiceOption(
      label: 'রক্ত চাই',
      icon: Icons.water_drop_rounded,
      iconColor: Color(0xFFE53935),
      iconBg: Color(0xFFFFEBEE),
      borderColor: Color(0xFFFFCDD2),
    ),
    _BloodServiceOption(
      label: 'রক্তদাতার লিস্ট',
      icon: Icons.format_list_bulleted_rounded,
      iconColor: Color(0xFF0F9D58),
      iconBg: Color(0xFFE8F5E9),
      borderColor: Color(0xFFC8E6C9),
    ),
    _BloodServiceOption(
      label: 'রক্ত দিতে চাই',
      icon: Icons.favorite_rounded,
      iconColor: Color(0xFFE53935),
      iconBg: Color(0xFFFFEBEE),
      borderColor: Color(0xFFFFCDD2),
    ),
    _BloodServiceOption(
      label: 'মতামত',
      icon: Icons.chat_bubble_rounded,
      iconColor: Color(0xFF1565C0),
      iconBg: Color(0xFFE3F2FD),
      borderColor: Color(0xFFBBDEFB),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
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
          'রক্তসেবা',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF222222),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.35,
            ),
            itemCount: _options.length,
            itemBuilder: (context, index) {
              final item = _options[index];
              return GestureDetector(
                onTap: () => _handleOptionTap(context, item.label),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: item.borderColor, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: item.iconColor.withValues(alpha: 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: item.iconBg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item.icon,
                          color: item.iconColor,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Text(
                          item.label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleOptionTap(BuildContext context, String option) {
    if (option == 'রক্ত চাই') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RequestBloodView()),
      );
      return;
    }
    if (option == 'রক্তদাতার লিস্ট') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DonorListView()),
      );
      return;
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$option অপশনে ক্লিক করা হয়েছে'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF009245),
      ),
    );
  }
}

class _BloodServiceOption {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final Color borderColor;

  const _BloodServiceOption({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.borderColor,
  });
}
