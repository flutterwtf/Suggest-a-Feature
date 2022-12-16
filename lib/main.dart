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
          onGetUserById: (String id) => Future(
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
  final SuggestionAuthor _suggestionAuthor = const SuggestionAuthor(id: '1', username: 'Author');
  Map<String, dynamic> suggestions = <String, Suggestion>{};
  Map<String, dynamic> comments = <String, Comment>{};

  MySuggestionDataSource({required this.userId});

  @override
  final String userId;

  String _generateCommentId() {
    if (comments.isEmpty) {
      return '1';
    } else {
      int lastId = int.parse(comments.values.last.id);
      ++lastId;
      return lastId.toString();
    }
  }

  String _generateSuggestionId() {
    if (suggestions.isEmpty) {
      return '1';
    } else {
      int lastId = int.parse(suggestions.values.last.id);
      ++lastId;
      return lastId.toString();
    }
  }

  @override
  Future<Wrapper<Comment>> createComment(CreateCommentModel commentModel) async {
    final Comment comment = Comment(
      id: _generateCommentId(),
      suggestionId: commentModel.suggestionId,
      author: _suggestionAuthor,
      isAnonymous: commentModel.isAnonymous,
      text: commentModel.text,
      creationTime: DateTime.now(),
    );
    comments[comment.id] = comment;
    return Wrapper(data: comment);
  }

  @override
  Future<Suggestion> createSuggestion(CreateSuggestionModel suggestionModel) async {
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
    final Wrapper<Suggestion> createdSuggestion = await getSuggestionById(suggestion.id);
    if (createdSuggestion.data == null) {
      throw NullThrownError();
    }
    return createdSuggestion.data!;
  }

  @override
  Future<Wrapper<Comment>> deleteCommentById(String commentId) async {
    comments.remove(commentId);
    return Wrapper();
  }

  @override
  Future<Wrapper<void>> addNotifyToUpdateUser(String suggestionId) async {
    final Set<String> modifiedSet = <String>{...suggestions[suggestionId]!.notifyUserIds, userId};
    suggestions[suggestionId] = suggestions[suggestionId]!.copyWith(
      notifyUserIds: modifiedSet,
    );
    return Wrapper();
  }

  @override
  Future<Wrapper<void>> deleteNotifyToUpdateUser(String suggestionId) async {
    final Set<String> modifiedSet = <String>{
      ...suggestions[suggestionId]!.notifyUserIds..remove(userId)
    };
    suggestions[suggestionId] = suggestions[suggestionId]!.copyWith(
      notifyUserIds: modifiedSet,
    );
    return Wrapper();
  }

  @override
  Future<Wrapper<Suggestion>> deleteSuggestionById(String suggestionId) async {
    suggestions.remove(suggestionId);
    return Wrapper();
  }

  @override
  Future<Wrapper<void>> upvote(String suggestionId) async {
    final Set<String> modifiedSet = <String>{...suggestions[suggestionId]!.votedUserIds, userId};
    suggestions[suggestionId] = suggestions[suggestionId]!.copyWith(
      votedUserIds: modifiedSet,
    );
    return Wrapper();
  }

  @override
  Future<Wrapper<void>> downvote(String suggestionId) async {
    final Set<String> modifiedSet = <String>{
      ...suggestions[suggestionId]!.votedUserIds..remove(userId)
    };
    suggestions[suggestionId] = suggestions[suggestionId]!.copyWith(
      votedUserIds: modifiedSet,
    );
    return Wrapper();
  }

  @override
  Future<Wrapper<Suggestion>> getSuggestionById(String suggestionId) async {
    return Wrapper(data: suggestions[suggestionId]);
  }

  @override
  Future<Wrapper<List<Suggestion>>> getAllSuggestions() async {
    return Wrapper(
      data: suggestions.isNotEmpty ? suggestions.values.cast<Suggestion>().toList() : null,
    );
  }

  @override
  Future<Wrapper<List<Comment>>> getAllComments(String suggestionId) async {
    return Wrapper(
      data: comments.isNotEmpty ? comments.values.cast<Comment>().toList() : null,
    );
  }

  @override
  Future<Wrapper<Suggestion>> updateSuggestion(Suggestion suggestion) async {
    suggestions[suggestion.id] = suggestion;
    return Wrapper();
  }
}
