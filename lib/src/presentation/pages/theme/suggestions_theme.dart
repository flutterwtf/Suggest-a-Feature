import 'package:flutter/material.dart';

import '../../di/injector.dart';
import '../../utils/font_sizes.dart';

SuggestionsTheme get theme => i.theme;

class SuggestionsTheme {
  final Color primaryBackgroundColor;
  final Color secondaryBackgroundColor;
  final Color thirdBackgroundColor;
  final Color bottomSheetBackgroundColor;
  final String fontFamily;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color primaryIconColor;
  final Color secondaryIconColor;
  final Color actionColor;
  final Color actionPressedColor;
  final Color actionBackgroundColor;
  final Color dividerColor;
  final Color dialogBarrierColor;
  final Color elevatedButtonColor;
  final Color pressedElevatedButtonColor;
  final Color elevatedButtonTextColor;
  final Color focusedTextButtonColor;
  final Color focusedTextColor;
  final Color focusedTextFieldBorderlineColor;
  final Color focusedTonalButtonColor;
  final Color enabledTextColor;
  final Color disabledTextColor;
  final Color disabledTextButtonColor;
  final Color tonalButtonColor;
  final Color errorColor;
  final Color fade;
  final Color fabColor;

  final Color upvoteArrowColor;
  final Color activatedUpvoteArrowColor;

  final Color requestsTabColor;
  final Color inProgressTabColor;
  final Color completedTabColor;

  final Color featureLabelColor;
  final Color bugLabelColor;

  SuggestionsTheme({
    required this.primaryBackgroundColor,
    required this.secondaryBackgroundColor,
    required this.thirdBackgroundColor,
    required this.bottomSheetBackgroundColor,
    required this.fontFamily,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.primaryIconColor,
    required this.secondaryIconColor,
    required this.actionColor,
    required this.actionPressedColor,
    required this.actionBackgroundColor,
    required this.dividerColor,
    required this.dialogBarrierColor,
    required this.elevatedButtonColor,
    required this.pressedElevatedButtonColor,
    required this.elevatedButtonTextColor,
    required this.focusedTextButtonColor,
    required this.focusedTextColor,
    required this.focusedTextFieldBorderlineColor,
    required this.focusedTonalButtonColor,
    required this.enabledTextColor,
    required this.disabledTextColor,
    required this.disabledTextButtonColor,
    required this.tonalButtonColor,
    required this.errorColor,
    required this.upvoteArrowColor,
    required this.activatedUpvoteArrowColor,
    required this.requestsTabColor,
    required this.inProgressTabColor,
    required this.completedTabColor,
    required this.featureLabelColor,
    required this.bugLabelColor,
    required this.fade,
    required this.fabColor,
  });

  TextStyle get base => TextStyle(
        fontFamily: fontFamily,
        color: primaryTextColor,
        fontFamilyFallback: ['sans-serif'],
      );

  TextStyle get textXXL => base.copyWith(fontSize: FontSizes.sixeXXL);

  TextStyle get textL => base.copyWith(fontSize: FontSizes.sizeL);

  TextStyle get textM => base.copyWith(fontSize: FontSizes.sizeM);

  TextStyle get textMPlus => base.copyWith(fontSize: FontSizes.sizeMPlus);

  TextStyle get textS => base.copyWith(fontSize: FontSizes.sizeS);

  TextStyle get textXXLBold => textXXL.copyWith(fontWeight: FontSizes.weightBold);

  TextStyle get textLBold => textL.copyWith(fontWeight: FontSizes.weightBold);

  TextStyle get textMSecondary => textM.copyWith(color: secondaryTextColor);

  TextStyle get textMPlusBold => textMPlus.copyWith(fontWeight: FontSizes.weightBold);

  TextStyle get textMBold => textM.copyWith(fontWeight: FontSizes.weightBold);

  TextStyle get textMSecondaryBold => textMSecondary.copyWith(fontWeight: FontSizes.weightBold);
}
