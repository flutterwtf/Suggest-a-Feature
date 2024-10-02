import 'package:flutter/cupertino.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/widgets/list_description.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/widgets/suggestion_card.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

class SuggestionList extends StatelessWidget {
  final SuggestionStatus status;
  final List<Suggestion> suggestions;
  final Color color;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;
  final OnSaveToGalleryCallback? onSaveToGallery;
  final OnShareSuggestion? onShareSuggestion;
  final OnGetUserById onGetUserById;
  final String userId;
  final ValueChanged<int> vote;
  final VoidCallback openSortingBottomSheet;

  const SuggestionList({
    required this.status,
    required this.suggestions,
    required this.color,
    required this.onGetUserById,
    required this.userId,
    required this.vote,
    required this.openSortingBottomSheet,
    this.onUploadMultiplePhotos,
    this.onSaveToGallery,
    this.onShareSuggestion,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView.builder(
          itemCount: suggestions.length + 1,
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.marginDefault,
          ),
          itemBuilder: (_, index) {
            return index == 0
                ? ListDescription(
                    status: status,
                    length: suggestions.length,
                    openSortingBottomSheet: openSortingBottomSheet,
                  )
                : _ListItem(
                    index: index,
                    suggestions: suggestions,
                    onGetUserById: onGetUserById,
                    onSaveToGallery: onSaveToGallery,
                    onUploadMultiplePhotos: onUploadMultiplePhotos,
                    onShareSuggestion: onShareSuggestion,
                    userId: userId,
                    status: status,
                    vote: vote,
                    color: color,
                  );
          },
        ),
        const _Shadows(),
      ],
    );
  }
}

class _ListItem extends StatelessWidget {
  final String userId;
  final ValueChanged<int> vote;
  final SuggestionStatus status;
  final List<Suggestion> suggestions;
  final Color color;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;
  final OnSaveToGalleryCallback? onSaveToGallery;
  final OnGetUserById onGetUserById;
  final OnShareSuggestion? onShareSuggestion;
  final int index;

  const _ListItem({
    required this.status,
    required this.suggestions,
    required this.color,
    required this.onGetUserById,
    required this.userId,
    required this.vote,
    required this.index,
    this.onUploadMultiplePhotos,
    this.onSaveToGallery,
    this.onShareSuggestion,
  });

  @override
  Widget build(BuildContext context) {
    return SuggestionCard(
      suggestion: suggestions[index - 1],
      color: color,
      status: status,
      index: index - 1,
      onClick: () =>
          (i.navigatorKey?.currentState ?? Navigator.of(context)).push(
        CupertinoPageRoute<dynamic>(
          builder: (_) => SuggestionPage(
            suggestion: suggestions[index - 1],
            onUploadMultiplePhotos: onUploadMultiplePhotos,
            onSaveToGallery: onSaveToGallery,
            onGetUserById: onGetUserById,
            onShareSuggestion: onShareSuggestion,
          ),
        ),
      ),
      userId: userId,
      voteCallBack: () => vote(index - 1),
    );
  }
}

class _Shadows extends StatelessWidget {
  const _Shadows();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      foregroundPainter: ShadowsCustomPainter(
        context: context,
        contentMarginTop: -11,
        contentMarginBottom: -5,
        backgroundColor: context.theme.scaffoldBackgroundColor,
      ),
    );
  }
}
