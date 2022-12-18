import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/assets_strings.dart';
import '../../utils/dimensions.dart';

class SuggestionsBackButton extends StatefulWidget {
  final VoidCallback onClick;
  final Color color;
  final Color pressedColor;

  const SuggestionsBackButton({
    required this.onClick,
    required this.color,
    required this.pressedColor,
    Key? key,
  }) : super(key: key);

  @override
  _SuggestionsBackButtonState createState() => _SuggestionsBackButtonState();
}

class _SuggestionsBackButtonState extends State<SuggestionsBackButton> {
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
        padding: const EdgeInsets.all(Dimensions.marginMicro),
        child: SvgPicture.asset(
          AssetStrings.backIconImage,
          package: AssetStrings.packageName,
          height: Dimensions.defaultSize,
          width: Dimensions.defaultSize,
          color: pressed ? widget.pressedColor : widget.color,
        ),
      ),
    );
  }
}
