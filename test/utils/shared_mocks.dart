import 'package:mockito/annotations.dart';
import 'package:suggest_a_feature/src/data/interfaces/i_suggestions_data_source.dart';
import 'package:suggest_a_feature/src/data/repositories/suggestion_repository.dart';
import 'package:suggest_a_feature/src/domain/interactors/suggestion_interactor.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/suggestion_cubit.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_cubit.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';

@GenerateMocks(<Type>[
  SuggestionRepository,
  SuggestionInteractor,
  SuggestionCubit,
  SuggestionsCubit,
  SuggestionsDataSource,
  SuggestionsTheme,
])
class SharedMocks {}
