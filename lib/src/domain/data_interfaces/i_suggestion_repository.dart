import '../entities/comment.dart';
import '../entities/suggestion.dart';
import '../entities/suggestion_author.dart';

abstract class ISuggestionRepository {
  Stream<List<Suggestion>> get suggestionsStream;
  List<Suggestion> get suggestions;
  Map<String, SuggestionAuthor?> get userInfo;

  void initSuggestions();
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
}
