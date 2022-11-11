import '../data_interfaces/i_suggestion_repository.dart';
import '../entities/comment.dart';
import '../entities/suggestion.dart';
import '../entities/suggestion_author.dart';
import '../utils/wrapper.dart';

class SuggestionInteractor {
  final ISuggestionRepository _suggestionRepository;

  const SuggestionInteractor(this._suggestionRepository);

  Stream<List<Suggestion>> get suggestionsStream => _suggestionRepository.suggestionsStream;

  Map<String, SuggestionAuthor?> get userInfo => _suggestionRepository.userInfo;

  Future<void> deleteSuggestion(int suggestionId) {
    return _suggestionRepository.deleteSuggestion(suggestionId);
  }

  void upvote(int suggestionId) {
    _suggestionRepository.upvote(suggestionId);
  }

  void downvote(int suggestionId) {
    _suggestionRepository.downvote(suggestionId);
  }

  void addNotifyToUpdateUser(int suggestionId) {
    _suggestionRepository.addNotifyToUpdateUser(suggestionId);
  }

  void deleteNotifyToUpdateUser(int suggestionId) {
    _suggestionRepository.deleteNotifyToUpdateUser(suggestionId);
  }

  void refreshSuggestions(Suggestion suggestion, {bool saveComments = false}) {
    _suggestionRepository.refreshSuggestions(suggestion, saveComments: saveComments);
  }

  Future<Wrapper<List<Comment>>> getAllComments(int suggestionId) {
    return _suggestionRepository.getAllComments(suggestionId);
  }

  Future<Wrapper<Comment>> createComment(CreateCommentModel comment) {
    return _suggestionRepository.createComment(comment);
  }
}
