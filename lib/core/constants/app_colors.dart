import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1A73E8); // Blue
  static const Color primaryDark = Color(0xFF1557B0);
  static const Color primaryLight = Color(0xFF4A8FEC);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF00BFA5); // Teal
  static const Color secondaryDark = Color(0xFF00897B);
  static const Color secondaryLight = Color(0xFF33D1B8);
  
  // Accent Colors
  static const Color accent = Color(0xFFFF6B6B); // Red
  static const Color accentOrange = Color(0xFFFF9F40);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentPurple = Color(0xFF9C27B0);
  
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
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);
  
  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);
  
  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // ==========================================
  // 🎨 PROFESSIONAL AUTH SCREEN GRADIENTS
  // ==========================================
  
  // OPTION 1: Modern Purple to Blue (Recommended - Very Professional)
  static const LinearGradient authBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFF667eea), // Purple
      Color(0xFF764ba2), // Deep Purple
      Color(0xFFf093fb), // Light Pink
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
  
  // OPTION 2: Sunset Orange to Pink (Warm & Inviting)
  static const LinearGradient authBackgroundGradient2 = LinearGradient(
    colors: [
      Color(0xFFfa709a), // Pink
      Color(0xFFfee140), // Yellow
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // OPTION 3: Ocean Blue to Teal (Fresh & Clean)
  static const LinearGradient authBackgroundGradient3 = LinearGradient(
    colors: [
      Color(0xFF4facfe), // Light Blue
      Color(0xFF00f2fe), // Cyan
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // OPTION 4: Mint Green to Blue (Calming & Professional)
  static const LinearGradient authBackgroundGradient4 = LinearGradient(
    colors: [
      Color(0xFF43e97b), // Green
      Color(0xFF38f9d7), // Turquoise
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // OPTION 5: Deep Blue to Purple (Corporate & Elegant)
  static const LinearGradient authBackgroundGradient5 = LinearGradient(
    colors: [
      Color(0xFF2196F3), // Blue
      Color(0xFF3F51B5), // Indigo
      Color(0xFF673AB7), // Deep Purple
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );
  
  // OPTION 6: Peach to Coral (Soft & Modern)
  static const LinearGradient authBackgroundGradient6 = LinearGradient(
    colors: [
      Color(0xFFffecd2), // Light Peach
      Color(0xFFfcb69f), // Coral
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // OPTION 7: Dark Gradient (For Premium Look)
  static const LinearGradient authBackgroundGradient7 = LinearGradient(
    colors: [
      Color(0xFF1e3c72), // Dark Blue
      Color(0xFF2a5298), // Medium Blue
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Card Gradients for Account Cards
  static const LinearGradient cardGradient1 = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient2 = LinearGradient(
    colors: [Color(0xFFF093FB), Color(0xFFF5576C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient3 = LinearGradient(
    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient4 = LinearGradient(
    colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}