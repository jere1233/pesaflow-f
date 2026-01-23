///home/hp/JERE/AutoNest-frontend/lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // ==========================================
  // 🎨 LIGHT THEME COLOR PALETTE (Tailwind-based)
  // ==========================================
  
  // Primary Colors - Orange (Action & Emphasis) - Tailwind orange-600
  static const Color primary = Color(0xFFF97316); // Tailwind orange-600
  static const Color primaryDark = Color(0xFFEA580C); // Tailwind orange-700 (hover)
  static const Color primaryLight = Color(0xFFFED7AA); // Tailwind orange-200
  
  // Secondary Orange Shade
  static const Color secondaryOrange = Color(0xFFFB923C); // Tailwind orange-400
  static const Color tertiaryOrange = Color(0xFFFFEDD5); // Tailwind orange-50
  
  // Secondary Colors - Gray (Supporting)
  static const Color secondary = Color(0xFF6B7280); // Medium Gray
  static const Color secondaryDark = Color(0xFF4B5563);
  static const Color secondaryLight = Color(0xFF9CA3AF);
  
  // Accent Colors - Light Theme Palette
  static const Color accent = Color(0xFFF97316); // Orange (primary)
  static const Color accentGold = Color(0xFFFFA500); // Gold
  static const Color accentSilver = Color(0xFFD1D5DB); // Light Gray
  static const Color accentEmerald = Color(0xFF10B981); // Tailwind emerald-500 (success)
  
  // Brand Colors
  static const Color brandPurple = Color(0xFFA855F7); // Tailwind purple-600
  static const Color brandTeal = Color(0xFF14B8A6); // Tailwind teal-600
  static const Color brandIndigo = Color(0xFF6366F1); // Tailwind indigo-600
  static const Color brandPink = Color(0xFFEC4899); // Tailwind pink-600
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9CA3AF);
  static const Color greyLight = Color(0xFFF3F4F6);
  static const Color greyDark = Color(0xFF374151);
  
  // Background Colors - Light Theme (Gray gradient base)
  static const Color background = Color(0xFFF9FAFB); // Tailwind gray-50
  static const Color backgroundDark = Color(0xFFF3F4F6); // Tailwind gray-100
  static const Color cardBackground = Color(0xFFFFFFFF); // White cards
  static const Color cardBackgroundDark = Color(0xFFF9FAFB);
  
  // Text Colors - Dark text for light background
  static const Color textPrimary = Color(0xFF1F2937); // Dark gray/charcoal
  static const Color textSecondary = Color(0xFF6B7280); // Medium gray
  static const Color textHint = Color(0xFFD1D5DB); // Light gray
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Status Colors
  static const Color success = Color(0xFF10B981); // Emerald-500 (Tailwind)
  static const Color successLight = Color(0xFFD1FAE5); // Emerald-100
  static const Color pending = Color(0xFFF97316); // Orange (primary)
  static const Color pendingLight = Color(0xFFFFEDD5); // Orange-50
  static const Color error = Color(0xFFEF4444); // Red-500
  static const Color errorLight = Color(0xFFFEE2E2); // Red-100
  static const Color warning = Color(0xFFF97316); // Orange (same as pending)
  static const Color warningLight = Color(0xFFFFEDD5); // Orange-50
  static const Color info = Color(0xFF3B82F6); // Blue-500 (use sparingly - not brand)
  static const Color infoLight = Color(0xFFDEEFEF); // Light blue background
  
  // Accent Colors for Buttons & UI
  static const Color accentOrange = Color(0xFFF97316); // Primary orange
  static const Color accentOrangeHover = Color(0xFFEA580C); // Darker orange on hover
  static const Color accentCoral = Color(0xFFFF6B6B); // Coral (avoid - not brand)
  static const Color accentBlue = Color(0xFF3B82F6); // Blue (avoid - not brand)
  
  // Border Colors
  static const Color border = Color(0xFFE5E7EB); // Light gray border
  static const Color borderDark = Color(0xFFD1D5DB);
  static const Color borderOrange = Color(0xFFFED7AA); // Orange-200 for orange borders
  
  // Shadow Colors - Light shadows for light theme
  static const Color shadow = Color(0x0D000000); // Very light shadow
  static const Color shadowDark = Color(0x1A000000);
  static const Color shadowOrange = Color(0x1AF97316); // Orange tinted shadow
  
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
  // 🎨 CARD GRADIENTS (Orange-based with brand colors)
  // ==========================================
  
  // Card Gradient 1: Orange → Purple
  static const LinearGradient cardGradient1 = LinearGradient(
    colors: [
      Color(0xFFFB923C), // orange-400
      Color(0xFFF97316), // orange-600
      Color(0xFFA855F7), // purple-600
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  // Card Gradient 2: Orange → Teal
  static const LinearGradient cardGradient2 = LinearGradient(
    colors: [
      Color(0xFFFB923C), // orange-400
      Color(0xFFF97316), // orange-600
      Color(0xFF14B8A6), // teal-600
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  // Card Gradient 3: Orange → Indigo
  static const LinearGradient cardGradient3 = LinearGradient(
    colors: [
      Color(0xFFFB923C), // orange-400
      Color(0xFFF97316), // orange-600
      Color(0xFF6366F1), // indigo-600
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  // Card Gradient 4: Orange → Pink
  static const LinearGradient cardGradient4 = LinearGradient(
    colors: [
      Color(0xFFFB923C), // orange-400
      Color(0xFFF97316), // orange-600
      Color(0xFFEC4899), // pink-600
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
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