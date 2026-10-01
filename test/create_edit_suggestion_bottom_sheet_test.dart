import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/create_edit/create_edit_suggestion_bottom_sheet.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

class _FakeDataSource implements SuggestionsDataSource {
  final created = <CreateSuggestionModel>[];

  @override
  String get userId => 'user';

  @override
  Future<Suggestion> createSuggestion(CreateSuggestionModel suggestion) async {
    created.add(suggestion);
    return Suggestion(
      id: '1',
      title: suggestion.title,
      description: suggestion.description,
      labels: suggestion.labels,
      images: suggestion.images,
      authorId: suggestion.authorId,
      isAnonymous: suggestion.isAnonymous,
      creationTime: DateTime(2026),
      status: suggestion.status,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  // The injector is a singleton that keeps the first data source it gets,
  // so all tests share one fake and reset it between runs.
  final dataSource = _FakeDataSource();

  void initInjector({
    List<SuggestionValidationRule> titleValidationRules = const [],
    List<SuggestionValidationRule> descriptionValidationRules = const [],
  }) => i.init(
    theme: SuggestionsTheme.initial(),
    userId: 'user',
    suggestionsDataSource: dataSource,
    locale: 'en',
    titleValidationRules: titleValidationRules,
    descriptionValidationRules: descriptionValidationRules,
  );

  setUp(() {
    dataSource.created.clear();
    initInjector();
  });

  Future<void> pumpSheet(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CreateEditSuggestionBottomSheet(
            controller: SheetController(),
            onClose: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder field(int index) => find.byType(TextField).at(index);

  testWidgets('does not create a suggestion with blank title and description', (
    tester,
  ) async {
    await pumpSheet(tester);

    await tester.enterText(field(0), '   ');
    await tester.tap(find.text('Suggest'));
    await tester.pumpAndSettle();

    expect(dataSource.created, isEmpty);
    expect(find.text('Please enter a title'), findsOneWidget);
    expect(find.text('Please enter a description'), findsOneWidget);
  });

  testWidgets('does not create a suggestion without a description', (
    tester,
  ) async {
    await pumpSheet(tester);

    await tester.enterText(field(0), 'Dark mode');
    await tester.tap(find.text('Suggest'));
    await tester.pumpAndSettle();

    expect(dataSource.created, isEmpty);
    expect(find.text('Please enter a title'), findsNothing);
    expect(find.text('Please enter a description'), findsOneWidget);
  });

  testWidgets('creates a suggestion with trimmed title and description', (
    tester,
  ) async {
    await pumpSheet(tester);

    await tester.enterText(field(0), '  Dark mode ');
    await tester.enterText(field(1), ' Add a dark theme\n');
    await tester.tap(find.text('Suggest'));
    await tester.pumpAndSettle();

    expect(dataSource.created, hasLength(1));
    expect(dataSource.created.single.title, 'Dark mode');
    expect(dataSource.created.single.description, 'Add a dark theme');
  });

  testWidgets('shows the custom rule errors and does not create a suggestion', (
    tester,
  ) async {
    initInjector(
      titleValidationRules: [
        SuggestionValidationRule.minLength(5, errorText: 'Title is too short'),
      ],
      descriptionValidationRules: [
        SuggestionValidationRule.minLength(
          20,
          errorText: 'Description is too short',
        ),
      ],
    );
    await pumpSheet(tester);

    await tester.enterText(field(0), 'Dark');
    await tester.enterText(field(1), 'Add a dark theme');
    await tester.tap(find.text('Suggest'));
    await tester.pumpAndSettle();

    expect(dataSource.created, isEmpty);
    expect(find.text('Title is too short'), findsOneWidget);
    expect(find.text('Description is too short'), findsOneWidget);
  });

  testWidgets('creates a suggestion that passes the custom rules', (
    tester,
  ) async {
    initInjector(
      titleValidationRules: [
        SuggestionValidationRule.minLength(5, errorText: 'Title is too short'),
      ],
      descriptionValidationRules: [
        SuggestionValidationRule.minLength(
          20,
          errorText: 'Description is too short',
        ),
      ],
    );
    await pumpSheet(tester);

    await tester.enterText(field(0), 'Dark mode');
    await tester.enterText(field(1), 'Add a dark theme for night use');
    await tester.tap(find.text('Suggest'));
    await tester.pumpAndSettle();

    expect(dataSource.created, hasLength(1));
  });
}
