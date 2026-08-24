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

  static const brandGreen = Color(0xFF008536);
  static const brandAccent = Color(0xFF02A946);
  static const primaryTeal = Color(0xFF0D9488);
  static const textDark = Color(0xFF1E293B);
  static const textMuted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFA), // Soft mint tint matching app background & cards
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D9488).withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
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
                    // Active Mint Pill Container Badge or Regular Icon
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryTeal.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: iconWidget,
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
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
