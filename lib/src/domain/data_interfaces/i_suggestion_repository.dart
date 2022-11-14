import '../entities/comment.dart';
import '../entities/suggestion.dart';
import '../entities/suggestion_author.dart';
import '../utils/wrapper.dart';

abstract class ISuggestionRepository {
  Stream<List<Suggestion>> get suggestionsStream;
  List<Suggestion> get suggestions;
  Map<String, SuggestionAuthor?> get userInfo;

  void initSuggestions();
  Future<Wrapper<Suggestion>> getSuggestionById(String suggestionId);
  Future<Wrapper<Suggestion>> createSuggestion(CreateSuggestionModel suggestion);
  Future<Wrapper<Suggestion>> updateSuggestion(Suggestion suggestion);
  Future<void> deleteSuggestion(String suggestionId);

  void upvote(String suggestionId);
  void downvote(String suggestionId);
  void addNotifyToUpdateUser(String suggestionId);
  void deleteNotifyToUpdateUser(String suggestionId);

  void refreshSuggestions(Suggestion suggestion, {bool saveComments});

  Future<Wrapper<List<Comment>>> getAllComments(String suggestionId);
  Future<Wrapper<Comment>> createComment(CreateCommentModel comment);
}
