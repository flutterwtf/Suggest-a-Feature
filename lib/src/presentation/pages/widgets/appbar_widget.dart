import 'package:flutter/material.dart';
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
          ? SuggestionsBackButton(onClick: onBackClick!)
          : null,
      title: Text(screenTitle),
      actions: trailing != null ? <Widget>[trailing!] : null,
      key: key,
    );
  }
}
