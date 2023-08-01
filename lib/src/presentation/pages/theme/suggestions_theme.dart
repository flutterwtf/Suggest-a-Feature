import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/src/presentation/utils/font_sizes.dart';

SuggestionsTheme get theme => i.theme;

class SuggestionsTheme {
  final Color primaryBackgroundColor;
  final Color secondaryBackgroundColor;
  final Color thirdBackgroundColor;
  final Color bottomSheetBackgroundColor;
  final String fontFamily;
  final Color onPrimaryColor;
  final Color secondaryTextColor;
  final Color secondaryIconColor;
  final Color actionColor;
  final Color actionPressedColor;
  final Color actionBackgroundColor;
  final Color dividerColor;
  final Color dialogBarrierColor;
  final Color accentColor;
  final Color pressedAccentColor;
  final Color onAccentColor;
  final Color focusedColor;
  final Color focusedTonalColor;
  final Color disabledTextColor;
  final Color disabledTextButtonColor;
  final Color errorColor;
  final Color fade;
  final Color fabColor;

  final Color upvoteArrowColor;

  final Color requestsTabColor;
  final Color inProgressTabColor;
  final Color completedTabColor;
  final Color declinedTabColor;
  final Color duplicatedTabColor;

  final Color featureLabelColor;
  final Color bugLabelColor;

