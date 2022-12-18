import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/assets_strings.dart';
import '../../utils/dimensions.dart';
import '../theme/suggestions_theme.dart';

class SuggestionsFab extends StatefulWidget {
  final VoidCallback onClick;
  final String imageIcon;
  final double size;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? splashColor;
  final Color? iconColor;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const SuggestionsFab({
    Key? key,
    required this.onClick,
    required this.imageIcon,
    this.size = Dimensions.veryBigSize,
    this.borderRadius = Dimensions.middleCircularRadius,
    this.backgroundColor,
    this.splashColor,
    this.iconColor,
    this.padding = const EdgeInsets.all(Dimensions.marginSmall),
    this.margin = const EdgeInsets.all(Dimensions.marginSmall),
  }) : super(key: key);

  @override
  State<SuggestionsFab> createState() => _SuggestionsFabState();
}

class _SuggestionsFabState extends State<SuggestionsFab> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    animation = Tween<double>(
      begin: widget.size / 5,
      end: widget.size * 2,
    ).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      onTapDown: (_) {
        controller.reset();
        controller.forward();
      },
      onTapUp: (_) => controller.reset(),
      onTapCancel: controller.reset,
      child: Container(
        width: widget.size,
        height: widget.size,
        margin: widget.margin,
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? theme.fabColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              right: -widget.size / 4,
              bottom: -widget.size / 2,
              child: _AnimatedCircle(
                animation: animation,
                color: widget.splashColor ?? theme.fabColor,
              ),
            ),
            Center(
              child: SvgPicture.asset(
                widget.imageIcon,
                package: AssetStrings.packageName,
                width: Dimensions.defaultSize,
                height: Dimensions.defaultSize,
                color: widget.iconColor ?? theme.primaryIconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedCircle extends AnimatedWidget {
  final Color color;

  const _AnimatedCircle({
    Key? key,
    required Animation<double> animation,
    required this.color,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return Center(
      child: Container(
        height: animation.value,
        width: animation.value,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
