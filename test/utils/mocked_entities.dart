import 'package:suggest_a_feature/suggest_a_feature.dart';

final mockedSuggestionAuthor = const SuggestionAuthor(
  id: '1',
  username: 'username',
);

final mockedCreateSuggestionModel = CreateSuggestionModel(
  title: 'Suggestion',
  description: 'Description',
  labels: [],
  images: [],
  authorId: '1',
  isAnonymous: false,
  status: SuggestionStatus.requests,
);

final mockedSuggestion = Suggestion(
  id: '1',
  title: 'Suggestion',
  description: 'Description',
  labels: [],
  images: [],
  authorId: '1',
  isAnonymous: false,
  creationTime: DateTime(2022),
  status: SuggestionStatus.requests,
  comments: [],
  votedUserIds: {},
  notifyUserIds: {},
);

final mockedSuggestion2 = Suggestion(
  id: '2',
  title: 'Suggestion2',
  description: 'Description2',
  labels: [],
  images: [],
  authorId: '1',
  isAnonymous: true,
  creationTime: DateTime(2022),
  status: SuggestionStatus.requests,
  comments: [],
  votedUserIds: {},
  notifyUserIds: {},
);

final mockedComment = Comment(
  id: '1',
  suggestionId: '1',
  author: mockedSuggestionAuthor,
  isAnonymous: true,
  text: 'Comment1',
  creationTime: DateTime(2022),
);

final mockedCreateCommentModel = CreateCommentModel(
  authorId: mockedComment.author.id,
  isAnonymous: mockedComment.isAnonymous,
  text: mockedComment.text,
  suggestionId: mockedComment.suggestionId,
);
