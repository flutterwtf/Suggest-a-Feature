import '../data_interfaces/i_suggestion_repository.dart';
import '../entities/comment.dart';
import '../entities/suggestion.dart';
import '../entities/suggestion_author.dart';

class SuggestionInteractor {
  final ISuggestionRepository _suggestionRepository;

  const SuggestionInteractor(this._suggestionRepository);

  Stream<List<Suggestion>> get suggestionsStream => _suggestionRepository.suggestionsStream;

  Map<String, SuggestionAuthor?> get userInfo => _suggestionRepository.userInfo;

  void initSuggestions() => _suggestionRepository.initSuggestions();

  Future<Suggestion> createSuggestion(CreateSuggestionModel suggestion) {
    return _suggestionRepository.createSuggestion(suggestion);
  }

  Future<Suggestion> updateSuggestion(Suggestion suggestion) {
    return _suggestionRepository.updateSuggestion(suggestion);
  }

  Future<void> deleteSuggestion(String suggestionId) {
    return _suggestionRepository.deleteSuggestion(suggestionId);
  }

  void upvote(String suggestionId) => _suggestionRepository.upvote(suggestionId);

  void downvote(String suggestionId) => _suggestionRepository.downvote(suggestionId);

  Future<void> addNotifyToUpdateUser(String suggestionId) async {
    await _suggestionRepository.addNotifyToUpdateUser(suggestionId);
  }

  Future<void> deleteNotifyToUpdateUser(String suggestionId) async {
    await _suggestionRepository.deleteNotifyToUpdateUser(suggestionId);
  }

  void refreshSuggestions(Suggestion suggestion, {bool saveComments = false}) {
    _suggestionRepository.refreshSuggestions(suggestion, saveComments: saveComments);
  }

  Future<List<Comment>> getAllComments(String suggestionId) {
    return _suggestionRepository.getAllComments(suggestionId);
  }

  Future<Comment> createComment(CreateCommentModel comment) {
    return _suggestionRepository.createComment(comment);
  }
}
