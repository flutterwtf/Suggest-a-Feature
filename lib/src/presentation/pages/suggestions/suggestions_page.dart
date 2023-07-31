import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suggest_a_feature/src/data/interfaces/suggestions_data_source.dart';
import 'package:suggest_a_feature/src/domain/entities/admin_settings.dart';
import 'package:suggest_a_feature/src/domain/entities/suggestion.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestion/create_edit/create_edit_suggestion_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_cubit.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_cubit_scope.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/suggestions_state.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/widgets/suggestion_list.dart';
import 'package:suggest_a_feature/src/presentation/pages/suggestions/widgets/suggestions_tab_bar.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/appbar_widget.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/sorting_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/fab.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:suggest_a_feature/src/presentation/utils/context_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/src/presentation/utils/platform_check.dart';
import 'package:suggest_a_feature/src/presentation/utils/rendering.dart';
import 'package:suggest_a_feature/src/presentation/utils/typedefs.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

class SuggestionsPage extends StatefulWidget {
  /// Current user id.
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

class _SuggestionsPageState extends State<SuggestionsPage> {
  @override
  Widget build(BuildContext context) {
    return SuggestionsCubitScope(
      child: BlocBuilder<SuggestionsCubit, SuggestionsState>(
        buildWhen: (previous, current) =>
            previous.isCreateBottomSheetOpened !=
                current.isCreateBottomSheetOpened ||
            previous.activeTab != current.activeTab ||
            previous.isSortingBottomSheetOpened !=
                current.isSortingBottomSheetOpened,
        builder: (context, state) {
          final cubit = context.read<SuggestionsCubit>();
          return Stack(
            children: [
              Scaffold(
                appBar: widget.customAppBar ??
                    SuggestionsAppBar(
                      onBackClick: Navigator.of(context).pop,
                      screenTitle: context.localization.suggestAFeature,
                    ),
                backgroundColor: theme.primaryBackgroundColor,
                body: Stack(
                  children: [
                    _MainContent(
                      userId: widget.userId,
                      onTabChanged: (index) {
                        cubit.changeActiveTab(
                          SuggestionStatus.values[index],
                        );
                      },
                      activeTab: state.activeTab,
                      onGetUserById: widget.onGetUserById,
                      onSaveToGallery: widget.onSaveToGallery,
                      onUploadMultiplePhotos: widget.onUploadMultiplePhotos,
                    ),
                    _BottomFab(
                      openCreateBottomSheet: cubit.openCreateBottomSheet,
                    ),
                  ],
                ),
              ),
              if (state.isCreateBottomSheetOpened)
                _BottomSheet(
                  onSaveToGallery: widget.onSaveToGallery,
                  onUploadMultiplePhotos: widget.onUploadMultiplePhotos,
                  onCloseBottomSheet: cubit.closeCreateBottomSheet,
                ),
              if (state.isSortingBottomSheetOpened)
                SortingBottomSheet(
                  closeSortingBottomSheet: cubit.closeSortingBottomSheet,
                  value: state.sortType,
                )
            ],
          );
        },
      ),
    );
  }
}

class _MainContent extends StatefulWidget {
  final String userId;
  final ValueChanged<int> onTabChanged;
  final SuggestionStatus activeTab;
  final OnGetUserById onGetUserById;
  final OnSaveToGalleryCallback? onSaveToGallery;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;

  const _MainContent({
    required this.userId,
    required this.onTabChanged,
    required this.activeTab,
    required this.onGetUserById,
    required this.onSaveToGallery,
    required this.onUploadMultiplePhotos,
  });

  @override
  State<_MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<_MainContent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(
      () => widget.onTabChanged(_tabController.index),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          SuggestionsTabBar(
            activeTab: widget.activeTab,
            tabController: _tabController,
          ),
          _TabBarView(
            onUploadMultiplePhotos: widget.onUploadMultiplePhotos,
            onSaveToGallery: widget.onSaveToGallery,
            onGetUserById: widget.onGetUserById,
            userId: widget.userId,
            onVote: context.read<SuggestionsCubit>().vote,
            tabController: _tabController,
            openSortingBottomSheet:
                context.read<SuggestionsCubit>().openSortingBottomSheet,
          ),
        ],
      ),
    );
  }
}

