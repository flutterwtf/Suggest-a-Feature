import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/assets_strings.dart';
import '../../utils/dimensions.dart';
import '../theme/suggestions_theme.dart';

class SuggestionsElevatedButton extends StatefulWidget {
  final String buttonText;
  final String? imageIcon;
  final VoidCallback onClick;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;

  const SuggestionsElevatedButton({
    Key? key,
    required this.buttonText,
    required this.onClick,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.imageIcon,
  }) : super(key: key);

  @override
  _SuggestionsElevatedButtonState createState() => _SuggestionsElevatedButtonState();
}

class _SuggestionsElevatedButtonState extends State<SuggestionsElevatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.isLoading ? () => <dynamic, dynamic>{} : widget.onClick(),
      onTapDown: (TapDownDetails tapDetails) {
        setState(() => _isPressed = true);
      },
      onTapUp: (TapUpDetails tapDetails) {
        setState(() => _isPressed = false);
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      child: SizedBox(
        height: Dimensions.buttonHeight,
        child: ElevatedButton(
          onPressed: widget.onClick,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            elevation: 0,
            backgroundColor: _isPressed
                ? widget.backgroundColor ?? theme.pressedElevatedButtonColor
                : widget.backgroundColor ?? theme.elevatedButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.smallCircularRadius),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.imageIcon != null) ...<Widget>[
                SvgPicture.asset(
                  widget.imageIcon!,
                  package: AssetStrings.packageName,
                  color: theme.elevatedButtonTextColor,
                ),
                const SizedBox(width: Dimensions.marginSmall),
              ],
              Text(
                widget.buttonText,
                style: theme.textSmallPlusBold.copyWith(
                  color: widget.textColor ?? theme.elevatedButtonTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
