import 'package:flutter/material.dart';
import 'app_colors.dart';

sealed class AppTextStyles {
  // Mavjud style
  static const buttonTextStyle = TextStyle(
    color: AppColors.white,
    fontSize: 24,
  );

  // Professional text styles
  static const headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.neutral900,
  );

  static const headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.neutral900,
  );

  static const headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.neutral900,
  );

  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral700,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral700,
  );

  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral600,
  );

  static const labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral800,
  );

  static const labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral800,
  );

  static const labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral700,
  );

  // Button text styles
  static const primaryButtonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const secondaryButtonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.lightPrimary,
  );

  static const dangerButtonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  // Error text styles
  static const errorText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.danger,
  );

  static const successText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.success,
  );

  // Table text styles
  static const tableHeader = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.neutral800,
  );

  static const tableCell = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral700,
  );

  // Caption styles
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral500,
  );

  static const captionBold = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.neutral600,
  );

  // Dark theme text styles
  static const headingLargeDark = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.neutral100,
  );

  static const headingMediumDark = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.neutral100,
  );

  static const headingSmallDark = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.neutral100,
  );

  static const bodyLargeDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral300,
  );

  static const bodyMediumDark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral300,
  );

  static const bodySmallDark = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral400,
  );

  static const labelLargeDark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral200,
  );

  static const labelMediumDark = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral200,
  );

  static const labelSmallDark = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral300,
  );

  // Table text styles for dark theme
  static const tableHeaderDark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.neutral200,
  );

  static const tableCellDark = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral300,
  );

  // Caption styles for dark theme
  static const captionDark = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral500,
  );

  static const captionBoldDark = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.neutral400,
  );
}