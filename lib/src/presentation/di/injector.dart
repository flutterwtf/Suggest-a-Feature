import '../../data/cache_data_source.dart';
import '../../data/interfaces/i_cache_data_source.dart';
import '../../data/interfaces/i_suggestions_data_source.dart';
import '../../data/repositories/suggestion_repository.dart';
import '../../domain/data_interfaces/i_suggestion_repository.dart';
import '../../domain/interactors/suggestion_interactor.dart';
import '../pages/suggestion/create_edit/create_edit_suggestion_cubit.dart';
import '../pages/suggestion/suggestion_cubit.dart';
import '../pages/suggestions/suggestions_cubit.dart';
import '../pages/theme/suggestions_theme.dart';

// ignore: library_private_types_in_public_api
_Injector get i => _Injector();

class _Injector {
  static final _Injector _singleton = _Injector._internal();

  factory _Injector() {
    return _singleton;
  }

  _Injector._internal();

  void init({
    required SuggestionsTheme theme,
    required String userId,
    required SuggestionsDataSource suggestionsDataSource,
    Map<String, String>? imageHeaders,
  }) {
    _theme = theme;
    _imageHeaders = imageHeaders;
    _userId = userId;
    _cacheDataSource = CacheDataSource();
    _suggestionsDataSource = suggestionsDataSource;
    _suggestionRepository = SuggestionRepository(_suggestionsDataSource, _cacheDataSource);
  }

  late SuggestionsTheme _theme;

  SuggestionsTheme get theme => _theme;

  Map<String, String>? _imageHeaders;

  Map<String, String>? get imageHeaders => _imageHeaders;

  late String _userId;

  String get userId => _userId;

  late SuggestionsDataSource _suggestionsDataSource;

  late ICacheDataSource _cacheDataSource;

  SuggestionsDataSource get suggestionsDataSource => _suggestionsDataSource;

  late ISuggestionRepository _suggestionRepository;

  ISuggestionRepository get suggestionRepository => _suggestionRepository;

  SuggestionInteractor get suggestionInteractor => SuggestionInteractor(suggestionRepository);

  SuggestionsCubit get suggestionsCubit => SuggestionsCubit(suggestionInteractor);

  SuggestionCubit get suggestionCubit => SuggestionCubit(suggestionInteractor);

  CreateEditSuggestionCubit get createEditSuggestionCubit =>
      CreateEditSuggestionCubit(suggestionInteractor);
}
