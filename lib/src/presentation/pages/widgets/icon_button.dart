import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/assets_strings.dart';
import '../../utils/dimensions.dart';
import '../theme/suggestions_theme.dart';

class SuggestionsIconButton extends StatefulWidget {
  final String imageIcon;
  final VoidCallback onClick;
  final Color? color;
  final double size;
  final EdgeInsets padding;

  const SuggestionsIconButton({
    required this.imageIcon,
    required this.onClick,
    this.color,
    this.size = Dimensions.defaultSize,
    this.padding = const EdgeInsets.all(Dimensions.marginMicro),
    Key? key,
  }) : super(key: key);

  @override
  _SuggestionsIconButtonState createState() => _SuggestionsIconButtonState();
}

class _SuggestionsIconButtonState extends State<SuggestionsIconButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.onClick(),
      onTapDown: (TapDownDetails tapDetails) {
        setState(() => pressed = true);
      },
      onTapUp: (TapUpDetails tapDetails) {
        setState(() => pressed = false);
      },
      onTapCancel: () {
        setState(() => pressed = false);
      },
      child: Padding(
        padding: widget.padding,
        child: SvgPicture.asset(
          widget.imageIcon,
          package: AssetStrings.packageName,
          width: widget.size,
          height: widget.size,
          color: pressed ? theme.actionPressedColor : widget.color ?? theme.primaryIconColor,
        ),
      ),
    );
  }
}
