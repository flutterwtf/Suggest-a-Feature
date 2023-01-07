import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../suggest_a_feature.dart';
import '../../../utils/assets_strings.dart';
import '../../../utils/context_utils.dart';
import '../../../utils/dimensions.dart';
import '../suggestions_state.dart';

class SuggestionsTabBar extends StatelessWidget {
  final TabController tabController;
  final SuggestionsState state;

  const SuggestionsTabBar({Key? key, required this.tabController, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double tabHeight = 60.0;
    return TabBar(
      indicator: BoxDecoration(
        color: theme.primaryBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.smallCircularRadius)),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      controller: tabController,
      tabs: <Tab>[
        Tab(
          height: tabHeight,
          child: _tabButton(
            status: SuggestionStatus.requests,
            activeImage: AssetStrings.suggestionsRequests,
            inactiveImage: AssetStrings.suggestionsRequestsInactive,
            color: theme.requestsTabColor,
            text: context.localization.requests,
            state: state,
          ),
        ),
        Tab(
          height: tabHeight,
          child: _tabButton(
            status: SuggestionStatus.inProgress,
            activeImage: AssetStrings.suggestionsInProgress,
            inactiveImage: AssetStrings.suggestionsInProgressInactive,
            color: theme.inProgressTabColor,
            text: context.localization.inProgress,
            state: state,
          ),
        ),
        Tab(
          height: tabHeight,
          child: _tabButton(
            status: SuggestionStatus.completed,
            activeImage: AssetStrings.suggestionsCompleted,
            inactiveImage: AssetStrings.suggestionsCompletedInactive,
            color: theme.completedTabColor,
            text: context.localization.completed,
            state: state,
          ),
        ),
      ],
    );
  }

  Widget _tabButton({
    required SuggestionStatus status,
    required String activeImage,
    required String inactiveImage,
    required Color color,
    required String text,
    required SuggestionsState state,
  }) {
    /// We need different heights because of svg files differences (inactive icons have smaller
    /// margins);
    const double activeIconHeight = 38.0;
    const double inactiveIconHeight = 22.0;
    const double textHeight = 1.17;
    final bool isActive = state.activeTab == status;
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: inactiveIconHeight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: isActive ? color.withOpacity(0.3) : theme.secondaryBackgroundColor,
                    blurRadius: 7,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: activeIconHeight,
              child: SvgPicture.asset(
                isActive ? activeImage : inactiveImage,
                package: AssetStrings.packageName,
                color: isActive ? color : theme.secondaryIconColor,
                height: isActive ? activeIconHeight : inactiveIconHeight,
              ),
            ),
          ],
        ),
        FittedBox(
          child: Text(
            text,
            style: isActive
                ? theme.textSmallPlusBold.copyWith(color: color, height: textHeight)
                : theme.textSmallPlusSecondary.copyWith(height: textHeight),
          ),
        ),
      ],
    );
  }
}
