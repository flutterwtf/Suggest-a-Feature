import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:suggest_a_feature/src/presentation/utils/context_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

class ListDescription extends StatelessWidget {
  final SuggestionStatus status;
  final int length;
  final VoidCallback openSortingBottomSheet;

  const ListDescription({
    required this.status,
    required this.length,
    required this.openSortingBottomSheet,
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
      case SuggestionStatus.declined:
        return context.localization.cancelledHeader;
      case SuggestionStatus.duplicated:
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
      case SuggestionStatus.declined:
        return context.localization.cancelledDescription;
      case SuggestionStatus.duplicated:
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: header,
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        color: context.theme.colorScheme.onBackground,
                      ),
                    ),
                    TextSpan(
                      text: ' ($length)',
                      style: context.theme.textTheme.labelLarge?.copyWith(
                        color: context.theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Dimensions.marginSmall),
              Flexible(
                child: GestureDetector(
                  onTap: openSortingBottomSheet,
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: Dimensions.marginSmall,
                    ),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.surfaceVariant,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(Dimensions.verySmallCircularRadius),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            context.localization.sortBy,
                            style: context.theme.textTheme.bodyMedium?.copyWith(
                              color: context.theme.colorScheme.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SvgPicture.asset(
                          AssetStrings.arrowDownIcon,
                          package: AssetStrings.packageName,
                          colorFilter: ColorFilter.mode(
                            context.theme.colorScheme.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.marginSmall),
          Text(
            description,
            textAlign: TextAlign.center,
            style: context.theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
