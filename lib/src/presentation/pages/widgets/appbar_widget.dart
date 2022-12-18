import 'package:flutter/material.dart';

import '../../utils/dimensions.dart';
import '../theme/suggestions_theme.dart';
import 'back_button.dart';

class SuggestionsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackClick;
  final String screenTitle;
  final Widget? trailing;

  @override
  Size get preferredSize => const Size.fromHeight(Dimensions.size2x);

  const SuggestionsAppBar({
    required this.onBackClick,
    required this.screenTitle,
    this.trailing,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: theme.primaryBackgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(
          left: Dimensions.marginDefault,
          right: Dimensions.marginSmall,
        ),
        child: SuggestionsBackButton(
          onClick: onBackClick,
          pressedColor: theme.actionPressedColor,
          color: theme.primaryTextColor,
        ),
      ),
      title: Text(
        screenTitle,
        style: theme.textMediumBold,
      ),
      actions: trailing != null ? <Widget>[trailing!] : null,
      key: key,
    );
  }
}
