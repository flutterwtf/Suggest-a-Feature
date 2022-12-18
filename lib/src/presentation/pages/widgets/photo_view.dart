import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/assets_strings.dart';
import '../../utils/dimensions.dart';
import 'icon_button.dart';
import 'zoomable_image_widget.dart';

class PhotoView extends StatefulWidget {
  final List<String> photos;
  final Function(String)? onDeleteClick;
  final Function(String)? onDownloadClick;
  final int initialIndex;
  final Color previousNavBarColor;

  const PhotoView({
    Key? key,
    required this.photos,
    required this.onDownloadClick,
    required this.previousNavBarColor,
    this.onDeleteClick,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  late PageController _galleryPageController;
  late int _currentIndex;
  final Map<int, Offset> _touchPositions = <int, Offset>{};
  ScrollPhysics _scrollPhysics = const _CustomPageViewScrollPhysics();
  bool _isZoomed = false;

  @override
  void initState() {
    _galleryPageController = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
    super.initState();
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
          Container(
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
                  onClick: Navigator.of(context).pop,
                  imageIcon: AssetStrings.backIconImage,
                  color: Colors.white,
                ),
                Row(
                  children: <Widget>[
                    if (widget.onDeleteClick != null) ...<Widget>[
                      SuggestionsIconButton(
                        imageIcon: AssetStrings.deleteIconImage,
                        onClick: () {
                          Navigator.of(context).pop();
                          widget.onDeleteClick!(widget.photos[_currentIndex]);
                        },
                        color: Colors.white,
                      ),
                      const SizedBox(width: Dimensions.marginDefault),
                    ],
                    if (widget.onDownloadClick != null) ...<Widget>[
                      SuggestionsIconButton(
                        imageIcon: AssetStrings.downloadIconImage,
                        onClick: () => widget.onDownloadClick!(widget.photos[_currentIndex]),
                        color: Colors.white,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Hero(
              tag: 'photo_view',
              child: Listener(
                onPointerDown: (PointerDownEvent opd) {
                  _touchPositions[opd.pointer] = opd.position;
                  _changeScrollPhysics();
                },
                onPointerCancel: (PointerCancelEvent opc) {
                  _touchPositions.remove(opc.pointer);
                  _changeScrollPhysics();
                },
                onPointerUp: (PointerUpEvent opu) {
                  _touchPositions.remove(opu.pointer);
                  _changeScrollPhysics();
                },
                child: PageView.builder(
                  physics: _scrollPhysics,
                  itemCount: widget.photos.length,
                  controller: _galleryPageController,
                  onPageChanged: (int pageIndex) => _currentIndex = pageIndex,
                  itemBuilder: (BuildContext context, int index) {
                    return ZoomableImage(
                      imageUrl: widget.photos[index],
                      changeScrollPhysics: _changeScrollPhysics,
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

  void _changeZoomStatus(bool isZoomed) => setState(() => _isZoomed = isZoomed);

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
      SystemUiOverlayStyle(systemNavigationBarColor: widget.previousNavBarColor),
    );
    super.dispose();
  }
}

class _CustomPageViewScrollPhysics extends ScrollPhysics {
  const _CustomPageViewScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  _CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _CustomPageViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 50,
        stiffness: 100,
        damping: 0.8,
      );
}
