///home/hp/JERE/AutoNest-frontend/lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // ==========================================
  // 🎨 HIGH-CLASS SOPHISTICATED COLOR PALETTE
  // ==========================================
  
  // Primary Colors - Deep Navy Blue (Professional & Trustworthy)
  static const Color primary = Color(0xFF1B2B4D); // Deep Navy
  static const Color primaryDark = Color(0xFF0F1926);
  static const Color primaryLight = Color(0xFF2D4263);
  
  // Secondary Colors - Rich Burgundy (Elegant & Premium)
  static const Color secondary = Color(0xFF8B4367); // Burgundy
  static const Color secondaryDark = Color(0xFF6B2F4F);
  static const Color secondaryLight = Color(0xFFAD5B8A);
  
  // Accent Colors - Sophisticated Palette
  static const Color accent = Color(0xFFC69B7B); // Warm Gold/Bronze
  static const Color accentGold = Color(0xFFD4AF37); // Muted Gold
  static const Color accentSilver = Color(0xFFA8B5C0); // Silver Gray
  static const Color accentEmerald = Color(0xFF2F5233); // Deep Forest Green
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyDark = Color(0xFF616161);
  
  // Background Colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundDark = Color(0xFF1E1E1E);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Status Colors
  static const Color success = Color(0xFF2F5233); // Deep Green
  static const Color error = Color(0xFF8B2E2E); // Deep Red
  static const Color warning = Color(0xFFB8860B); // Dark Goldenrod
  static const Color info = Color(0xFF2D5F7E); // Deep Blue
  
  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);
  
  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);
  
  // ==========================================
  // 🎨 HIGH-CLASS AUTH SCREEN GRADIENTS
  // ==========================================
  
  // OPTION 1: Deep Navy to Burgundy (Recommended - Executive & Sophisticated)
  static const LinearGradient authBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFF1B2B4D), // Deep Navy
      Color(0xFF2D4263), // Medium Navy
      Color(0xFF8B4367), // Rich Burgundy
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  // OPTION 2: Charcoal to Deep Teal (Modern Corporate)
  static const LinearGradient authBackgroundGradient2 = LinearGradient(
    colors: [
      Color(0xFF2C3E50), // Charcoal
      Color(0xFF34495E), // Slate Gray
      Color(0xFF16537E), // Deep Teal
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  // OPTION 3: Deep Forest to Olive (Natural & Refined)
  static const LinearGradient authBackgroundGradient3 = LinearGradient(
    colors: [
      Color(0xFF2F5233), // Deep Forest
      Color(0xFF3D6946), // Forest Green
      Color(0xFF556B2F), // Olive
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  // OPTION 4: Midnight Blue to Plum (Luxury & Elegance)
  static const LinearGradient authBackgroundGradient4 = LinearGradient(
    colors: [
      Color(0xFF191970), // Midnight Blue
      Color(0xFF2F2F5F), // Dark Blue
      Color(0xFF5D3A5A), // Deep Plum
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  // OPTION 5: Slate Blue to Burgundy (Classic & Timeless)
  static const LinearGradient authBackgroundGradient5 = LinearGradient(
    colors: [
      Color(0xFF384B70), // Slate Blue
      Color(0xFF507687), // Steel Blue
      Color(0xFF6B4367), // Muted Burgundy
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  // OPTION 6: Deep Teal to Navy (Professional & Trustworthy)
  static const LinearGradient authBackgroundGradient6 = LinearGradient(
    colors: [
      Color(0xFF134E5E), // Deep Teal
      Color(0xFF1A5F7A), // Ocean Blue
      Color(0xFF1B3A4B), // Deep Navy
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  // OPTION 7: Charcoal to Bronze (Warm & Executive)
  static const LinearGradient authBackgroundGradient7 = LinearGradient(
    colors: [
      Color(0xFF36454F), // Charcoal
      Color(0xFF4A5B6B), // Slate
      Color(0xFF8B6F47), // Bronze
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  // OPTION 8: Deep Purple to Indigo (Royal & Premium)
  static const LinearGradient authBackgroundGradient8 = LinearGradient(
    colors: [
      Color(0xFF3A1C71), // Deep Purple
      Color(0xFF2C3E70), // Dark Blue
      Color(0xFF1E3C5A), // Indigo
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  // OPTION 9: Dark Emerald to Navy (Sophisticated & Rich)
  static const LinearGradient authBackgroundGradient9 = LinearGradient(
    colors: [
      Color(0xFF0F4C3A), // Dark Emerald
      Color(0xFF1A5653), // Teal
      Color(0xFF1B2B4D), // Navy
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  // OPTION 10: Mahogany to Charcoal (Warm & Executive)
  static const LinearGradient authBackgroundGradient10 = LinearGradient(
    colors: [
      Color(0xFF5D2E2E), // Mahogany
      Color(0xFF4A3F3F), // Dark Brown
      Color(0xFF2C3333), // Charcoal
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  // ==========================================
  // 🎨 CARD GRADIENTS (Sophisticated)
  // ==========================================
  
  static const LinearGradient cardGradient1 = LinearGradient(
    colors: [Color(0xFF2D4263), Color(0xFF1B2B4D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient2 = LinearGradient(
    colors: [Color(0xFF8B4367), Color(0xFF6B2F4F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient3 = LinearGradient(
    colors: [Color(0xFF2F5233), Color(0xFF1A3D21)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient4 = LinearGradient(
    colors: [Color(0xFF36454F), Color(0xFF2C3333)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // ==========================================
  // 🎨 OVERLAY COLORS (For Glass Effect)
  // ==========================================
  
  static const Color glassFrost = Color(0x40FFFFFF); // 25% white
  static const Color glassDark = Color(0x30000000); // 19% black
  
  // ==========================================
  // 🎨 ACCENT COLORS FOR HIGHLIGHTS
  // ==========================================
  
  static const Color highlightGold = Color(0xFFD4AF37); // Muted Gold
  static const Color highlightBronze = Color(0xFFCD7F32); // Bronze
  static const Color highlightSilver = Color(0xFFC0C0C0); // Silver
  static const Color highlightPearl = Color(0xFFF0EAD6); // Pearl White
}