import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServiceCardWidget extends StatefulWidget {
  final String title;
  final IconData? icon;
  final String? svgAsset;
  final Color backgroundColor;
  final VoidCallback onTap;
  final Widget? customIconWidget;

  const ServiceCardWidget({
    super.key,
    required this.title,
    this.icon,
    this.svgAsset,
    required this.backgroundColor,
    required this.onTap,
    this.customIconWidget,
  });

  @override
  State<ServiceCardWidget> createState() => _ServiceCardWidgetState();
}

class _ServiceCardWidgetState extends State<ServiceCardWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        child: Container(
          height: 110,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                widget.backgroundColor,
                widget.backgroundColor.withValues(alpha: 0.88),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.backgroundColor.withValues(alpha: 0.35),
                blurRadius: 14,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left Title Text
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Right Graphic (SVG Asset or Custom Icon or Material Icon)
              if (widget.customIconWidget != null)
                widget.customIconWidget!
              else if (widget.svgAsset != null)
                SizedBox(
                  width: 44,
                  height: 44,
                  child: SvgPicture.asset(
                    widget.svgAsset!,
                    width: 44,
                    height: 44,
                    fit: BoxFit.contain,
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    widget.icon ?? Icons.medical_services_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
