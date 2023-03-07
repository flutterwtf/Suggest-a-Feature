import 'package:intl/intl.dart';

import './string_utils.dart';

DateTime fromDateTime(String string) {
  return DateFormat('yyyy-MM-ddTHH:mm:ss').parse(string, true).toLocal();
}

extension DateTimeExtension on DateTime {
  String getMonth(String locale) {
    return DateFormat('MMMM', locale).format(this).capitalize();
  }

  String formatComment(String locale) {
    return '$day, ${getMonth(locale)} $year';
  }

  String formatEditSuggestion(String locale) {
    return '${getMonth(locale)} $day, $year';
  }
}
