import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suggest_a_feature/src/data/interfaces/suggestions_data_source.dart';
import 'package:suggest_a_feature/src/domain/entities/admin_settings.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/create_edit/create_edit_suggestion_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_cubit.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_state.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/widgets/suggestion_list.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/widgets/suggestions_tab_bar.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/appbar_widget.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/fab.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:suggest_a_feature/src/presentation/utils/context_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/src/presentation/utils/platform_check.dart';
import 'package:suggest_a_feature/src/presentation/utils/rendering.dart';
import 'package:suggest_a_feature/src/presentation/utils/typedefs.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

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

  /// Callback returning the current user (SuggestionAuthor).
  final OnGetUserById onGetUserById;

  /// Custom AppBar that will be displayed on the [SuggestionsPage].
  final PreferredSizeWidget? customAppBar;

  /// Administrator account settings that will be used instead of the user
  /// account if [isAdmin] == `true`.
  final AdminSettings? adminSettings;

  /// If `true` then [adminSettings] will be used instead of user account.
  final bool isAdmin;

  SuggestionsPage({
    required this.userId,
    required this.suggestionsDataSource,
    required this.theme,
    required this.onGetUserById,
    this.adminSettings,
    this.isAdmin = false,
    this.onSaveToGallery,
    this.onUploadMultiplePhotos,
    this.customAppBar,
    this.imageHeaders,
    super.key,
  }) : assert(
          (isAdmin && adminSettings != null) || !isAdmin,
          'if isAdmin == true, then adminSettings cannot be null',
        ) {
    i.init(
      theme: theme,
      userId: userId,
      imageHeaders: imageHeaders,
      suggestionsDataSource: suggestionsDataSource,
      adminSettings: adminSettings,
      isAdmin: isAdmin,
    );
  }

  @override
  State<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage>
    with SingleTickerProviderStateMixin {
  final SuggestionsCubit _cubit = i.suggestionsCubit;
  late final TabController _tabController;
  final SheetController _sheetController = SheetController();

  @override
  void initState() {
    super.initState();
    _cubit.init();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(
      () => _cubit.changeActiveTab(
        SuggestionStatus.values[_tabController.index],
      ),
    );
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
              appBar: widget.customAppBar ??
                  SuggestionsAppBar(
                    onBackClick: Navigator.of(context).pop,
                    screenTitle: context.localization.suggestAFeature,
                  ),
              backgroundColor: theme.primaryBackgroundColor,
              body: Stack(
                children: <Widget>[
                  _MainContent(
                    userId: widget.userId,
                    state: state,
                    tabController: _tabController,
                    onGetUserById: widget.onGetUserById,
                    onSaveToGallery: widget.onSaveToGallery,
                    onUploadMultiplePhotos: widget.onUploadMultiplePhotos,
                    cubit: _cubit,
                  ),
                  _BottomFab(
                    openCreateBottomSheet: _cubit.openCreateBottomSheet,
                  ),
                ],
              ),
            ),
            if (state.isCreateBottomSheetOpened)
              _BottomSheet(
                sheetController: _sheetController,
                onSaveToGallery: widget.onSaveToGallery,
                onUploadMultiplePhotos: widget.onUploadMultiplePhotos,
                cubit: _cubit,
              ),
          ],
        );
      },
    );
  }
}

class _MainContent extends StatelessWidget {
  final String userId;
  final SuggestionsState state;
  final TabController tabController;
  final OnGetUserById onGetUserById;
  final OnSaveToGalleryCallback? onSaveToGallery;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;
  final SuggestionsCubit cubit;

  const _MainContent({
    required this.userId,
    required this.state,
    required this.tabController,
    required this.onGetUserById,
    required this.onSaveToGallery,
    required this.onUploadMultiplePhotos,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
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
              tabController: tabController,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                SuggestionList(
                  status: SuggestionStatus.requests,
                  suggestions: state.requests,
                  color: theme.requestsTabColor,
                  onGetUserById: onGetUserById,
                  onSaveToGallery: onSaveToGallery,
                  onUploadMultiplePhotos: onUploadMultiplePhotos,
                  userId: userId,
                  vote: (int i) => cubit.vote(SuggestionStatus.requests, i),
                ),
                SuggestionList(
                  status: SuggestionStatus.inProgress,
                  suggestions: state.inProgress,
                  color: theme.inProgressTabColor,
                  onGetUserById: onGetUserById,
                  onSaveToGallery: onSaveToGallery,
                  onUploadMultiplePhotos: onUploadMultiplePhotos,
                  userId: userId,
                  vote: (int i) => cubit.vote(SuggestionStatus.inProgress, i),
                ),
                SuggestionList(
                  status: SuggestionStatus.completed,
                  suggestions: state.completed,
                  color: theme.completedTabColor,
                  onGetUserById: onGetUserById,
                  onSaveToGallery: onSaveToGallery,
                  onUploadMultiplePhotos: onUploadMultiplePhotos,
                  userId: userId,
                  vote: (int i) => cubit.vote(SuggestionStatus.completed, i),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  final SheetController sheetController;
  final OnSaveToGalleryCallback? onSaveToGallery;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;
  final SuggestionsCubit cubit;

  const _BottomSheet({
    required this.sheetController,
    required this.onSaveToGallery,
    required this.onUploadMultiplePhotos,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return CreateEditSuggestionBottomSheet(
      controller: sheetController,
      onClose: ([_]) => sheetController
          .collapse()
          ?.then((_) => cubit.closeCreateBottomSheet()),
      onSaveToGallery: onSaveToGallery,
      onUploadMultiplePhotos: onUploadMultiplePhotos,
    );
  }
}

class _BottomFab extends StatelessWidget {
  final VoidCallback openCreateBottomSheet;

  const _BottomFab({
    required this.openCreateBottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: (SuggestionsPlatform.isIOS
              ? Dimensions.margin2x
              : Dimensions.marginDefault) +
          MediaQuery.of(context).viewInsets.bottom,
      right: Dimensions.marginDefault,
      child: SuggestionsFab(
        padding: const EdgeInsets.all(Dimensions.marginDefault),
        margin: EdgeInsets.zero,
        imageIcon: AssetStrings.plusIconThickImage,
        onClick: openCreateBottomSheet,
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
