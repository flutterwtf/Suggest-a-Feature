import '../../domain/entities/comment.dart';
import '../../domain/entities/suggestion.dart';
import '../../domain/utils/wrapper.dart';

abstract class SuggestionsDataSource {
  String get userId;
  Future<Wrapper<List<Suggestion>>> getAllSuggestions();
  Future<Wrapper<Suggestion>> createSuggestion(CreateSuggestionModel suggestion);
  Future<Wrapper<Suggestion>> getSuggestionById(String suggestionId);
  Future<Wrapper<Suggestion>> updateSuggestion(Suggestion suggestion);
  Future<Wrapper<Suggestion>> deleteSuggestionById(String suggestionId);

  Future<Wrapper<void>> upvote(String suggestionId);
  Future<Wrapper<void>> downvote(String suggestionId);
  Future<Wrapper<void>> addNotifyToUpdateUser(String suggestionId);
  Future<Wrapper<void>> deleteNotifyToUpdateUser(String suggestionId);

  Future<Wrapper<List<Comment>>> getAllComments(String suggestionId);
  Future<Wrapper<Comment>> getCommentById(String commentId);
  Future<Wrapper<Comment>> createComment(CreateCommentModel comment);
  Future<Wrapper<Comment>> updateComment(Comment comment);
  Future<Wrapper<Comment>> deleteCommentById(int commentId);
}
