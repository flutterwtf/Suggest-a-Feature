import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/suggestions_labels.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/votes_counter.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';

class SuggestionCard extends StatefulWidget {
  final int index;
  final SuggestionStatus status;
  final Suggestion suggestion;
  final Color color;
  final VoidCallback onClick;
  final VoidCallback voteCallBack;
  final String userId;

  const SuggestionCard({
    required this.index,
    required this.status,
    required this.suggestion,
    required this.color,
    required this.onClick,
    required this.userId,
    required this.voteCallBack,
    super.key,
  });

  @override
  State<SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<SuggestionCard> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              bottom: Dimensions.marginDefault,
            ),
            child: Material(
              color: theme.secondaryBackgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(Dimensions.mediumCircularRadius),
              ),
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(Dimensions.mediumCircularRadius),
                ),
                onTap: widget.onClick,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: Dimensions.marginDefault,
                    right: Dimensions.margin3x,
                    top: Dimensions.marginBig,
                    bottom: Dimensions.marginDefault,
                  ),
                  child: _CardContent(
                    suggestion: widget.suggestion,
                    voteCallBack: widget.voteCallBack,
                    userId: widget.userId,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _SuggestionIndicator(color: widget.color),
          ),
        ],
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final Suggestion suggestion;
  final VoidCallback voteCallBack;
  final String userId;

  const _CardContent({
    required this.suggestion,
    required this.voteCallBack,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                style: context.themeData.textTheme.headlineSmall,
              ),
              const SizedBox(height: Dimensions.marginSmall),
              if (suggestion.description != null)
                Text(
                  suggestion.description!,
                  style: context.themeData.textTheme.titleMedium,
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
  });

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

  const _SuggestionIndicator({
    required this.color,
  });

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
