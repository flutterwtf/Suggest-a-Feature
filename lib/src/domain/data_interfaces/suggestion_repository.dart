import 'package:suggest_a_feature/src/domain/entities/comment.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion_author.dart';

abstract class SuggestionRepository {
  Stream<List<Suggestion>> get suggestionsStream;
  List<Suggestion> get suggestions;
  Map<String, SuggestionAuthor?> get userInfo;

  Future<void> initSuggestions();
  Future<Suggestion> getSuggestionById(String suggestionId);
  Future<Suggestion> createSuggestion(CreateSuggestionModel suggestion);
  Future<Suggestion> updateSuggestion(Suggestion suggestion);
  Future<void> deleteSuggestion(String suggestionId);

  void upvote(String suggestionId);
  void downvote(String suggestionId);
  Future<void> addNotifyToUpdateUser(String suggestionId);
  Future<void> deleteNotifyToUpdateUser(String suggestionId);

  void refreshSuggestions(Suggestion suggestion, {bool saveComments});

  Future<List<Comment>> getAllComments(String suggestionId);
  Future<Comment> createComment(CreateCommentModel comment);
  Future<void> deleteCommentById(String commentId);
}
