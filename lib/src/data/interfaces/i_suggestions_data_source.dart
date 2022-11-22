import '../../../suggest_a_feature.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/suggestion.dart';
import '../../domain/utils/wrapper.dart';

abstract class SuggestionsDataSource {
  /// The current user id.
  String get userId;

  Future<Wrapper<List<Suggestion>>> getAllSuggestions();

  /// Creates suggestion.
  ///
  /// Uses a [CreateSuggestionModel] type parameter, which does not have an id field.
  /// The [Wrapper.data] field type is [Suggestion], which contains the id generated
  /// by the database.
  Future<Wrapper<Suggestion>> createSuggestion(CreateSuggestionModel suggestion);

  Future<Wrapper<Suggestion>> getSuggestionById(String suggestionId);

  Future<Wrapper<Suggestion>> updateSuggestion(Suggestion suggestion);

  Future<Wrapper<Suggestion>> deleteSuggestionById(String suggestionId);

  /// Adds a vote to the suggestion, raising its priority.
  ///
  /// In order to add a notification to noSql database, use the [CreateVotedUserRelationModel],
  /// which represents a many-to-many relationship.
  Future<Wrapper<void>> upvote(String suggestionId);

  /// Takes away a vote from the suggestion, lowering its priority.
  Future<Wrapper<void>> downvote(String suggestionId);

  /// Subscribes the user to change the status of the suggestion.
  ///
  /// In order to add a notification to noSql database, use the [CreateSubscribedUserRelationModel],
  /// which represents a many-to-many relationship.
  Future<Wrapper<void>> addNotifyToUpdateUser(String suggestionId);

  /// Unsubscribes the user to change the status of the suggestion.
  Future<Wrapper<void>> deleteNotifyToUpdateUser(String suggestionId);

  Future<Wrapper<List<Comment>>> getAllComments(String suggestionId);

  Future<Wrapper<Comment>> getCommentById(String commentId);

  /// Creates comment.
  ///
  /// Uses a [CreateCommentModel] type parameter, which does not have an id field.
  /// The [Wrapper.data] field type is [Comment], which contains the id generated
  /// by the database.
  Future<Wrapper<Comment>> createComment(CreateCommentModel comment);

  Future<Wrapper<Comment>> updateComment(Comment comment);

  Future<Wrapper<Comment>> deleteCommentById(String commentId);

  Future<List<String>?> uploadMultiplePhotos({required int availableNumOfPhotos});

  Future<bool?> saveToGallery(String url);

  Future<SuggestionAuthor?> getUserById(String id);
}
