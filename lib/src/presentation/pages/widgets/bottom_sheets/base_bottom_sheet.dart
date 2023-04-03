import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/src/presentation/utils/platform_check.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

typedef OnDismissCallback = void Function([ClosureType? closureType]);

const Duration bottomSheetOpenCloseDuration = Duration(milliseconds: 200);

class BaseBottomSheet extends StatefulWidget {
  final String? title;
  final double titleBottomPadding;
  final double titleTopPadding;
  final OnDismissCallback onClose;
  final VoidCallback? onOpen;
  final SheetBuilder? headerBuilder;
  final SheetBuilder? footerBuilder;
  final SheetBuilder contentBuilder;
  final SheetController controller;
  final EdgeInsetsGeometry contentPadding;
  final double initialSnapping;
  final Duration openDuration;
  final bool openBouncing;
  final Color backgroundColor;
  final bool showDimming;
  final bool paintNavBarToShadowColor;
  final LoadingStatus loadingStatus;
  final Color? navbarColor;
  final List<double> additionalSnappings;
  final Color previousNavBarColor;
  final Color previousStatusBarColor;

  const BaseBottomSheet({
    required this.contentBuilder,
    required this.controller,
    required this.onClose,
    required this.backgroundColor,
    required this.previousNavBarColor,
    required this.previousStatusBarColor,
    this.title,
    this.titleBottomPadding = Dimensions.marginDefault,
    this.titleTopPadding = Dimensions.marginDefault,
    this.navbarColor,
    this.onOpen,
    this.headerBuilder,
    this.footerBuilder,
    this.initialSnapping = 1.0,
    this.openDuration = bottomSheetOpenCloseDuration,
    this.openBouncing = false,
    this.showDimming = true,
    this.paintNavBarToShadowColor = false,
    this.contentPadding = EdgeInsets.zero,
    this.loadingStatus = LoadingStatus.empty,
    this.additionalSnappings = const <double>[],
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _BaseBottomSheetState();
}

class _BaseBottomSheetState extends State<BaseBottomSheet>
    with TickerProviderStateMixin {
  late AnimationController _dimmingController;

  @override
  void initState() {
    super.initState();
    _dimmingController = AnimationController(
      vsync: this,
      duration: widget.openDuration,
    )..forward();
  }

  void _onDismiss(ClosureType closureType) {
    _dimmingController.reverse();
    widget.onClose(closureType);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: widget.navbarColor ?? widget.backgroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: DecoratedBoxTransition(
          decoration: DecorationTween(
            begin: const BoxDecoration(
              color: Colors.transparent,
            ),
            end: BoxDecoration(
              color: theme.fade,
            ),
          ).animate(_dimmingController),
          child: _SlidingSheet(
            onDismiss: _onDismiss,
            onOpen: widget.onOpen,
            openBouncing: widget.openBouncing,
            openDuration: widget.openDuration,
            backgroundColor: widget.backgroundColor,
            controller: widget.controller,
            additionalSnappings: widget.additionalSnappings,
            initialSnapping: widget.initialSnapping,
            headerBuilder: widget.headerBuilder,
            footerBuilder: widget.footerBuilder,
            title: widget.title,
            titleBottomPadding: widget.titleBottomPadding,
            titleTopPadding: widget.titleTopPadding,
            contentPadding: widget.contentPadding,
            contentBuilder: widget.contentBuilder,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: widget.previousNavBarColor,
        statusBarColor: Colors.transparent,
      ),
    );
    _dimmingController.dispose();
    super.dispose();
  }
}

class _SlidingSheet extends StatelessWidget {
  final ValueChanged<ClosureType> onDismiss;
  final VoidCallback? onOpen;
  final bool openBouncing;
  final Duration openDuration;
  final SheetController? controller;
  final Color backgroundColor;
  final double initialSnapping;
  final List<double> additionalSnappings;
  final SheetBuilder? headerBuilder;
  final SheetBuilder? footerBuilder;
  final SheetBuilder contentBuilder;
  final EdgeInsetsGeometry contentPadding;
  final String? title;
  final double titleBottomPadding;
  final double titleTopPadding;

  const _SlidingSheet({
    required this.onDismiss,
    required this.onOpen,
    required this.openBouncing,
    required this.openDuration,
    required this.controller,
    required this.backgroundColor,
    required this.initialSnapping,
    required this.additionalSnappings,
    required this.contentPadding,
    required this.title,
    required this.titleBottomPadding,
    required this.titleTopPadding,
    required this.contentBuilder,
    this.headerBuilder,
    this.footerBuilder,
  });

  void _onDismissPrevented(bool backButton, bool backDrop) {
    if (backButton) {
      onDismiss(ClosureType.backButton);
    } else if (backDrop) {
      onDismiss(ClosureType.backDrop);
    } else {
      onDismiss(ClosureType.swipeDown);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlidingSheet(
      cornerRadiusOnFullscreen: 0,
      closeOnBackButtonPressed: true,
      closeOnBackdropTap: true,
      onDismissPrevented: _onDismissPrevented,
      onOpen: onOpen?.call,
      openBouncing: openBouncing,
      openDuration: openDuration,
      controller: controller,
      color: backgroundColor,
      cornerRadius: Dimensions.smallCircularRadius,
      snapSpec: SnapSpec(
        snappings: <double>[
          0,
          1,
          if (initialSnapping != 1) initialSnapping,
          ...additionalSnappings,
        ],
        initialSnap: initialSnapping,
        onSnap: (SheetState state, double? snap) {
          if (state.isCollapsed) {
            onDismiss(ClosureType.swipeDown);
          }
        },
      ),
      headerBuilder: (context, state) => _HeaderBuilder(
        state: state,
        headerBuilder: headerBuilder,
      ),
      builder: (BuildContext context, SheetState state) {
        return _SafeArea(
          contentBuilder: contentBuilder,
          contentPadding: contentPadding,
          titleTopPadding: titleTopPadding,
          titleBottomPadding: titleBottomPadding,
          title: title,
          state: state,
        );
      },
      footerBuilder: footerBuilder,
    );
  }
}

class _SafeArea extends StatelessWidget {
  final SheetBuilder contentBuilder;
  final EdgeInsetsGeometry contentPadding;
  final String? title;
  final double titleBottomPadding;
  final double titleTopPadding;
  final SheetState state;

  const _SafeArea({
    required this.contentBuilder,
    required this.contentPadding,
    required this.titleTopPadding,
    required this.titleBottomPadding,
    required this.state,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: SuggestionsPlatform.isIOS,
      child: Padding(
        padding: contentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (title != null)
              Padding(
                padding: EdgeInsets.only(
                  left: Dimensions.marginDefault - contentPadding.horizontal,
                  top: titleTopPadding,
                  bottom: titleBottomPadding,
                ),
                child: Text(
                  title!,
                  style: theme.textLargeBold,
                ),
              ),
            contentBuilder(context, state),
          ],
        ),
      ),
    );
  }
}

class _HeaderBuilder extends StatelessWidget {
  final SheetState state;
  final SheetBuilder? headerBuilder;

  const _HeaderBuilder({
    required this.state,
    this.headerBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const _Grabbing(),
        if (headerBuilder != null) headerBuilder!.call(context, state),
      ],
    );
  }
}

class _Grabbing extends StatelessWidget {
  const _Grabbing();

  @override
  Widget build(BuildContext context) {
    return SheetListenerBuilder(
      builder: (BuildContext context, SheetState state) {
        if (state.extent != 1) {
          return SizedBox(
            height: state.extent > 0.95
                ? (1 - state.extent) / 0.05 * Dimensions.grabbingHeight
                : Dimensions.grabbingHeight,
            child: FittedBox(
              fit: BoxFit.none,
              child: Opacity(
                opacity: state.extent > 0.95 ? (1 - state.extent) / 0.05 : 1.0,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: Dimensions.marginSmall,
                      bottom: Dimensions.marginMiddle,
                    ),
                    height: 5,
                    width: Dimensions.size2x,
                    decoration: BoxDecoration(
                      color: theme.actionColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

enum ClosureType {
  backButton,
  backDrop,
  swipeDown,
}

enum LoadingStatus { empty, loading, loaded, error, loadedStatic }
