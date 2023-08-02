import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/base_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/clickable_list_item.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      backgroundColor: context.theme.bottomSheetTheme.backgroundColor ??
          theme.bottomSheetBackgroundColor,
      previousNavBarColor: context.theme.colorScheme.background,
      previousStatusBarColor: context.theme.colorScheme.background,
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
        return _BottomSheetListView(
          onCancel: onCancel,
          onConfirm: onConfirm,
          onCancelText: onCancelText,
          onConfirmAsset: onConfirmAsset,
          onConfirmText: onConfirmText,
          question: question,
        );
      },
    );
  }
}

class _BottomSheetListView extends StatelessWidget {
  final String question;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String onCancelText;
  final String onConfirmText;
  final String onConfirmAsset;

  const _BottomSheetListView({
    required this.onCancelText,
    required this.onConfirmText,
    required this.onConfirmAsset,
    required this.onCancel,
    required this.onConfirm,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(
        top: Dimensions.marginDefault,
        bottom: Dimensions.marginBig,
      ),
      shrinkWrap: true,
      children: <Widget>[
        _Question(
          question: question,
        ),
        const SizedBox(height: Dimensions.marginDefault),
        _Confirm(
          onConfirm: onConfirm,
          onConfirmAsset: onConfirmAsset,
          onConfirmText: onConfirmText,
        ),
        const SizedBox(height: Dimensions.marginSmall),
        _Cancel(
          onCancel: onCancel,
          onCancelText: onCancelText,
        ),
      ],
    );
  }
}

class _Question extends StatelessWidget {
  final String question;

  const _Question({required this.question});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.marginDefault,
      ),
      child: Text(
        question,
        style: context.theme.textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _Confirm extends StatelessWidget {
  final VoidCallback? onConfirm;
  final String onConfirmAsset;
  final String onConfirmText;

  const _Confirm({
    required this.onConfirmAsset,
    required this.onConfirmText,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return ClickableListItem(
      onClick: onConfirm,
      leading: SvgPicture.asset(
        onConfirmAsset,
        package: AssetStrings.packageName,
        width: Dimensions.defaultSize,
        height: Dimensions.defaultSize,
        colorFilter: ColorFilter.mode(
          context.theme.colorScheme.error,
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        onConfirmText,
        style: context.theme.textTheme.titleMedium?.copyWith(
          color: context.theme.colorScheme.error,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}

class _Cancel extends StatelessWidget {
  final VoidCallback onCancel;
  final String onCancelText;

  const _Cancel({
    required this.onCancel,
    required this.onCancelText,
  });

  @override
  Widget build(BuildContext context) {
    return ClickableListItem(
      onClick: onCancel,
      leading: SvgPicture.asset(
        AssetStrings.closeIconImage,
        package: AssetStrings.packageName,
        width: Dimensions.defaultSize,
        height: Dimensions.defaultSize,
        colorFilter: ColorFilter.mode(
          context.theme.colorScheme.onBackground,
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        onCancelText,
        style: context.theme.textTheme.titleMedium,
        textAlign: TextAlign.left,
      ),
    );
  }
}
