import 'package:flutter_test/flutter_test.dart';
import 'package:suggest_a_feature/src/domain/utils/suggestion_validator.dart';

void main() {
  const required = 'required';

  String? validate(String? text, {SuggestionValidationRule? rule}) =>
      SuggestionValidator.validate(
        text,
        requiredErrorText: required,
        rules: [?rule],
      );

  group('SuggestionValidator without a rule', () {
    test('rejects missing, empty and whitespace-only text', () {
      expect(validate(null), required);
      expect(validate(''), required);
      expect(validate('  \n\t'), required);
    });

    test('accepts text', () {
      expect(validate(' Dark mode '), isNull);
    });
  });

  group('SuggestionValidator with a rule', () {
    final noDigits = SuggestionValidationRule(
      pattern: RegExp(r'^\D*$'),
      errorText: 'no digits',
    );

    test('still reports empty text as required', () {
      expect(validate('   ', rule: noDigits), required);
    });

    test('reports the rule error when the pattern does not match', () {
      expect(validate('Version 2', rule: noDigits), 'no digits');
    });

    test('accepts text matching the pattern', () {
      expect(validate('Dark mode', rule: noDigits), isNull);
    });
  });

  group('SuggestionValidationRule.minLength', () {
    final rule = SuggestionValidationRule.minLength(5, errorText: 'too short');

    test('rejects shorter text, ignoring surrounding whitespace', () {
      expect(validate('Dark', rule: rule), 'too short');
      expect(validate('   Dark   ', rule: rule), 'too short');
    });

    test('accepts text of exactly the minimum length', () {
      expect(validate('Theme', rule: rule), isNull);
    });

    test('counts line breaks inside the text', () {
      expect(validate('ab\ncd', rule: rule), isNull);
    });

    test('counts an emoji as one character', () {
      expect(validate('ab🔥c', rule: rule), 'too short');
    });
  });

  group('SuggestionValidationRule.maxLength', () {
    final rule = SuggestionValidationRule.maxLength(5, errorText: 'too long');

    test('accepts text up to the maximum, ignoring surrounding whitespace', () {
      expect(validate('  Theme  ', rule: rule), isNull);
    });

    test('rejects longer text', () {
      expect(validate('Themes', rule: rule), 'too long');
    });
  });

  group('SuggestionValidationRule.forbidden', () {
    final rule = SuggestionValidationRule.forbidden(
      pattern: RegExp(r'\bdick\b', caseSensitive: false),
      errorText: 'banned word',
    );

    test('rejects text containing the pattern in any case', () {
      expect(validate('What a dick move', rule: rule), 'banned word');
      expect(validate('DICK', rule: rule), 'banned word');
    });

    test('accepts text where the word is only part of a longer word', () {
      expect(validate('Dickens is a writer', rule: rule), isNull);
    });

    test(r'treats a hyphen as a word boundary for \b', () {
      expect(validate('Moby-Dick is a book', rule: rule), 'banned word');
    });
  });

  group('SuggestionValidator with several rules', () {
    final rules = [
      SuggestionValidationRule.forbidden(
        pattern: RegExp(r'\bdick\b', caseSensitive: false),
        errorText: 'banned word',
      ),
      SuggestionValidationRule.minLength(5, errorText: 'too short'),
      SuggestionValidationRule.maxLength(10, errorText: 'too long'),
    ];

    String? validateAll(String text) => SuggestionValidator.validate(
      text,
      requiredErrorText: required,
      rules: rules,
    );

    test('returns the error of the first failing rule', () {
      expect(validateAll('dick'), 'banned word');
      expect(validateAll('Dark'), 'too short');
      expect(validateAll('Dark mode please'), 'too long');
    });

    test('accepts text passing every rule', () {
      expect(validateAll('Dark mode'), isNull);
    });

    test('checks the required rule before the custom ones', () {
      expect(validateAll('   '), required);
    });
  });
}
