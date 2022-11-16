import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion_author.dart';

import '../../../data/interfaces/i_suggestions_data_source.dart';
import '../../../domain/entities/suggestion.dart';
import '../../di/injector.dart';
import '../../utils/assets_strings.dart';
import '../../utils/dimensions.dart';
import '../../utils/rendering.dart';
import '../../utils/typedefs.dart';
import '../../utils/context_utils.dart';
import '../suggestion/create_edit/create_edit_suggestion_bottom_sheet.dart';
import '../suggestion/suggestion_page.dart';
import '../theme/suggestions_theme.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/fab.dart';
import '../widgets/suggestions_labels.dart';
import '../widgets/votes_counter.dart';
import 'suggestions_cubit.dart';
import 'suggestions_state.dart';

class SuggestionsPage extends StatefulWidget {
  /// The current user id.
  final String userId;

  /// Additional headers for the image provider, for example for authentication.
  final Map<String, String>? imageHeaders;

  /// Implementation of [SuggestionsDataSource].
  final SuggestionsDataSource suggestionsDataSource;

  /// Current module theme.
  final SuggestionsTheme theme;

  /// Callback processing the upload of photos.
  final OnUploadMultiplePhotosCallback onUploadMultiplePhotos;

  /// Callback processing saving photos to the gallery.
  final OnSaveToGalleryCallback onSaveToGallery;

  /// Callback callback returning the current user [SuggestionAuthor].
  final OnGetUserById onGetUserById;

  SuggestionsPage({
    required this.userId,
    required this.suggestionsDataSource,
    required this.theme,
    required this.onUploadMultiplePhotos,
    required this.onSaveToGallery,
    required this.onGetUserById,
    this.imageHeaders,
  }) {
    i.init(
        theme: theme,
        userId: userId,
        imageHeaders: imageHeaders,
        suggestionsDataSource: suggestionsDataSource);
  }

