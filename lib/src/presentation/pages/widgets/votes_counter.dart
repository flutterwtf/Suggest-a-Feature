import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/assets_strings.dart';
import '../../utils/dimensions.dart';
import '../theme/suggestions_theme.dart';

class VotesCounter extends StatelessWidget {
  final bool isVoted;
  final int upvotesCount;

  const VotesCounter({
    required this.isVoted,
    required this.upvotesCount,
    Key? key,
  }) : super(key: key);

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
              color: isVoted ? theme.activatedUpvoteArrowColor : theme.upvoteArrowColor,
              fit: BoxFit.none,
            ),
          ),
          Text('$upvotesCount', style: theme.textSmallPlusBold),
        ],
      ),
    );
  }
}
