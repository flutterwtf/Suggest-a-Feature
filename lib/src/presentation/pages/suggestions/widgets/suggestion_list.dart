import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../suggest_a_feature.dart';
import '../../../di/injector.dart';
import '../../../utils/dimensions.dart';
import '../../suggestion/suggestion_page.dart';
import '../suggestions_cubit.dart';
import 'list_description.dart';
import 'suggestion_card.dart';

class SuggestionList extends StatelessWidget {
  final SuggestionsCubit _cubit = i.suggestionsCubit;

  final SuggestionStatus status;
  final List<Suggestion> suggestions;
  final Color color;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;
  final OnSaveToGalleryCallback? onSaveToGallery;
  final OnGetUserById onGetUserById;
  final String userId;

  SuggestionList({
    Key? key,
    required this.status,
    required this.suggestions,
    required this.color,
    this.onUploadMultiplePhotos,
    this.onSaveToGallery,
    required this.onGetUserById,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView.builder(
          itemCount: suggestions.length + 1,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.marginDefault),
          itemBuilder: (BuildContext context, int index) {
            return index == 0
                ? ListDescription(status: status, length: suggestions.length)
                : Padding(
                    padding: const EdgeInsets.only(bottom: Dimensions.marginDefault),
                    child: SuggestionCard(
                      suggestion: suggestions[index - 1],
                      color: color,
                      status: status,
                      index: index - 1,
                      onClick: () => Navigator.of(context).push(
                        CupertinoPageRoute<dynamic>(
                          builder: (_) => SuggestionPage(
                            suggestion: suggestions[index - 1],
                            onUploadMultiplePhotos: onUploadMultiplePhotos,
                            onSaveToGallery: onSaveToGallery,
                            onGetUserById: onGetUserById,
                          ),
                        ),
                      ),
                      userId: userId,
                      voteCallBack: () => _cubit.vote(status, index - 1),
                    ),
                  );
          },
        ),
        _shadows(context),
      ],
    );
  }

  Widget _shadows(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      foregroundPainter: ShadowsCustomPainter(
        context: context,
        contentMarginTop: -11,
        contentMarginBottom: -5,
        backgroundColor: theme.primaryBackgroundColor,
      ),
    );
  }
}
