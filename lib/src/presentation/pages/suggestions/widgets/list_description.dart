import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suggest_a_feature/src/presentation/localization/localization_extensions.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
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

  String get statusHeader {
    switch (status) {
      case SuggestionStatus.requests:
        return localization.requestsHeader;
      case SuggestionStatus.inProgress:
        return localization.inProgressHeader;
      case SuggestionStatus.completed:
        return localization.completedHeader;
      case SuggestionStatus.declined:
        return localization.cancelledHeader;
      case SuggestionStatus.duplicated:
        return localization.duplicatedHeader;
      case SuggestionStatus.unknown:
        return '';
    }
  }

  String get statusDescription {
    switch (status) {
      case SuggestionStatus.requests:
        return localization.requestsDescription;
      case SuggestionStatus.inProgress:
        return localization.inProgressDescription;
      case SuggestionStatus.completed:
        return localization.completedDescription;
      case SuggestionStatus.declined:
        return localization.cancelledDescription;
      case SuggestionStatus.duplicated:
        return localization.duplicatedDescription;
      case SuggestionStatus.unknown:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      text: statusHeader,
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
                            localization.sortBy,
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
            statusDescription,
            textAlign: TextAlign.center,
            style: context.theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
