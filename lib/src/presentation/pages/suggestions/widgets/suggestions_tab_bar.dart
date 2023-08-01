import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:suggest_a_feature/src/presentation/utils/context_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

class SuggestionsTabBar extends StatelessWidget {
  final TabController tabController;
  final SuggestionStatus activeTab;

  const SuggestionsTabBar({
    required this.tabController,
    required this.activeTab,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      indicatorColor: context.theme.colorScheme.primary,
      tabs: [
        Tab(
          child: _TabButton(
            isActive: activeTab == SuggestionStatus.requests,
            iconPath: AssetStrings.suggestionsRequests,
            text: context.localization.requests,
          ),
        ),
        Tab(
          child: _TabButton(
            isActive: activeTab == SuggestionStatus.inProgress,
            iconPath: AssetStrings.suggestionsInProgress,
            text: context.localization.inProgress,
          ),
        ),
        Tab(
          child: _TabButton(
            isActive: activeTab == SuggestionStatus.completed,
            iconPath: AssetStrings.suggestionsCompleted,
            text: context.localization.completed,
          ),
        ),
        Tab(
          child: _TabButton(
            isActive: activeTab == SuggestionStatus.declined,
            iconPath: AssetStrings.suggestionsDeclined,
            text: context.localization.declined,
          ),
        ),
        Tab(
          child: _TabButton(
            isActive: activeTab == SuggestionStatus.duplicated,
            iconPath: AssetStrings.suggestionsDuplicated,
            text: context.localization.duplicated,
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final bool isActive;
  final String iconPath;
  final String text;

  const _TabButton({
    required this.isActive,
    required this.iconPath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TabIcon(
          iconPath: iconPath,
          isActive: isActive,
        ),
        const SizedBox(width: Dimensions.marginSmall),
        FittedBox(
          child: Text(
            text,
            style: context.theme.textTheme.labelLarge?.copyWith(
              color:
                  isActive ? null : context.theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _TabIcon extends StatelessWidget {
  final bool isActive;
  final String iconPath;

  const _TabIcon({
    required this.iconPath,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SvgPicture.asset(
        iconPath,
        package: AssetStrings.packageName,
        colorFilter: ColorFilter.mode(
          isActive
              ? context.theme.colorScheme.onBackground
              : context.theme.colorScheme.onSurfaceVariant,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
