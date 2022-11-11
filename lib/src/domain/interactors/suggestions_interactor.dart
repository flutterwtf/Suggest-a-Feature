import '../data_interfaces/i_suggestion_repository.dart';
import '../entities/suggestion.dart';

class SuggestionsInteractor {
  final ISuggestionRepository _suggestionRepository;

  const SuggestionsInteractor(this._suggestionRepository);

  Stream<List<Suggestion>> get suggestionsStream => _suggestionRepository.suggestionsStream;

  void initSuggestions() => _suggestionRepository.initSuggestions();

  void upvote(int suggestionId) => _suggestionRepository.upvote(suggestionId);

  void downvote(int suggestionId) => _suggestionRepository.downvote(suggestionId);
}
