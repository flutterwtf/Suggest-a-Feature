import '../../domain/entities/suggestion_author.dart';

abstract class CacheDataSource {
  abstract final Map<String, SuggestionAuthor> userInfo;
}
