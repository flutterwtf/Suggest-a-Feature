// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../../data/interfaces/i_suggestions_data_source.dart';
import '../../../domain/entities/suggestion.dart';
import '../../di/injector.dart';
import '../../utils/assets_strings.dart';
import '../../utils/context_utils.dart';
import '../../utils/dimensions.dart';
import '../../utils/platform_check.dart';
import '../../utils/rendering.dart';
import '../../utils/typedefs.dart';
import '../suggestion/create_edit/create_edit_suggestion_bottom_sheet.dart';
import '../theme/suggestions_theme.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/fab.dart';
import 'suggestions_cubit.dart';
import 'suggestions_state.dart';
import 'widgets/suggestion_list.dart';
import 'widgets/suggestions_tab_bar.dart';

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
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;

  /// Callback processing saving photos to the gallery.
  final OnSaveToGalleryCallback? onSaveToGallery;

  /// Callback callback returning the current user [SuggestionAuthor].
  final OnGetUserById onGetUserById;

  SuggestionsPage({
    Key? key,
    required this.userId,
    required this.suggestionsDataSource,
    required this.theme,
    required this.onGetUserById,
    this.onSaveToGallery,
    this.onUploadMultiplePhotos,
    this.imageHeaders,
  }) : super(key: key) {
    i.init(
      theme: theme,
      userId: userId,
      imageHeaders: imageHeaders,
      suggestionsDataSource: suggestionsDataSource,
    );
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
      builder: (BuildContext context, SuggestionsState state) {
        return Stack(
          children: <Widget>[
            Scaffold(
              appBar: SuggestionsAppBar(
                onBackClick: Navigator.of(context).pop,
                screenTitle: context.localization.suggestAFeature,
              ),
              backgroundColor: theme.primaryBackgroundColor,
              body: Stack(
                children: <Widget>[
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
            child: SuggestionsTabBar(
              state: state,
              tabController: _tabController,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                SuggestionList(
                  status: SuggestionStatus.requests,
                  suggestions: state.requests,
                  color: theme.requestsTabColor,
                  onGetUserById: widget.onGetUserById,
                  onSaveToGallery: widget.onSaveToGallery,
                  onUploadMultiplePhotos: widget.onUploadMultiplePhotos,
                  userId: widget.userId,
                  vote: (int i) => _cubit.vote(SuggestionStatus.requests, i),
                ),
                SuggestionList(
                  status: SuggestionStatus.inProgress,
                  suggestions: state.inProgress,
                  color: theme.inProgressTabColor,
                  onGetUserById: widget.onGetUserById,
                  onSaveToGallery: widget.onSaveToGallery,
                  onUploadMultiplePhotos: widget.onUploadMultiplePhotos,
                  userId: widget.userId,
                  vote: (int i) => _cubit.vote(SuggestionStatus.inProgress, i),
                ),
                SuggestionList(
                  status: SuggestionStatus.completed,
                  suggestions: state.completed,
                  color: theme.completedTabColor,
                  onGetUserById: widget.onGetUserById,
                  onSaveToGallery: widget.onSaveToGallery,
                  onUploadMultiplePhotos: widget.onUploadMultiplePhotos,
                  userId: widget.userId,
                  vote: (int i) => _cubit.vote(SuggestionStatus.completed, i),
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
      bottom: (SuggestionsPlatform.isIOS ? Dimensions.margin2x : Dimensions.marginDefault) +
          MediaQuery.of(context).viewInsets.bottom,
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
