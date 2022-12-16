import '../../suggest_a_feature.dart';
import 'interfaces/i_cache_data_source.dart';

class CacheDataSource extends ICacheDataSource {
  @override
  final Map<String, SuggestionAuthor> userInfo = <String, SuggestionAuthor>{};
}
