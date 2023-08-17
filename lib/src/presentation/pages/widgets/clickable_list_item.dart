import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';

class ClickableListItem extends StatefulWidget {
  final Widget? leading;
  final Widget title;
  final Widget? trailing;
  final VoidCallback? onClick;
  final double horizontalPadding;
  final double verticalPadding;

  const ClickableListItem({
    required this.title,
    this.onClick,
    this.leading,
    this.trailing,
    this.horizontalPadding = Dimensions.marginDefault,
    this.verticalPadding = Dimensions.marginSmall,
    super.key,
  });

  @override
  State<ClickableListItem> createState() => _ClickableListItemState();
}

class _ClickableListItemState extends State<ClickableListItem> {
  var _pressed = false;

  void _onTap(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onClick,
      onPanDown: (_) => _onTap(true),
      onPanCancel: () => _onTap(false),
      onPanUpdate: (_) => _onTap(false),
      child: ColoredBox(
        color: _pressed ? theme.actionBackgroundColor : Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding,
            vertical: widget.verticalPadding,
          ),
          child: Row(
            children: <Widget>[
              if (widget.leading != null)
                Padding(
                  padding: const EdgeInsets.only(
                    right: Dimensions.marginMiddle,
                  ),
                  child: widget.leading,
                ),
              Expanded(
                child: widget.title,
              ),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
