import 'package:flutter/material.dart';

class ModernGlowNavBarItem {
  final IconData icon;
  final String label;

  const ModernGlowNavBarItem({
    required this.icon,
    required this.label,
  });
}

class ModernGlowNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<ModernGlowNavBarItem> items;

  const ModernGlowNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  static const primaryTeal = Color(0xFF0D9488);
  static const textMuted = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      height: 68,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = currentIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Active Line Indicator
                  Container(
                    height: 3.5,
                    width: 24,
                    decoration: BoxDecoration(
                      color: isSelected ? primaryTeal : Colors.transparent,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(3),
                      ),
                    ),
                  ),

                  // Icon
                  Icon(
                    item.icon,
                    color: isSelected ? primaryTeal : textMuted,
                    size: 23,
                  ),

                  // Label
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? primaryTeal : textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
