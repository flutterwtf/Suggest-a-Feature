import 'package:suggest_a_feature/suggest_a_feature.dart';

const SuggestionAuthor mockedSuggestionAuthor = SuggestionAuthor(
  id: '1',
  username: 'username',
);

final CreateSuggestionModel mockedCreateSuggestionModel = CreateSuggestionModel(
  title: 'Suggestion',
  description: 'Description',
  labels: <SuggestionLabel>[],
  images: <String>[],
  authorId: '1',
  isAnonymous: false,
);

final Suggestion mockedSuggestion = Suggestion(
  id: '1',
  title: 'Suggestion',
  description: 'Description',
  authorId: '1',
  isAnonymous: false,
  creationTime: DateTime(2022),
  status: SuggestionStatus.requests,
);

final Suggestion mockedSuggestion2 = Suggestion(
  id: '2',
  title: 'Suggestion2',
  description: 'Description2',
  authorId: '1',
  isAnonymous: true,
  creationTime: DateTime(2022),
  status: SuggestionStatus.requests,
);

final Comment mockedComment = Comment(
  id: '1',
  suggestionId: '1',
  author: mockedSuggestionAuthor,
  isAnonymous: true,
  text: 'Comment1',
  creationTime: DateTime(2022),
);

final CreateCommentModel mockedCreateCommentModel = CreateCommentModel(
  authorId: mockedComment.author.id,
  isAnonymous: mockedComment.isAnonymous,
  text: mockedComment.text,
  suggestionId: mockedComment.suggestionId,
);
