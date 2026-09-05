import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? titleIcon;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Color titleColor;
  final Color backButtonColor;
  final Color backButtonBorderColor;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.titleIcon,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.backgroundColor = Colors.white,
    this.titleColor = const Color(0xFF0F172A),
    this.backButtonColor = Colors.white,
    this.backButtonBorderColor = const Color(0xFFE2E8F0),
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(62.0);

  @override
  Widget build(BuildContext context) {
    final bool canPop = showBackButton && (onBackPressed != null || Navigator.canPop(context));

    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      titleSpacing: canPop ? 12 : 20,
      leadingWidth: canPop ? 64 : 0,
      leading: canPop
          ? Padding(
              padding: const EdgeInsets.only(left: 16, top: 11, bottom: 11),
              child: InkWell(
                onTap: onBackPressed ?? () => Navigator.maybePop(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: backButtonColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: backButtonBorderColor, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF0F172A),
                    size: 17,
                  ),
                ),
              ),
            )
          : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (titleIcon != null) ...[
            titleIcon!,
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 1.5),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      actions: actions != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                ),
              ),
            ]
          : null,
    );
  }
}
