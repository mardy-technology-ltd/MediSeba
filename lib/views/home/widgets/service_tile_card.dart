import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServiceTileCard extends StatefulWidget {
  final String title;
  final String svgPath;
  final Color? backgroundColor;
  final Gradient? gradient;
  final VoidCallback onTap;

  const ServiceTileCard({
    super.key,
    required this.title,
    required this.svgPath,
    this.backgroundColor,
    this.gradient,
    required this.onTap,
  });

  @override
  State<ServiceTileCard> createState() => _ServiceTileCardState();
}

class _ServiceTileCardState extends State<ServiceTileCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = widget.gradient ??
        (widget.backgroundColor != null
            ? LinearGradient(
                colors: [widget.backgroundColor!, widget.backgroundColor!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null);

    final primaryColor = (effectiveGradient is LinearGradient &&
            effectiveGradient.colors.isNotEmpty)
        ? effectiveGradient.colors.first
        : (widget.backgroundColor ?? const Color(0xFF0D9488));

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: effectiveGradient == null ? widget.backgroundColor : null,
            gradient: effectiveGradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              // Top Right SVG Icon
              Positioned(
                top: 0,
                right: 0,
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: SvgPicture.asset(
                    widget.svgPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Bottom Left White Text Label
              Positioned(
                left: 0,
                bottom: 0,
                right: 48,
                child: Text(
                  widget.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
