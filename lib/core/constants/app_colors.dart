///home/hp/JERE/AutoNest-frontend/lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // ==========================================
  // 🎨 LIGHT THEME COLOR PALETTE
  // ==========================================
  
  // Primary Colors - Orange (Action & Emphasis)
  static const Color primary = Color(0xFFE8744F); // Warm Orange
  static const Color primaryDark = Color(0xFFD45A2C);
  static const Color primaryLight = Color(0xFFFF9E68);
  
  // Secondary Colors - Gray (Supporting)
  static const Color secondary = Color(0xFF6B7280); // Medium Gray
  static const Color secondaryDark = Color(0xFF4B5563);
  static const Color secondaryLight = Color(0xFF9CA3AF);
  
  // Accent Colors - Light Theme Palette
  static const Color accent = Color(0xFFE8744F); // Orange
  static const Color accentGold = Color(0xFFFFA500); // Gold
  static const Color accentSilver = Color(0xFFD1D5DB); // Light Gray
  static const Color accentEmerald = Color(0xFF059669); // Emerald Green
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9CA3AF);
  static const Color greyLight = Color(0xFFF3F4F6);
  static const Color greyDark = Color(0xFF374151);
  
  // Background Colors - Light Theme
  static const Color background = Color(0xFFFAFAFA); // Off-white
  static const Color backgroundDark = Color(0xFFF0F0F0);
  static const Color cardBackground = Color(0xFFFFFFFF); // White cards
  static const Color cardBackgroundDark = Color(0xFFF9F9F9);
  
  // Text Colors - Dark text for light background
  static const Color textPrimary = Color(0xFF1F2937); // Dark gray/charcoal
  static const Color textSecondary = Color(0xFF6B7280); // Medium gray
  static const Color textHint = Color(0xFFD1D5DB); // Light gray
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Status Colors
  static const Color success = Color(0xFF059669); // Green
  static const Color successLight = Color(0xFFDEEFE8); // Light green background
  static const Color error = Color(0xFFDC2626); // Red
  static const Color errorLight = Color(0xFFFEE2E2); // Light red background
  static const Color warning = Color(0xFFD97706); // Orange
  static const Color warningLight = Color(0xFFFEF3C7); // Light orange background
  static const Color info = Color(0xFF0284C7); // Blue
  static const Color infoLight = Color(0xFFDEEFEF); // Light blue background
  
  // Accent Colors for Buttons & UI
  static const Color accentOrange = Color(0xFFE8744F); // Warm Orange
  static const Color accentCoral = Color(0xFFFF6B6B); // Coral
  static const Color accentBlue = Color(0xFF0284C7); // Modern Blue
  
  // Border Colors
  static const Color border = Color(0xFFE5E7EB); // Light gray border
  static const Color borderDark = Color(0xFFD1D5DB);
  
  // Shadow Colors - Light shadows for light theme
  static const Color shadow = Color(0x0D000000); // Very light shadow
  static const Color shadowDark = Color(0x1A000000);
  
  // ==========================================
  // 🎨 LIGHT THEME GRADIENTS
  // ==========================================
  
  // Auth Screen - Light background to soft gradient
  static const LinearGradient authBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFFFAFAFA), // Off-white
      Color(0xFFF3F4F6), // Light gray
      Color(0xFFFFEBE0), // Soft orange tint
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient authBackgroundGradient2 = LinearGradient(
    colors: [
      Color(0xFFFFFFFF), // White
      Color(0xFFFAFAFA), // Off-white
      Color(0xFFF9F9F9), // Very light gray
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient authBackgroundGradient3 = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFAFAFA),
      Color(0xFFF3F4F6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient authBackgroundGradient4 = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF9F9F9),
      Color(0xFFF3F4F6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient authBackgroundGradient5 = LinearGradient(
    colors: [
      Color(0xFFFAFAFA),
      Color(0xFFF3F4F6),
      Color(0xFFFFEBE0),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient authBackgroundGradient6 = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFAFAFA),
      Color(0xFFFFEBE0),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient authBackgroundGradient7 = LinearGradient(
    colors: [
      Color(0xFFFAFAFA),
      Color(0xFFFFFFFF),
      Color(0xFFF3F4F6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient authBackgroundGradient8 = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFAFAFA),
      Color(0xFFF9F9F9),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient authBackgroundGradient9 = LinearGradient(
    colors: [
      Color(0xFFFAFAFA),
      Color(0xFFFFEBE0),
      Color(0xFFFFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient authBackgroundGradient10 = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF9F9F9),
      Color(0xFFFFEBE0),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  // ==========================================
  // 🎨 CARD GRADIENTS (Light Theme)
  // ==========================================
  
  static const LinearGradient cardGradient1 = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFFAFAFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient2 = LinearGradient(
    colors: [Color(0xFFFAFAFA), Color(0xFFF3F4F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient3 = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFFFEBE0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient4 = LinearGradient(
    colors: [Color(0xFFFAFAFA), Color(0xFFFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // ==========================================
  // 🎨 OVERLAY COLORS (For Light Theme)
  // ==========================================
  
  static const Color glassFrost = Color(0x0DFFFFFF); // Very light white overlay
  static const Color glassDark = Color(0x0D000000); // Very light dark overlay
  
  // ==========================================
  // 🎨 ACCENT COLORS FOR HIGHLIGHTS
  // ==========================================
  
  static const Color highlightGold = Color(0xFFD4AF37); // Muted Gold
  static const Color highlightBronze = Color(0xFFCD7F32); // Bronze
  static const Color highlightSilver = Color(0xFFC0C0C0); // Silver
  static const Color highlightPearl = Color(0xFFF0EAD6); // Pearl White
}