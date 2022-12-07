import 'package:flutter/material.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suggest a feature Example',
      home: Scaffold(
        body: SuggestionsPage(
          onGetUserById: (id) => Future(
            () => const SuggestionAuthor(id: '1', username: 'Author'),
          ),
          suggestionsDataSource: MySuggestionDataSource(userId: '1'),
          theme: SuggestionsTheme.initial(),
          userId: '1',
        ),
      ),
    );
  }
}

class MySuggestionDataSource implements SuggestionsDataSource {
  final _suggestions = <Suggestion>[];
  final _comments = <Comment>[];
  final _votedUserRelation = <CreateVotedUserRelationModel>[];
  final _subscribedUserRelation = <CreateSubscribedUserRelationModel>[];

  final _suggestionAuthor = const SuggestionAuthor(id: '1', username: 'Author');

  @override
  final String userId;

  MySuggestionDataSource({
    required this.userId,
  });

  String _generateCommentId() {
    if (_comments.isEmpty) {
      return '1';
    } else {
      var lastId = int.parse(_comments.last.id);
      lastId++;
      return lastId.toString();
    }
  }

  String _generateSuggestionId() {
    if (_suggestions.isEmpty) {
      return '1';
    } else {
      var lastId = int.parse(_suggestions.last.id);
      lastId++;
      return lastId.toString();
    }
  }

  @override
  Future<Wrapper<Comment>> createComment(CreateCommentModel commentModel) async {
    final comment = Comment(
      id: _generateCommentId(),
      suggestionId: commentModel.suggestionId,
      author: _suggestionAuthor,
      isAnonymous: commentModel.isAnonymous,
      text: commentModel.text,
      creationTime: DateTime.now(),
    );
    _comments.add(comment);
    return Wrapper(data: comment);
  }

  @override
  Future<Wrapper<Suggestion>> createSuggestion(CreateSuggestionModel suggestionModel) async {
    final suggestion = Suggestion(
      id: _generateSuggestionId(),
      title: suggestionModel.title,
      authorId: suggestionModel.authorId,
      isAnonymous: suggestionModel.isAnonymous,
      creationTime: DateTime.now(),
      status: suggestionModel.status,
    );
    _suggestions.add(suggestion);
    return Wrapper(data: suggestion);
  }

  @override
  Future<Wrapper<Comment>> deleteCommentById(String commentId) async {
    _comments.removeWhere((comment) => comment.id == commentId);
    return Wrapper(status: 200);
  }

  @override
  Future<Wrapper<void>> addNotifyToUpdateUser(String suggestionId) async {
    _subscribedUserRelation.add(
      CreateSubscribedUserRelationModel(suggestionId: suggestionId, userId: userId),
    );
    return Wrapper(status: 200);
  }

  @override
  Future<Wrapper<void>> deleteNotifyToUpdateUser(String suggestionId) async {
    _subscribedUserRelation.removeWhere(
      (element) => element.suggestionId == suggestionId && element.userId == userId,
    );
    return Wrapper(status: 200);
  }

  @override
  Future<Wrapper<Suggestion>> deleteSuggestionById(String suggestionId) async {
    _comments.removeWhere((suggestion) => suggestion.id == suggestionId);
    return Wrapper(status: 200);
  }

  @override
  Future<Wrapper<void>> upvote(String suggestionId) async {
    _votedUserRelation.add(
      CreateVotedUserRelationModel(suggestionId: suggestionId, userId: userId),
    );
    return Wrapper(status: 200);
  }

  @override
  Future<Wrapper<void>> downvote(String suggestionId) async {
    _votedUserRelation.removeWhere(
      (element) => element.suggestionId == suggestionId && element.userId == userId,
    );
    return Wrapper(status: 200);
  }

  @override
  Future<Wrapper<List<Comment>>> getAllComments(String suggestionId) async {
    return Wrapper(data: _comments);
  }

  Suggestion _mockSuggestionSqlJoin(Suggestion suggestion) {
    final shouldNotifyAfterCompleted = _subscribedUserRelation.contains(
      CreateSubscribedUserRelationModel(suggestionId: suggestion.id, userId: userId),
    );
    final isVoted = _votedUserRelation.contains(
      CreateVotedUserRelationModel(suggestionId: suggestion.id, userId: userId),
    );
    final upvotesCount = _votedUserRelation
        .where((element) => element.suggestionId == suggestion.id)
        .toList()
        .length;

    final fullInfoSuggestion = suggestion.copyWith(
      shouldNotifyAfterCompleted: shouldNotifyAfterCompleted,
      isVoted: isVoted,
      upvotesCount: upvotesCount,
    );

    return fullInfoSuggestion;
  }

  @override
  Future<Wrapper<List<Suggestion>>> getAllSuggestions() async {
    final suggestions = _suggestions.map((element) => _mockSuggestionSqlJoin(element)).toList();
    return Wrapper(data: suggestions);
  }

  @override
  Future<Wrapper<Comment>> getCommentById(String commentId) async {
    return Wrapper(data: _comments.firstWhere((comment) => comment.id == commentId));
  }

  @override
  Future<Wrapper<Suggestion>> getSuggestionById(String suggestionId) async {
    return Wrapper(
      data: _mockSuggestionSqlJoin(
          _suggestions.firstWhere((suggestion) => suggestion.id == suggestionId)),
    );
  }

  @override
  Future<Wrapper<Comment>> updateComment(Comment comment) async {
    final commentIndex = _comments.indexWhere((element) => element.id == comment.id);
    _comments[commentIndex] = comment;
    return Wrapper(status: 200);
  }

  @override
  Future<Wrapper<Suggestion>> updateSuggestion(Suggestion suggestion) async {
    final suggestionIndex = _suggestions.indexWhere((element) => element.id == suggestion.id);
    _suggestions[suggestionIndex] = suggestion;
    return Wrapper(status: 200);
  }
}
