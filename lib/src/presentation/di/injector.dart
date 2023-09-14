import 'package:flutter/widgets.dart';
import 'package:suggest_a_feature/src/data/cache_data_source.dart';
import 'package:suggest_a_feature/src/data/interfaces/cache_data_source.dart';
import 'package:suggest_a_feature/src/data/interfaces/suggestions_data_source.dart';
import 'package:suggest_a_feature/src/data/repositories/suggestion_repository.dart';
import 'package:suggest_a_feature/src/domain/data_interfaces/suggestion_repository.dart';
import 'package:suggest_a_feature/src/domain/entities/admin_settings.dart';
import 'package:suggest_a_feature/src/presentation/localization/localization_extensions.dart';
import 'package:suggest_a_feature/src/presentation/localization/localization_options.dart';
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
    required String locale,
    GlobalKey<NavigatorState>? navigatorKey,
    AdminSettings? adminSettings,
    bool isAdmin = false,
    Map<String, String>? imageHeaders,
  }) {
    assert(
      (isAdmin && adminSettings != null) || !isAdmin,
      'if isAdmin == true, then adminSettings cannot be null',
    );
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
    _isAdmin = isAdmin;
    _localization = locale.localizationOptions;
    _navigatorKey = navigatorKey;
  }

  AdminSettings? _adminSettings;

  AdminSettings? get adminSettings => _adminSettings;

  late bool _isAdmin;

  bool get isAdmin => _isAdmin;

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

  late LocalizationOptions _localization;

  LocalizationOptions get localizations => _localization;

  late GlobalKey<NavigatorState>? _navigatorKey;

  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
}
