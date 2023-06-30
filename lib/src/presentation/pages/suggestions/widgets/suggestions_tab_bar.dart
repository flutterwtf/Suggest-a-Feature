import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
      indicatorColor: theme.barIndicatorColor,
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
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final bool isActive;
  final String iconPath;
  final String text;

  /// We need different heights because of svg files differences
  /// (inc const double textHeight = 1.17;

  const _TabButton({
    required this.isActive,
    required this.iconPath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _TabIcon(
          activeImagePath: iconPath,
          isActive: isActive,
        ),
        const SizedBox(width: Dimensions.marginSmall),
        FittedBox(
          child: Text(
            text,
            style: isActive
                ? theme.textSmallPlusBold
                : theme.textSmallPlusSecondary,
          ),
        ),
      ],
    );
  }
}

class _TabIcon extends StatelessWidget {
  final bool isActive;
  final String activeImagePath;

  const _TabIcon({
    required this.activeImagePath,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SvgPicture.asset(
        activeImagePath,
        package: AssetStrings.packageName,
        colorFilter: ColorFilter.mode(
          isActive ? theme.activeTabColor : theme.secondaryIconColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
