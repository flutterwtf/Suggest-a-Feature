import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/bottom_sheets/base_bottom_sheet.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/clickable_list_item.dart';
import 'package:suggest_a_feature/src/presentation/utils/assets_strings.dart';
import 'package:suggest_a_feature/src/presentation/utils/context_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/date_utils.dart';
import 'package:suggest_a_feature/src/presentation/utils/dimensions.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

class EditDeleteSuggestionBottomSheet extends StatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onEditClick;
  final VoidCallback onDeleteClick;
  final SheetController controller;
  final DateTime creationDate;

  const EditDeleteSuggestionBottomSheet({
    required this.onCancel,
    required this.onEditClick,
    required this.onDeleteClick,
    required this.controller,
    required this.creationDate,
    super.key,
  });

  @override
  State<EditDeleteSuggestionBottomSheet> createState() =>
      _EditDeleteSuggestionBottomSheetState();
}

class _EditDeleteSuggestionBottomSheetState
    extends State<EditDeleteSuggestionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      controller: widget.controller,
      onClose: ([_]) => widget.onCancel(),
      backgroundColor: context.theme.bottomSheetTheme.backgroundColor ??
          context.theme.colorScheme.background,
      previousNavBarColor: context.theme.colorScheme.background,
      previousStatusBarColor: context.theme.colorScheme.background,
      contentBuilder: (context, _) {
        return ListView(
          padding: const EdgeInsets.only(
            top: Dimensions.marginDefault,
            bottom: Dimensions.marginBig,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                _LeadingText(
                  text: widget.creationDate
                      .formatEditSuggestion(context.localization.localeName),
                ),
                const SizedBox(height: Dimensions.marginDefault),
                _EditItem(onEditClick: widget.onEditClick),
                const SizedBox(height: Dimensions.marginSmall),
                _DeleteItem(onDeleteClick: widget.onDeleteClick),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _LeadingText extends StatelessWidget {
  final String text;

  const _LeadingText({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.theme.textTheme.titleMedium,
    );
  }
}

class _EditItem extends StatelessWidget {
  final VoidCallback onEditClick;

  const _EditItem({
    required this.onEditClick,
  });

  @override
  Widget build(BuildContext context) {
    return ClickableListItem(
      title: Text(
        context.localization.edit,
        style: context.theme.textTheme.titleMedium,
      ),
      leading: SvgPicture.asset(
        AssetStrings.penIconImage,
        package: AssetStrings.packageName,
        height: Dimensions.defaultSize,
        width: Dimensions.defaultSize,
        colorFilter: ColorFilter.mode(
          context.theme.colorScheme.onBackground,
          BlendMode.srcIn,
        ),
      ),
      onClick: onEditClick,
    );
  }
}

class _DeleteItem extends StatelessWidget {
  final VoidCallback onDeleteClick;

  const _DeleteItem({
    required this.onDeleteClick,
  });

  @override
  Widget build(BuildContext context) {
    return ClickableListItem(
      title: Text(
        context.localization.delete,
        style: context.theme.textTheme.titleMedium?.copyWith(
          color: context.theme.colorScheme.error,
        ),
      ),
      leading: SvgPicture.asset(
        AssetStrings.deleteIconImage,
        package: AssetStrings.packageName,
        colorFilter: ColorFilter.mode(
          context.theme.colorScheme.error,
          BlendMode.srcIn,
        ),
        height: Dimensions.defaultSize,
        width: Dimensions.defaultSize,
      ),
      onClick: onDeleteClick,
    );
  }
}
