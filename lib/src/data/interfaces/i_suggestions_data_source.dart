import '../../domain/entities/comment.dart';
import '../../domain/entities/suggestion.dart';
import '../../domain/utils/wrapper.dart';

abstract class SuggestionsDataSource {
  String get userId;
  Future<Wrapper<List<Suggestion>>> getAllSuggestions();
  Future<Wrapper<Suggestion>> createSuggestion(CreateSuggestionModel suggestion);
  Future<Wrapper<Suggestion>> getSuggestionById(int suggestionId);
  Future<Wrapper<Suggestion>> updateSuggestion(Suggestion suggestion);
  Future<Wrapper<Suggestion>> deleteSuggestionById(int suggestionId);

  Future<Wrapper<void>> upvote(int suggestionId);
  Future<Wrapper<void>> downvote(int suggestionId);
  Future<Wrapper<void>> addNotifyToUpdateUser(int suggestionId);
  Future<Wrapper<void>> deleteNotifyToUpdateUser(int suggestionId);

  Future<Wrapper<List<Comment>>> getAllComments(int suggestionId);
  Future<Wrapper<Comment>> getCommentById(int commentId);
  Future<Wrapper<Comment>> createComment(CreateCommentModel comment);
  Future<Wrapper<Comment>> updateComment(Comment comment);
  Future<Wrapper<Comment>> deleteCommentById(int commentId);
}
