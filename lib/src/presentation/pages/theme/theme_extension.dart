import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ThemeData get theme {
    return Theme.of(this);
  }
}
