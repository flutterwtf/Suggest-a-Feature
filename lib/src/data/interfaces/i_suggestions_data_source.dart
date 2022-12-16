import '../../domain/entities/comment.dart';
import '../../domain/entities/suggestion.dart';

abstract class SuggestionsDataSource {
  /// The current user id.
  String get userId;

  /// Creates suggestion.
  ///
  /// Uses a [CreateSuggestionModel] type parameter, which does not have an id field.
  /// A [Suggestion] type contains the id generated
  /// by the database.
  Future<Suggestion> createSuggestion(CreateSuggestionModel suggestion);

  Future<Suggestion> getSuggestionById(String suggestionId);

  Future<List<Suggestion>> getAllSuggestions();

  Future<Suggestion> updateSuggestion(Suggestion suggestion);

  Future<void> deleteSuggestionById(String suggestionId);

  /// Creates comment.
  ///
  /// Uses a [CreateCommentModel] type parameter, which does not have an id field.
  /// A [Comment] type contains the id generated
  /// by the database.
  Future<Comment> createComment(CreateCommentModel comment);

  Future<List<Comment>> getAllComments(String suggestionId);

  Future<void> deleteCommentById(String commentId);

  /// Adds a vote to the suggestion, raising its priority.
  ///
  /// In order to add a notification to noSql database, use the [CreateVotedUserRelationModel],
  /// which represents a many-to-many relationship.
  Future<void> upvote(String suggestionId);

  /// Takes away a vote from the suggestion, lowering its priority.
  Future<void> downvote(String suggestionId);

  /// Subscribes the user to change the status of the suggestion.
  ///
  /// In order to add a notification to noSql database, use the [CreateSubscribedUserRelationModel],
  /// which represents a many-to-many relationship.
  Future<void> addNotifyToUpdateUser(String suggestionId);

  /// Unsubscribes the user to change the status of the suggestion.
  Future<void> deleteNotifyToUpdateUser(String suggestionId);
}
