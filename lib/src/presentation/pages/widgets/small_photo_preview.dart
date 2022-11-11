import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../di/injector.dart';
import '../../utils/dimensions.dart';

class SmallPhotoPreview extends StatelessWidget {
  final Color backgroundColor;
  final String src;
  final double size;
  final String heroTag;

  const SmallPhotoPreview({
    Key? key,
    required this.backgroundColor,
    required this.src,
    this.size = Dimensions.defaultSize,
    this.heroTag = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size - 1,
      height: size - 1,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(size),
      ),
      child: Hero(
        tag: heroTag,
        child: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(src, headers: i.imageHeaders),
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}
