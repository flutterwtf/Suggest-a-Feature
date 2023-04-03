import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';

class SuggestionsElevatedButton extends StatefulWidget {
  final String buttonText;
  final String? imageIconPath;
  final VoidCallback onClick;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;

  const SuggestionsElevatedButton({
    required this.buttonText,
    required this.onClick,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.imageIconPath,
    super.key,
  });

  @override
  State<SuggestionsElevatedButton> createState() =>
      _SuggestionsElevatedButtonState();
}

class _SuggestionsElevatedButtonState extends State<SuggestionsElevatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () =>
          widget.isLoading ? () => <dynamic, dynamic>{} : widget.onClick(),
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
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
              borderRadius:
                  BorderRadius.circular(Dimensions.smallCircularRadius),
            ),
          ),
          child: _ButtonContent(
            buttonText: widget.buttonText,
            textColor: widget.textColor,
            imageIconPath: widget.imageIconPath,
          ),
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final String buttonText;
  final String? imageIconPath;
  final Color? textColor;

  const _ButtonContent({
    required this.buttonText,
    this.textColor,
    this.imageIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (imageIconPath != null) ...<Widget>[
          SvgPicture.asset(
            imageIconPath!,
            package: AssetStrings.packageName,
            colorFilter: ColorFilter.mode(
              theme.elevatedButtonTextColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: Dimensions.marginSmall),
        ],
        Text(
          buttonText,
          style: theme.textSmallPlusBold.copyWith(
            color: textColor ?? theme.elevatedButtonTextColor,
          ),
        ),
      ],
    );
  }
}
