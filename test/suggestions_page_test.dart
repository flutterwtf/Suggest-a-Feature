import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

class _FakeDataSource implements SuggestionsDataSource {
  @override
  String get userId => 'user';

  @override
  Future<List<Suggestion>> getAllSuggestions() async => [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('passes updated rule texts to the form when the app rebuilds', (
    tester,
  ) async {
    final dataSource = _FakeDataSource();

    Widget page(String errorText) => MaterialApp(
      home: SuggestionsPage(
        userId: 'user',
        suggestionsDataSource: dataSource,
        theme: SuggestionsTheme.initial(),
        onGetUserById: (_) async => null,
        titleValidationRules: [
          SuggestionValidationRule.minLength(5, errorText: errorText),
        ],
      ),
    );

    await tester.pumpWidget(page('Too short'));
    expect(i.titleValidationRules.single.errorText, 'Too short');

    await tester.pumpWidget(page('Zu kurz'));
    expect(i.titleValidationRules.single.errorText, 'Zu kurz');
  });
}
