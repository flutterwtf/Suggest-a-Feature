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

  String statusHeader(BuildContext context) {
    switch (status) {
      case SuggestionStatus.requests:
        return context.localization.requestsHeader;
      case SuggestionStatus.inProgress:
        return context.localization.inProgressHeader;
      case SuggestionStatus.completed:
        return context.localization.completedHeader;
      case SuggestionStatus.cancelled:
        return context.localization.cancelledHeader;
      case SuggestionStatus.duplicate:
        return context.localization.duplicatedHeader;
      case SuggestionStatus.unknown:
        return '';
    }
  }

  String statusDescription(BuildContext context) {
    switch (status) {
      case SuggestionStatus.requests:
        return context.localization.requestsDescription;
      case SuggestionStatus.inProgress:
        return context.localization.inProgressDescription;
      case SuggestionStatus.completed:
        return context.localization.completedDescription;
      case SuggestionStatus.cancelled:
        return context.localization.cancelledDescription;
      case SuggestionStatus.duplicate:
        return context.localization.duplicatedDescription;
      case SuggestionStatus.unknown:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final header = statusHeader(context);
    final description = statusDescription(context);
    if (status == SuggestionStatus.unknown) {
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
