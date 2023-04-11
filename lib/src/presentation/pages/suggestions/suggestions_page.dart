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
                ),
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
  final OnGetUserById onGetUserById;
  final OnSaveToGalleryCallback? onSaveToGallery;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;

  const _MainContent({
    required this.userId,
    required this.onTabChanged,
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
    _tabController = TabController(length: 3, vsync: this);
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
      length: 3,
      child: Column(
        children: [
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
              state: context.watch<SuggestionsCubit>().state,
              tabController: _tabController,
            ),
          ),
          _TabBarView(
            onUploadMultiplePhotos: widget.onUploadMultiplePhotos,
            onSaveToGallery: widget.onSaveToGallery,
            onGetUserById: widget.onGetUserById,
            userId: widget.userId,
            onVote: context.read<SuggestionsCubit>().vote,
            tabController: _tabController,
          ),
        ],
      ),
    );
  }
}

class _BottomSheet extends StatefulWidget {
  final OnSaveToGalleryCallback? onSaveToGallery;
  final OnUploadMultiplePhotosCallback? onUploadMultiplePhotos;

  const _BottomSheet({
    required this.onSaveToGallery,
    required this.onUploadMultiplePhotos,
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
          context.read<SuggestionsCubit>().closeCreateBottomSheet();
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

  const _TabBarView({
    required this.tabController,
    required this.onGetUserById,
    required this.onSaveToGallery,
    required this.userId,
    required this.onUploadMultiplePhotos,
    required this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SuggestionsCubit>();
    return Expanded(
      child: TabBarView(
        controller: tabController,
        children: [
          SuggestionList(
            status: SuggestionStatus.requests,
            suggestions: cubit.state.requests,
            color: theme.requestsTabColor,
            onGetUserById: onGetUserById,
            onSaveToGallery: onSaveToGallery,
            onUploadMultiplePhotos: onUploadMultiplePhotos,
            userId: userId,
            vote: (i) => onVote(SuggestionStatus.requests, i),
          ),
          SuggestionList(
            status: SuggestionStatus.inProgress,
            suggestions: cubit.state.inProgress,
            color: theme.inProgressTabColor,
            onGetUserById: onGetUserById,
            onSaveToGallery: onSaveToGallery,
            onUploadMultiplePhotos: onUploadMultiplePhotos,
            userId: userId,
            vote: (i) => onVote(SuggestionStatus.inProgress, i),
          ),
          SuggestionList(
            status: SuggestionStatus.completed,
            suggestions: cubit.state.completed,
            color: theme.completedTabColor,
            onGetUserById: onGetUserById,
            onSaveToGallery: onSaveToGallery,
            onUploadMultiplePhotos: onUploadMultiplePhotos,
            userId: userId,
            vote: (i) => onVote(SuggestionStatus.completed, i),
          ),
        ],
      ),
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
