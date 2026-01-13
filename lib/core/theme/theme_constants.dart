import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Theme Constants for consistent UI elements across the app
class ThemeConstants {
  // ============================================================================
  // SHADOWS
  // ============================================================================
  
  /// Subtle shadow - used for small cards and elements
  static const List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  /// Medium shadow - used for cards and moderately elevated elements
  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  
  /// Large shadow - used for modals and highly elevated elements
  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: AppColors.shadowDark,
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
  
  /// Elevated shadow - used for floating action buttons and popups
  static const List<BoxShadow> shadowElevated = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  // ============================================================================
  // BORDER RADIUS
  // ============================================================================
  
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXL = 24;
  
  static const BorderRadius borderRadiusSmall = BorderRadius.all(Radius.circular(radiusSmall));
  static const BorderRadius borderRadiusMedium = BorderRadius.all(Radius.circular(radiusMedium));
  static const BorderRadius borderRadiusLarge = BorderRadius.all(Radius.circular(radiusLarge));
  static const BorderRadius borderRadiusXL = BorderRadius.all(Radius.circular(radiusXL));
  
  // ============================================================================
  // PADDING & SPACING
  // ============================================================================
  
  static const double paddingXS = 4;
  static const double paddingSmall = 8;
  static const double paddingMedium = 12;
  static const double paddingLarge = 16;
  static const double paddingXL = 24;
  static const double paddingXXL = 32;
  
  // ============================================================================
  // CARD DECORATIONS
  // ============================================================================
  
  /// Standard card decoration with subtle shadow
  static BoxDecoration get cardDecoration {
    return BoxDecoration(
      color: AppColors.cardBackground,
      borderRadius: borderRadiusMedium,
      boxShadow: shadowSmall,
    );
  }
  
  /// Standard card decoration for dark mode
  static BoxDecoration get cardDecorationDark {
    return BoxDecoration(
      color: AppColors.cardBackgroundDark,
      borderRadius: borderRadiusMedium,
      boxShadow: shadowMedium,
    );
  }
  
  /// Elevated card decoration
  static BoxDecoration get cardDecorationElevated {
    return BoxDecoration(
      color: AppColors.cardBackground,
      borderRadius: borderRadiusMedium,
      boxShadow: shadowMedium,
    );
  }
  
  /// Gradient card decoration
  static BoxDecoration cardDecorationGradient(LinearGradient gradient) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: borderRadiusMedium,
      boxShadow: shadowMedium,
    );
  }
  
  // ============================================================================
  // BUTTON DECORATIONS
  // ============================================================================
  
  /// Primary button shape
  static RoundedRectangleBorder get buttonShape {
    return RoundedRectangleBorder(borderRadius: borderRadiusMedium);
  }
  
  /// Large button shape
  static RoundedRectangleBorder get buttonShapeLarge {
    return RoundedRectangleBorder(borderRadius: borderRadiusLarge);
  }
  
  // ============================================================================
  // DIALOG DECORATIONS
  // ============================================================================
  
  /// Standard dialog decoration
  static BoxDecoration get dialogDecoration {
    return BoxDecoration(
      color: AppColors.cardBackground,
      borderRadius: borderRadiusLarge,
      boxShadow: shadowLarge,
    );
  }
  
  /// Dark mode dialog decoration
  static BoxDecoration get dialogDecorationDark {
    return BoxDecoration(
      color: AppColors.cardBackgroundDark,
      borderRadius: borderRadiusLarge,
      boxShadow: shadowLarge,
    );
  }
  
  // ============================================================================
  // INPUT FIELD DECORATIONS
  // ============================================================================
  
  /// Standard input field decoration
  static InputDecoration inputDecoration({
    required String labelText,
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.cardBackground,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: paddingLarge,
        vertical: paddingMedium,
      ),
      border: OutlineInputBorder(
        borderRadius: borderRadiusMedium,
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadiusMedium,
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadiusMedium,
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
  
  // ============================================================================
  // STATUS BACKGROUNDS
  // ============================================================================
  
  /// Success status background
  static BoxDecoration get statusSuccessBackground {
    return BoxDecoration(
      color: AppColors.successLight.withOpacity(0.15),
      borderRadius: borderRadiusMedium,
      border: Border.all(color: AppColors.successLight),
    );
  }
  
  /// Error status background
  static BoxDecoration get statusErrorBackground {
    return BoxDecoration(
      color: AppColors.errorLight.withOpacity(0.15),
      borderRadius: borderRadiusMedium,
      border: Border.all(color: AppColors.errorLight),
    );
  }
  
  /// Warning status background
  static BoxDecoration get statusWarningBackground {
    return BoxDecoration(
      color: AppColors.warningLight.withOpacity(0.15),
      borderRadius: borderRadiusMedium,
      border: Border.all(color: AppColors.warningLight),
    );
  }
  
  /// Info status background
  static BoxDecoration get statusInfoBackground {
    return BoxDecoration(
      color: AppColors.infoLight.withOpacity(0.15),
      borderRadius: borderRadiusMedium,
      border: Border.all(color: AppColors.infoLight),
    );
  }
}
