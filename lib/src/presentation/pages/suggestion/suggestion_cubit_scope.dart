import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/suggestion_cubit.dart';

class SuggestionCubitScope extends StatelessWidget {
  final Widget child;

  const SuggestionCubitScope({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SuggestionCubit(
        i.suggestionRepository,
      ),
      child: child,
    );
  }
}
