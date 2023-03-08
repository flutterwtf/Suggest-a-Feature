import 'package:suggest_a_feature/src/data/cache_data_source.dart';
import 'package:suggest_a_feature/src/data/interfaces/cache_data_source.dart';
import 'package:suggest_a_feature/src/data/interfaces/suggestions_data_source.dart';
import 'package:suggest_a_feature/src/data/repositories/suggestion_repository.dart';
import 'package:suggest_a_feature/src/domain/data_interfaces/suggestion_repository.dart';
import 'package:suggest_a_feature/src/domain/entities/admin_settings.dart';
import 'package:suggest_a_feature/src/domain/interactors/suggestion_interactor.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/create_edit/create_edit_suggestion_cubit.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/suggestion_cubit.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_cubit.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';

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
    AdminSettings? adminSettings,
    Map<String, String>? imageHeaders,
  }) {
    _theme = theme;
    _imageHeaders = imageHeaders;
    _userId = userId;
    _cacheDataSource = CacheDataSourceImpl();
    _suggestionsDataSource = suggestionsDataSource;
    _suggestionRepository = SuggestionRepositoryImpl(
      _suggestionsDataSource,
      _cacheDataSource,
    );
    _adminSettings = adminSettings;
  }

  AdminSettings? _adminSettings;

  AdminSettings? get adminSettings => _adminSettings;

  late SuggestionsTheme _theme;

  SuggestionsTheme get theme => _theme;

  Map<String, String>? _imageHeaders;

  Map<String, String>? get imageHeaders => _imageHeaders;

  late String _userId;

  String get userId => _userId;

  late SuggestionsDataSource _suggestionsDataSource;

  late CacheDataSource _cacheDataSource;

  SuggestionsDataSource get suggestionsDataSource => _suggestionsDataSource;

  late SuggestionRepository _suggestionRepository;

  SuggestionRepository get suggestionRepository => _suggestionRepository;

  SuggestionInteractor get suggestionInteractor =>
      SuggestionInteractor(suggestionRepository);

  SuggestionsCubit get suggestionsCubit =>
      SuggestionsCubit(suggestionInteractor);

  SuggestionCubit get suggestionCubit => SuggestionCubit(suggestionInteractor);

  CreateEditSuggestionCubit get createEditSuggestionCubit =>
      CreateEditSuggestionCubit(suggestionInteractor);
}
