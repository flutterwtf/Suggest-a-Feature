import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

class SuggestionsRadioButton extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  const SuggestionsRadioButton({
    required this.selected,
    required this.onTap,
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
              color: theme.primaryIconColor,
              width: 0.5,
            ),
            color:
                selected ? theme.primaryIconColor : theme.thirdBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: selected
              ? Icon(
                  Icons.check,
                  size: Dimensions.smallSize,
                  color: theme.primaryBackgroundColor,
                )
              : null,
        ),
      ),
    );
  }
}
