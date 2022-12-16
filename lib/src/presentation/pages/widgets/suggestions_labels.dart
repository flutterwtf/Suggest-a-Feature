import 'package:flutter/material.dart';

import '../../../domain/entities/suggestion.dart';
import '../../utils/dimensions.dart';
import '../../utils/label_utils.dart';
import '../theme/suggestions_theme.dart';

class SuggestionLabels extends StatelessWidget {
  final List<SuggestionLabel> labels;

  const SuggestionLabels({Key? key, required this.labels}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Dimensions.marginBig,
      runSpacing: Dimensions.marginMiddle,
      children: labels.map((SuggestionLabel label) => _label(label, context)).toList(),
    );
  }

  Widget _label(SuggestionLabel label, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: Dimensions.microSize,
          height: Dimensions.microSize,
          decoration: BoxDecoration(
            color: label.labelColor(),
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: label.labelColor().withOpacity(0.16),
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        const SizedBox(width: 11),
        Text(
          label.labelName(context),
          style: theme.textSmallPlusBold.copyWith(
            color: label.labelColor(),
          ),
        ),
      ],
    );
  }
}