class _BottomSheet extends StatefulWidget {
  final OnSaveToGalleryCallback? onSaveToGallery;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;
  final VoidCallback onCloseBottomSheet;

  const _BottomSheet({
    required this.onCloseBottomSheet,
    this.onSaveToGallery,
    this.onUploadMultiplePhotos,
  });

  @override
  State<_BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<_BottomSheet> {
  final SheetController _sheetController = SheetController();

  @override
  Widget build(BuildContext context) {
    return CreateEditSuggestionBottomSheet(
      controller: _sheetController,
      onClose: ([_]) async {
        await _sheetController.collapse();
        if (mounted) {
          widget.onCloseBottomSheet();
        }
      },
      onSaveToGallery: widget.onSaveToGallery,
      onUploadMultiplePhotos: widget.onUploadMultiplePhotos,
    );
  }
}

class _TabBarView extends StatelessWidget {
  final TabController tabController;
  final OnGetUserById onGetUserById;
  final OnSaveToGalleryCallback? onSaveToGallery;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;
  final void Function(SuggestionStatus status, int i) onVote;
  final String userId;
  final VoidCallback openSortingBottomSheet;

  const _TabBarView({
    required this.tabController,
    required this.onGetUserById,
    required this.userId,
    required this.onVote,
    required this.openSortingBottomSheet,
    this.onSaveToGallery,
    this.onUploadMultiplePhotos,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuggestionsCubit, SuggestionsState>(
      buildWhen: (previous, current) =>
          previous.requests != current.requests ||
          previous.inProgress != current.inProgress ||
          previous.completed != current.completed ||
          previous.declined != current.declined ||
          previous.duplicated != current.duplicated,
      builder: (context, state) {
        return Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              SuggestionList(
                status: SuggestionStatus.requests,
                suggestions: state.requests,
                color: theme.requestsTabColor,
                onGetUserById: onGetUserById,
                onSaveToGallery: onSaveToGallery,
                onUploadMultiplePhotos: onUploadMultiplePhotos,
                userId: userId,
                vote: (i) => onVote(SuggestionStatus.requests, i),
                openSortingBottomSheet: openSortingBottomSheet,
              ),
              SuggestionList(
                status: SuggestionStatus.inProgress,
                suggestions: state.inProgress,
                color: theme.inProgressTabColor,
                onGetUserById: onGetUserById,
                onSaveToGallery: onSaveToGallery,
                onUploadMultiplePhotos: onUploadMultiplePhotos,
                userId: userId,
                vote: (i) => onVote(SuggestionStatus.inProgress, i),
                openSortingBottomSheet: openSortingBottomSheet,
              ),
              SuggestionList(
                status: SuggestionStatus.completed,
                suggestions: state.completed,
                color: theme.completedTabColor,
                onGetUserById: onGetUserById,
                onSaveToGallery: onSaveToGallery,
                onUploadMultiplePhotos: onUploadMultiplePhotos,
                userId: userId,
                vote: (i) => onVote(SuggestionStatus.completed, i),
                openSortingBottomSheet: openSortingBottomSheet,
              ),
              SuggestionList(
                status: SuggestionStatus.declined,
                suggestions: state.declined,
                color: theme.declinedTabColor,
                onGetUserById: onGetUserById,
                onSaveToGallery: onSaveToGallery,
                onUploadMultiplePhotos: onUploadMultiplePhotos,
                userId: userId,
                vote: (i) => onVote(SuggestionStatus.declined, i),
                openSortingBottomSheet: openSortingBottomSheet,
              ),
              SuggestionList(
                status: SuggestionStatus.duplicated,
                suggestions: state.duplicated,
                color: theme.duplicatedTabColor,
                onGetUserById: onGetUserById,
                onSaveToGallery: onSaveToGallery,
                onUploadMultiplePhotos: onUploadMultiplePhotos,
                userId: userId,
                vote: (i) => onVote(SuggestionStatus.duplicated, i),
                openSortingBottomSheet: openSortingBottomSheet,
              ),
            ],
          ),
        );
      },
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
