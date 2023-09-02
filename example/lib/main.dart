import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:saf_example/web_wrapper.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

void main() => runApp(
      kIsWeb
          ? const WebWrapper(
              app: MyApp(),
            )
          : const MyApp(),
    );

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return MaterialApp(
      title: 'Suggest a Feature',
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: SuggestionsPage(
          onGetUserById: (id) => Future<SuggestionAuthor>(
            () => _suggestionAuthor,
          ),
          suggestionsDataSource: MySuggestionDataSource(userId: '1'),
          theme: SuggestionsTheme.initial(),
          userId: '1',
          isAdmin: true,
          adminSettings: _adminSettings,
        ),
      ),
    );
  }
}

const SuggestionAuthor _suggestionAuthor = SuggestionAuthor(
  id: '1',
  username: 'Author',
);
const AdminSettings _adminSettings = AdminSettings(
  id: '2',
  username: 'Admin',
);

class MySuggestionDataSource implements SuggestionsDataSource {
  final Map<String, Suggestion> _suggestions = <String, Suggestion>{
    '1': Suggestion(
      id: '1',
      title: 'Hashtags',
      authorId: '1',
      isAnonymous: false,
      creationTime: DateTime.now(),
      description: 'Ability to add and filter events with #hashtags',
      status: SuggestionStatus.requests,
    ),
    '2': Suggestion(
      id: '2',
      title: 'Import/Export as pdf',
      authorId: '2',
      isAnonymous: true,
      labels: const [SuggestionLabel.feature],
      creationTime: DateTime.now(),
      description: 'Feature to import and export events',
      status: SuggestionStatus.requests,
    ),
    '3': Suggestion(
      id: '3',
      title: 'Notification',
      authorId: '3',
      isAnonymous: false,
      creationTime: DateTime.now(),
      description: 'Implement notification date change',
      status: SuggestionStatus.inProgress,
    ),
    '4': Suggestion(
      id: '4',
      title: 'Video',
      authorId: '4',
      isAnonymous: true,
      labels: const [SuggestionLabel.feature],
      creationTime: DateTime.now(),
      description: 'Аbility to save video',
      status: SuggestionStatus.inProgress,
    ),
    '5': Suggestion(
      id: '5',
      title: 'Image',
      authorId: '5',
      isAnonymous: true,
      creationTime: DateTime.now(),
      labels: const [SuggestionLabel.bug],
      description: 'Poor image quality',
      status: SuggestionStatus.completed,
    ),
    '6': Suggestion(
      id: '6',
      title: 'Offline authorization',
      authorId: '6',
      isAnonymous: false,
      creationTime: DateTime.now(),
      status: SuggestionStatus.completed,
    ),
  };
  final Map<String, Comment> _comments = <String, Comment>{
    '1': Comment(
      author: _suggestionAuthor,
      id: '1',
      suggestionId: '1',
      isAnonymous: false,
      text: 'Good idea',
      creationTime: DateTime.now(),
      isFromAdmin: true,
    ),
    '2': Comment(
      author: _suggestionAuthor,
      id: '2',
      suggestionId: '2',
      isAnonymous: false,
      text: 'It would be helpful',
      creationTime: DateTime.now(),
      isFromAdmin: false,
    ),
    '3': Comment(
      author: _suggestionAuthor,
      id: '3',
      suggestionId: '3',
      isAnonymous: false,
      text: 'Be sure to think about it',
      creationTime: DateTime.now(),
      isFromAdmin: true,
    ),
    '4': Comment(
      author: _suggestionAuthor,
      id: '4',
      suggestionId: '4',
      isAnonymous: false,
      text: 'Good idea',
      creationTime: DateTime.now(),
      isFromAdmin: true,
    ),
    '5': Comment(
      author: _suggestionAuthor,
      id: '5',
      suggestionId: '5',
      isAnonymous: false,
      text: 'Urgent fix',
      creationTime: DateTime.now(),
      isFromAdmin: false,
    ),
    '6': Comment(
      author: _suggestionAuthor,
      id: '6',
      suggestionId: '6',
      isAnonymous: true,
      text: 'Done',
      creationTime: DateTime.now(),
      isFromAdmin: true,
    ),
  };

