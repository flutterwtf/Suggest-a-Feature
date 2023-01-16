import 'package:rxdart/rxdart.dart';

import '../../domain/data_interfaces/i_suggestion_repository.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/suggestion.dart';
import '../../domain/entities/suggestion_author.dart';
import '../interfaces/i_cache_data_source.dart';
import '../interfaces/i_suggestions_data_source.dart';

class SuggestionRepository implements ISuggestionRepository {
  final SuggestionsDataSource _suggestionsDataSource;
  final ICacheDataSource _cacheDataSource;

  SuggestionRepository(this._suggestionsDataSource, this._cacheDataSource);

  final BehaviorSubject<List<Suggestion>> _suggestionsSubject = BehaviorSubject<List<Suggestion>>();

  @override
  Stream<List<Suggestion>> get suggestionsStream => _suggestionsSubject;

  @override
  List<Suggestion> get suggestions => _suggestionsSubject.value;

  @override
  Map<String, SuggestionAuthor?> get userInfo => _cacheDataSource.userInfo;

  @override
  void refreshSuggestions(Suggestion suggestion, {bool saveComments = true}) {
    final List<Suggestion> suggestions = List<Suggestion>.from(this.suggestions);
    final Suggestion removedSuggestion =
        suggestions.firstWhere((Suggestion e) => e.id == suggestion.id);
    suggestions.remove(removedSuggestion);
    _suggestionsSubject.add(
      suggestions
        ..add(
          suggestion.copyWith(comments: saveComments ? removedSuggestion.comments : null),
        ),
    );
  }

  @override
  Future<void> initSuggestions() async {
    final List<Suggestion> suggestions = await _suggestionsDataSource.getAllSuggestions();
    _suggestionsSubject.add(suggestions);
  }

  @override
  Future<Suggestion> getSuggestionById(String suggestionId) {
    return _suggestionsDataSource.getSuggestionById(suggestionId);
  }

  @override
  Future<Suggestion> createSuggestion(CreateSuggestionModel suggestion) async {
    final Suggestion createdSuggestion = await _suggestionsDataSource.createSuggestion(suggestion);

    final List<Suggestion> suggestions = List<Suggestion>.from(this.suggestions)
      ..add(createdSuggestion);
    _suggestionsSubject.add(suggestions);

    return createdSuggestion;
  }

  @override
  Future<Suggestion> updateSuggestion(Suggestion suggestion) async {
    final Suggestion result = await _suggestionsDataSource.updateSuggestion(suggestion);
    final Suggestion updatedSuggestion = await getSuggestionById(suggestion.id);
    refreshSuggestions(updatedSuggestion);
    return result;
  }

  @override
  Future<void> deleteSuggestion(String suggestionId) async {
    await _suggestionsDataSource.deleteSuggestionById(suggestionId);
    final List<Suggestion> suggestions = List<Suggestion>.from(this.suggestions)
      ..removeWhere((Suggestion e) => e.id == suggestionId);
    _suggestionsSubject.add(suggestions);
  }

  @override
  Future<void> addNotifyToUpdateUser(String suggestionId) async {
    await _suggestionsDataSource.addNotifyToUpdateUser(suggestionId);
    final Suggestion suggestion = await getSuggestionById(suggestionId);
    refreshSuggestions(suggestion);
  }

  @override
  Future<void> deleteNotifyToUpdateUser(String suggestionId) async {
    await _suggestionsDataSource.deleteNotifyToUpdateUser(suggestionId);
    final Suggestion suggestion = await getSuggestionById(suggestionId);
    refreshSuggestions(suggestion);
  }

  @override
  Future<void> downvote(String suggestionId) async {
    await _suggestionsDataSource.downvote(suggestionId);
    final Suggestion suggestion = await getSuggestionById(suggestionId);
    refreshSuggestions(suggestion);
  }

  @override
  Future<void> upvote(String suggestionId) async {
    await _suggestionsDataSource.upvote(suggestionId);
    final Suggestion suggestion = await getSuggestionById(suggestionId);
    refreshSuggestions(suggestion);
  }

  @override
  Future<List<Comment>> getAllComments(String suggestionId) {
    return _suggestionsDataSource.getAllComments(suggestionId);
  }

  @override
  Future<Comment> createComment(CreateCommentModel comment) async {
    final Comment result = await _suggestionsDataSource.createComment(comment);
    return result;
  }
}
