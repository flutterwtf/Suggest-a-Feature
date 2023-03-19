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
      title: 'Suggest a feature Example page',
      home: Scaffold(
        body: SuggestionsPage(
          onGetUserById: (String id) => Future<SuggestionAuthor>(
            () => const SuggestionAuthor(
              id: '1',
              username: 'Author',
            ),
          ),
          suggestionsDataSource: MySuggestionDataSource(userId: '1'),
          theme: SuggestionsTheme.initial(),
          userId: '1',
          isAdmin: true,
          adminSettings: const AdminSettings(
            id: '2',
            username: 'Admin',
          ),
          customAppBar: const SuggestionsAppBar(
            screenTitle: 'Suggest a feature',
          ),
        ),
      ),
      localizationsDelegates: const [SuggestionsLocalizations.delegate],
    );
  }
}

class MySuggestionDataSource implements SuggestionsDataSource {
  final SuggestionAuthor _suggestionAuthor = const SuggestionAuthor(
    id: '1',
    username: 'Author',
  );
  final SuggestionAuthor _adminSettings = const AdminSettings(
    id: '2',
    username: 'Admin',
  );
  final Map<String, dynamic> suggestions = <String, Suggestion>{};
  Map<String, Comment> comments = <String, Comment>{};

  MySuggestionDataSource({required this.userId});

  @override
  final String userId;

  @override
  Future<Suggestion> createSuggestion(
      CreateSuggestionModel suggestionModel) async {
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
    suggestions[suggestion.id] = suggestion;
    return getSuggestionById(suggestion.id);
  }

  @override
  Future<Suggestion> getSuggestionById(String suggestionId) async =>
      suggestions[suggestionId];

  @override
  Future<List<Suggestion>> getAllSuggestions() async => suggestions.isNotEmpty
      ? suggestions.values.cast<Suggestion>().toList()
      : <Suggestion>[];

  @override
  Future<Suggestion> updateSuggestion(Suggestion suggestion) async {
    suggestions[suggestion.id] = suggestion;
    return suggestions[suggestion.id];
  }

  @override
  Future<void> deleteSuggestionById(String suggestionId) async =>
      suggestions.remove(suggestionId);

  @override
  Future<Comment> createComment(CreateCommentModel commentModel) async {
    final Comment comment = Comment(
      id: _generateCommentId(),
      suggestionId: commentModel.suggestionId,
      author: commentModel.isFromAdmin ? _adminSettings : _suggestionAuthor,
      isAnonymous: commentModel.isAnonymous,
      text: commentModel.text,
      creationTime: DateTime.now(),
      isFromAdmin: commentModel.isFromAdmin,
    );
    comments[comment.id] = comment;
    return comment;
  }

  @override
  Future<List<Comment>> getAllComments(String suggestionId) async =>
      comments.isNotEmpty
          ? comments.values
              .where((comment) => comment.suggestionId == suggestionId)
              .toList()
          : <Comment>[];

  @override
  Future<void> deleteCommentById(String commentId) async =>
      comments.remove(commentId);

  @override
  Future<void> addNotifyToUpdateUser(String suggestionId) async {
    final Set<String> modifiedSet = <String>{
      ...suggestions[suggestionId]!.notifyUserIds,
      userId
    };
    suggestions[suggestionId] = suggestions[suggestionId]!.copyWith(
      notifyUserIds: modifiedSet,
    );
  }

  @override
  Future<void> deleteNotifyToUpdateUser(String suggestionId) async {
    final Set<String> modifiedSet = <String>{
      ...suggestions[suggestionId]!.notifyUserIds..remove(userId)
    };
    suggestions[suggestionId] = suggestions[suggestionId]!.copyWith(
      notifyUserIds: modifiedSet,
    );
  }

  @override
  Future<void> upvote(String suggestionId) async {
    final Set<String> modifiedSet = <String>{
      ...suggestions[suggestionId]!.votedUserIds,
      userId
    };
    suggestions[suggestionId] = suggestions[suggestionId]!.copyWith(
      votedUserIds: modifiedSet,
    );
  }

  @override
  Future<void> downvote(String suggestionId) async {
    final Set<String> modifiedSet = <String>{
      ...suggestions[suggestionId]!.votedUserIds..remove(userId)
    };
    suggestions[suggestionId] = suggestions[suggestionId]!.copyWith(
      votedUserIds: modifiedSet,
    );
  }

  String _generateCommentId() {
    if (comments.isEmpty) {
      return '1';
    } else {
      final Comment lastAddedComment = comments.values.last;
      int lastId = int.parse(lastAddedComment.id);
      ++lastId;
      return lastId.toString();
    }
  }

  String _generateSuggestionId() {
    if (suggestions.isEmpty) {
      return '1';
    } else {
      final Suggestion lastAddedSuggestion = suggestions.values.last;
      int lastId = int.parse(lastAddedSuggestion.id);
      ++lastId;
      return lastId.toString();
    }
  }
}
