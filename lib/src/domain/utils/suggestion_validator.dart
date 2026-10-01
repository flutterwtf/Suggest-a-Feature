/// An extra rule for a suggestion's title or description, checked after the
/// field is known to be non-empty.
class SuggestionValidationRule {
  /// Checked against the trimmed text with [RegExp.hasMatch], so anchor the
  /// pattern with `^` and `$` to check the whole text.
  final RegExp pattern;

  /// Shown under the field when the rule fails.
  final String errorText;

  /// If `true`, the text must match [pattern]; if `false`, it must not.
  final bool mustMatch;

  /// A rule that passes when the text matches [pattern].
  const SuggestionValidationRule({
    required this.pattern,
    required this.errorText,
  }) : mustMatch = true;

  /// A rule that fails when [pattern] is found anywhere in the text, for
  /// example a banned word.
  const SuggestionValidationRule.forbidden({
    required this.pattern,
    required this.errorText,
  }) : mustMatch = false;

  /// Requires at least [length] characters, not counting surrounding
  /// whitespace.
  factory SuggestionValidationRule.minLength(
    int length, {
    required String errorText,
  }) => SuggestionValidationRule(
    pattern: RegExp('^[\\s\\S]{$length,}\$', unicode: true),
    errorText: errorText,
  );

  /// Allows at most [length] characters, not counting surrounding
  /// whitespace.
  factory SuggestionValidationRule.maxLength(
    int length, {
    required String errorText,
  }) => SuggestionValidationRule(
    pattern: RegExp('^[\\s\\S]{0,$length}\$', unicode: true),
    errorText: errorText,
  );

  bool isValid(String text) => pattern.hasMatch(text) == mustMatch;
}

/// Rules a suggestion must satisfy before it can be created or updated.
///
/// Text is checked after trimming, so a title or description made only of
/// whitespace is treated as empty. A missing description is empty too.
abstract final class SuggestionValidator {
  /// Returns the error to show for [text], or `null` if it is valid.
  ///
  /// Empty text gets [requiredErrorText]. Otherwise [rules] are checked in
  /// order and the first one that fails gives the error.
  static String? validate(
    String? text, {
    required String requiredErrorText,
    List<SuggestionValidationRule> rules = const [],
  }) {
    final trimmed = text?.trim() ?? '';
    if (trimmed.isEmpty) {
      return requiredErrorText;
    }
    for (final rule in rules) {
      if (!rule.isValid(trimmed)) {
        return rule.errorText;
      }
    }
    return null;
  }
}
