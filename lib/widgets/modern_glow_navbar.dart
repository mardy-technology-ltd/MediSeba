import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ModernGlowNavBarItem {
  final String? iconPath;
  final IconData? icon;
  final String label;
  final bool isPng;

  const ModernGlowNavBarItem({
    this.iconPath,
    this.icon,
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
  static const textMuted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: brandGreen.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final isSelected = currentIndex == index;
                  final iconColor = isSelected ? brandGreen : textMuted;

                  final Widget iconWidget;
                  if (item.icon != null) {
                    iconWidget = Icon(item.icon, size: 24, color: iconColor);
                  } else if (item.isPng && item.iconPath != null) {
                    iconWidget = Image.asset(
                      item.iconPath!,
                      width: 24,
                      height: 24,
                      color: iconColor,
                      colorBlendMode: BlendMode.srcIn,
                      fit: BoxFit.contain,
                    );
                  } else if (item.iconPath != null) {
                    iconWidget = SvgPicture.asset(
                      item.iconPath!,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                      fit: BoxFit.contain,
                    );
                  } else {
                    iconWidget = Icon(Icons.circle, size: 24, color: iconColor);
                  }

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(index),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Active Glow Pill Container Badge or Regular Icon
                          isSelected
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: brandGreen.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: brandGreen.withValues(alpha: 0.15), width: 0.8),
                                  ),
                                  child: iconWidget,
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: iconWidget,
                                ),

                          const SizedBox(height: 4),

                          // Label
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              color: iconColor,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