  MySuggestionDataSource({required this.userId});

  @override
  final String userId;

  @override
  Future<Suggestion> createSuggestion(
    CreateSuggestionModel suggestionModel,
  ) async {
    final Suggestion suggestion = Suggestion(
      id: _generateSuggestionId(),
      title: suggestionModel.title,
      description: suggestionModel.description,
      labels: suggestionModel.labels,
      images: suggestionModel.images,
      authorId: suggestionModel.authorId,
      isAnonymous: suggestionModel.isAnonymous,
      creationTime: DateTime.now(),
      status: suggestionModel.status,
    );
    _suggestions[suggestion.id] = suggestion;
    return getSuggestionById(suggestion.id);
  }

  @override
  Future<Suggestion> getSuggestionById(String suggestionId) async =>
      _suggestions[suggestionId]!;

  @override
  Future<List<Suggestion>> getAllSuggestions() async => _suggestions.isNotEmpty
      ? _suggestions.values.cast<Suggestion>().toList()
      : <Suggestion>[];

  @override
  Future<Suggestion> updateSuggestion(Suggestion suggestion) async {
    _suggestions[suggestion.id] = suggestion;
    return _suggestions[suggestion.id]!;
  }

  @override
  Future<void> deleteSuggestionById(String suggestionId) async =>
      _suggestions.remove(suggestionId);

  @override
  Future<Comment> createComment(CreateCommentModel commentModel) async {
    final Comment comment = Comment(
      id: _generateCommentId(),
      suggestionId: commentModel.suggestionId,
      author: _suggestionAuthor,
      isAnonymous: commentModel.isAnonymous,
      text: commentModel.text,
      creationTime: DateTime.now(),
      isFromAdmin: commentModel.isFromAdmin,
    );
    _comments[comment.id] = comment;
    return comment;
  }

  @override
  Future<List<Comment>> getAllComments(String suggestionId) async =>
      _comments.isNotEmpty
          ? _comments.values
              .where((comment) => comment.suggestionId == suggestionId)
              .toList()
          : <Comment>[];

  @override
  Future<void> deleteCommentById(String commentId) async =>
      _comments.remove(commentId);

  @override
  Future<void> addNotifyToUpdateUser(String suggestionId) async {
    final modifiedSet = {
      ..._suggestions[suggestionId]!.notifyUserIds,
    }..add(userId);

    _suggestions[suggestionId] = _suggestions[suggestionId]!.copyWith(
      notifyUserIds: modifiedSet,
    );
  }

  @override
  Future<void> deleteNotifyToUpdateUser(String suggestionId) async {
    final modifiedSet = {
      ..._suggestions[suggestionId]!.notifyUserIds,
    }..remove(userId);

    _suggestions[suggestionId] = _suggestions[suggestionId]!.copyWith(
      notifyUserIds: modifiedSet,
    );
  }

  @override
  Future<void> upvote(String suggestionId) async {
    final modifiedSet = {
      ..._suggestions[suggestionId]!.votedUserIds,
    }..add(userId);
    _suggestions[suggestionId] = _suggestions[suggestionId]!.copyWith(
      votedUserIds: modifiedSet,
    );
  }

  @override
  Future<void> downvote(String suggestionId) async {
    final modifiedSet = {
      ..._suggestions[suggestionId]!.votedUserIds,
    }..remove(userId);

    _suggestions[suggestionId] = _suggestions[suggestionId]!.copyWith(
      votedUserIds: modifiedSet,
    );
  }

  String _generateCommentId() {
    if (_comments.isEmpty) {
      return '1';
    } else {
      final Comment lastAddedComment = _comments.values.last;
      int lastId = int.parse(lastAddedComment.id);
      ++lastId;
      return lastId.toString();
    }
  }

  String _generateSuggestionId() {
    if (_suggestions.isEmpty) {
      return '1';
    } else {
      final Suggestion lastAddedSuggestion = _suggestions.values.last;
      int lastId = int.parse(lastAddedSuggestion.id);
      ++lastId;
      return lastId.toString();
    }
  }
}
