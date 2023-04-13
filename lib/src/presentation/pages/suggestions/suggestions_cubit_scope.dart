import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_cubit.dart';

class SuggestionsCubitScope extends StatelessWidget {
  final Widget child;

  const SuggestionsCubitScope({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SuggestionsCubit(
        i.suggestionRepository,
      ),
      child: child,
    );
  }
}