  SuggestionsTheme({
    required this.primaryBackgroundColor,
    required this.secondaryBackgroundColor,
    required this.thirdBackgroundColor,
    required this.bottomSheetBackgroundColor,
    required this.fontFamily,
    required this.onPrimaryColor,
    required this.secondaryTextColor,
    required this.secondaryIconColor,
    required this.actionColor,
    required this.actionPressedColor,
    required this.actionBackgroundColor,
    required this.dividerColor,
    required this.dialogBarrierColor,
    required this.accentColor,
    required this.pressedAccentColor,
    required this.onAccentColor,
    required this.focusedColor,
    required this.focusedTonalColor,
    required this.disabledTextColor,
    required this.disabledTextButtonColor,
    required this.errorColor,
    required this.upvoteArrowColor,
    required this.requestsTabColor,
    required this.inProgressTabColor,
    required this.completedTabColor,
    required this.declinedTabColor,
    required this.duplicatedTabColor,
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
        onPrimaryColor: const Color.fromRGBO(51, 51, 51, 1),
        secondaryTextColor: const Color.fromRGBO(140, 140, 140, 1),
        secondaryIconColor: const Color.fromRGBO(193, 193, 193, 1),
        actionColor: const Color.fromRGBO(51, 51, 51, 0.15),
        actionPressedColor: const Color.fromRGBO(51, 51, 51, 0.2),
        actionBackgroundColor: const Color.fromRGBO(224, 224, 224, 1),
        dividerColor: const Color.fromRGBO(210, 216, 223, 1),
        dialogBarrierColor: const Color.fromRGBO(255, 255, 255, 0.8),
        accentColor: const Color.fromRGBO(241, 96, 29, 1),
        pressedAccentColor: const Color.fromRGBO(200, 80, 25, 1),
        onAccentColor: const Color.fromRGBO(255, 255, 255, 1),
        focusedColor: const Color.fromRGBO(241, 96, 29, 0.12),
        focusedTonalColor: const Color.fromRGBO(241, 96, 29, 0.3),
        disabledTextColor: const Color.fromRGBO(51, 51, 51, 0.38),
        disabledTextButtonColor: const Color.fromRGBO(51, 51, 51, 0.08),
        errorColor: const Color.fromRGBO(246, 24, 48, 1),
        upvoteArrowColor: const Color.fromRGBO(140, 140, 140, 1),
        requestsTabColor: const Color.fromRGBO(241, 96, 29, 1),
        inProgressTabColor: const Color.fromRGBO(245, 167, 24, 1),
        completedTabColor: const Color.fromRGBO(38, 155, 85, 1),
        declinedTabColor: const Color.fromRGBO(246, 24, 48, 1),
        duplicatedTabColor: const Color.fromRGBO(29, 121, 241, 1),
        featureLabelColor: const Color.fromRGBO(0, 133, 255, 1),
        bugLabelColor: const Color.fromRGBO(246, 24, 48, 1),
        fade: const Color.fromRGBO(0, 0, 0, 0.65),
        fabColor: const Color.fromRGBO(33, 33, 33, 0.12),
      );

  SuggestionsTheme copyWith({
    Color? primaryBackgroundColor,
    Color? secondaryBackgroundColor,
    Color? thirdBackgroundColor,
    Color? bottomSheetBackgroundColor,
    String? fontFamily,
    Color? onPrimaryColor,
    Color? secondaryTextColor,
    Color? secondaryIconColor,
    Color? actionColor,
    Color? actionPressedColor,
    Color? actionBackgroundColor,
    Color? dividerColor,
    Color? dialogBarrierColor,
    Color? accentColor,
    Color? pressedAccentColor,
    Color? onAccentColor,
    Color? focusedColor,
    Color? focusedTonalColor,
    Color? disabledTextColor,
    Color? disabledTextButtonColor,
    Color? errorColor,
    Color? upvoteArrowColor,
    Color? requestsTabColor,
    Color? inProgressTabColor,
    Color? completedTabColor,
    Color? declinedTabColor,
    Color? duplicatedTabColor,
    Color? featureLabelColor,
    Color? bugLabelColor,
    Color? fade,
    Color? fabColor,
  }) {
    return SuggestionsTheme(
      primaryBackgroundColor:
          primaryBackgroundColor ?? this.primaryBackgroundColor,
      secondaryBackgroundColor:
          secondaryBackgroundColor ?? this.secondaryBackgroundColor,
      thirdBackgroundColor: thirdBackgroundColor ?? this.thirdBackgroundColor,
      bottomSheetBackgroundColor:
          bottomSheetBackgroundColor ?? this.bottomSheetBackgroundColor,
      fontFamily: fontFamily ?? this.fontFamily,
      onPrimaryColor: onPrimaryColor ?? this.onPrimaryColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      secondaryIconColor: secondaryIconColor ?? this.secondaryIconColor,
      actionColor: actionColor ?? this.actionColor,
      actionPressedColor: actionPressedColor ?? this.actionPressedColor,
      actionBackgroundColor:
          actionBackgroundColor ?? this.actionBackgroundColor,
      dividerColor: dividerColor ?? this.dividerColor,
      dialogBarrierColor: dialogBarrierColor ?? this.dialogBarrierColor,
      accentColor: accentColor ?? this.accentColor,
      pressedAccentColor: pressedAccentColor ?? this.pressedAccentColor,
      onAccentColor: onAccentColor ?? this.onAccentColor,
      focusedColor: focusedColor ?? this.focusedColor,
      focusedTonalColor: focusedTonalColor ?? this.focusedTonalColor,
      disabledTextColor: disabledTextColor ?? this.disabledTextColor,
      disabledTextButtonColor:
          disabledTextButtonColor ?? this.disabledTextButtonColor,
      errorColor: errorColor ?? this.errorColor,
      upvoteArrowColor: upvoteArrowColor ?? this.upvoteArrowColor,
      requestsTabColor: requestsTabColor ?? this.requestsTabColor,
      inProgressTabColor: inProgressTabColor ?? this.inProgressTabColor,
      completedTabColor: completedTabColor ?? this.completedTabColor,
      declinedTabColor: declinedTabColor ?? this.declinedTabColor,
      duplicatedTabColor: duplicatedTabColor ?? this.duplicatedTabColor,
      featureLabelColor: featureLabelColor ?? this.featureLabelColor,
      bugLabelColor: bugLabelColor ?? this.bugLabelColor,
      fade: fade ?? this.fade,
      fabColor: fabColor ?? this.fabColor,
    );
  }
}

ThemeData generateThemeData(SuggestionsTheme theme) {
  return ThemeData(
    useMaterial3: true,
    fontFamily: theme.fontFamily,
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: theme.onPrimaryColor,
        fontWeight: FontSizes.weightBold,
        fontSize: FontSizes.large,
      ),
      displayMedium: TextStyle(
        color: theme.onPrimaryColor,
        fontWeight: FontSizes.weightBold,
        fontSize: FontSizes.mediumPlus,
      ),
      displaySmall: TextStyle(
        color: theme.onPrimaryColor,
        fontWeight: FontSizes.weightBold,
        fontSize: FontSizes.medium,
      ),
      headlineLarge: TextStyle(
        color: theme.onPrimaryColor,
        fontWeight: FontSizes.weightRegular,
        fontSize: FontSizes.mediumPlus,
      ),
      headlineMedium: TextStyle(
        color: theme.onPrimaryColor,
        fontWeight: FontSizes.weightRegular,
        fontSize: FontSizes.medium,
      ),
      headlineSmall: TextStyle(
        color: theme.onPrimaryColor,
        fontWeight: FontSizes.weightBold,
        fontSize: FontSizes.smallPlus,
      ),
      titleLarge: TextStyle(
        color: theme.secondaryTextColor,
        fontWeight: FontSizes.weightBold,
        fontSize: FontSizes.smallPlus,
      ),
      titleMedium: TextStyle(
        color: theme.onPrimaryColor,
        fontWeight: FontSizes.weightRegular,
        fontSize: FontSizes.smallPlus,
      ),
      titleSmall: TextStyle(
        color: theme.onPrimaryColor,
        fontWeight: FontSizes.weightRegular,
        fontSize: FontSizes.small,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: const MaterialStatePropertyAll(EdgeInsets.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: const MaterialStatePropertyAll(0),
        backgroundColor: _materialStateProperty<Color>(
          defaultValue: theme.accentColor,
          pressed: theme.pressedAccentColor,
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.smallCircularRadius),
          ),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(
            vertical: Dimensions.marginMiddle,
            horizontal: Dimensions.marginBig,
          ),
        ),
        foregroundColor: _materialStateProperty<Color>(
          defaultValue: theme.onPrimaryColor,
          pressed: theme.actionPressedColor,
        ),
        textStyle: const MaterialStatePropertyAll(
          TextStyle(
            fontWeight: FontSizes.weightRegular,
            fontSize: FontSizes.smallPlus,
          ),
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: theme.primaryBackgroundColor,
      surfaceTintColor: Colors.transparent,
      foregroundColor: theme.onPrimaryColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: FontSizes.medium,
        fontWeight: FontSizes.weightBold,
        color: theme.onPrimaryColor,
      ),
    ),
  );
}

MaterialStateProperty<T?> _materialStateProperty<T>({
  T? defaultValue,
  T? focused,
  T? pressed,
  T? disabled,
}) {
  return MaterialStateProperty.resolveWith(
    (states) {
      if (focused != null && states.contains(MaterialState.focused)) {
        return focused;
      }
      if (pressed != null && states.contains(MaterialState.pressed)) {
        return pressed;
      }
      if (disabled != null && states.contains(MaterialState.disabled)) {
        return disabled;
      }
      return defaultValue;
    },
  );
}
