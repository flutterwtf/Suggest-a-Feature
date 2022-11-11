import '../../domain/entities/suggestion_author.dart';

abstract class ICacheDataSource {
  abstract final Map<String, SuggestionAuthor> userInfo;
}
