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
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
      height: 68,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
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
          final iconColor = isSelected ? primaryTeal : textMuted;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Centered Top Active Line Indicator
                  Container(
                    height: 3.5,
                    width: 24,
                    decoration: BoxDecoration(
                      color: isSelected ? primaryTeal : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Custom Asset Icon (SVG or PNG)
                  SizedBox(
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
                  ),

                  // Label
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: iconColor,
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
