import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/network_image.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';

class AvatarWidget extends StatelessWidget {
  final String? avatar;
  final double size;
  final Color? backgroundColor;
  final double iconPadding;

  const AvatarWidget({
    required this.size,
    this.avatar,
    this.backgroundColor,
    this.iconPadding = Dimensions.marginSmall,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.theme.colorScheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(size)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: avatar != null && avatar!.isNotEmpty
            ? SuggestionsNetworkImage(url: avatar!)
            : Padding(
                padding: EdgeInsets.all(iconPadding),
                child: SvgPicture.asset(
                  AssetStrings.profileIconImage,
                  package: AssetStrings.packageName,
                  colorFilter: ColorFilter.mode(
                    context.theme.colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
              ),
      ),
    );
  }
}
