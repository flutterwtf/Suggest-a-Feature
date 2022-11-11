import '../data_interfaces/i_suggestion_repository.dart';
import '../entities/suggestion.dart';
import '../utils/wrapper.dart';

class CreateEditSuggestionInteractor {
  final ISuggestionRepository _suggestionRepository;

  const CreateEditSuggestionInteractor(this._suggestionRepository);

  Future<Wrapper<Suggestion>> createSuggestion(CreateSuggestionModel suggestion) {
    return _suggestionRepository.createSuggestion(suggestion);
  }

  Future<Wrapper<Suggestion>> updateSuggestion(Suggestion suggestion) {
    return _suggestionRepository.updateSuggestion(suggestion);
  }
}
