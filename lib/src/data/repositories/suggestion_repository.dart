import 'package:rxdart/rxdart.dart';

import '../../domain/data_interfaces/i_suggestion_repository.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/suggestion.dart';
import '../../domain/entities/suggestion_author.dart';
import '../../domain/utils/wrapper.dart';
import '../interfaces/i_cache_data_source.dart';
import '../interfaces/i_suggestions_data_source.dart';

class SuggestionRepository implements ISuggestionRepository {
  final SuggestionsDataSource _suggestionsDataSource;
  final ICacheDataSource _cacheDataSource;

  SuggestionRepository(this._suggestionsDataSource, this._cacheDataSource);

  final BehaviorSubject<List<Suggestion>> _suggestionsSubject = BehaviorSubject();

  @override
  Stream<List<Suggestion>> get suggestionsStream => _suggestionsSubject;

  @override
  List<Suggestion> get suggestions => _suggestionsSubject.value;

  @override
  Map<String, SuggestionAuthor?> get userInfo => _cacheDataSource.userInfo;

  @override
  void refreshSuggestions(Suggestion suggestion, {bool saveComments = true}) {
    final suggestions = List<Suggestion>.from(this.suggestions);
    final removedSuggestion = suggestions.firstWhere((e) => e.id == suggestion.id);
    suggestions.remove(removedSuggestion);
    _suggestionsSubject.add(
      suggestions
        ..add(
          suggestion.copyWith(comments: saveComments ? removedSuggestion.comments : null),
        ),
    );
  }

  @override
  void initSuggestions() async {
    final suggestions = (await _suggestionsDataSource.getAllSuggestions()).data;
    _suggestionsSubject.add(suggestions ?? []);
  }

  @override
  Future<Wrapper<Suggestion>> getSuggestionById(String suggestionId) {
    return _suggestionsDataSource.getSuggestionById(suggestionId);
  }

  @override
  Future<Wrapper<Suggestion>> createSuggestion(CreateSuggestionModel suggestion) async {
    final result = await _suggestionsDataSource.createSuggestion(suggestion);
    if (result.data != null) {
      final suggestions = List<Suggestion>.from(this.suggestions)..add(result.data!);
      _suggestionsSubject.add(suggestions);
    }
    return result;
  }

  @override
  Future<Wrapper<Suggestion>> updateSuggestion(Suggestion suggestion) async {
    final result = await _suggestionsDataSource.updateSuggestion(suggestion);
    final updatedSuggestion = (await getSuggestionById(suggestion.id)).data;
    if (result.success() && updatedSuggestion != null) {
      refreshSuggestions(updatedSuggestion);
    }
    return result;
  }

  @override
  Future<void> deleteSuggestion(String suggestionId) async {
    final result = await _suggestionsDataSource.deleteSuggestionById(suggestionId);
    if (result.success()) {
      final suggestions = List<Suggestion>.from(this.suggestions)
        ..removeWhere((e) => e.id == suggestionId);
      _suggestionsSubject.add(suggestions);
    }
  }

  @override
  void addNotifyToUpdateUser(String suggestionId) async {
    final result = await _suggestionsDataSource.addNotifyToUpdateUser(suggestionId);
    final suggestion = (await getSuggestionById(suggestionId)).data;
    if (result.success() && suggestion != null) {
      refreshSuggestions(suggestion);
    }
  }

  @override
  void deleteNotifyToUpdateUser(String suggestionId) async {
    final result = await _suggestionsDataSource.deleteNotifyToUpdateUser(suggestionId);
    final suggestion = (await getSuggestionById(suggestionId)).data;
    if (result.success() && suggestion != null) {
      refreshSuggestions(suggestion);
    }
  }

  @override
  void downvote(String suggestionId) async {
    final result = await _suggestionsDataSource.downvote(suggestionId);
    final suggestion = (await getSuggestionById(suggestionId)).data;
    if (result.success() && suggestion != null) {
      refreshSuggestions(suggestion);
    }
  }

  @override
  void upvote(String suggestionId) async {
    final result = await _suggestionsDataSource.upvote(suggestionId);
    final suggestion = (await getSuggestionById(suggestionId)).data;
    if (result.success() && suggestion != null) {
      refreshSuggestions(suggestion);
    }
  }

  @override
  Future<Wrapper<List<Comment>>> getAllComments(String suggestionId) {
    return _suggestionsDataSource.getAllComments(suggestionId);
  }

  @override
  Future<Wrapper<Comment>> createComment(CreateCommentModel comment) async {
    final result = await _suggestionsDataSource.createComment(comment);
    return result;
  }
}
