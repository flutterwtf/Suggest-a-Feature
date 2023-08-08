import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_cubit.dart';
import 'package:suggest_a_feature/src/presentation/utils/typedefs.dart';

class SuggestionsCubitScope extends StatelessWidget {
  final Widget child;
  final SortType sortType;

  const SuggestionsCubitScope({
    required this.child,
    required this.sortType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SuggestionsCubit(
        i.suggestionRepository,
        sortType,
      ),
      child: child,
    );
  }
}
