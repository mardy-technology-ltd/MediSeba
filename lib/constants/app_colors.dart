import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette (Brand Green #008536)
  static const Color primary = Color(0xFF008536);       // Brand Green
  static const Color primaryLight = Color(0xFF02A946);  // Bright Green
  static const Color primaryDark = Color(0xFF006428);   // Dark Green
  
  // Secondary / Accent Colors (Brand Red #ED1B24)
  static const Color accent = Color(0xFF38BDF8);        // Sky Blue Accent
  static const Color highlight = Color(0xFFF59E0B);     // Amber Warning/Rating
  static const Color danger = Color(0xFFED1B24);        // Brand Red
  static const Color brandRed = Color(0xFFED1B24);      // Brand Red

  // Background & Cards
  static const Color background = Color(0xFFF8FAFC);    // Soft Slate Grey
  static const Color surface = Color(0xFFFFFFFF);       // Pure White Surface
  static const Color cardBg = Color(0xFFF1F5F9);        // Light Card Fill
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);   // Dark Slate Header
  static const Color textSecondary = Color(0xFF64748B); // Cool Muted Text
  static const Color textLight = Color(0xFF94A3B8);     // Subtitle Grey
  
  // Status Colors
  static const Color success = Color(0xFF008536);       // Brand Green
  static const Color statusPending = Color(0xFFF59E0B);  // Amber
  static const Color statusCancelled = Color(0xFFED1B24);// Brand Red

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF008536), Color(0xFF02A946)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF006428), Color(0xFF008536), Color(0xFF02A946)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
