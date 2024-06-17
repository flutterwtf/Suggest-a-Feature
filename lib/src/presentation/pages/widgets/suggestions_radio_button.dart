import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';

class SuggestionsRadioButton extends StatelessWidget {
  final bool selected;
  final VoidCallback? onTap;
  const SuggestionsRadioButton({
    required this.selected,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: Dimensions.defaultSize,
        width: Dimensions.defaultSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: context.theme.colorScheme.onSurface,
              width: 0.5,
            ),
            color: selected
                ? context.theme.colorScheme.onSurface
                : context.theme.bottomSheetTheme.backgroundColor ??
                    context.theme.colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: selected
              ? Icon(
                  Icons.check,
                  size: Dimensions.smallSize,
                  color: context.theme.colorScheme.surface,
                )
              : null,
        ),
      ),
    );
  }
}
