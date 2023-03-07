import '../../suggest_a_feature.dart';
import 'interfaces/cache_data_source.dart';

class CacheDataSourceImpl extends CacheDataSource {
  @override
  final Map<String, SuggestionAuthor> userInfo = <String, SuggestionAuthor>{};
}
