import 'package:flutter/material.dart';

import '../../utils/dimensions.dart';
import '../theme/suggestions_theme.dart';

class SuggestionsTextButton extends StatefulWidget {
  final String title;
  final VoidCallback onClick;

  const SuggestionsTextButton({
    required this.title,
    required this.onClick,
    Key? key,
  }) : super(key: key);

  @override
  _SuggestionsTextButtonState createState() => _SuggestionsTextButtonState();
}

class _SuggestionsTextButtonState extends State<SuggestionsTextButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    Color color = theme.primaryTextColor;
    if (_pressed) {
      color = theme.actionPressedColor;
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onClick,
      onTapDown: (TapDownDetails tapDetails) {
        setState(() => _pressed = true);
      },
      onTapUp: (TapUpDetails tapDetails) {
        setState(() => _pressed = false);
      },
      onTapCancel: () {
        setState(() => _pressed = false);
      },
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
                  ? theme.textSmallPlus.copyWith(color: theme.actionPressedColor)
                  : theme.textSmallPlus.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
