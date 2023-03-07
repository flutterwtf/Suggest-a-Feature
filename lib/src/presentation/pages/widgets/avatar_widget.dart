import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/network_image.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';

class AvatarWidget extends StatefulWidget {
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
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.primaryBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(widget.size)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size),
        child: widget.avatar != null && widget.avatar!.isNotEmpty
            ? SuggestionsNetworkImage(url: widget.avatar!)
            : Padding(
                padding: EdgeInsets.all(widget.iconPadding),
                child: SvgPicture.asset(
                  AssetStrings.profileIconImage,
                  package: AssetStrings.packageName,
                  colorFilter: ColorFilter.mode(
                    theme.primaryIconColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
      ),
    );
  }
}
