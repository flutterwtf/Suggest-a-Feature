import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../../utils/dimensions.dart';
import '../../theme/suggestions_theme.dart';

typedef OnDismissCallback = void Function([ClosureType? closureType]);

const bottomSheetOpenCloseDuration = Duration(milliseconds: 200);

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
    this.additionalSnappings = const [],
  });

  @override
  State<StatefulWidget> createState() => _BaseBottomSheetState();
}

class _BaseBottomSheetState extends State<BaseBottomSheet> with TickerProviderStateMixin {
  late AnimationController _dimmingController;

  @override
  void initState() {
    super.initState();
    _dimmingController = AnimationController(
      vsync: this,
      duration: widget.openDuration,
    )..forward();
  }

  void _onDismissPrevented(bool backButton, bool backDrop) {
    if (backButton) {
      _onDismiss(ClosureType.backButton);
    } else if (backDrop) {
      _onDismiss(ClosureType.backDrop);
    } else {
      _onDismiss(ClosureType.swipeDown);
    }
  }

  void _onDismiss(ClosureType closureType) {
    _dimmingController.reverse();
    widget.onClose(closureType);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          systemNavigationBarColor: widget.navbarColor ?? widget.backgroundColor),
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
          child: SlidingSheet(
            cornerRadiusOnFullscreen: 0.0,
            closeOnBackButtonPressed: true,
            closeOnBackdropTap: true,
            onDismissPrevented: _onDismissPrevented,
            onOpen: widget.onOpen?.call,
            openBouncing: widget.openBouncing,
            openDuration: widget.openDuration,
            controller: widget.controller,
            color: widget.backgroundColor,
            elevation: 0,
            cornerRadius: Dimensions.smallCircularRadius,
            snapSpec: SnapSpec(
              snap: true,
              snappings: [
                0,
                1,
                if (widget.initialSnapping != 1) widget.initialSnapping,
                ...widget.additionalSnappings,
              ],
              initialSnap: widget.initialSnapping,
              positioning: SnapPositioning.relativeToAvailableSpace,
              onSnap: (state, snap) {
                if (state.isCollapsed) {
                  _onDismiss(ClosureType.swipeDown);
                }
              },
            ),
            headerBuilder: _headerBuilder,
            builder: (context, state) {
              return Padding(
                padding: widget.contentPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.title != null)
                      Padding(
                        padding: EdgeInsets.only(
                          left: Dimensions.marginDefault - widget.contentPadding.horizontal,
                          top: widget.titleTopPadding,
                          bottom: widget.titleBottomPadding,
                        ),
                        child: Text(
                          widget.title!,
                          style: theme.textXXLBold,
                        ),
                      ),
                    widget.contentBuilder(context, state),
                  ],
                ),
              );
            },
            footerBuilder: widget.footerBuilder,
          ),
        ),
      ),
    );
  }

  Widget _headerBuilder(BuildContext context, SheetState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _grabbing(),
        if (widget.headerBuilder != null) widget.headerBuilder!.call(context, state),
      ],
    );
  }

  Widget _grabbing() {
    return SheetListenerBuilder(
      builder: (context, state) {
        if (state.extent != 1) {
          return Container(
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

enum ClosureType {
  backButton,
  backDrop,
  swipeDown,
}

enum LoadingStatus { empty, loading, loaded, error, loadedStatic }
