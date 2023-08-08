import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/localization/localization_extensions.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';

class BottomSheetOptionBar extends StatelessWidget {
  final String title;
  final VoidCallback onCancel;
  final VoidCallback onDone;

  const BottomSheetOptionBar({
    required this.title,
    required this.onCancel,
    required this.onDone,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: onCancel,
            child: Text(localization.cancel),
          ),
        ),
        Text(title, style: context.theme.textTheme.titleMedium),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onDone,
            child: Text(localization.done),
          ),
        ),
      ],
    );
  }
}
