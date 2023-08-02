import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';

SuggestionsTheme get theme => i.theme;

class SuggestionsTheme {
  final Color bottomSheetBackgroundColor;
  final Color actionColor;
  final Color actionPressedColor;
  final Color actionBackgroundColor;
  final Color disabledTextColor;
  final Color upvoteArrowColor;
  final Color fade;
  final Color fabColor;

  final Color requestsTabColor;
  final Color inProgressTabColor;
  final Color completedTabColor;
  final Color declinedTabColor;
  final Color duplicatedTabColor;

  final Color featureLabelColor;
  final Color bugLabelColor;

  SuggestionsTheme({
    required this.bottomSheetBackgroundColor,
    required this.actionColor,
    required this.actionPressedColor,
    required this.actionBackgroundColor,
    required this.disabledTextColor,
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
        bottomSheetBackgroundColor: const Color.fromRGBO(248, 248, 248, 1),
        actionColor: const Color.fromRGBO(51, 51, 51, 0.15),
        actionPressedColor: const Color.fromRGBO(51, 51, 51, 0.2),
        actionBackgroundColor: const Color.fromRGBO(224, 224, 224, 1),
        disabledTextColor: const Color.fromRGBO(51, 51, 51, 0.38),
        upvoteArrowColor: const Color.fromRGBO(246, 24, 48, 1),
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
    Color? bottomSheetBackgroundColor,
    Color? actionColor,
    Color? actionPressedColor,
    Color? actionBackgroundColor,
    Color? disabledTextColor,
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
      bottomSheetBackgroundColor:
          bottomSheetBackgroundColor ?? this.bottomSheetBackgroundColor,
      actionColor: actionColor ?? this.actionColor,
      actionPressedColor: actionPressedColor ?? this.actionPressedColor,
      actionBackgroundColor:
          actionBackgroundColor ?? this.actionBackgroundColor,
      disabledTextColor: disabledTextColor ?? this.disabledTextColor,
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
