import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../../utils/assets_strings.dart';
import '../../../utils/context_utils.dart';
import '../../../utils/date_utils.dart';
import '../../../utils/dimensions.dart';
import '../../theme/suggestions_theme.dart';
import '../clickable_list_item.dart';
import 'base_bottom_sheet.dart';

class EditDeleteSuggestionBottomSheet extends StatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onEditClick;
  final VoidCallback onDeleteClick;
  final SheetController controller;
  final DateTime creationDate;

  const EditDeleteSuggestionBottomSheet({
    Key? key,
    required this.onCancel,
    required this.onEditClick,
    required this.onDeleteClick,
    required this.controller,
    required this.creationDate,
  }) : super(key: key);

  @override
  _EditDeleteSuggestionBottomSheetState createState() => _EditDeleteSuggestionBottomSheetState();
}

class _EditDeleteSuggestionBottomSheetState extends State<EditDeleteSuggestionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      controller: widget.controller,
      onClose: ([_]) => widget.onCancel(),
      backgroundColor: theme.bottomSheetBackgroundColor,
      previousNavBarColor: theme.primaryBackgroundColor,
      previousStatusBarColor: theme.primaryBackgroundColor,
      contentBuilder: (BuildContext context, SheetState sheetState) {
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
                _leadingText(),
                const SizedBox(height: Dimensions.marginDefault),
                _editItem(),
                const SizedBox(height: Dimensions.marginSmall),
                _deleteItem(),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _leadingText() {
    return Text(
      widget.creationDate.formatEditSuggestion(context.localization.localeName),
      style: theme.textMediumPlusBold,
    );
  }

  Widget _editItem() {
    return ClickableListItem(
      title: Text(
        context.localization.edit,
        style: theme.textMediumPlusBold,
      ),
      leading: SvgPicture.asset(
        AssetStrings.penIconImage,
        package: AssetStrings.packageName,
        height: Dimensions.defaultSize,
        width: Dimensions.defaultSize,
        color: theme.primaryIconColor,
      ),
      onClick: widget.onEditClick,
    );
  }

  Widget _deleteItem() {
    return ClickableListItem(
      title: Text(
        context.localization.delete,
        style: theme.textMediumPlusBold.copyWith(color: theme.errorColor),
      ),
      leading: SvgPicture.asset(
        AssetStrings.deleteIconImage,
        package: AssetStrings.packageName,
        color: theme.errorColor,
        height: Dimensions.defaultSize,
        width: Dimensions.defaultSize,
      ),
      onClick: widget.onDeleteClick,
    );
  }
}
