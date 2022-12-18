import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../di/injector.dart';

class ZoomableImage extends StatefulWidget {
  final String imageUrl;
  final VoidCallback changeScrollPhysics;
  final Function(bool value) changeZoomStatus;

  const ZoomableImage({
    Key? key,
    required this.imageUrl,
    required this.changeScrollPhysics,
    required this.changeZoomStatus,
  }) : super(key: key);

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  Animation<double>? _animation;
  Function() _animationListener = () {};

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
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
            maxScale: 3.0,
            animationMaxScale: 3.5,
            gestureDetailsIsChanged: (GestureDetails? details) {
              final bool isZoomed = details!.totalScale! > 1;
              widget.changeZoomStatus(isZoomed);
            },
          );
        },
        onDoubleTap: (ExtendedImageGestureState state) {
          final Offset? pointerDownPosition = state.pointerDownPosition;
          final double begin = state.gestureDetails!.totalScale!;
          double end;

          _animation?.removeListener(_animationListener);
          _animationController.stop();
          _animationController.reset();

          if (begin == 1) {
            widget.changeZoomStatus(true);
            end = 2;
          } else {
            widget.changeZoomStatus(false);
            end = 1;
          }
          widget.changeScrollPhysics();

          _animationListener = () {
            state.handleDoubleTap(
              scale: _animation!.value,
              doubleTapPosition: pointerDownPosition,
            );
          };
          _animation = _animationController.drive(Tween<double>(
            begin: begin,
            end: end,
          ));
          _animation!.addListener(_animationListener);
          _animationController.forward();
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
