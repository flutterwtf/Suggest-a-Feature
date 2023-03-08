import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/utils/context_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

class ListDescription extends StatelessWidget {
  final SuggestionStatus status;
  final int length;

  const ListDescription({
    required this.status,
    required this.length,
    super.key,
  });

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
      case SuggestionStatus.cancelled:
        header = context.localization.cancelledHeader;
        description = context.localization.cancelledDescription;
        break;
      case SuggestionStatus.duplicate:
        header = context.localization.duplicatedHeader;
        description = context.localization.duplicatedDescription;
        break;
      case SuggestionStatus.unknown:
        return const SizedBox.shrink();
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
