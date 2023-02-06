import 'package:flutter/material.dart';

import '../../../../domain/entities/suggestion.dart';
import '../../../utils/dimensions.dart';
import '../../theme/suggestions_theme.dart';
import '../../widgets/suggestions_labels.dart';
import '../../widgets/votes_counter.dart';

class SuggestionCard extends StatelessWidget {
  final int index;
  final SuggestionStatus status;
  final Suggestion suggestion;
  final Color color;
  final VoidCallback onClick;
  final VoidCallback voteCallBack;
  final String userId;

  const SuggestionCard({
    Key? key,
    required this.index,
    required this.status,
    required this.suggestion,
    required this.color,
    required this.onClick,
    required this.userId,
    required this.voteCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: IntrinsicHeight(
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                left: Dimensions.marginDefault,
                right: Dimensions.margin3x,
                top: Dimensions.marginBig,
                bottom: Dimensions.marginDefault,
              ),
              decoration: BoxDecoration(
                color: theme.secondaryBackgroundColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(Dimensions.mediumCircularRadius),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _VoteCounter(
                    upvotesCount: suggestion.upvotesCount,
                    isVoted: suggestion.votedUserIds.contains(userId),
                    voteCallBack: voteCallBack,
                  ),
                  const SizedBox(width: Dimensions.marginDefault),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          suggestion.title,
                          style: theme.textSmallPlusBold,
                        ),
                        const SizedBox(height: Dimensions.marginSmall),
                        if (suggestion.description != null)
                          Text(
                            suggestion.description!,
                            style: theme.textSmallPlus,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        const SizedBox(height: Dimensions.marginDefault),
                        SuggestionLabels(labels: suggestion.labels),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _SuggestionIndicator(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoteCounter extends StatelessWidget {
  final bool isVoted;
  final int upvotesCount;
  final VoidCallback voteCallBack;

  const _VoteCounter({
    required this.isVoted,
    required this.upvotesCount,
    required this.voteCallBack,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: voteCallBack,
      child: VotesCounter(
        isVoted: isVoted,
        upvotesCount: upvotesCount,
      ),
    );
  }
}

class _SuggestionIndicator extends StatelessWidget {
  final Color color;

  const _SuggestionIndicator({required this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.margin2x),
      child: Container(
        width: 3,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.verySmallCircularRadius),
            bottomLeft: Radius.circular(Dimensions.verySmallCircularRadius),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withOpacity(0.16),
              spreadRadius: 4,
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }
}