  @override
  _SuggestionsPageState createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> with SingleTickerProviderStateMixin {
  final SuggestionsCubit _cubit = i.suggestionsCubit;
  late final TabController _tabController;
  final SheetController _sheetController = SheetController();

  @override
  void initState() {
    _cubit.init();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(
      () => _cubit.changeActiveTab(SuggestionStatus.values[_tabController.index]),
    );
    super.initState();
  }

  @override
  void dispose() {
    _cubit.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuggestionsCubit, SuggestionsState>(
      bloc: _cubit,
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: SuggestionsAppBar(
                onBackClick: Navigator.of(context).pop,
                screenTitle: context.localization.suggestAFeature,
              ),
              backgroundColor: theme.primaryBackgroundColor,
              body: Stack(
                children: [
                  _mainContent(state),
                  _bottomFab(),
                ],
              ),
            ),
            if (state.isCreateBottomSheetOpened) _bottomSheet(),
          ],
        );
      },
    );
  }

  Widget _mainContent(SuggestionsState state) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
              left: Dimensions.marginDefault,
              right: Dimensions.marginDefault,
              top: Dimensions.marginDefault + Dimensions.marginMicro,
            ),
            decoration: BoxDecoration(
              color: theme.secondaryBackgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(Dimensions.mediumCircularRadius),
              ),
            ),
            padding: const EdgeInsets.all(Dimensions.marginSmall),
            child: _tabBar(state),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _suggestionList(
                  status: SuggestionStatus.requests,
                  suggestions: state.requests,
                  color: theme.requestsTabColor,
                ),
                _suggestionList(
                  status: SuggestionStatus.inProgress,
                  suggestions: state.inProgress,
                  color: theme.inProgressTabColor,
                ),
                _suggestionList(
                  status: SuggestionStatus.completed,
                  suggestions: state.completed,
                  color: theme.completedTabColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomFab() {
    return Positioned(
      bottom: Dimensions.marginDefault + MediaQuery.of(context).viewInsets.bottom,
      right: Dimensions.marginDefault,
      child: SuggestionsFab(
        padding: const EdgeInsets.all(Dimensions.marginDefault),
        margin: EdgeInsets.zero,
        imageIcon: AssetStrings.plusIconThickImage,
        onClick: _cubit.openCreateBottomSheet,
      ),
    );
  }

  Widget _bottomSheet() {
    return CreateEditSuggestionBottomSheet(
      controller: _sheetController,
      onClose: ([_]) => _sheetController.collapse()?.then((_) => _cubit.closeCreateBottomSheet()),
      onSaveToGallery: widget.onSaveToGallery,
      onUploadMultiplePhotos: widget.onUploadMultiplePhotos,
    );
  }

  Widget _tabBar(SuggestionsState state) {
    const tabHeight = 60.0;
    return TabBar(
      indicator: BoxDecoration(
        color: theme.primaryBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.smallCircularRadius)),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      controller: _tabController,
      tabs: <Tab>[
        Tab(
          child: _tabButton(
            status: SuggestionStatus.requests,
            activeImage: AssetStrings.suggestionsRequests,
            inactiveImage: AssetStrings.suggestionsRequestsInactive,
            color: theme.requestsTabColor,
            text: context.localization.requests,
            state: state,
          ),
          height: tabHeight,
        ),
        Tab(
          child: _tabButton(
            status: SuggestionStatus.inProgress,
            activeImage: AssetStrings.suggestionsInProgress,
            inactiveImage: AssetStrings.suggestionsInProgressInactive,
            color: theme.inProgressTabColor,
            text: context.localization.inProgress,
            state: state,
          ),
          height: tabHeight,
        ),
        Tab(
          child: _tabButton(
            status: SuggestionStatus.completed,
            activeImage: AssetStrings.suggestionsCompleted,
            inactiveImage: AssetStrings.suggestionsCompletedInactive,
            color: theme.completedTabColor,
            text: context.localization.completed,
            state: state,
          ),
          height: tabHeight,
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
    const activeIconHeight = 38.0;
    const inactiveIconHeight = 22.0;
    const textHeight = 1.17;
    final isActive = state.activeTab == status;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: inactiveIconHeight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
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
                ? theme.textMBold.copyWith(
                    color: color,
                    height: textHeight,
                  )
                : theme.textMSecondary.copyWith(height: textHeight),
          ),
        ),
      ],
    );
  }

  Widget _suggestionList({
    required SuggestionStatus status,
    required List<Suggestion> suggestions,
    required Color color,
  }) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: suggestions.length + 1,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.marginDefault),
          itemBuilder: (context, index) {
            return index == 0
                ? _listDescription(status, suggestions.length)
                : Padding(
                    padding: const EdgeInsets.only(bottom: Dimensions.marginDefault),
                    child: _suggestionCard(
                      suggestion: suggestions[index - 1],
                      color: color,
                      status: status,
                      index: index - 1,
                      onClick: () => Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => SuggestionPage(
                            suggestion: suggestions[index - 1],
                            onUploadMultiplePhotos: widget.onUploadMultiplePhotos,
                            onSaveToGallery: widget.onSaveToGallery,
                            onGetUserById: widget.onGetUserById,
                          ),
                        ),
                      ),
                    ),
                  );
          },
        ),
        _shadows(),
      ],
    );
  }

  Widget _shadows() {
    return CustomPaint(
      size: const Size(double.infinity, double.infinity),
      foregroundPainter: ShadowsCustomPainter(
        context: context,
        contentMarginTop: -11,
        contentMarginBottom: -5,
        backgroundColor: theme.primaryBackgroundColor,
      ),
    );
  }

  Widget _listDescription(SuggestionStatus status, int length) {
    final String header;
    final String description;
    switch (status) {
      case SuggestionStatus.requests:
        header = context.localization.requestsHeader;
        description = context.localization.requestsDescription;
        break;
      case SuggestionStatus.inProgress:
        header = context.localization.inProgressHeader;
        description = context.localization.inProgressDescription;
        break;
      default:
        header = context.localization.completedHeader;
        description = context.localization.completedDescription;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.margin2x),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(text: header, style: theme.textMPlusBold),
                TextSpan(text: ' ($length)', style: theme.textM),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.marginSmall),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textM,
          ),
        ],
      ),
    );
  }

  Widget _suggestionCard({
    required int index,
    required SuggestionStatus status,
    required Suggestion suggestion,
    required Color color,
    required VoidCallback onClick,
  }) {
    return GestureDetector(
      onTap: onClick,
      child: IntrinsicHeight(
        child: Stack(
          children: [
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
                children: [
                  _voteCounter(suggestion, status, index),
                  const SizedBox(width: Dimensions.marginDefault),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          suggestion.title,
                          style: theme.textMBold,
                        ),
                        const SizedBox(height: Dimensions.marginSmall),
                        if (suggestion.description != null)
                          Text(
                            suggestion.description!,
                            style: theme.textM,
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
              child: _suggestionIndicator(color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _voteCounter(
    Suggestion suggestion,
    SuggestionStatus status,
    int index,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _cubit.vote(status, index),
      child: VotesCounter(
        isVoted: suggestion.isVoted,
        upvotesCount: suggestion.upvotesCount,
      ),
    );
  }

  Widget _suggestionIndicator(Color color) {
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
          boxShadow: [
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

class ShadowsCustomPainter extends CustomPainter {
  final BuildContext context;
  final double contentMarginTop;
  final double contentMarginBottom;
  final Color backgroundColor;

  ShadowsCustomPainter({
    required this.context,
    required this.contentMarginBottom,
    required this.contentMarginTop,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    renderHidings(
      canvas: canvas,
      size: size,
      context: context,
      contentMarginTop: contentMarginTop,
      contentMarginBottom: contentMarginBottom,
      backgroundColor: backgroundColor,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
