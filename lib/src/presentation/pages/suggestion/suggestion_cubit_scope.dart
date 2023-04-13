import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/suggestion_cubit.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

class SuggestionCubitScope extends StatelessWidget {
  final Widget child;
  final Suggestion suggestion;
  final OnGetUserById onGetUserById;

  const SuggestionCubitScope({
    required this.suggestion,
    required this.onGetUserById,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SuggestionCubit(
        suggestionRepository: i.suggestionRepository,
        suggestion: suggestion,
        onGetUserById: onGetUserById,
      ),
      child: child,
    );
  }
}
