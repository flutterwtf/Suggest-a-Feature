import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';

class VotesCounter extends StatelessWidget {
  final bool isVoted;
  final int upvotesCount;

  const VotesCounter({
    required this.isVoted,
    required this.upvotesCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: Dimensions.bigSize,
            width: Dimensions.bigSize,
            child: SvgPicture.asset(
              AssetStrings.suggestionsUpvoteArrow,
              package: AssetStrings.packageName,
              colorFilter: ColorFilter.mode(
                isVoted
                    ? context.theme.colorScheme.primary
                    : context.theme.colorScheme.outline,
                BlendMode.srcIn,
              ),
              fit: BoxFit.none,
            ),
          ),
          Text(
            '$upvotesCount',
            style: context.theme.textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
