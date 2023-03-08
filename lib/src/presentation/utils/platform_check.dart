import 'dart:io';
import 'package:flutter/foundation.dart';

abstract class SuggestionsPlatform {
  static bool get isIOS => !kIsWeb && Platform.isIOS;
}
