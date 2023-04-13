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

final Suggestion mockedRequestSuggestion = Suggestion(
  id: '1',
  title: 'Suggestion',
  description: 'Description',
  authorId: '1',
  isAnonymous: false,
  creationTime: DateTime(2022),
  status: SuggestionStatus.requests,
);

final Suggestion mockedRequestSuggestion2 = Suggestion(
  id: '2',
  title: 'Suggestion2',
  description: 'Description2',
  authorId: '1',
  isAnonymous: true,
  creationTime: DateTime(2022),
  status: SuggestionStatus.requests,
);

final Suggestion mockedInProgressSuggestion = Suggestion(
  id: '3',
  title: 'Suggestion3',
  description: 'Description3',
  authorId: '1',
  isAnonymous: false,
  creationTime: DateTime(2022),
  status: SuggestionStatus.inProgress,
);

final Suggestion mockedInProgressSuggestion2 = Suggestion(
  id: '4',
  title: 'Suggestion4',
  description: 'Description4',
  authorId: '1',
  isAnonymous: true,
  creationTime: DateTime(2022),
  status: SuggestionStatus.inProgress,
);

final Suggestion mockedCompletedSuggestion = Suggestion(
  id: '5',
  title: 'Suggestion5',
  description: 'Description5',
  authorId: '1',
  isAnonymous: true,
  creationTime: DateTime(2022),
  status: SuggestionStatus.completed,
);

final Suggestion mockedCompletedSuggestion2 = Suggestion(
  id: '6',
  title: 'Suggestion6',
  description: 'Description6',
  authorId: '1',
  isAnonymous: false,
  creationTime: DateTime(2022),
  status: SuggestionStatus.completed,
);

final Comment mockedComment = Comment(
  id: '1',
  suggestionId: '1',
  author: mockedSuggestionAuthor,
  isAnonymous: true,
  text: 'Comment1',
  creationTime: DateTime(2022),
  isFromAdmin: false,
);

final CreateCommentModel mockedCreateCommentModel = CreateCommentModel(
  authorId: mockedComment.author.id,
  isAnonymous: mockedComment.isAnonymous,
  text: mockedComment.text,
  suggestionId: mockedComment.suggestionId,
  isFromAdmin: false,
);
