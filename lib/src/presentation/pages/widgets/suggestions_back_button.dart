import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';

class SuggestionsBackButton extends StatelessWidget {
  final VoidCallback onClick;

  const SuggestionsBackButton({
    required this.onClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.only(
          top: Dimensions.marginMicro,
          bottom: Dimensions.marginMicro,
          left: Dimensions.marginDefault + Dimensions.marginMicro,
          right: Dimensions.marginMiddle,
        ),
        child: SvgPicture.asset(
          AssetStrings.backIconImage,
          package: AssetStrings.packageName,
          height: Dimensions.defaultSize,
          width: Dimensions.defaultSize,
          colorFilter: ColorFilter.mode(
            context.theme.appBarTheme.iconTheme?.color ??
                context.theme.colorScheme.onSurface,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
