// ignore_for_file: avoid_classes_with_only_static_members
import 'dart:io';
import 'package:flutter/foundation.dart';

abstract class SuggestionsPlatform {
  static bool get isIOS => !kIsWeb && Platform.isIOS;
}
