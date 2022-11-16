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

  factory SuggestionsTheme.initial() => SuggestionsTheme(
        primaryBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        secondaryBackgroundColor: const Color.fromRGBO(244, 245, 246, 1),
        thirdBackgroundColor: const Color.fromRGBO(243, 243, 243, 1),
        bottomSheetBackgroundColor: const Color.fromRGBO(248, 248, 248, 1),
        fontFamily: 'Rubik',
        primaryTextColor: const Color.fromRGBO(51, 51, 51, 1),
        secondaryTextColor: const Color.fromRGBO(140, 140, 140, 1),
        primaryIconColor: const Color.fromRGBO(51, 51, 51, 1),
        secondaryIconColor: const Color.fromRGBO(193, 193, 193, 1),
        actionColor: const Color.fromRGBO(51, 51, 51, 0.15),
        actionPressedColor: const Color.fromRGBO(51, 51, 51, 0.2),
        actionBackgroundColor: const Color.fromRGBO(224, 224, 224, 1),
        dividerColor: const Color.fromRGBO(210, 216, 223, 1),
        dialogBarrierColor: const Color.fromRGBO(255, 255, 255, 0.8),
        elevatedButtonColor: const Color.fromRGBO(241, 96, 29, 1),
        pressedElevatedButtonColor: const Color.fromRGBO(200, 80, 25, 1),
        elevatedButtonTextColor: const Color.fromRGBO(255, 255, 255, 1),
        focusedTextButtonColor: const Color.fromRGBO(241, 96, 29, 0.12),
        focusedTextColor: const Color.fromRGBO(200, 80, 25, 1),
        focusedTextFieldBorderlineColor: const Color(0xFFF1601D),
        focusedTonalButtonColor: const Color.fromRGBO(241, 96, 29, 0.3),
        enabledTextColor: const Color.fromRGBO(241, 96, 29, 1),
        disabledTextColor: const Color.fromRGBO(51, 51, 51, 0.38),
        disabledTextButtonColor: const Color.fromRGBO(51, 51, 51, 0.08),
        tonalButtonColor: const Color.fromRGBO(241, 96, 29, 0.12),
        errorColor: const Color.fromRGBO(246, 24, 48, 1),
        upvoteArrowColor: const Color.fromRGBO(140, 140, 140, 1),
        activatedUpvoteArrowColor: const Color.fromRGBO(241, 96, 29, 1),
        requestsTabColor: const Color.fromRGBO(241, 96, 29, 1),
        inProgressTabColor: const Color.fromRGBO(245, 167, 24, 1),
        completedTabColor: const Color.fromRGBO(38, 155, 85, 1),
        featureLabelColor: const Color.fromRGBO(0, 133, 255, 1),
        bugLabelColor: const Color.fromRGBO(246, 24, 48, 1),
        fade: const Color.fromRGBO(0, 0, 0, 0.65),
        fabColor: const Color.fromRGBO(33, 33, 33, 0.12),
      );

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
