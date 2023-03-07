import 'package:suggest_a_feature/src/data/interfaces/cache_data_source.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

class CacheDataSourceImpl extends CacheDataSource {
  @override
  final Map<String, SuggestionAuthor> userInfo = <String, SuggestionAuthor>{};
}
