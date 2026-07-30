import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ModernGlowNavBarItem {
  final String iconPath;
  final String label;
  final bool isPng;

  const ModernGlowNavBarItem({
    required this.iconPath,
    required this.label,
    this.isPng = false,
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
  static const textMuted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = currentIndex == index;
            final iconColor = isSelected ? primaryTeal : textMuted;

            final iconWidget = SizedBox(
              width: 24,
              height: 24,
              child: item.isPng
                  ? Image.asset(
                      item.iconPath,
                      width: 24,
                      height: 24,
                      color: iconColor,
                      colorBlendMode: BlendMode.srcIn,
                      fit: BoxFit.contain,
                    )
                  : SvgPicture.asset(
                      item.iconPath,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                      fit: BoxFit.contain,
                    ),
            );

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Active Pill Container Badge or Regular Icon
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryTeal.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: iconWidget,
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: iconWidget,
                      ),

                    const SizedBox(height: 4),

                    // Label
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: iconColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
