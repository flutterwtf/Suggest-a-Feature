import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/src/presentation/utils/label_utils.dart';

class SuggestionLabels extends StatelessWidget {
  final List<SuggestionLabel> labels;

  const SuggestionLabels({
    required this.labels,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Dimensions.marginBig,
      runSpacing: Dimensions.marginMiddle,
      children: labels
          .where((SuggestionLabel label) => label != SuggestionLabel.unknown)
          .map((SuggestionLabel label) => _Label(label: label))
          .toList(),
    );
  }
}

class _Label extends StatelessWidget {
  final SuggestionLabel label;

  const _Label({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: Dimensions.microSize,
          height: Dimensions.microSize,
          decoration: BoxDecoration(
            color: label.labelColor(context),
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: label.labelColor(context).withValues(alpha: 0.16),
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        const SizedBox(width: 11),
        Text(
          label.labelName,
          style: context.theme.textTheme.labelLarge?.copyWith(
            color: label.labelColor(context),
          ),
        ),
      ],
    );
  }
}
