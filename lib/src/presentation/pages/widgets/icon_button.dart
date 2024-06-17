import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';

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
    super.key,
  });

  @override
  State<SuggestionsIconButton> createState() => _SuggestionsIconButtonState();
}

class _SuggestionsIconButtonState extends State<SuggestionsIconButton> {
  var _pressed = false;

  void _onTap(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.onClick(),
      onTapDown: (_) => _onTap(true),
      onTapUp: (_) => _onTap(false),
      onTapCancel: () => _onTap(false),
      child: Padding(
        padding: widget.padding,
        child: SvgPicture.asset(
          widget.imageIcon,
          package: AssetStrings.packageName,
          width: widget.size,
          height: widget.size,
          colorFilter: ColorFilter.mode(
            _pressed
                ? theme.actionPressedColor
                : widget.color ?? context.theme.colorScheme.onSurface,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
