import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';
import 'package:suggest_a_feature/src/presentation/utils/context_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:suggest_a_feature/src/presentation/utils/platform_check.dart';

class BottomSheetActions extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback onDone;
  final bool isDoneActive;
  final bool hasLeftButton;

  const BottomSheetActions({
    required this.onDone,
    this.onCancel,
    this.isDoneActive = true,
    this.hasLeftButton = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.marginBig,
        right: Dimensions.marginBig,
        top: Dimensions.marginSmall,
        bottom: SuggestionsPlatform.isIOS
            ? Dimensions.marginBig
            : Dimensions.marginSmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (hasLeftButton)
            _NewSuggestionTextButton(
              title: context.localization.cancel,
              onClick: onCancel ?? () {},
              isTonal: false,
            ),
          const SizedBox(width: Dimensions.marginMicro),
          _NewSuggestionTextButton(
            title: context.localization.done,
            onClick: onDone,
            enabled: isDoneActive,
          ),
        ],
      ),
    );
  }
}

class _NewSuggestionTextButton extends StatefulWidget {
  final String title;
  final bool enabled;
  final bool isTonal;
  final VoidCallback onClick;
  final VoidCallback? onDisabledClick;

  const _NewSuggestionTextButton({
    required this.title,
    required this.onClick,
    this.onDisabledClick,
    this.enabled = true,
    this.isTonal = true,
    super.key,
  });

  @override
  State<_NewSuggestionTextButton> createState() =>
      _NewSuggestionTextButtonState();
}

class _NewSuggestionTextButtonState extends State<_NewSuggestionTextButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    var color = widget.enabled
        ? widget.isTonal
            ? theme.tonalButtonColor
            : Colors.transparent
        : theme.disabledTextButtonColor;
    var textColor =
        widget.enabled ? theme.enabledTextColor : theme.disabledTextColor;
    if (_pressed) {
      color = widget.isTonal
          ? theme.focusedTonalButtonColor
          : theme.focusedTextButtonColor;
      textColor = theme.focusedTextColor;
    }
    return GestureDetector(
      onTap: widget.enabled ? widget.onClick : widget.onDisabledClick?.call,
      onTapDown: (_) => setState(() {
        if (widget.enabled) {
          _pressed = true;
        }
      }),
      onTapUp: (_) => setState(() {
        if (widget.enabled) {
          _pressed = false;
        }
      }),
      onTapCancel: () => setState(() {
        if (widget.enabled) {
          _pressed = false;
        }
      }),
      child: Container(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        height: Dimensions.largeSize,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.marginBig),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(Dimensions.smallCircularRadius),
        ),
        child: Text(
          widget.title,
          style: theme.textSmallPlusBold.copyWith(color: textColor),
        ),
      ),
    );
  }
}
