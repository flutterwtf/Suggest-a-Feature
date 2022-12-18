import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../../utils/assets_strings.dart';
import '../../../utils/dimensions.dart';
import '../../theme/suggestions_theme.dart';
import '../clickable_list_item.dart';
import 'base_bottom_sheet.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  final String question;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final VoidCallback? onBackdrop;
  final SheetController controller;
  final String onConfirmText;
  final String onCancelText;
  final String onConfirmAsset;
  final Color? color;
  final bool showDimming;

  const ConfirmationBottomSheet({
    required this.question,
    required this.onConfirm,
    required this.onCancel,
    required this.onConfirmText,
    required this.onCancelText,
    required this.onConfirmAsset,
    required this.controller,
    this.onBackdrop,
    this.color,
    this.showDimming = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      backgroundColor: theme.bottomSheetBackgroundColor,
      previousNavBarColor: theme.primaryBackgroundColor,
      previousStatusBarColor: theme.primaryBackgroundColor,
      controller: controller,
      onClose: ([ClosureType? closureType]) {
        if (closureType == ClosureType.backButton) {
          onCancel();
        } else {
          (onBackdrop ?? onCancel).call();
        }
      },
      showDimming: showDimming,
      contentBuilder: (BuildContext context, SheetState sheetState) {
        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
            top: Dimensions.marginDefault,
            bottom: Dimensions.marginBig,
          ),
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.marginDefault),
              child: Text(
                question,
                style: theme.textMediumPlusBold,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Dimensions.marginDefault),
            ClickableListItem(
              onClick: onConfirm,
              leading: SvgPicture.asset(
                onConfirmAsset,
                package: AssetStrings.packageName,
                width: Dimensions.defaultSize,
                height: Dimensions.defaultSize,
                color: theme.errorColor,
              ),
              title: Text(
                onConfirmText,
                style: theme.textMediumPlusBold.copyWith(color: theme.errorColor),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: Dimensions.marginSmall),
            ClickableListItem(
              onClick: onCancel,
              leading: SvgPicture.asset(
                AssetStrings.closeIconImage,
                package: AssetStrings.packageName,
                width: Dimensions.defaultSize,
                height: Dimensions.defaultSize,
                color: theme.primaryIconColor,
              ),
              title: Text(
                onCancelText,
                style: theme.textMediumPlusBold,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        );
      },
    );
  }
}
