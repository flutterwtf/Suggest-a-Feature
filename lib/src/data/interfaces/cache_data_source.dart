import 'package:suggest_a_feature/src/domain/entities/suggestion_author.dart';

abstract class CacheDataSource {
  abstract final Map<String, SuggestionAuthor> userInfo;
}
