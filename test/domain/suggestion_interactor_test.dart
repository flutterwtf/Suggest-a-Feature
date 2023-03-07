// ignore_for_file: always_specify_types

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:suggest_a_feature/src/domain/data_interfaces/suggestion_repository.dart';
import 'package:suggest_a_feature/src/domain/interactors/suggestion_interactor.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

import '../utils/mocked_entities.dart';
import '../utils/shared_mocks.mocks.dart';

void main() {
  final mockSuggestionRepository = MockSuggestionRepository();
  final suggestionInteractor =
      SuggestionInteractor(mockSuggestionRepository as SuggestionRepository);

  final createSuggestionModel = mockedCreateSuggestionModel;
  final comment = mockedComment;
  final createCommentModel = mockedCreateCommentModel;

  group('suggestion interactor', () {
    test('suggestions stream', () async {
      final suggestionsList = <Suggestion>[mockedSuggestion];

      when(mockSuggestionRepository.suggestionsStream)
          .thenAnswer((_) => Stream.fromIterable([suggestionsList]));

      expect(
        await suggestionInteractor.suggestionsStream.first,
        suggestionsList,
      );
    });

    test('update suggestion', () async {
      when(mockSuggestionRepository.updateSuggestion(mockedSuggestion))
          .thenAnswer((_) => Future.value(mockedSuggestion));

      expect(
        await suggestionInteractor.updateSuggestion(mockedSuggestion),
        mockedSuggestion,
      );
    });

    test('create suggestion', () async {
      when(mockSuggestionRepository.createSuggestion(createSuggestionModel))
          .thenAnswer((_) => Future.value(mockedSuggestion));

      expect(
        await suggestionInteractor.createSuggestion(createSuggestionModel),
        mockedSuggestion,
      );
    });

    test('get all comments', () async {
      final suggestionsList = <Comment>[comment];
      final response = suggestionsList;

      when(mockSuggestionRepository.getAllComments(mockedSuggestion.id))
          .thenAnswer((_) => Future.value(response));

      expect(
        await suggestionInteractor.getAllComments(mockedSuggestion.id),
        response,
      );
    });

    test('create comment', () async {
      when(mockSuggestionRepository.createComment(createCommentModel))
          .thenAnswer((_) => Future.value(comment));

      expect(
        await suggestionInteractor.createComment(createCommentModel),
        comment,
      );
    });
  });
}
