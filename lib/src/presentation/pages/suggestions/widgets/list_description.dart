import 'package:flutter/material.dart';

import '../../../../../suggest_a_feature.dart';
import '../../../utils/context_utils.dart';
import '../../../utils/dimensions.dart';

class ListDescription extends StatelessWidget {
  final SuggestionStatus status;
  final int length;
  const ListDescription({Key? key, required this.status, required this.length}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String header;
    final String description;
    switch (status) {
      case SuggestionStatus.requests:
        header = context.localization.requestsHeader;
        description = context.localization.requestsDescription;
        break;
      case SuggestionStatus.inProgress:
        header = context.localization.inProgressHeader;
        description = context.localization.inProgressDescription;
        break;
      case SuggestionStatus.completed:
        header = context.localization.completedHeader;
        description = context.localization.completedDescription;
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.margin2x),
      child: Column(
        children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(text: header, style: theme.textMediumBold),
                TextSpan(text: ' ($length)', style: theme.textSmallPlus),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.marginSmall),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textSmallPlus,
          ),
        ],
      ),
    );
  }
}
