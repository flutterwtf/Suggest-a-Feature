import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';

class ZoomableImage extends StatefulWidget {
  final String imageUrl;
  final VoidCallback changeScrollPhysics;
  final void Function(bool value) changeZoomStatus;

  const ZoomableImage({
    required this.imageUrl,
    required this.changeScrollPhysics,
    required this.changeZoomStatus,
    super.key,
  });

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  Animation<double>? _animation;
  void Function() _animationListener = () {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: ExtendedImage(
        image: CachedNetworkImageProvider(
          widget.imageUrl,
          headers: i.imageHeaders,
        ),
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
        initGestureConfigHandler: (ExtendedImageState state) {
          return GestureConfig(
            minScale: 1,
            animationMinScale: 1,
            maxScale: 3,
            animationMaxScale: 3.5,
            gestureDetailsIsChanged: (GestureDetails? details) {
              final isZoomed = details!.totalScale! > 1;
              widget.changeZoomStatus(isZoomed);
            },
          );
        },
        onDoubleTap: _onDoubleTap,
      ),
    );
  }

  void _onDoubleTap(ExtendedImageGestureState state) {
    final pointerDownPosition = state.pointerDownPosition;
    final begin = state.gestureDetails!.totalScale!;
    final end = begin == 1 ? 2.0 : 1.0;

    _animation?.removeListener(_animationListener);
    _animationController
      ..stop()
      ..reset();

    widget.changeZoomStatus(begin == 1);
    widget.changeScrollPhysics();

    _animationListener = () {
      state.handleDoubleTap(
        scale: _animation!.value,
        doubleTapPosition: pointerDownPosition,
      );
    };
    _animation = _animationController.drive(
      Tween<double>(
        begin: begin,
        end: end,
      ),
    );
    _animation!.addListener(_animationListener);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
