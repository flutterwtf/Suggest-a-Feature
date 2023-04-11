import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';

class SuggestionsBackButton extends StatefulWidget {
  final VoidCallback onClick;
  final Color color;
  final Color pressedColor;

  const SuggestionsBackButton({
    required this.onClick,
    required this.color,
    required this.pressedColor,
    super.key,
  });

  @override
  State<SuggestionsBackButton> createState() => _SuggestionsBackButtonState();
}

class _SuggestionsBackButtonState extends State<SuggestionsBackButton> {
  var _pressed = false;

  void _onPan(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onClick,
      onTapDown: (_) => _onPan(true),
      onTapUp: (_) => _onPan(false),
      onTapCancel: () => _onPan(false),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.marginMicro),
        child: SvgPicture.asset(
          AssetStrings.backIconImage,
          package: AssetStrings.packageName,
          height: Dimensions.defaultSize,
          width: Dimensions.defaultSize,
          colorFilter: ColorFilter.mode(
            _pressed ? widget.pressedColor : widget.color,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
