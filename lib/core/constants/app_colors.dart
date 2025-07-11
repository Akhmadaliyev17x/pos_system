import 'package:flutter/material.dart';

sealed class AppColors {
  // Mavjud ranglar
  static const indigoPrimary = Colors.indigo;
  static const white = Colors.white;

  // Light Theme Colors
  static const lightPrimary = Color(0xFF2563EB);        // Professional blue
  static const lightPrimaryVariant = Color(0xFF1E40AF);  // Darker blue
  static const lightSecondary = Color(0xFF10B981);       // Emerald green
  static const lightSecondaryVariant = Color(0xFF059669); // Darker emerald
  static const lightBackground = Color(0xFFFAFAFA);       // Light gray
  static const lightSurface = Color(0xFFFFFFFF);          // Pure white
  static const lightError = Color(0xFFDC2626);            // Red
  static const lightOnPrimary = Color(0xFFFFFFFF);        // White
  static const lightOnSecondary = Color(0xFFFFFFFF);      // White
  static const lightOnBackground = Color(0xFF1F2937);     // Dark gray
  static const lightOnSurface = Color(0xFF374151);        // Medium gray
  static const lightOnError = Color(0xFFFFFFFF);          // White

  // Dark Theme Colors
  static const darkPrimary = Color(0xFF3B82F6);           // Lighter blue
  static const darkPrimaryVariant = Color(0xFF2563EB);    // Professional blue
  static const darkSecondary = Color(0xFF34D399);         // Light emerald
  static const darkSecondaryVariant = Color(0xFF10B981);  // Emerald green
  static const darkBackground = Color(0xFF111827);        // Very dark gray
  static const darkSurface = Color(0xFF1F2937);           // Dark gray
  static const darkError = Color(0xFFEF4444);             // Light red
  static const darkOnPrimary = Color(0xFF000000);         // Black
  static const darkOnSecondary = Color(0xFF000000);       // Black
  static const darkOnBackground = Color(0xFFF9FAFB);      // Light gray
  static const darkOnSurface = Color(0xFFE5E7EB);         // Light gray
  static const darkOnError = Color(0xFF000000);           // Black

  // Additional Professional Colors
  static const success = Color(0xFF10B981);               // Emerald
  static const warning = Color(0xFFF59E0B);               // Amber
  static const info = Color(0xFF3B82F6);                  // Blue
  static const danger = Color(0xFFDC2626);                // Red

  // Neutral Colors
  static const neutral50 = Color(0xFFFAFAFA);
  static const neutral100 = Color(0xFFF5F5F5);
  static const neutral200 = Color(0xFFE5E5E5);
  static const neutral300 = Color(0xFFD4D4D4);
  static const neutral400 = Color(0xFFA3A3A3);
  static const neutral500 = Color(0xFF737373);
  static const neutral600 = Color(0xFF525252);
  static const neutral700 = Color(0xFF404040);
  static const neutral800 = Color(0xFF262626);
  static const neutral900 = Color(0xFF171717);

  // Professional Card Colors
  static const cardLight = Color(0xFFFFFFFF);
  static const cardDark = Color(0xFF1F2937);

  // Border Colors
  static const borderLight = Color(0xFFE5E7EB);
  static const borderDark = Color(0xFF374151);

  // Divider Colors
  static const dividerLight = Color(0xFFE5E7EB);
  static const dividerDark = Color(0xFF374151);

  // Shadow Colors
  static const shadowLight = Color(0x1A000000);
  static const shadowDark = Color(0x3D000000);
}