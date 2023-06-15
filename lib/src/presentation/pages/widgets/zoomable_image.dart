import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ZoomableImage extends StatefulWidget {
  final String imageUrl;
  final VoidCallback changeScrollPhysics;
  final ValueChanged<bool> changeZoomStatus;

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
  late final TransformationController _transformationController;
  late final AnimationController _animationController;
  late Animation<Matrix4> _animation;

  final double _doubleTapZoomScale = 2;

  @override
  void initState() {
    super.initState();

    _transformationController = TransformationController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: _onDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 1,
        maxScale: 3,
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  void _onDoubleTap(TapDownDetails details) {
    _animationController.addListener(_animationListener);

    final pos = details.localPosition;

    widget.changeZoomStatus(_transformationController.value.isIdentity());
    widget.changeScrollPhysics();

    final x = -pos.dx * (_doubleTapZoomScale - 1);
    final y = -pos.dy * (_doubleTapZoomScale - 1);
    final zoomedMatrix = Matrix4.identity()
      ..translate(x, y)
      ..scale(_doubleTapZoomScale);

    final endMatrix = _transformationController.value.isIdentity()
        ? zoomedMatrix
        : Matrix4.identity();

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: endMatrix,
    ).animate(
      CurveTween(curve: Curves.easeInOut).animate(_animationController),
    );
    _animationController.forward(from: 0).then(
          (_) => _animationController.removeListener(
            _animationListener,
          ),
        );
  }

  void _animationListener() =>
      _transformationController.value = _animation.value;
}
