import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.buttonHeight,
      child: ElevatedButton(
        style: context.themeData.elevatedButtonTheme.style?.copyWith(
          backgroundColor: MaterialStatePropertyAll(widget.backgroundColor),
        ),
        onPressed: () =>
            widget.isLoading ? () => <dynamic, dynamic>{} : widget.onClick(),
        child: _ButtonContent(
          buttonText: widget.buttonText,
          imageIconPath: widget.imageIconPath,
          textColor: widget.textColor,
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
              theme.onAccentColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: Dimensions.marginSmall),
        ],
        Text(
          buttonText,
          style: context.themeData.textTheme.headlineSmall?.copyWith(
            color: textColor ?? theme.onAccentColor,
          ),
        ),
      ],
    );
  }
}
