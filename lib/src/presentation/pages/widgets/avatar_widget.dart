// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/assets_strings.dart';
import '../../utils/dimensions.dart';
import '../theme/suggestions_theme.dart';
import 'network_image.dart';

class AvatarWidget extends StatefulWidget {
  final String? avatar;
  final double size;
  final Color? backgroundColor;
  final double iconPadding;

  const AvatarWidget({
    Key? key,
    required this.size,
    this.avatar,
    this.backgroundColor,
    this.iconPadding = Dimensions.marginSmall,
  }) : super(key: key);

  @override
  _AvatarWidgetState createState() => _AvatarWidgetState();
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
                  color: theme.primaryIconColor,
                ),
              ),
      ),
    );
  }
}
