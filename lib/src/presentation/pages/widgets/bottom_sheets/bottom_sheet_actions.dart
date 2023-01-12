import 'package:flutter/material.dart';

import '../../../utils/context_utils.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/platform_check.dart';
import '../../theme/suggestions_theme.dart';

class BottomSheetActions extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback onDone;
  final bool isDoneActive;
  final bool hasLeftButton;

  const BottomSheetActions({
    Key? key,
    required this.onDone,
    this.onCancel,
    this.isDoneActive = true,
    this.hasLeftButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.marginBig,
        right: Dimensions.marginBig,
        top: Dimensions.marginSmall,
        bottom: SuggestionsPlatform.isIOS ? Dimensions.marginBig : Dimensions.marginSmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (hasLeftButton)
            NewSuggestionTextButton(
              title: context.localization.cancel,
              onClick: onCancel ?? () {},
              isTonal: false,
            ),
          const SizedBox(width: Dimensions.marginMicro),
          NewSuggestionTextButton(
            title: context.localization.done,
            onClick: onDone,
            enabled: isDoneActive,
          ),
        ],
      ),
    );
  }
}

class NewSuggestionTextButton extends StatefulWidget {
  final String title;
  final bool enabled;
  final bool isTonal;
  final VoidCallback onClick;
  final VoidCallback? onDisabledClick;

  const NewSuggestionTextButton({
    Key? key,
    required this.title,
    required this.onClick,
    this.onDisabledClick,
    this.enabled = true,
    this.isTonal = true,
  }) : super(key: key);

  @override
  State<NewSuggestionTextButton> createState() => _NewSuggestionTextButtonState();
}

class _NewSuggestionTextButtonState extends State<NewSuggestionTextButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    Color color = widget.enabled
        ? widget.isTonal
            ? theme.tonalButtonColor
            : Colors.transparent
        : theme.disabledTextButtonColor;
    Color textColor = widget.enabled ? theme.enabledTextColor : theme.disabledTextColor;
    if (_pressed) {
      color = widget.isTonal ? theme.focusedTonalButtonColor : theme.focusedTextButtonColor;
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
