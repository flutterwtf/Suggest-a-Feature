import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';

class SuggestionsTextButton extends StatefulWidget {
  final String title;
  final VoidCallback onClick;

  const SuggestionsTextButton({
    required this.title,
    required this.onClick,
    super.key,
  });

  @override
  State<SuggestionsTextButton> createState() => _SuggestionsTextButtonState();
}

class _SuggestionsTextButtonState extends State<SuggestionsTextButton> {
  var _pressed = false;

  void _onPan(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) {
    final color = _pressed ? theme.actionPressedColor : theme.primaryTextColor;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onClick,
      onTapDown: (_) => _onPan(true),
      onTapUp: (_) => _onPan(false),
      onTapCancel: () => _onPan(false),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.marginMiddle,
          horizontal: Dimensions.marginBig,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.title,
              style: _pressed
                  ? theme.textSmallPlus.copyWith(
                      color: theme.actionPressedColor,
                    )
                  : theme.textSmallPlus.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
