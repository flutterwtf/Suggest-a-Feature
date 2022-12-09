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
  final _suggestionAuthor = const SuggestionAuthor(id: '1', username: 'Author');

  MySuggestionDataSource({required this.userId});

  @override
  final String userId;

  String _generateCommentId() {
    if (_comments.isEmpty) {
      return '1';
    } else {
      var lastId = int.parse(_comments.last.id);
      ++lastId;
      return lastId.toString();
    }
  }

  String _generateSuggestionId() {
    if (_suggestions.isEmpty) {
      return '1';
    } else {
      var lastId = int.parse(_suggestions.last.id);
      ++lastId;
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
      description: suggestionModel.description,
      labels: suggestionModel.labels,
      images: suggestionModel.images,
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
    final suggestionIndex = _suggestions.indexWhere(((element) => element.id == suggestionId));
    Set<String> modifiedSet = {..._suggestions[suggestionIndex].notifyUserIds, userId};
    _suggestions[suggestionIndex] = _suggestions[suggestionIndex].copyWith(
      notifyUserIds: modifiedSet,
    );
    return Wrapper(status: 200);
  }

  @override
  Future<Wrapper<void>> deleteNotifyToUpdateUser(String suggestionId) async {
    final suggestionIndex = _suggestions.indexWhere(((element) => element.id == suggestionId));
    Set<String> modifiedSet = {..._suggestions[suggestionIndex].notifyUserIds..remove(userId)};
    _suggestions[suggestionIndex] = _suggestions[suggestionIndex].copyWith(
      notifyUserIds: modifiedSet,
    );
    return Wrapper(status: 200);
  }

  @override
  Future<Wrapper<Suggestion>> deleteSuggestionById(String suggestionId) async {
    _suggestions.removeWhere((suggestion) => suggestion.id == suggestionId);
    return Wrapper(status: 200);
  }

  @override
  Future<Wrapper<void>> upvote(String suggestionId) async {
    final suggestionIndex = _suggestions.indexWhere(((element) => element.id == suggestionId));
    Set<String> modifiedSet = {..._suggestions[suggestionIndex].votedUserIds, userId};
    _suggestions[suggestionIndex] = _suggestions[suggestionIndex].copyWith(
      votedUserIds: modifiedSet,
    );
    return Wrapper(status: 200);
  }

  @override
  Future<Wrapper<void>> downvote(String suggestionId) async {
    final suggestionIndex = _suggestions.indexWhere(((element) => element.id == suggestionId));
    Set<String> modifiedSet = {..._suggestions[suggestionIndex].votedUserIds..remove(userId)};
    _suggestions[suggestionIndex] = _suggestions[suggestionIndex].copyWith(
      votedUserIds: modifiedSet,
    );
    return Wrapper(status: 200);
  }

  @override
  Future<Wrapper<Suggestion>> getSuggestionById(String suggestionId) async {
    return Wrapper(data: _suggestions.firstWhere((suggestion) => suggestion.id == suggestionId));
  }

  @override
  Future<Wrapper<List<Suggestion>>> getAllSuggestions() async {
    return Wrapper(data: _suggestions);
  }

  @override
  Future<Wrapper<Comment>> getCommentById(String commentId) async {
    return Wrapper(data: _comments.firstWhere((comment) => comment.id == commentId));
  }

  @override
  Future<Wrapper<List<Comment>>> getAllComments(String suggestionId) async {
    return Wrapper(
      data: _comments.where((comment) => comment.suggestionId == suggestionId).toList(),
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
