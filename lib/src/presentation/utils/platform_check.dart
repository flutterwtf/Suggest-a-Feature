import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

abstract class SuggestionsPlatform {
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  static String localeName(BuildContext context) {
    return View.of(context).platformDispatcher.locale.languageCode;
  }
}
