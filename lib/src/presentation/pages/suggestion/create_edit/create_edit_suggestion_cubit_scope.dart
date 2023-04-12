import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/create_edit/create_edit_suggestion_cubit.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

class CreateEditSuggestionCubitScope extends StatelessWidget {
  final Widget child;
  final Suggestion? suggestion;

  const CreateEditSuggestionCubitScope({
    required this.child,
    this.suggestion,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateEditSuggestionCubit(
        suggestionRepository: i.suggestionRepository,
        suggestion: suggestion,
      ),
      child: child,
    );
  }
}
