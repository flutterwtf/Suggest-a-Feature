import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:vector_graphics/vector_graphics.dart';

class SuggestionsIcon extends StatelessWidget {
  const SuggestionsIcon(
    this.iconPath, {
    this.size,
    this.color,
    this.fit,
    super.key,
  });

  final String iconPath;
  final double? size;
  final Color? color;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return VectorGraphic(
      loader: AssetBytesLoader(
        iconPath,
        packageName: AssetStrings.packageName,
      ),
      width: size,
      height: size,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      fit: fit ?? BoxFit.contain,
    );
  }
}
