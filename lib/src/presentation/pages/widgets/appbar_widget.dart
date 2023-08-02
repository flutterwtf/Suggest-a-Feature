import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/suggestions_back_button.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';

class SuggestionsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String screenTitle;
  final VoidCallback? onBackClick;
  final Widget? trailing;

  @override
  Size get preferredSize => const Size.fromHeight(Dimensions.size2x);

  const SuggestionsAppBar({
    required this.screenTitle,
    this.onBackClick,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: onBackClick != null
          ? Padding(
              padding: const EdgeInsets.only(
                left: Dimensions.marginDefault,
                right: Dimensions.marginSmall,
              ),
              child: SuggestionsBackButton(
                onClick: onBackClick!,
                pressedColor: theme.actionPressedColor,
                color: context.theme.colorScheme.onBackground,
              ),
            )
          : null,
      title: Text(screenTitle),
      actions: trailing != null ? <Widget>[trailing!] : null,
      key: key,
    );
  }
}
