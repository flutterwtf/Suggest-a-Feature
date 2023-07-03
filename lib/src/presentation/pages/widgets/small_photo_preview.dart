import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';

class SmallPhotoPreview extends StatelessWidget {
  final Color backgroundColor;
  final String src;
  final double size;
  final String heroTag;

  const SmallPhotoPreview({
    required this.backgroundColor,
    required this.src,
    this.size = Dimensions.defaultSize,
    this.heroTag = '',
    super.key,
  });

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
          backgroundImage: NetworkImage(
            src,
            headers: i.imageHeaders,
          ),
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}
