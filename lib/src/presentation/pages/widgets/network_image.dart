import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';

class SuggestionsNetworkImage extends StatelessWidget {
  final String url;
  final Color? noImageColor;
  final BoxFit boxFit;
  final double maxHeight;

  const SuggestionsNetworkImage({
    required this.url,
    this.noImageColor,
    this.boxFit = BoxFit.contain,
    this.maxHeight = 480.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      child: Image(
        filterQuality: FilterQuality.medium,
        image: CachedNetworkImageProvider(url, headers: i.imageHeaders),
        fit: boxFit,
        loadingBuilder: (
          BuildContext context,
          Widget child,
          ImageChunkEvent? loadingProgress,
        ) {
          if (loadingProgress == null) {
            return child;
          }
          return ColoredBox(color: noImageColor ?? theme.thirdBackgroundColor);
        },
        errorBuilder:
            (BuildContext context, Object object, StackTrace? stackTrace) =>
                ColoredBox(color: noImageColor ?? theme.thirdBackgroundColor),
      ),
    );
  }
}
