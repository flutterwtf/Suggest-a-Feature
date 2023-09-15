import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/icon_button.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/zoomable_image.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';

class PhotoView extends StatefulWidget {
  final List<String> photos;
  final ValueChanged<String>? onDeleteClick;
  final ValueChanged<String>? onDownloadClick;
  final int initialIndex;
  final Color previousNavBarColor;

  const PhotoView({
    required this.photos,
    required this.onDownloadClick,
    required this.previousNavBarColor,
    this.onDeleteClick,
    this.initialIndex = 0,
    super.key,
  });

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  late PageController _galleryPageController;
  late int _currentIndex;
  final Map<int, Offset> _touchPositions = <int, Offset>{};
  ScrollPhysics _scrollPhysics = const _CustomPageViewScrollPhysics();

  var _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _galleryPageController = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Column(
        children: <Widget>[
          _ActionButtons(
            currentIndex: _currentIndex,
            onDeleteClick: widget.onDeleteClick,
            onDownloadClick: widget.onDownloadClick,
            photos: widget.photos,
          ),
          Expanded(
            child: Hero(
              tag: 'photo_view',
              child: Listener(
                onPointerDown: (opd) {
                  _touchPositions[opd.pointer] = opd.position;
                  _changeScrollPhysics();
                },
                onPointerCancel: (opc) {
                  _touchPositions.remove(opc.pointer);
                  _changeScrollPhysics();
                },
                onPointerUp: (opu) {
                  _touchPositions.remove(opu.pointer);
                  _changeScrollPhysics();
                },
                child: PageView.builder(
                  physics: _scrollPhysics,
                  itemCount: widget.photos.length,
                  controller: _galleryPageController,
                  onPageChanged: (pageIndex) => _currentIndex = pageIndex,
                  itemBuilder: (_, index) {
                    return ZoomableImage(
                      imageUrl: widget.photos[index],
                      changeZoomStatus: _changeZoomStatus,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.marginDefault),
        ],
      ),
    );
  }

  void _changeZoomStatus(bool isZoomed) {
    setState(() => _isZoomed = isZoomed);
    _changeScrollPhysics();
  }

  void _changeScrollPhysics() {
    setState(() {
      _scrollPhysics = _touchPositions.length > 1 || _isZoomed
          ? const NeverScrollableScrollPhysics()
          : const _CustomPageViewScrollPhysics();
    });
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: widget.previousNavBarColor,
      ),
    );
    _galleryPageController.dispose();
    super.dispose();
  }
}

class _ActionButtons extends StatelessWidget {
  final List<String> photos;
  final ValueChanged<String>? onDeleteClick;
  final ValueChanged<String>? onDownloadClick;
  final int currentIndex;

  const _ActionButtons({
    required this.currentIndex,
    required this.photos,
    this.onDeleteClick,
    this.onDownloadClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: Dimensions.marginDefault,
        right: Dimensions.marginDefault,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SuggestionsIconButton(
            onClick: () =>
                (i.navigatorKey?.currentState ?? Navigator.of(context)).pop(),
            imageIcon: AssetStrings.backIconImage,
            color: Colors.white,
          ),
          Row(
            children: <Widget>[
              if (onDeleteClick != null) ...<Widget>[
                SuggestionsIconButton(
                  imageIcon: AssetStrings.deleteIconImage,
                  onClick: () {
                    (i.navigatorKey?.currentState ?? Navigator.of(context))
                        .pop();
                    onDeleteClick!(photos[currentIndex]);
                  },
                  color: Colors.white,
                ),
                const SizedBox(width: Dimensions.marginDefault),
              ],
              if (onDownloadClick != null) ...<Widget>[
                SuggestionsIconButton(
                  imageIcon: AssetStrings.downloadIconImage,
                  onClick: () => onDownloadClick!(photos[currentIndex]),
                  color: Colors.white,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomPageViewScrollPhysics extends ScrollPhysics {
  const _CustomPageViewScrollPhysics({super.parent});

  @override
  _CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      _CustomPageViewScrollPhysics(parent: buildParent(ancestor));

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 50,
        stiffness: 100,
        damping: 0.8,
      );
}
