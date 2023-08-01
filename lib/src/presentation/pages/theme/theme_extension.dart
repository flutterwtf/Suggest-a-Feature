import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ThemeData get themeData {
    return Theme.of(this);
  }
}
