import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette (Medical Teal & Fresh Mint)
  static const Color primary = Color(0xFF0F766E);       // Deep Medical Teal
  static const Color primaryLight = Color(0xFF14B8A6);  // Bright Teal
  static const Color primaryDark = Color(0xFF115E59);   // Dark Teal
  
  // Secondary / Accent Colors
  static const Color accent = Color(0xFF38BDF8);        // Sky Blue Accent
  static const Color highlight = Color(0xFFF59E0B);     // Amber Warning/Rating
  static const Color danger = Color(0xFFEF4444);        // Coral Red Alert

  // Background & Cards
  static const Color background = Color(0xFFF8FAFC);    // Soft Slate Grey
  static const Color surface = Color(0xFFFFFFFF);       // Pure White Surface
  static const Color cardBg = Color(0xFFF1F5F9);        // Light Card Fill
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);   // Dark Slate Header
  static const Color textSecondary = Color(0xFF64748B); // Cool Muted Text
  static const Color textLight = Color(0xFF94A3B8);     // Subtitle Grey
  
  // Status Colors
  static const Color success = Color(0xFF10B981);       // Emerald Green
  static const Color statusPending = Color(0xFFF59E0B);  // Amber
  static const Color statusCancelled = Color(0xFFEF4444);// Red

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0F766E), Color(0xFF0D9488)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF115E59), Color(0xFF0F766E), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
