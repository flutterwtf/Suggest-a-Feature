import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:suggest_a_feature/src/domain/interactors/suggestion_interactor.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

import '../utils/mocked_entities.dart';
import '../utils/shared_mocks.mocks.dart';

void main() {
  final mockSuggestionRepository = MockSuggestionRepository();

  final suggestionInteractor = SuggestionInteractor(mockSuggestionRepository);

  final suggestion = mockedSuggestion;
  final createSuggestionModel = mockedCreateSuggestionModel;
  final comment = mockedComment;
  final createCommentModel = mockedCreateCommentModel;

  final response = Wrapper<Suggestion>(data: suggestion);

  group('suggestion interactor', () {
    test('suggestions stream', () async {
      final suggestionsList = <Suggestion>[suggestion];

      when(mockSuggestionRepository.suggestionsStream)
          .thenAnswer((_) => Stream.fromIterable([suggestionsList]));

      expect(await suggestionInteractor.suggestionsStream.first, suggestionsList);
    });

    test('update suggestion', () async {
      when(mockSuggestionRepository.updateSuggestion(suggestion))
          .thenAnswer((_) => Future.value(response));

      expect(await suggestionInteractor.updateSuggestion(suggestion), response);
    });

    test('create suggestion', () async {
      when(mockSuggestionRepository.createSuggestion(createSuggestionModel))
          .thenAnswer((_) => Future.value(response.data));

      expect(await suggestionInteractor.createSuggestion(createSuggestionModel), response);
    });

    test('get all comments', () async {
      final suggestionsList = <Comment>[comment];
      final response = Wrapper(data: suggestionsList);

      when(mockSuggestionRepository.getAllComments(suggestion.id))
          .thenAnswer((_) => Future.value(response));

      expect(await suggestionInteractor.getAllComments(suggestion.id), response);
    });

    test('create comment', () async {
      final response = Wrapper(data: comment);

      when(mockSuggestionRepository.createComment(createCommentModel))
          .thenAnswer((_) => Future.value(response));

      expect(await suggestionInteractor.createComment(createCommentModel), response);
    });
  });
}
