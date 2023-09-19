import 'package:suggest_a_feature/src/data/interfaces/cache_data_source.dart';
import 'package:suggest_a_feature/src/data/interfaces/suggestions_data_source.dart';
import 'package:suggest_a_feature/src/domain/data_interfaces/suggestion_repository.dart';
import 'package:suggest_a_feature/src/domain/entities/comment.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion_author.dart';
import 'package:suggest_a_feature/src/domain/utils/simple_behavior_subject.dart';

class SuggestionRepositoryImpl implements SuggestionRepository {
  final SuggestionsDataSource _suggestionsDataSource;
  final CacheDataSource _cacheDataSource;

  SuggestionRepositoryImpl(
    this._suggestionsDataSource,
    this._cacheDataSource,
  );

  final SimpleBehaviorSubject<List<Suggestion>> _suggestionsSubject =
      SimpleBehaviorSubject<List<Suggestion>>([]);

  @override
  Stream<List<Suggestion>> get suggestionsStream =>
      _suggestionsSubject.stream();

  @override
  List<Suggestion> get suggestions => _suggestionsSubject.value;

  @override
  Map<String, SuggestionAuthor?> get userInfo => _cacheDataSource.userInfo;

  @override
  void refreshSuggestions(Suggestion suggestion, {bool saveComments = true}) {
    final suggestions = [...this.suggestions];
    final indexForUpdate = suggestions.indexWhere((e) => e.id == suggestion.id);
    final oldSuggestion = suggestions[indexForUpdate];

    suggestions[indexForUpdate] = suggestion.copyWith(
      comments: saveComments ? oldSuggestion.comments : null,
    );

    _suggestionsSubject.value = suggestions;
  }

  @override
  Future<void> initSuggestions() async {
    final suggestions = await _suggestionsDataSource.getAllSuggestions();
    _suggestionsSubject.value = suggestions;
  }

  @override
  Future<Suggestion> getSuggestionById(String suggestionId) =>
      _suggestionsDataSource.getSuggestionById(suggestionId);

  @override
  Future<Suggestion> createSuggestion(CreateSuggestionModel suggestion) async {
    final createdSuggestion =
        await _suggestionsDataSource.createSuggestion(suggestion);

    final suggestions = List<Suggestion>.from(this.suggestions)
      ..add(createdSuggestion);
    _suggestionsSubject.value = suggestions;

    return createdSuggestion;
  }

  @override
  Future<Suggestion> updateSuggestion(Suggestion suggestion) async {
    final result = await _suggestionsDataSource.updateSuggestion(suggestion);
    final updatedSuggestion = await getSuggestionById(suggestion.id);
    refreshSuggestions(updatedSuggestion);
    return result;
  }

  @override
  Future<void> deleteSuggestion(String suggestionId) async {
    await _suggestionsDataSource.deleteSuggestionById(suggestionId);
    final suggestions = List<Suggestion>.from(this.suggestions)
      ..removeWhere((Suggestion e) => e.id == suggestionId);
    _suggestionsSubject.value = suggestions;
  }

  @override
  Future<void> addNotifyToUpdateUser(String suggestionId) async {
    await _suggestionsDataSource.addNotifyToUpdateUser(suggestionId);
    final suggestion = await getSuggestionById(suggestionId);
    refreshSuggestions(suggestion);
  }

  @override
  Future<void> deleteNotifyToUpdateUser(String suggestionId) async {
    await _suggestionsDataSource.deleteNotifyToUpdateUser(suggestionId);
    final suggestion = await getSuggestionById(suggestionId);
    refreshSuggestions(suggestion);
  }

  @override
  Future<void> downvote(String suggestionId) async {
    await _suggestionsDataSource.downvote(suggestionId);
    final suggestion = await getSuggestionById(suggestionId);
    refreshSuggestions(suggestion);
  }

  @override
  Future<void> upvote(String suggestionId) async {
    await _suggestionsDataSource.upvote(suggestionId);
    final suggestion = await getSuggestionById(suggestionId);
    refreshSuggestions(suggestion);
  }

  @override
  Future<List<Comment>> getAllComments(String suggestionId) =>
      _suggestionsDataSource.getAllComments(suggestionId);

  @override
  Future<Comment> createComment(CreateCommentModel comment) =>
      _suggestionsDataSource.createComment(comment);

  @override
  Future<void> deleteCommentById(String commentId) =>
      _suggestionsDataSource.deleteCommentById(commentId);
}
