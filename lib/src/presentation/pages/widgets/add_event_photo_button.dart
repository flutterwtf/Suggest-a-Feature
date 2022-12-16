import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/assets_strings.dart';
import '../../utils/context_utils.dart';
import '../../utils/dimensions.dart';
import '../theme/suggestions_theme.dart';
import 'dotted_border.dart';

class AddPhotoButton extends StatelessWidget {
  final double width;
  final double height;
  final TextStyle style;
  final bool isLoading;

  const AddPhotoButton({
    Key? key,
    required this.width,
    required this.height,
    required this.style,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.marginDefault),
      child: DottedBorder(
        dashPattern: const <double>[10, 4],
        borderType: BorderType.RRect,
        strokeCap: StrokeCap.round,
        color: theme.actionColor,
        radius: const Radius.circular(Dimensions.smallCircularRadius),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
                  strokeWidth: 1.0,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryIconColor),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      AssetStrings.addPhotoButton,
                      package: AssetStrings.packageName,
                      height: Dimensions.defaultSize,
                      color: theme.primaryTextColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: Dimensions.marginSmall),
                      child: Text(
                        context.localization.add,
                        style: style.copyWith(color: theme.primaryTextColor),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
